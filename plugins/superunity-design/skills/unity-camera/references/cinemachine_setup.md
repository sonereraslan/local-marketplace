# Cinemachine — Unity Camera Setup Guide

## Cinemachine Package Setup

```
Install: Window -> Package Manager -> Cinemachine (Unity Registry)
Required version: Cinemachine 3.x (Unity 2022.3+) or Cinemachine 2.x (earlier)

Note: This guide uses Cinemachine 3.x API naming.
For Cinemachine 2.x, CinemachineCamera -> CinemachineVirtualCamera,
CinemachinePositionComposer -> CinemachineFramingTransposer.
```

---

## Camera Rig by Perspective

### 2D / 2.5D Side-Scroll Setup

```
Main Camera GameObject:
  Camera component:
    Projection:     Perspective (FOV 40-50 for subtle depth)
                    OR Orthographic (Size 5-7 for flat 2D)
    Clear Flags:    Solid Color or Skybox
    Culling Mask:   Everything

  CinemachineBrain component:
    Default Blend:  EaseInOut, 0.7 sec
    Update Method:  Smart Update
```

**Gameplay Follow Camera (2D/2.5D):**
```
GameObject: "CM_Gameplay"
  CinemachineCamera component:
    Priority:  10 (default gameplay camera)

  Body — CinemachinePositionComposer:
    Tracked Object Offset:  (0, 1, 0)     — frame player slightly above centre
    Lookahead Time:         0.3            — camera leads movement direction
    Lookahead Smoothing:    5
    Damping X:              1.0            — smooth horizontal follow
    Damping Y:              0.8            — slightly tighter vertical
    Screen X:               0.4            — offset left of centre (player looks right)
    Screen Y:               0.4            — player in lower portion of frame
    Dead Zone Width:        0.1            — small dead zone for micro-movement
    Dead Zone Height:       0.05
    Soft Zone Width:        0.6
    Soft Zone Height:       0.6

  Aim — CinemachineRotationComposer:
    Tracked Object Offset:  (0, 0.5, 0)
    Lookahead Time:         0
    Damping:                2

  Lens:
    Field of View:  45     (perspective) or Ortho Size: 5.5 (orthographic)
```

### Third-Person Setup

```
GameObject: "CM_ThirdPerson"
  CinemachineCamera component:
    Priority:  10

  Body — Cinemachine3rdPersonFollow:
    Shoulder Offset:     (0.5, 0.3, 0)    — over-shoulder view
    Camera Distance:     4                  — distance behind player
    Camera Side:         0.6               — offset right
    Damping:             (0.5, 0.5, 0.5)
    Vertical Arm Length: 0.4
    Camera Collision Filter: Default layer mask

  Aim — CinemachineRotationComposer:
    Tracked Object Offset:  (0, 1.5, 0)   — look at head height
    Damping:                3

  Lens:
    Field of View: 60
```

### Top-Down / Isometric Setup

```
GameObject: "CM_TopDown"
  CinemachineCamera component:
    Priority:  10

  Body — CinemachineTransposer (or CinemachinePositionComposer):
    Follow Offset:  (0, 15, -10)          — angled top-down
    Damping:        (1, 1, 1)
    Binding Mode:   World Space

  Aim — CinemachineRotationComposer:
    Tracked Object Offset:  (0, 0, 0)
    Damping:                2

  Lens:
    Field of View: 45 (perspective) or Ortho Size: 8-12 (orthographic)

  Notes:
    - For pure top-down: Follow Offset (0, 20, 0), camera rotation (90, 0, 0)
    - For isometric: Follow Offset (0, 15, -10), camera rotation (55, 0, 0)
    - Add zoom control by adjusting FOV or Ortho Size via script
```

### Look-Ahead Direction Flip (2D/2.5D)

```csharp
// Flip camera offset when player changes direction
public class CameraDirectionBias : MonoBehaviour
{
    [SerializeField] CinemachineCamera virtualCamera;
    [SerializeField] float leftScreenX  = 0.6f;  // player on right, looking left
    [SerializeField] float rightScreenX = 0.4f;  // player on left, looking right
    [SerializeField] float flipSpeed    = 2f;

    private CinemachinePositionComposer _composer;
    private float _targetScreenX;

    void Awake()
    {
        _composer = virtualCamera.GetComponent<CinemachinePositionComposer>();
    }

    public void SetFacingDirection(float direction)
    {
        _targetScreenX = direction > 0 ? rightScreenX : leftScreenX;
    }

    void Update()
    {
        var composition = _composer.Composition;
        composition.ScreenPosition.x = Mathf.Lerp(
            composition.ScreenPosition.x,
            _targetScreenX,
            Time.deltaTime * flipSpeed
        );
        _composer.Composition = composition;
    }
}
```

---

## Zone Confinement

### Confiner Setup (2D)

```
Each room / zone needs:
  1. A PolygonCollider2D on a dedicated "CameraBounds" layer (set to trigger)
  2. The collider defines the camera's allowed area in that zone
  3. CinemachineConfiner2D component on the virtual camera

CinemachineConfiner2D settings:
  Bounding Shape 2D:   [reference to the zone's PolygonCollider2D]
  Damping:             0.3   — soft approach to bounds (not hard stop)
  Max Window Size:     0     — recalculate every frame (set higher for performance)
```

### Confiner Setup (3D)

```
Each zone needs:
  1. A BoxCollider or MeshCollider marked as trigger on a "CameraBounds" layer
  2. CinemachineConfiner3D component on the virtual camera

CinemachineConfiner3D settings:
  Bounding Volume:     [reference to the zone's Collider]
  Damping:             0.3
```

### Zone Camera Trigger System

```csharp
// Place on trigger volume at zone entrance — works for 2D and 3D
public class CameraZoneTrigger : MonoBehaviour
{
    [SerializeField] CinemachineCamera zoneCamera;
    [SerializeField] int activePriority   = 15;
    [SerializeField] int inactivePriority = 0;

    void Awake()
    {
        zoneCamera.Priority = inactivePriority;
    }

    // Use OnTriggerEnter2D / OnTriggerExit2D for 2D games
    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
            zoneCamera.Priority = activePriority;
    }

    void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
            zoneCamera.Priority = inactivePriority;
    }
}
```

### Area Entry — Wide Establishing Shot

```csharp
// Briefly activates a wide camera on area entry before blending to gameplay camera
public class AreaEntryCamera : MonoBehaviour
{
    [SerializeField] CinemachineCamera establishingCamera;
    [SerializeField] float holdDuration = 2f;
    [SerializeField] int establishPriority = 20;

    private bool _hasTriggered;

    // Use OnTriggerEnter2D for 2D games
    void OnTriggerEnter(Collider other)
    {
        if (_hasTriggered || !other.CompareTag("Player")) return;
        _hasTriggered = true;
        StartCoroutine(EstablishingSequence());
    }

    IEnumerator EstablishingSequence()
    {
        establishingCamera.Priority = establishPriority;
        yield return new WaitForSeconds(holdDuration);
        establishingCamera.Priority = 0;
        // Brain blends to gameplay camera automatically
    }
}
```

---

## Cinematic Camera Patterns

### Pan-to-Reveal (show consequence of action)

```csharp
public class PanToReveal : MonoBehaviour
{
    [SerializeField] CinemachineCamera revealCamera;
    [SerializeField] Transform targetPoint;
    [SerializeField] float holdTime  = 2f;
    [SerializeField] int priority    = 25;

    public void TriggerReveal()
    {
        revealCamera.Follow = null;
        revealCamera.LookAt = targetPoint;
        revealCamera.Priority = priority;
        StartCoroutine(RevealSequence());
    }

    IEnumerator RevealSequence()
    {
        yield return new WaitForSeconds(holdTime);
        revealCamera.Priority = 0;
    }
}
```

### Dolly Track — Guided Camera Path

```
Setup:
  1. Create empty GameObject -> Add CinemachineSplineDolly
  2. Add child SplineContainer -> draw the dolly path in the Scene view
  3. Create CinemachineCamera with Body = CinemachineSplineDolly

CinemachineSplineDolly settings:
  Spline:          [reference to SplineContainer]
  Position Units:  Normalized (0-1 along path)
  Auto Dolly:      Enabled — follows nearest point to target
  Damping:         0.5

Drive position via script or Timeline for cinematic control.
```

```csharp
// Drive dolly position over time for a cinematic move
public class DollyMover : MonoBehaviour
{
    [SerializeField] CinemachineSplineDolly dolly;
    [SerializeField] float duration = 3f;

    public void StartDollyMove(float fromPosition, float toPosition)
    {
        StartCoroutine(MoveDolly(fromPosition, toPosition));
    }

    IEnumerator MoveDolly(float from, float to)
    {
        float t = 0;
        while (t < 1)
        {
            t += Time.deltaTime / duration;
            dolly.CameraPosition = Mathf.Lerp(from, to, Mathf.SmoothStep(0, 1, t));
            yield return null;
        }
    }
}
```

### Lock-and-Hold (static emotional frame)

```csharp
// Static camera — player moves within a fixed frame
public class LockCamera : MonoBehaviour
{
    [SerializeField] CinemachineCamera lockCamera;
    [SerializeField] int priority = 25;

    // lockCamera.Follow = null (no tracking)
    // Position and rotation set in Scene view to frame the moment

    public void Activate()  => lockCamera.Priority = priority;
    public void Release()   => lockCamera.Priority = 0;
}
```

---

## Blend Profiles

### Custom Blend Settings

```
CinemachineBrain -> Custom Blends asset:

  From                    To                      Blend       Duration
  -----------------------------------------------------------------------
  CM_Gameplay             CM_PuzzleZone           EaseInOut   0.7
  CM_PuzzleZone           CM_Gameplay             EaseOut     0.5
  CM_Gameplay             CM_Establishing         Cut         0.0
  CM_Establishing         CM_Gameplay             EaseInOut   1.0
  CM_Gameplay             CM_Cinematic            EaseIn      0.5
  CM_Cinematic            CM_Gameplay             EaseOut     0.8
  CM_Gameplay             CM_Combat               EaseInOut   0.3
  CM_Combat               CM_Gameplay             EaseOut     0.5
  Any                     Any                     EaseInOut   0.7
```

### Blend Styles Reference

```
Cut:        Instant — shock, surprise, time skip
EaseIn:     Slow start, fast end — entering a cinematic (feels deliberate)
EaseOut:    Fast start, slow end — returning to gameplay (feels smooth)
EaseInOut:  Standard — room-to-room transitions
Linear:     Constant speed — dolly moves, mechanical feel
```

---

## Parallax System (2D / 2.5D)

### Layer Setup

```
Hierarchy:
  Environment
  +-- ParallaxLayer_Sky         Z = +20   SortingLayer: Background-3
  +-- ParallaxLayer_FarBG       Z = +12   SortingLayer: Background-2
  +-- ParallaxLayer_MidBG       Z = +6    SortingLayer: Background-1
  +-- GameplayLayer             Z = 0     SortingLayer: Default
  +-- ParallaxLayer_NearFG      Z = -3    SortingLayer: Foreground-1
  +-- ParallaxLayer_Overlay     Z = -5    SortingLayer: Foreground-2
```

### Script-Driven Parallax

```csharp
public class ParallaxLayer : MonoBehaviour
{
    [SerializeField] Transform cameraTransform;
    [SerializeField] float parallaxFactor = 0.5f; // 0 = static, 1 = moves with camera

    private Vector3 _startPos;
    private float _startCamX;

    void Start()
    {
        _startPos  = transform.position;
        _startCamX = cameraTransform.position.x;
    }

    void LateUpdate()
    {
        float deltaX = cameraTransform.position.x - _startCamX;
        float parallaxX = deltaX * parallaxFactor;
        transform.position = new Vector3(
            _startPos.x + parallaxX,
            _startPos.y,
            _startPos.z
        );
    }
}
```

### Parallax Factor Guide

| Layer | Distance | Factor | Movement feel |
|-------|----------|--------|---------------|
| Sky | Z +20 | 0.05 | Nearly static |
| Far background | Z +12 | 0.15 | Very slow drift |
| Mid background | Z +6 | 0.35 | Subtle movement |
| Gameplay | Z 0 | 1.0 | Moves with camera |
| Near foreground | Z -3 | 1.3 | Passes faster than player |
| Overlay frame | Z -5 | 1.8 | Fastest — creates depth |

---

## Camera Zoom Control (Top-Down / Strategy)

```csharp
// Zoom control for top-down or strategy cameras
public class CameraZoom : MonoBehaviour
{
    [SerializeField] CinemachineCamera vcam;
    [SerializeField] float minZoom = 5f;
    [SerializeField] float maxZoom = 15f;
    [SerializeField] float zoomSpeed = 2f;
    [SerializeField] bool isOrthographic = true;

    private float _targetZoom;

    void Start()
    {
        _targetZoom = isOrthographic ? vcam.Lens.OrthographicSize : vcam.Lens.FieldOfView;
    }

    void Update()
    {
        float scroll = Input.mouseScrollDelta.y;
        if (Mathf.Abs(scroll) > 0.01f)
        {
            _targetZoom -= scroll * zoomSpeed;
            _targetZoom = Mathf.Clamp(_targetZoom, minZoom, maxZoom);
        }

        if (isOrthographic)
        {
            var lens = vcam.Lens;
            lens.OrthographicSize = Mathf.Lerp(lens.OrthographicSize, _targetZoom, Time.deltaTime * 5f);
            vcam.Lens = lens;
        }
        else
        {
            var lens = vcam.Lens;
            lens.FieldOfView = Mathf.Lerp(lens.FieldOfView, _targetZoom, Time.deltaTime * 5f);
            vcam.Lens = lens;
        }
    }
}
```

---

## Timeline Integration — Cinematic Sequences

### Timeline Setup for Camera Cinematics

```
For multi-shot cinematic sequences (narrative beats, boss intros, act transitions):

  1. Create Timeline asset on a director GameObject
  2. Add Cinemachine Track -> bind to CinemachineBrain
  3. Add Cinemachine Shot clips for each camera in sequence
  4. Set blend curves between clips on the track
  5. Trigger via PlayableDirector.Play() from gameplay code

Timeline structure:
  [Establishing Wide] --blend--> [Push to Character] --blend--> [Return to Gameplay]
  0.0s                  1.5s      3.0s                  4.5s      5.5s
```

```csharp
// Trigger a Timeline cinematic from gameplay
public class CinematicTrigger : MonoBehaviour
{
    [SerializeField] PlayableDirector director;
    [SerializeField] bool playOnce = true;

    private bool _hasPlayed;

    // Use OnTriggerEnter2D for 2D games
    void OnTriggerEnter(Collider other)
    {
        if (playOnce && _hasPlayed) return;
        if (!other.CompareTag("Player")) return;

        _hasPlayed = true;
        director.Play();
    }
}
```

---

## Depth-of-Field (Perspective Cameras)

### URP Post-Processing Setup

```
For perspective cameras — blur background to focus on gameplay layer:

  Global Volume -> Depth of Field override:
    Mode:             Bokeh (quality) or Gaussian (performance)
    Focus Distance:   Match camera distance to gameplay plane
    Focal Length:     50 (default) — increase for shallower DOF
    Aperture:         5.6 — subtle blur; lower = more blur

  Adjust dynamically:
    Engagement   -> increase blur (tighten focus on gameplay)
    Cinematic    -> shift focus to narrative object
    Wide shot    -> reduce blur (show full environment)
```

```csharp
// Shift depth of field focus for cinematic moments
public class DOFFocusShift : MonoBehaviour
{
    [SerializeField] Volume globalVolume;
    [SerializeField] float focusShiftDuration = 0.5f;

    private DepthOfField _dof;

    void Start()
    {
        globalVolume.profile.TryGet(out _dof);
    }

    public void FocusOn(float distance)
    {
        StartCoroutine(ShiftFocus(distance));
    }

    IEnumerator ShiftFocus(float targetDistance)
    {
        float start = _dof.focusDistance.value;
        float t = 0;
        while (t < 1)
        {
            t += Time.deltaTime / focusShiftDuration;
            _dof.focusDistance.value = Mathf.Lerp(start, targetDistance, t);
            yield return null;
        }
    }
}
```

---

## Camera Design Patterns — Quick Reference

### Room Entry
- New area -> wide establishing shot (2-3 sec) -> blend to follow camera
- Revisited area -> follow camera immediately (no repeat establishing)

### Challenge Framing
- Camera adjusts to show the full challenge space
- Interactive objects always visible within the frame
- Camera stays stable during active gameplay unless the player moves

### Narrative Beats
- Camera leaves the player to frame a story moment
- Static hold for 3-5 seconds — lets the image speak
- Returns to gameplay with a smooth blend

### NPC/Companion Moments
- Camera briefly tracks the NPC when they react to something important
- Player retains control — only the camera shifts, not the input
- Duration: 1-2 seconds, then blends back

### Depth Usage (2.5D / 3D)
- Background layers show the wider world
- Foreground frames create intimacy in close spaces
- Parallax or DOF slows/shifts during emotional moments
