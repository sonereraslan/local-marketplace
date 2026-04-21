---
name: unity-visual-feedback
description: >
  This skill should be used when designing visual feedback, game feel, or polish for any Unity
  game — including making actions feel responsive, ensuring players can read the scene at a glance,
  designing animation states, adding juice to player interactions, or deciding what UI is needed.
  Trigger phrases include: "add juice", "game feel", "feedback for this action", "screen shake",
  "particle effect", "hit pause", "squash and stretch", "action feels flat", "player can't tell
  what's interactive", "interaction feedback", "animation states", "visual clarity",
  "scene readability", "UI design", "HUD design", "diegetic UI", "feedback mapping",
  "make this feel better", "polish pass", "anticipation animation", "feedback systems",
  "combat feel", "hit feedback".
---

# Unity Visual Feedback Designer

> Make every action readable and every moment feel alive — through clarity, feedback, animation, and polish

## When to Use This Skill

- Designing feedback for a specific player action (jump, attack, interact, fail)
- Diagnosing why a scene feels unclear or actions feel unresponsive
- Defining animation states and their emotional intent
- Adding juice and polish without breaking clarity or performance
- Deciding what UI the game needs and how to present it

> **Design the mechanic first** using `unity-mechanics` (this plugin).
> **Design level visual atmosphere** using `unity-level` (this plugin).
> **Design audio response** using `unity-audio` (this plugin).

### Feedback Ownership

This skill **starts** the feedback design chain for any player action. It owns the visual layer: animation, particles, screen effects, state changes, and UI. The audio layer is designed in `unity-audio`. Neither skill alone covers "action feel" — both are required.

**Workflow order**: `unity-mechanics` (mechanic works?) → `unity-visual-feedback` (visual response) → `unity-audio` (audio response). Always design visual feedback before audio — the visual establishes timing and intensity that audio must match.

---

## Core Philosophy

### "If an action matters, it must feel noticeable."
Every mechanic the player uses must produce a feedback response that communicates: *that worked* or *that didn't work*. Silent actions erode trust in the controls.

### "If the player misses it, it doesn't exist."
Visual hierarchy is not decoration. An interactive object that blends into the background is a broken design. Clarity is a higher priority than beauty.

### Feedback Before Polish
Apply layers in order. A scene with no clarity cannot be rescued by juice. A feedback system that is ambiguous cannot be fixed by screen shake.

---

## Five-Layer Workflow

Apply in this order — each layer depends on the one before:

```
Layer 1 — VISUAL CLARITY      Can the player read the scene?
Layer 2 — FEEDBACK SYSTEMS    Does every action communicate its result?
Layer 3 — ANIMATION           Does movement convey emotion and intent?
Layer 4 — JUICE               Does every satisfying action feel satisfying?
Layer 5 — UI / UX             What UI is necessary and how should it be presented?
```

---

## Layer 1: Visual Clarity

**Goal**: The player instantly understands what is interactive, dangerous, or important — without reading any text.

### Visual Hierarchy Rules

| Priority | Visual treatment | Examples |
|----------|----------------|---------|
| **Primary** — act now | Brightest, most saturated, in motion or light | The object to interact with, the enemy to fight, the path forward |
| **Secondary** — relevant | Midtone, readable, still | The door that will open, the platform ahead, the UI element |
| **Background** — context | Desaturated, low contrast, static | Walls, far scenery, non-interactive props |

### Interactive vs. Static Visual Language

Establish one consistent visual rule for your game and never break it:

```
Interactable objects:
  - Visually distinct from environment (colour, contrast, shape, or motion)
  - Optional: idle animation, glow, particle, outline when in range
  - Consistent shape language across the game

Hazards:
  - Clearly dangerous before the player touches them
  - Distinct visual language from interactive objects
  - Active state is more visually intense than idle

Background:
  - Lower contrast and saturation than gameplay layer
  - No movement that competes with gameplay-layer elements
```

### Scene Readability Checklist

```
- [ ] Can the player identify the primary interactive element in <2 seconds?
- [ ] Are hazards visually distinct from interactive objects?
- [ ] Does the background layer have lower contrast than the gameplay layer?
- [ ] Are depth layers (foreground, gameplay, background) clearly separated?
- [ ] Does the camera frame the most important element at each beat?
- [ ] Is the visual language consistent across the game?
```

Full scene analysis patterns at [references/implementation_guide.md].

---

## Layer 2: Feedback Systems

**Goal**: Every player action produces an immediate, unambiguous response.

### Three Feedback Types

| Type | Trigger | Response |
|------|---------|---------|
| **Immediate** | Button press / action | Instant visual + audio within 1 frame |
| **State-based** | World condition changes | Environment reflects new state clearly |
| **Anticipation** | Action about to happen | Warning cue 0.3-0.5 seconds before consequence |

### Action -> Feedback Mapping

For every core mechanic, define the full feedback chain:

```markdown
## Action: [mechanic name]

Success feedback:
  Visual:  [what the player sees — animation, particle, colour change]
  Audio:   [sound response — described in unity-audio]
  World:   [how the environment changes state]

Failure / wrong-use feedback:
  Visual:  [what shows the action did not work — not punishment, just information]
  Audio:   [soft failure sound — not alarming]
  World:   [environment shows resistance or lack of change]

State change feedback:
  Visual:  [before state vs after state — must be instantly readable at a glance]
```

**Rule**: Failure feedback must never feel like punishment — it must feel like information. The player should understand *what to try differently*, not feel penalised.

### Game State Readability

Every important game state must be readable at a glance:

```
Default state:    Standard appearance
Active / engaged: Visual emphasis (glow, animation, UI indicator)
Completed state:  Clear change (opened, destroyed, activated, collected)
                  Should not require a UI label — the world shows it
```

---

## Layer 3: Animation Direction

**Goal**: Character movement communicates state and intent.

### Core Animation States

Define these for the player character (and other key characters) as a minimum:

| State | Trigger | Intent |
|-------|---------|--------|
| **Idle** | No input | Alive, breathing, present |
| **Move** | Directional input | Neutral — pace varies by context |
| **Primary action** | Main mechanic used | Engaged, purposeful |
| **Secondary action** | Alternate mechanic | Variant of engagement |
| **Hurt / hit** | Damage received | Vulnerability, consequence |
| **Recovery** | After hit or fail | Returning to ready state |
| **Special state** | Context-specific | Matches the emotion of the moment |

### Four Animation Principles to Prioritise

Detailed principles at [references/implementation_guide.md]. For any game, prioritise:

| Principle | What it does | Most critical for |
|-----------|-------------|------------------|
| **Anticipation** | Small wind-up before main action | Jump, attack, throw — makes action feel intentional |
| **Squash & Stretch** | Deformation on impact/landing | Landing, hitting, bouncing objects |
| **Follow Through** | Secondary elements trail main body | Hair, cloth, weapon, particles — adds life |
| **Timing** | Frame count = weight | Slow = heavy/powerful; fast = light/snappy |

### Emotional Animation Rules (Adapt to Game)

```
Tension / fear:      Faster idle, shorter pauses, frequent glances
Confidence:          Steady pace, wide stance, minimal hesitation
Exhaustion:          Heavy foot plant, slower response to input
Determination:       Steady pace, direct movement, minimal idle variation
Joy / triumph:       Bounce, wider movements, faster recovery
```

---

## Layer 4: Juice

**Goal**: Satisfying actions feel physically real and rewarding without adding noise.

### Impact Feel Formula

Apply this sequence for any impactful action:

```
1. Anticipation     — 2-4 frame wind-up (squash, lean, or pause)
2. Action           — The main motion
3. Impact           — Hit-stop: freeze game 2-4 frames on contact
4. Response         — Target reacts (enemy flinches, object shakes, world responds)
5. Resolution       — Particle burst + sound + subtle camera response
```

### Juice Techniques — Quick Reference

| Technique | Use for | Intensity |
|-----------|---------|-----------|
| **Screen shake** | Large impacts, explosions, hard landings | Subtle — 0.1-0.2 units, 0.15 sec max |
| **Hit-stop** | Any attack or heavy impact | 2-4 frames at Time.timeScale = 0 |
| **Particle burst** | Successful interactions, footsteps, hits | Small, short-lived (< 0.5 sec) |
| **Squash & stretch** | Jumps, landings, bouncing objects | Exaggerated but brief — snap back quickly |
| **Light flash** | Major moment, crit hit, key event | Single frame colour overlay, then fade |
| **Object wiggle** | Interactive object responding to approach | Subtle idle — signals interactability |
| **Chromatic aberration** | Damage taken, disorientation | Brief pulse, not sustained |
| **Speed lines / motion blur** | Fast movement, dashes, charges | Duration matches action length |

### Juice Budget Rule

**Every action gets one primary effect.** Do not layer all techniques on a single moment.

```
Tier 1 (minor action):    particles OR sound response
Tier 2 (meaningful action): particles + sound + animation response
Tier 3 (major moment):    hit-stop + screen shake + particles + sound + camera
```

Full Unity implementation (ParticleSystem, Cinemachine, DOTween) at [references/implementation_guide.md].

---

## Layer 5: UI / UX

**Goal**: Communicate what needs to be communicated. Match UI approach to the game's genre and audience.

### UI Approaches by Genre

| Approach | Best for | Philosophy |
|----------|---------|-----------|
| **Minimal / world-first** | Puzzle, platformer, narrative, horror | UI as last resort — world communicates first |
| **Functional HUD** | Action, RPG, shooter, strategy | Clear persistent info — health, ammo, minimap |
| **Diegetic** | Immersive sim, horror, sci-fi | UI exists in the game world (hologram, tablet, watch) |
| **Stylized overlay** | Roguelike, card game, strategy | Heavy UI is part of the aesthetic |

### UI Justification Test

Before adding any UI element, answer:
1. Can this be communicated through the environment instead?
2. Can this be communicated through animation or sound instead?
3. If UI is unavoidable — is it the simplest possible version?
4. Does the UI style match the game's aesthetic and genre?

### Common UI Patterns

| UI need | World-based solution | UI fallback |
|---------|---------------------|-------------|
| "Press X to interact" | Object visual cue when in range | Small contextual prompt — disappears after first use |
| Health / status | Animation state, screen vignette | Health bar or number — persistent or on-damage only |
| Objective | Environmental cues, NPC dialogue | Subtle indicator — quest log for complex games |
| Inventory | N/A for most games | Genre-appropriate inventory screen |
| Minimap | Landmarks visible in world | Minimap for open/complex spaces |

---

## Action-Feedback Proposal Format

```markdown
## Feedback: [Action Name]

**Mechanic**: Which core mechanic does this apply to?

**Success chain**:
  Anticipation: [wind-up animation, 2-4 frames]
  Action:       [main movement]
  Impact:       [hit-stop duration, if applicable]
  Response:     [world reaction, particle, animation]
  Audio:        [sound — brief description, detail in unity-audio]

**Failure chain**:
  Visual:       [what shows the action did not succeed]
  Audio:        [soft non-punishing cue]
  World:        [environment shows resistance]

**State change**:
  Before:       [how the world looks in default state]
  After:        [how the world looks in changed state]
  Transition:   [animation / particle / sound during change]

**Juice tier**: 1 (minor) / 2 (meaningful) / 3 (major)

**Unity implementation**: [Animator / ParticleSystem / Cinemachine / DOTween]
  -> See references/implementation_guide.md for full setup
```

---

## Anti-Patterns

| Anti-pattern | Symptom | Fix |
|---|---|---|
| **Silent action** | Player presses a button and nothing noticeably changes | Add immediate visual + audio response on the same frame |
| **Feedback overload** | Every action has screen shake, particles, and flash | Apply juice budget — Tier 1 actions get one effect only |
| **Visual noise** | Background elements compete with interactive objects | Desaturate and reduce contrast in background layer |
| **Ambiguous state** | Player cannot tell if something changed | Ensure world state is visibly different before and after |
| **Punishing failure** | Wrong action plays alarming sound or flash | Replace with a soft, information-only response |
| **UI overload** | Screen cluttered with persistent indicators | Audit each element; remove or contextualise (show on hover, show on damage) |
| **Inconsistent language** | Different visual rules in different areas | Establish one visual language and enforce it everywhere |

---

## Related Skills in This Plugin

| Need | Skill |
|------|-------|
| Design the mechanic this feedback applies to | `unity-mechanics` |
| Place feedback within a level | `unity-level` |
| Design audio for each feedback event | `unity-audio` |
| Tie animation state to narrative moment | `unity-narrative` |

## Additional Resources

- **[references/visual_feedback_design.md]** — Source role definitions (5 roles)
- **[references/implementation_guide.md]** — Unity implementation: Animator states, ParticleSystem setup, Cinemachine shake, DOTween, UI patterns
