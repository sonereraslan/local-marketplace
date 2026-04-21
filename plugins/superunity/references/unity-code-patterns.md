# Unity Code Patterns

Canonical code patterns for consistent, idiomatic Unity C#. Consult when implementing features or writing tests.

## MonoBehaviour Lifecycle

```csharp
public class Example : MonoBehaviour
{
    // Internal init — runs once, before Start, even if disabled
    void Awake()
    {
        rb = GetComponent<Rigidbody>();
    }

    // Setup that depends on other objects being initialized
    void Start() { }

    // Called when enabled — subscribe to events here
    void OnEnable()
    {
        EventManager.OnScoreChanged += HandleScoreChanged;
    }

    // Called when disabled — unsubscribe here (pair with OnEnable)
    void OnDisable()
    {
        EventManager.OnScoreChanged -= HandleScoreChanged;
    }

    // Per-frame logic (input, state machines)
    void Update() { }

    // Fixed timestep (physics forces, raycasts)
    void FixedUpdate() { }

    // After all Update calls (camera follow, UI sync)
    void LateUpdate() { }

    // Final cleanup
    void OnDestroy() { }
}
```

**Order:** Awake → OnEnable → Start → FixedUpdate → Update → LateUpdate → OnDisable → OnDestroy

## ScriptableObject Data Container

```csharp
[CreateAssetMenu(fileName = "New Item", menuName = "Game/Item Data")]
public class ItemData : ScriptableObject
{
    public string itemName;
    public int value;
    public Sprite icon;
    public GameObject prefab;
}

// Usage — reference via Inspector, not code
public class Inventory : MonoBehaviour
{
    [SerializeField] private ItemData[] startingItems;
}
```

**When to use:** Game data (stats, configs, enemy definitions). Shared across scenes. Editable in Inspector. Never store scene object references in ScriptableObjects.

## Event System (Decoupled Communication)

```csharp
// Channel — static events, no MonoBehaviour needed
public static class GameEvents
{
    public static event Action OnGameStart;
    public static event Action<int> OnScoreChanged;
    public static event Action OnGameOver;

    public static void TriggerGameStart() => OnGameStart?.Invoke();
    public static void TriggerScoreChanged(int score) => OnScoreChanged?.Invoke(score);
    public static void TriggerGameOver() => OnGameOver?.Invoke();
}

// Subscriber — always pair += with -=
public class ScoreUI : MonoBehaviour
{
    void OnEnable() => GameEvents.OnScoreChanged += UpdateDisplay;
    void OnDisable() => GameEvents.OnScoreChanged -= UpdateDisplay;

    void UpdateDisplay(int score) { /* update UI */ }
}
```

**Rule:** Every `+=` must have a matching `-=` in `OnDisable` or `OnDestroy`. Static events that outlive subscribers cause memory leaks.

## Object Pooling

```csharp
public class ObjectPool : MonoBehaviour
{
    [SerializeField] private GameObject prefab;
    [SerializeField] private int initialSize = 20;

    private readonly Queue<GameObject> pool = new Queue<GameObject>();

    void Awake()
    {
        for (int i = 0; i < initialSize; i++)
        {
            var obj = Instantiate(prefab, transform);
            obj.SetActive(false);
            pool.Enqueue(obj);
        }
    }

    public GameObject Get()
    {
        var obj = pool.Count > 0 ? pool.Dequeue() : Instantiate(prefab, transform);
        obj.SetActive(true);
        return obj;
    }

    public void Return(GameObject obj)
    {
        obj.SetActive(false);
        pool.Enqueue(obj);
    }
}
```

**When to use:** Projectiles, particles, enemies, VFX — anything instantiated/destroyed at high frequency.

## Coroutines

```csharp
public class TimedActions : MonoBehaviour
{
    IEnumerator DelayedAction(float delay)
    {
        yield return new WaitForSeconds(delay);
        // action after delay
    }

    IEnumerator FadeOut(SpriteRenderer sprite, float duration)
    {
        float elapsed = 0f;
        Color start = sprite.color;

        while (elapsed < duration)
        {
            elapsed += Time.deltaTime;
            float alpha = Mathf.Lerp(1f, 0f, elapsed / duration);
            sprite.color = new Color(start.r, start.g, start.b, alpha);
            yield return null; // wait one frame
        }
    }

    void Start()
    {
        StartCoroutine(DelayedAction(2f));
    }
}
```

**Prefer coroutines for:** simple delays, tweens, sequenced actions. **Prefer async/UniTask for:** web requests, file I/O, complex async flows.

## 3D Physics Movement

```csharp
[RequireComponent(typeof(Rigidbody))]
public class PhysicsMovement : MonoBehaviour
{
    [SerializeField] private float moveSpeed = 5f;
    [SerializeField] private float jumpForce = 10f;
    [SerializeField] private LayerMask groundLayer;

    private Rigidbody rb;
    private bool isGrounded;

    void Awake() => rb = GetComponent<Rigidbody>();

    void FixedUpdate()
    {
        isGrounded = Physics.Raycast(transform.position, Vector3.down, 1.1f, groundLayer);

        float h = Input.GetAxis("Horizontal");
        float v = Input.GetAxis("Vertical");
        rb.AddForce(new Vector3(h, 0f, v) * moveSpeed);
    }

    void Update()
    {
        if (Input.GetButtonDown("Jump") && isGrounded)
            rb.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
    }
}
```

## 2D Character Controller

```csharp
[RequireComponent(typeof(Rigidbody2D))]
public class CharacterController2D : MonoBehaviour
{
    [SerializeField] private float moveSpeed = 5f;
    [SerializeField] private float jumpForce = 10f;
    [SerializeField] private Transform groundCheck;
    [SerializeField] private LayerMask groundLayer;

    private Rigidbody2D rb;
    private bool facingRight = true;

    void Awake() => rb = GetComponent<Rigidbody2D>();

    void Update()
    {
        bool isGrounded = Physics2D.OverlapCircle(groundCheck.position, 0.2f, groundLayer);
        float moveInput = Input.GetAxis("Horizontal");

        rb.velocity = new Vector2(moveInput * moveSpeed, rb.velocity.y);

        if ((moveInput > 0 && !facingRight) || (moveInput < 0 && facingRight))
            Flip();

        if (Input.GetButtonDown("Jump") && isGrounded)
            rb.velocity = new Vector2(rb.velocity.x, jumpForce);
    }

    void Flip()
    {
        facingRight = !facingRight;
        Vector3 scale = transform.localScale;
        scale.x *= -1;
        transform.localScale = scale;
    }
}
```

## UI Toolkit (Runtime)

```csharp
public class GameUI : MonoBehaviour
{
    private UIDocument uiDocument;
    private Label scoreLabel;
    private Button startButton;

    void OnEnable()
    {
        uiDocument = GetComponent<UIDocument>();
        var root = uiDocument.rootVisualElement;

        scoreLabel = root.Q<Label>("score-label");
        startButton = root.Q<Button>("start-button");
        startButton.clicked += OnStartClicked;
    }

    void OnDisable()
    {
        startButton.clicked -= OnStartClicked;
    }

    void OnStartClicked() { /* handle click */ }

    public void UpdateScore(int score)
    {
        scoreLabel.text = $"Score: {score}";
    }
}
```

## Singleton (Use Sparingly)

```csharp
public class GameManager : MonoBehaviour
{
    public static GameManager Instance { get; private set; }

    void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
        DontDestroyOnLoad(gameObject);
    }
}
```

**Caution:** Singletons create hidden coupling. Prefer events or dependency injection for communication. Only use for true single-instance services (audio manager, save system, input manager).

## Graph Toolkit (Node-Based Editor Tools)

Minimal boilerplate for a GTK-based tool. For full architecture patterns (importer, runtime execution, port API), see `references/gtk-architecture-patterns.md`.

```csharp
[Graph(AssetExtension)]
[Serializable]
public class MyToolGraph : Graph
{
    public const string AssetExtension = "mytool";

    [MenuItem("Assets/Create/My Tool Graph")]
    public static void CreateAsset()
    {
        GraphDatabase.PromptInProjectBrowserToCreateNewAsset<MyToolGraph>();
    }
}
```

**When to use:** Dialogue trees, state machines, ability/skill editors, quest systems, shader graphs, any visual node-based authoring tool. GTK handles UI (nodes, wires, zoom, undo) — developer implements domain logic and runtime execution.

## Common Namespaces

```csharp
using UnityEngine;                  // Core Unity
using UnityEngine.UI;               // UGUI
using UnityEngine.UIElements;       // UI Toolkit
using UnityEngine.SceneManagement;  // Scene loading
using System;                       // Action, Func
using System.Collections;           // IEnumerator
using System.Collections.Generic;   // List, Dictionary, Queue
```
