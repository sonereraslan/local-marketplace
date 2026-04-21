# Unity Testing Anti-Patterns

Reference for writing or changing Unity tests, adding test doubles, or evaluating test-only methods on MonoBehaviours or ScriptableObjects.

## Overview

Tests must verify observable behavior, not implementation details. Unity-specific coupling — singletons, static events, scene dependencies — makes this discipline harder to maintain. The discipline matters more, not less.

**Core principle:** Test what the code does, not how it does it internally.

## Core Rules

- **Never** test MonoBehaviour internal state directly — test observable output
- **Never** add test-only methods to production MonoBehaviours or ScriptableObjects
- **Never** use GameObject.Find, FindObjectOfType, or static singletons inside tests

## Anti-Pattern 1: Testing MonoBehaviour Internals

**The violation:**
```csharp
// ❌ BAD: Reading private field via reflection
[Test]
public void PlayerController_WhenDamaged_HealthFieldDecreases()
{
    var go = new GameObject();
    var player = go.AddComponent<PlayerController>();

    var field = typeof(PlayerController).GetField("_health",
        BindingFlags.NonPublic | BindingFlags.Instance);
    field.SetValue(player, 100);
    player.TakeDamage(30);

    Assert.AreEqual(70, (int)field.GetValue(player));
    Object.Destroy(go);
}
```

**Why this is wrong:**
- Tests implementation detail, not behavior
- Breaks on every rename or refactor of the field
- Doesn't verify that the health change was communicated to any consumer

**The fix:**
```csharp
// ✅ GOOD: Test observable output — the event or the public accessor
[Test]
public void PlayerController_WhenDamaged_RaisesHealthChangedEvent()
{
    var go = new GameObject();
    var player = go.AddComponent<PlayerController>();
    int receivedHealth = -1;
    player.OnHealthChanged += h => receivedHealth = h;

    player.SetHealth(100);
    player.TakeDamage(30);

    Assert.AreEqual(70, receivedHealth);
    Object.Destroy(go);
}
```

Or better — extract health logic to a pure C# class and test that directly in EditMode without any MonoBehaviour.

## Anti-Pattern 2: Test-Only Methods in Production Classes

**The violation:**
```csharp
// ❌ BAD: ResetForTesting() only exists for tests
public class AudioManager : MonoBehaviour
{
    private static AudioManager _instance;

    public static void ResetForTesting() // ← only called in tests
    {
        _instance = null;
        _isInitialized = false;
    }
}
```

**Why this is wrong:**
- Pollutes production code with test concerns
- The singleton + static state is the real design problem — this just masks it
- Dangerous if called accidentally in production

**The fix:**
```csharp
// ✅ GOOD: Make the system testable by design

// Option A: Extract pure C# AudioService, inject it — no singleton needed in tests

// Option B: Use [TearDown] to destroy the singleton owner
[TearDown]
public void TearDown()
{
    if (AudioManager.Instance != null)
        Object.DestroyImmediate(AudioManager.Instance.gameObject);
}
```

## Anti-Pattern 3: Scene Dependencies Inside Tests

**The violation:**
```csharp
// ❌ BAD: Test depends on a specific object existing in the scene
[UnityTest]
public IEnumerator InventoryUI_WhenItemAdded_ShowsItem()
{
    var ui = GameObject.Find("InventoryUI").GetComponent<InventoryUI>();
    // ...
    yield return null;
}
```

**Why this is wrong:**
- Test only passes in a specific scene with a specific hierarchy
- Breaks on scene rename or hierarchy restructure
- Execution order across tests becomes fragile

**The fix:**
```csharp
// ✅ GOOD: Create everything the test needs
[UnityTest]
public IEnumerator InventoryUI_WhenItemAdded_ShowsItem()
{
    var go = new GameObject("InventoryUI");
    var ui = go.AddComponent<InventoryUI>();

    // ... test behavior

    Object.Destroy(go);
    yield return null;
}
```

## Anti-Pattern 4: Static Singletons Inside Tests

**The violation:**
```csharp
// ❌ BAD: Test depends on GameManager singleton existing
[Test]
public void QuestSystem_WhenQuestCompleted_AwardsExperience()
{
    QuestSystem.CompleteQuest("quest_01");

    Assert.AreEqual(100, GameManager.Instance.PlayerExperience);
}
```

**Why this is wrong:**
- `GameManager.Instance` is null in EditMode — test errors, not fails
- State from previous tests leaks into this one
- The test is actually testing GameManager, not QuestSystem

**The fix:**
```csharp
// ✅ GOOD: Inject the dependency, test in isolation
public interface IExperienceReceiver
{
    void AddExperience(int amount);
}

[Test]
public void QuestSystem_WhenQuestCompleted_AwardsCorrectExperience()
{
    int awarded = 0;
    var fakeReceiver = new FakeExperienceReceiver(e => awarded = e);
    var system = new QuestSystem(fakeReceiver);

    system.CompleteQuest("quest_01");

    Assert.AreEqual(100, awarded);
}
```

## Anti-Pattern 5: PlayMode Tests for Pure Logic

**The violation:**
```csharp
// ❌ BAD: PlayMode used for a calculation with no Unity dependency
[UnityTest]
public IEnumerator DamageCalculator_WithArmor_ReducesDamage()
{
    var calculator = new DamageCalculator();

    int result = calculator.Calculate(100, armor: 20);

    Assert.AreEqual(80, result);
    yield return null;
}
```

**Why this is wrong:**
- PlayMode tests carry 5–10× more overhead than EditMode
- Domain enter/exit cost for zero benefit
- `yield return null` adds a frame wait for a pure calculation

**The fix:**
```csharp
// ✅ GOOD: EditMode test — no Unity runtime needed
[Test]
public void DamageCalculator_WithArmor_ReducesDamage()
{
    var calculator = new DamageCalculator();

    int result = calculator.Calculate(100, armor: 20);

    Assert.AreEqual(80, result);
}
```

## Anti-Pattern 6: WaitForSeconds as a Timing Fix

**The violation:**
```csharp
// ❌ BAD: Arbitrary delay used to "give it time"
[UnityTest]
public IEnumerator EnemySpawner_AfterSpawn_EnemyIsActive()
{
    spawner.Spawn();
    yield return new WaitForSeconds(1f); // "give it time to initialize"

    Assert.IsTrue(spawner.LastSpawned.activeInHierarchy);
}
```

**Why this is wrong:**
- Hides a real initialization ordering problem
- Adds 1+ second to every test run
- Will fail on slow machines or with variable frame rates

**The fix:**
```csharp
// ✅ GOOD: Wait for the specific frame the initialization completes
[UnityTest]
public IEnumerator EnemySpawner_AfterSpawn_EnemyIsActive()
{
    spawner.Spawn();
    yield return null; // one frame — Awake and Start have now run

    Assert.IsTrue(spawner.LastSpawned.activeInHierarchy);
}

// OR: Fix the spawner so the spawned object is active immediately
// after Spawn() returns — eliminating the frame wait entirely.
```

## Quick Reference

| Anti-Pattern | Fix |
|--------------|-----|
| Testing internal fields via reflection | Test observable output (events, return values, public state) |
| Test-only methods on MonoBehaviour | Move to `[TearDown]` utilities or fix the design |
| `GameObject.Find` inside tests | Create objects explicitly in test setup |
| Static singleton inside tests | Inject an interface; use `[TearDown]` to destroy singleton owner |
| PlayMode test for pure C# logic | Move to EditMode |
| `WaitForSeconds(n)` for timing | Use `yield return null`; find the actual frame dependency |

## Red Flags

- Reflection to access private MonoBehaviour fields
- `ResetForTesting()`, `GetStateForTesting()`, `IsTestMode` in production code
- `GameObject.Find` or `FindObjectOfType` in any test
- Any test accessing `Instance` on a singleton
- `[UnityTest]` on a test that never yields
- `yield return new WaitForSeconds(n)` where `n > 0.1f`
- Tests that only pass when run in a specific order
- Test that asserts exact floating-point equality without tolerance (use `Assert.AreEqual(expected, actual, delta)`)
- Test that depends on `Time.timeScale` default value without setting it explicitly in `[SetUp]`
- Test that assumes `Application.isPlaying` without explicitly verifying context

## Mutation Testing Awareness

If removing a line of production logic does not cause a test to fail, your test suite is insufficient.

After implementing a feature, do a manual spot-check:
1. Comment out or negate a condition in the production code
2. Run the tests
3. If all tests still pass — the missing behavior is untested. Add a test for it.

This is especially relevant for:
- Guard clauses (`if (x <= 0) return`)
- Boundary conditions in combat/economy calculations
- Event subscription checks (`if (onEvent != null)`)
- Early-exit paths that protect against invalid state

You do not need a dedicated mutation testing tool. The discipline of asking "which test would catch this if I deleted it?" is sufficient.

## Bottom Line

**If domain logic is in a pure C# class, it is straightforward to test.**
**If it is inside a MonoBehaviour, extract the logic first, then test it.**

Tests that are painful to write are telling you the design needs work.
