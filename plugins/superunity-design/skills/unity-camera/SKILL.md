---
name: unity-camera
description: >
  This skill should be used when designing camera behavior for any Unity game — including room
  framing, camera transitions between zones, cinematic camera moves for narrative beats, depth
  layering, Cinemachine virtual camera setup, or deciding when the camera should lead versus
  follow the player. Covers 2D, 2.5D, third-person, top-down, and isometric perspectives.
  Trigger phrases include: "camera design", "camera setup", "room framing", "camera transition",
  "cinematic camera", "Cinemachine", "virtual camera", "parallax layers", "depth layering",
  "camera follow", "camera reveal", "dolly camera", "camera zone", "confiner",
  "camera for puzzle", "camera for narrative beat", "third person camera", "top-down camera",
  "isometric camera", "2D camera".
---

# Unity Camera Designer

> The camera is a narrator — it shows the player what matters, hides what should surprise, and breathes with the emotion of each moment

## When to Use This Skill

- Designing how the camera frames a space on entry
- Planning camera transitions between zones or beats
- Setting up Cinemachine virtual cameras for any perspective
- Creating cinematic camera moves for narrative moments
- Designing depth layering for visual storytelling
- Deciding when the camera should lead, follow, or hold still

> **Design the level layout first** using `unity-level` (this plugin).
> **Design visual feedback and screen shake** using `unity-visual-feedback` (this plugin).
> **Design the narrative beat the camera serves** using `unity-narrative` (this plugin).

---

## Core Philosophy

### "The Camera is a Narrator, Not a Follower"
In any game, the camera does more than track the player. It reveals spaces, guides attention to important details, and creates emotional framing. A camera that only follows is a camera that tells no story.

### Restraint as Default
Most of the time, the camera follows the player simply and predictably. Special camera behavior — reveals, cinematic holds, depth shifts — is reserved for moments that earn it. Overusing camera tricks numbs the player to all of them.

### Match the Perspective to the Game
Different genres and perspectives require fundamentally different camera approaches. Define the default camera behavior first, then design the exceptions.

---

## Camera Perspective Guide

### Choosing Your Default Camera

| Perspective | Best for | Cinemachine body | Key considerations |
|------------|---------|-----------------|-------------------|
| **2D side-scroll** | Platformer, puzzle | Framing Transposer | Horizontal look-ahead, vertical damping, confiner bounds |
| **2.5D** | Side-scroll with 3D depth | Framing Transposer | Parallax layers, Z-axis dolly for reveals, depth-of-field |
| **Top-down** | Strategy, twin-stick, zelda-like | Transposer (offset Y) | Fixed angle, zoom for context, rotation optional |
| **Isometric** | Tactics, ARPG, city builder | Transposer (angled) | Fixed rotation or player-rotatable, zoom levels |
| **Third-person** | Action-adventure, RPG | 3rd Person Follow | Orbit, collision avoidance, shoulder offset |
| **First-person** | FPS, horror, immersive sim | POV / Hard Lock | Head bob, weapon sway, FOV changes for speed |

---

## Four-Phase Workflow

```
Phase 1 — ROOM FRAMING        How does the camera present each space?
Phase 2 — TRANSITIONS         How does the camera move between zones and beats?
Phase 3 — DEPTH & LAYERING    How does depth create atmosphere and guide attention?
Phase 4 — CINEMATIC CAMERAS   When does the camera leave the player to tell the story?
```

---

## Phase 1: Room Framing

**Goal**: Each room or zone is framed to show the player exactly what they need — the space, the goal, and the emotional tone — within the first 2 seconds.

### Framing Strategies

| Moment | Camera behavior | Purpose |
|--------|----------------|---------|
| **Area entry** | Wide shot — pull back to show full space | Orient the player; show scope |
| **Engagement** | Tighter follow — closer to player, less dead space | Focus attention on the interaction zone |
| **Challenge solved** | Brief pan or push toward consequence | Confirm result; show what changed |
| **Narrative beat** | Camera leaves player — frames the story element | Prioritise story over gameplay for this moment |
| **Return to gameplay** | Smooth blend back to follow camera | Restore player control without a jarring cut |

### Framing Rules (Adapt to Perspective)

**2D / 2.5D / Side-scroll:**
```
1. Show the goal and the obstacle in the same frame on room entry
2. Never frame the player dead centre — offset toward direction of travel
3. Use look-ahead bias: camera leads slightly in movement direction
4. Vertical sections: tilt or pull back further to show height
5. Keep interactive objects within the camera frame during engagement
```

**Third-person:**
```
1. Camera collision: never clip through walls or objects
2. Combat: widen FOV slightly or pull back to show more of the arena
3. Tight spaces: closer over-shoulder, reduced orbit speed
4. Open spaces: let the player see the horizon and landmarks
5. Lock-on: camera frames both player and target
```

**Top-down / Isometric:**
```
1. Zoom level communicates scope: zoomed in = intimate, zoomed out = strategic
2. Important elements should be within the default zoom frame
3. Edge panning or camera drag for larger-than-screen areas
4. Highlight tiles or areas under the cursor for readability
5. Minimap supplements camera for large spaces
```

---

## Phase 2: Transitions

**Goal**: Camera movement between zones feels intentional, never jarring, and communicates spatial relationships.

### Transition Types

| Type | Mechanism | Use for |
|------|-----------|---------|
| **Confiner blend** | Player crosses zone boundary -> camera blends to new confiner | Adjacent rooms, corridor-to-room |
| **Priority swap** | New virtual camera activates at higher priority | Beat changes within a room |
| **Dolly move** | Camera travels along a predefined path | Cinematic reveals, guided transitions |
| **Cut** | Instant switch, no blend | Time skip, shock, scene change |
| **Fade through black** | Fade out -> reposition -> fade in | Act transitions, large spatial jumps |
| **Zoom transition** | Camera zooms into a detail, cuts, zooms out in new space | Stylistic transitions, dream sequences |

### Blend Duration Guide

| Context | Blend time | Blend curve |
|---------|-----------|-------------|
| Adjacent room transition | 0.5-1.0 sec | EaseInOut |
| Beat change within room | 0.3-0.5 sec | EaseInOut |
| Cinematic reveal | 1.5-3.0 sec | Linear or custom |
| Return to gameplay | 0.5-0.8 sec | EaseOut |
| Shock or surprise | 0 sec (cut) | — |

### Zone Boundary Design

```
Each zone defines:
  - A Cinemachine confiner (2D polygon or 3D collider bounds)
  - A virtual camera with framing settings tuned to that zone
  - A trigger volume at the zone entrance that activates the virtual camera
  - An optional entry camera (wide reveal) before the follow camera takes over
```

---

## Phase 3: Depth & Layering

**Goal**: Use depth to create atmosphere, separate layers visually, and guide the player's eye to what matters.

### 2D / 2.5D Parallax Layer Structure

```
Layer 5 — Sky / far background     Z = +20    Parallax: 0.05x
Layer 4 — Far background            Z = +12    Parallax: 0.15x
Layer 3 — Mid background            Z = +6     Parallax: 0.35x
Layer 2 — Gameplay plane             Z = 0      Parallax: 1.0x (camera follows)
Layer 1 — Near foreground            Z = -3     Parallax: 1.3x
Layer 0 — Overlay / frame            Z = -5     Parallax: 1.8x
```

### 3D Depth Techniques

| Technique | Application | Effect |
|-----------|-------------|--------|
| **Depth of field** | Blur background during close interaction | Directs attention to gameplay layer |
| **Fog / atmospheric** | Distance fade on far geometry | Creates depth, hides LOD transitions |
| **Lighting zones** | Different light colour/intensity per area | Emotional framing, guides attention |
| **Foreground framing** | Objects between camera and player | Intimacy, confinement, voyeuristic tension |

### Depth as Storytelling

| Depth technique | Emotional effect | Example |
|----------------|-----------------|---------|
| **Deep background activity** | World feels alive beyond the play space | Distant city lights, moving vehicles, wildlife |
| **Foreground framing** | Intimacy, confinement, focus | Bars, foliage, doorframes framing the scene |
| **Depth-of-field shift** | Directs attention to a specific layer | Blur background to highlight a character moment |
| **Z-axis movement** | Scale and revelation | Camera moves through a doorway into a new space |

### Depth Design Rules

```
1. Interactive objects must be on the gameplay layer — never place them on parallax/background layers
2. Background layers use lower saturation and contrast than the gameplay layer
3. Foreground elements must not occlude interactive objects for more than 0.5 seconds of movement
4. Moving elements in background layers add life without competing with gameplay
5. Depth technique should match the game's art style and perspective
```

---

## Phase 4: Cinematic Cameras

**Goal**: At key moments, the camera temporarily becomes a director — framing story beats with intention before returning control to the player.

### Cinematic Camera Patterns

| Pattern | Camera behavior | Use for |
|---------|----------------|---------|
| **Pan-to-reveal** | Slow pan from player toward point of interest | Show consequence of an action |
| **Follow-subject** | Camera briefly tracks an NPC or object instead of player | Guide player attention, show NPC reaction |
| **Slow push** | Gentle dolly toward a story object or character | Draw attention to a narrative detail |
| **Pull-back** | Camera pulls away from player, revealing scale | Isolation, consequence, awe |
| **Lock-and-hold** | Camera stops moving; player moves within static frame | Weight, silence, grief — powerful framing |
| **Peek** | Camera shifts to show what's ahead or below | Foreshadowing, building anticipation |

### Cinematic Timing Rules

```
1. Cinematic cameras should last 2-5 seconds for gameplay reveals
2. Narrative cinematics can last 5-15 seconds — but only at major story beats
3. Always return to gameplay camera with a smooth blend (0.5-0.8 sec)
4. Never take camera control away during active gameplay challenges
5. Pair silence or a music cue with cinematic camera moves — camera and audio work together
```

### When to Use Cinematic Cameras

```
YES — earned moments:
  - First time entering a major area (establishing shot)
  - Challenge completed -> show consequence in the world
  - Narrative reveal (discovery, character moment, loss)
  - Boss entrance or major enemy reveal
  - Act transition or major environment change

NO — these stay on gameplay camera:
  - Routine interactions
  - Repeated actions the player has seen before
  - Minor pickups or collectibles
  - Any moment where the player needs control
```

---

## Scene Camera Proposal Format

```markdown
## Camera: [Scene / Zone Name]

**Perspective**: 2D / 2.5D / Third-person / Top-down / Isometric / First-person
**Zone type**: Combat arena / Puzzle room / Corridor / Narrative space / Hub / Open area
**Dimensions**: Approximate size of playable area

**Entry camera**:
  Type:      Wide establishing / Follow / Cinematic dolly
  Duration:  [seconds before blending to gameplay camera]
  Intent:    What should the player understand from this framing?

**Gameplay camera**:
  Follow style:  Standard follow / Tight follow / Loose follow / Fixed
  Look-ahead:    [amount of forward bias, if applicable]
  Confiner:      [bounds description]
  Special:       [any perspective-specific behavior]

**Cinematic moments** (if any):
  Trigger:   [what causes the cinematic camera?]
  Pattern:   [pan-to-reveal / follow-subject / slow-push / pull-back / lock-and-hold]
  Duration:  [seconds]
  Return:    [blend time and curve back to gameplay camera]

**Depth layers** (if applicable):
  Background: [what's visible in the far depth?]
  Foreground:  [what frames the scene?]
  Notes: [any special depth behavior for this zone?]

**Audio pairing**: [does a music or ambient cue sync with camera behavior?]
```

---

## Anti-Patterns

| Anti-pattern | Symptom | Fix |
|---|---|---|
| **Camera never varies** | Every moment feels the same; no framing variation | Add zone-specific virtual cameras with different framing per beat |
| **Cinematic interrupts gameplay** | Player loses control during active challenge | Reserve cinematic cameras for before and after challenges, never during |
| **Jarring transitions** | Camera snaps or pops between zones | Add blend profiles (0.5-1.0 sec EaseInOut) between all virtual cameras |
| **Dead-centre framing** | Player always centred; camera feels static | Add look-ahead bias and offset toward direction of travel |
| **Foreground occlusion** | Foreground element blocks interactive objects | Reduce foreground density; ensure no occlusion longer than 0.5 sec |
| **Overused reveals** | Every room has a cinematic entry; player starts skipping | Reserve establishing shots for new areas; repeat visits use gameplay camera only |
| **Wrong perspective** | Camera perspective doesn't match the game's needs | Validate perspective choice against core gameplay and genre expectations |

---

## Related Skills in This Plugin

| Need | Skill |
|------|-------|
| Design the level layout the camera frames | `unity-level` |
| Design screen shake and visual feedback | `unity-visual-feedback` |
| Design the narrative beat the camera serves | `unity-narrative` |
| Design audio that pairs with camera moves | `unity-audio` |

## Additional Resources

- **[references/cinemachine_setup.md]** — Full Cinemachine setup: virtual cameras, confiner, framing transposer, dolly tracks, zone triggers, blend profiles, parallax system, Timeline integration
