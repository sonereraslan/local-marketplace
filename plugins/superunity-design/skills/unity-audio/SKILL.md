---
name: unity-audio
description: >
  This skill should be used when designing audio for any Unity game — including defining the
  game's audio identity, planning when music plays, mapping sound effects to player actions,
  designing silence and dynamic audio, balancing audio layers, or setting up Unity audio systems.
  Trigger phrases include: "audio design", "sound design", "audio vision", "audio pillars",
  "when should music play", "SFX for this action", "sound for interaction", "footstep sounds",
  "music strategy", "scene music plan", "audio identity", "audio balance", "too many sounds",
  "silence in the game", "audio audit", "audio motif", "set up AudioMixer", "AudioSource setup",
  "event-driven audio", "music loops", "ambient sound", "combat music", "adaptive audio".
---

# Unity Audio Designer

> Sound that serves the game — clarity, emotion, and intentional design in every layer

## When to Use This Skill

- Defining the game's audio identity and pillars
- Planning when music plays, fades, and stops
- Mapping sound effects to player actions and game states
- Designing adaptive or dynamic audio systems
- Auditing an audio mix that feels noisy or unclear
- Setting up Unity audio architecture for the project

> **Design visual feedback first** using `unity-visual-feedback` (this plugin).
> **Tie audio to a narrative moment** using `unity-narrative` (this plugin).
> **Design the action that needs sound** using `unity-mechanics` (this plugin).

### Feedback Chain Position

This skill **completes** the audio layer of the feedback chain started in `unity-visual-feedback`. Visual feedback establishes timing and intensity; audio must match it. When designing "action feel," follow this order: `unity-mechanics` → `unity-visual-feedback` → `unity-audio`. Do not design audio for an action whose visual feedback is not yet defined.

---

## Core Philosophy

### Every Sound Must Justify Its Place
Audio clutter is worse than silence. Before adding any sound, ask: *"Does removing this make the experience worse?"* If no — don't add it.

### Silence is a Design Tool
Silence is not the absence of audio design — it is the most deliberate audio choice available. Design silence as intentionally as you design music. The impact of a sound is proportional to the quiet that preceded it.

### Audio Serves Clarity, Then Emotion
A sound that confuses the player is worse than no sound. Feedback sounds must be unambiguous before they are beautiful.

---

## Five-Layer Workflow

```
Layer 1 — AUDIO VISION      What is the game's sound identity and pillars?
Layer 2 — MUSIC STRATEGY    When does music play, fade, and stop?
Layer 3 — SFX DESIGN        What does each action sound like?
Layer 4 — AUDIO DIRECTION   Balance: what to keep, cut, and prioritise?
Layer 5 — IMPLEMENTATION    How is it set up in Unity?
```

---

## Layer 1: Audio Vision

**Goal**: Establish a sound identity that guides every audio decision in the project.

### Audio Pillars

Define 2-4 audio pillars before any sound is created. Every audio decision is measured against them.

**Example audio pillars by genre:**

**Minimalist / Emotional (puzzle, narrative, platformer):**
```
1. Emotional Minimalism — Less is more. Every sound earns its place.
2. Environmental Storytelling — The world speaks through ambient audio.
3. Silence as Punctuation — Use silence before and after important moments.
```

**Intense / Immersive (action, horror, shooter):**
```
1. Visceral Impact — Every hit, shot, and explosion feels physical.
2. Spatial Awareness — Audio communicates threat direction and distance.
3. Dynamic Intensity — Music and ambience react to gameplay state.
```

**Playful / Expressive (platformer, puzzle, casual):**
```
1. Musical Gameplay — Actions create rhythm and melody.
2. Satisfying Feedback — Every interaction sounds rewarding.
3. Personality Through Sound — Characters and objects have audio identity.
```

### Key Questions Before Starting

```
1. What should the player feel in a room with no music and no action?
2. When should audio lead the emotion — before the player acts?
3. When should audio follow — confirming what just happened?
4. What three sounds would define this game if heard out of context?
5. What role does silence play in this game?
```

---

## Layer 2: Music Strategy

**Goal**: Music plays at the right moments, stops at the right moments, and never competes with gameplay.

### Music Approaches by Genre

| Approach | Best for | How it works |
|----------|---------|-------------|
| **Earned moments** | Puzzle, narrative, horror | Silence by default; music enters at emotional peaks |
| **Continuous underscore** | RPG, adventure, open-world | Low-intensity music always present; swells at key moments |
| **Adaptive / layered** | Action, stealth, combat | Music layers add/remove based on gameplay state |
| **Diegetic** | Immersive sim, horror, realistic | Music comes from in-world sources (radios, musicians) |
| **Procedural / reactive** | Rhythm, experimental, sandbox | Music generated or modified by player actions |

### When Music Plays (Adaptive Template)

| Game state | Music action | Emotional intent |
|-----------|-------------|-----------------|
| Exploration (safe) | Light theme or ambient | Curiosity, calm |
| Challenge engaged | Shift based on approach: fade for puzzles, intensify for combat | Focus or tension |
| Challenge completed | Brief swell or stinger -> settle | Satisfaction |
| Narrative beat | Full music entry or dramatic shift | Emotional weight |
| High-stakes moment | Music builds with gameplay intensity | Urgency |
| Resolution / transition | Theme returns, slower or resolved | Relief, reflection |
| Loss or defeat | Music drops -> silence or single instrument | Weight, consequence |

### Motif Design

Assign a short melodic motif (4-8 notes) to each major character, location, or theme. Recur it across the game in different arrangements:

```
Character motif  ->  appears at introduction, returns at reunion, distorted at conflict
Location theme   ->  heard when safe; absent or corrupted in danger
Main theme       ->  first heard in menu/intro; returns in full at climax
```

### Scene Music Proposal Format

```markdown
## Music: [Scene Name]

**Entry condition**: What triggers this music cue?
**Exit condition**: What triggers the fade or cut?
**Tempo**: Slow / Medium / Driven
**Instrumentation**: [1-3 instruments — be specific]
**Emotional intent**: What should the player feel?
**Motif used**: Which character or theme motif appears here?
**Silence before**: Yes / No — how many seconds?
**Loop point**: Where does the loop begin for seamless repetition?
```

Full music architecture at [references/audio_implementation.md].

---

## Layer 3: SFX Design

**Goal**: Every player action has a distinct, clear, non-fatiguing sound response.

### SFX Categories

| Category | Examples | Design rule |
|----------|---------|------------|
| **Player actions** | Footsteps, jump, attack, dodge, land | Vary by surface/context; 3+ variants to avoid repetition |
| **Interactions** | Push, pick up, activate, open, craft | Short, clear, satisfying — matches physical weight |
| **Game states** | Switch toggle, door open, checkpoint, level complete | State change must be audibly distinct from ambient |
| **Feedback** | Success chime, failure thud, damage, heal | Success: warm and brief; Failure: informative, not punishing |
| **Combat** | Hit, block, parry, projectile, explosion | Impact weight matches visual; enemy sounds distinct from player |
| **Ambient** | Wind, water, machinery, wildlife, crowd | Loops seamlessly; implies world and place |
| **UI** | Menu navigate, select, back, notification | Subtle, consistent, never fatiguing |

### Action -> Sound Mapping Format

```markdown
## SFX: [Action Name]

**Trigger**: What player input or game event fires this?

**Primary sound**:
  Character:  [soft / sharp / warm / mechanical / organic / heavy]
  Duration:   [short < 0.3s / medium 0.3-1s / long > 1s]
  Pitch:      [fixed / slight random variation +/-10%]
  Volume:     [relative to ambient baseline]

**Variation strategy**: How to avoid repetition fatigue?
  [ ] 2-3 pitch variants played randomly
  [ ] Alternate between 2+ recordings
  [ ] Vary playback speed +/-5-10%

**Failure / wrong-use version** (if needed):
  Character:  [softer, lower pitch — not alarming]
  Duration:   [shorter than success sound]

**Layering**: What sounds accompany this?
  [ ] Animation hit event triggers additional layer
  [ ] Ambient ducks slightly on interaction
```

### SFX Design Rules

```
Short and clear > long and complex
Each action has a distinct sound — no two core mechanics share a sound identity
3+ variants for any sound played more than once per minute
Volume hierarchy is enforced across all categories
```

---

## Layer 4: Audio Direction

**Goal**: All audio layers work together. Important sounds stand out. Nothing competes.

### "Does This Need a Sound?" Audit

Run this before finalising any audio mix:

```
For every sound in the game, ask:
  1. Does this confirm something the player needs to know?
  2. Does this reinforce an emotion at the right moment?
  3. Does removing this make anything worse?

If the answer to 3 is "no" — remove the sound.
```

### Volume Hierarchy

Define the priority order for your game. Common hierarchy:

```
Priority 1 — Narrative audio (key story sounds, dialogue, music at emotional peaks)
Priority 2 — Action feedback (player interaction SFX, combat, state changes)
Priority 3 — Ambient environment (loops, background atmosphere)
Priority 4 — Background music (exploration underscore)

Rule: Lower priority sounds duck automatically when higher priority fires.
Use AudioMixer duck groups for this.
```

### Common Audio Problems

| Problem | Cause | Fix |
|---------|-------|-----|
| Sound mix feels muddy | Too many layers at equal volume | Apply volume hierarchy; duck ambient under SFX |
| Interaction sounds ignored | Too quiet relative to ambient | Raise SFX group or duck ambient on interaction trigger |
| Music distracts from gameplay | Music competes with action that requires focus | Fade or simplify music during demanding gameplay |
| Repetitive SFX fatigue | Same sound plays identically each time | Add 3+ variants with random pitch/volume variation |
| Silence feels broken | Music fades awkwardly or abruptly | Use volume fade over 1-2 seconds; find a phrase end in the music |
| Too many sounds at once | Multiple events trigger simultaneously | Queue non-critical sounds; only feedback and narrative fire immediately |

---

## Layer 5: Unity Implementation

**Goal**: Clean, event-driven audio architecture that is easy to extend and debug.

### Mixer Architecture

```
Master
+-- Music          (volume, reverb send)
+-- SFX
|   +-- Player     (footsteps, actions, effort)
|   +-- World      (interactions, environment objects)
|   +-- Combat     (hits, projectiles, abilities)
|   +-- UI         (menu, notifications)
+-- Ambient        (environment loops)
+-- Dialogue       (voice, narration)
```

### Core Implementation Pattern

```csharp
// Centralised audio event system — decouple audio from gameplay logic
public static class AudioEvents
{
    public static event Action<SoundId> OnPlaySound;
    public static event Action<MusicId> OnPlayMusic;
    public static event Action          OnStopMusic;

    public static void Play(SoundId id)    => OnPlaySound?.Invoke(id);
    public static void PlayMusic(MusicId id) => OnPlayMusic?.Invoke(id);
    public static void StopMusic()         => OnStopMusic?.Invoke();
}

// Usage in gameplay code — no AudioSource reference needed
void OnChallengeCompleted()
{
    AudioEvents.Play(SoundId.ChallengeComplete);
    AudioEvents.PlayMusic(MusicId.VictoryStinger);
}
```

### Random Variation — Avoid Repetition Fatigue

```csharp
[SerializeField] AudioClip[] footstepVariants;
[SerializeField] AudioSource audioSource;

void PlayFootstep()
{
    int index = Random.Range(0, footstepVariants.Length);
    audioSource.pitch = Random.Range(0.95f, 1.05f);
    audioSource.PlayOneShot(footstepVariants[index]);
}
```

Full AudioMixer setup, music crossfade, ambient ducking, and spatial audio patterns at [references/audio_implementation.md].

---

## Anti-Patterns

| Anti-pattern | Symptom | Fix |
|---|---|---|
| **Constant music** | Music never stops — player tunes it out | Design intentional quiet moments; let music earn its entries |
| **Sound clutter** | Every minor action has a loud SFX | Apply audio audit: remove any sound that fails the 3-question test |
| **Punishing failure sound** | Wrong action triggers alarming buzzer | Replace with soft, informative, non-alarming cue |
| **Repetition fatigue** | Same footstep or click sound on every frame | Minimum 3 variants with pitch randomisation |
| **Music fighting gameplay** | Player can't focus — audio competes with thinking/reacting | Adapt music intensity to gameplay state |
| **No silence** | Audio fills every moment | Design deliberate silence moments — they make the sound moments matter |
| **Hardcoded audio** | AudioSource.Play() scattered in gameplay scripts | Centralise via AudioEvents or audio manager |

---

## Related Skills in This Plugin

| Need | Skill |
|------|-------|
| Design the action this sound responds to | `unity-mechanics` |
| Map audio to visual feedback | `unity-visual-feedback` |
| Tie a music cue to a narrative moment | `unity-narrative` |
| Place audio cues within a level | `unity-level` |

## Additional Resources

- **[references/audio_implementation.md]** — Full AudioMixer, MusicManager, AudioManager, spatial audio, ambient loops, C# audio manager pattern
