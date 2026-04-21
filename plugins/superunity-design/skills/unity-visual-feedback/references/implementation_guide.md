# Visual Feedback — Unity Implementation Guide

## Animator — Character States

### Animator Controller Setup

```
States (minimum per character — adapt to your game):
  Idle          -> default state, looping
  Move          -> BlendTree on velocity (1D or 2D based on perspective)
  PrimaryAction -> trigger-based, exits to Idle (attack, interact, cast)
  SecondaryAction -> trigger-based (alt attack, block, dodge)
  Hurt          -> trigger-based, short duration
  Recover       -> auto-transition from Hurt
  SpecialState  -> bool-based (carrying, aiming, charging, etc.)
  EmotionBlend  -> bool-based (story flag), modifies movement speed/posture

Parameters:
  float  Velocity        -> movement blend (magnitude or X/Y)
  bool   IsSpecialState  -> context-specific override
  bool   IsEmotionBlend  -> set via story flag
  trigger PrimaryAction
  trigger SecondaryAction
  trigger Hurt
```

### Emotional State Blend via Script

```csharp
// Set emotion state from story manager or gameplay state
public void SetEmotionalState(EmotionState state)
{
    float speedMultiplier = state switch
    {
        EmotionState.Grief       => 0.7f,
        EmotionState.Urgency     => 1.2f,
        EmotionState.Exhaustion  => 0.6f,
        EmotionState.Confident   => 1.1f,
        EmotionState.Normal      => 1.0f,
        _ => 1.0f
    };
    animator.SetFloat("SpeedMultiplier", speedMultiplier);
}
```

### Animation Event — Footstep Particles

```csharp
// Called via Animation Event on walk/run cycle frames
public void OnFootstep()
{
    ParticleSystem dust = GetFootstepParticles();
    dust.transform.position = footBone.position;
    dust.Play();
}
```

---

## ParticleSystem — Common Setups

### Dust Burst (footstep / landing)

```
Duration:        0.3
Looping:         false
Start Lifetime:  0.2-0.4
Start Speed:     1-3
Start Size:      0.1-0.3
Emission:        Burst — 8-12 particles on play
Shape:           Hemisphere, radius 0.2
Color:           Match floor material (desaturated)
Renderer:        Additive or Alpha Blend
```

### Impact Sparkle (hit / success / activation)

```
Duration:        0.8
Looping:         false
Start Lifetime:  0.5-1.0
Start Speed:     2-5
Start Size:      0.05-0.15
Emission:        Burst — 20-30 particles
Shape:           Sphere, radius 0.3
Color over Lifetime: Warm yellow -> transparent (or match game's accent colour)
Renderer:        Additive blend
```

### Blood / Damage Burst (combat hit)

```
Duration:        0.4
Looping:         false
Start Lifetime:  0.3-0.6
Start Speed:     3-6
Start Size:      0.05-0.2
Emission:        Burst — 15-25 particles
Shape:           Cone, angle 30, radius 0.1
Color:           Match game's damage palette
Gravity Modifier: 0.5-1.0 (drops after burst)
Renderer:        Alpha Blend
```

### Object Wiggle (interactable idle)

```
Use DOTween or Animation Clip (not ParticleSystem):

DOTween:
  transform.DOShakePosition(duration: 0.3f, strength: 0.05f, vibrato: 10)
  Loop: LoopType.Yoyo, DelayBetween: 2.0f
```

---

## Cinemachine — Screen Shake

### Impulse Source Setup (recommended over manual shake)

```csharp
// On the impacting object
[SerializeField] CinemachineImpulseSource impulseSource;

void OnImpact()
{
    // Small impact (landing, light hit)
    impulseSource.GenerateImpulse(new Vector3(0, -0.1f, 0));

    // Large impact (explosion, heavy hit, boss stomp)
    impulseSource.GenerateImpulse(new Vector3(0.2f, -0.2f, 0));
}
```

### Impulse Listener on Virtual Camera

```
Add component: CinemachineImpulseListener
Gain:    0.5 (subtle) to 1.0 (normal)
Use 2D:  true (for 2D/2.5D games) / false (for 3D)
```

### Shake Intensity Guide

| Event | Impulse strength | Duration |
|-------|----------------|---------|
| Footstep | 0.02-0.05 | 0.05 sec |
| Player lands from height | 0.1-0.15 | 0.15 sec |
| Light attack hit | 0.05-0.1 | 0.08 sec |
| Heavy attack hit | 0.15-0.25 | 0.12 sec |
| Explosion / major event | 0.3-0.5 | 0.2 sec |
| Boss stomp / earthquake | 0.4-0.6 | 0.3 sec |

**Rule**: If you notice the shake consciously, it is too strong. It should be felt, not seen.

---

## Hit-Stop Implementation

```csharp
public IEnumerator HitStop(float duration = 0.05f)
{
    Time.timeScale = 0f;
    yield return new WaitForSecondsRealtime(duration);
    Time.timeScale = 1f;
}

// Usage — call on impact
StartCoroutine(HitStop(0.04f)); // 2-3 frames at 60fps
```

**Hit-stop guide:**
- Minor impact: 0.03-0.05 sec (2-3 frames)
- Major impact: 0.08-0.1 sec (5-6 frames)
- Never exceed 0.1 sec — becomes frustrating

---

## DOTween — Polish Animations

### Object Bounce on Interact

```csharp
// Object acknowledges player input
public void OnInteractAttempt()
{
    transform.DOPunchScale(Vector3.one * 0.1f, 0.3f, 8, 0.5f);
}
```

### Success Scale Pop

```csharp
public void OnSuccess()
{
    transform.DOScale(1.15f, 0.1f)
             .SetEase(Ease.OutBack)
             .OnComplete(() =>
                 transform.DOScale(1f, 0.15f).SetEase(Ease.InBack));
}
```

### Light Flash (key moment)

```csharp
public IEnumerator LightFlash(Light targetLight, float intensity, float duration)
{
    float original = targetLight.intensity;
    targetLight.intensity = intensity;
    yield return new WaitForSeconds(duration);

    // Lerp back
    float t = 0;
    while (t < 1)
    {
        t += Time.deltaTime / 0.3f;
        targetLight.intensity = Mathf.Lerp(intensity, original, t);
        yield return null;
    }
}
```

### Damage Flash (screen overlay)

```csharp
// Brief red flash on damage using a UI Image overlay
public IEnumerator DamageFlash(Image overlay, float duration = 0.1f)
{
    overlay.color = new Color(1, 0, 0, 0.3f);
    overlay.gameObject.SetActive(true);

    float t = 0;
    while (t < 1)
    {
        t += Time.deltaTime / duration;
        overlay.color = new Color(1, 0, 0, Mathf.Lerp(0.3f, 0, t));
        yield return null;
    }
    overlay.gameObject.SetActive(false);
}
```

---

## UI Implementation Patterns

### Interaction Prompt (world-based)

```
Approach: Small icon hovers near object when player enters trigger zone
  - SpriteRenderer or Canvas on child object of interactive item
  - Enable/disable via OnTriggerEnter / OnTriggerExit
  - Subtle float animation (DOTween: transform.DOMoveY +0.1f, 0.8f, LoopType.Yoyo)
  - Scale 0 -> 1 on appear (DOTween: transform.DOScale(1f, 0.2f).From(0))
  - Optional: Hide after first successful interaction (don't repeat for known mechanics)

Icon design:
  - Minimal — button symbol or hand icon only
  - Semi-transparent (alpha 0.7)
  - Consistent style across the game
```

### Health / Danger State

```
Option 1 — Animation state (minimal UI games):
  Low health -> trigger "Limp" or "Struggle" animation blend
  Critically low -> slow movement, breathing animation

Option 2 — Post-processing vignette (subtle):
  Full health:   Vignette intensity 0
  50% health:    Vignette intensity 0.3 (subtle darkening at edges)
  Critical:      Vignette intensity 0.5, desaturate slightly
  Use URP Global Volume with Vignette override

Option 3 — Health bar (standard HUD):
  Smooth lerp on value change
  Colour shift: green -> yellow -> red
  Optional: brief shake on damage
```

### Objective Indicator

```
Minimal approach (exploration / puzzle games):
  - NPC or ally looks toward goal (animation trigger, no UI)
  - If still stuck: faint particle trail from player toward next beat
  - Last resort: subtle directional arrow

Standard approach (action / RPG):
  - Waypoint marker on HUD or minimap
  - Distance indicator
  - Quest log for complex objectives
```

---

## Disney Principles — Unity Application Quick Reference

| Principle | Unity technique |
|-----------|----------------|
| Squash & Stretch | Non-uniform scale on impact frames; DOPunchScale |
| Anticipation | 2-4 frame wind-up animation before main action |
| Follow Through | Secondary Rigidbody or spring joint on cloth/hair/weapon |
| Slow In / Slow Out | Animation curve: EaseInOut on all clips |
| Arcs | Animation curve editor: ensure joint paths are curved not linear |
| Timing | Adjust clip speed via Animator speed parameter per state |
| Exaggeration | Increase squash/stretch magnitude — match to game's art style |
| Secondary Action | Idle breathing, tail wag, cape flutter, weapon sway |
