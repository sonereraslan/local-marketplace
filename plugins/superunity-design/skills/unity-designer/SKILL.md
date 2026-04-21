---
name: unity-designer
description: >
  This is the core design hub for the superunity-design plugin. This skill should be used when the
  user asks a general Unity game design question, needs help deciding which design skill to use,
  wants to understand the overall design workflow, is starting a new design task, asks about
  design pillars and constraints, or needs to create, structure, audit, or consolidate
  game design documentation. This skill routes to 8 specialised sub-skills and handles GDD work
  directly. Trigger phrases include: "help me design", "where do I start", "design workflow",
  "game design overview", "what should I design first", "design process", "which skill should I use",
  "design this scene", "design this area", "full design pass", "design pillars", "game context",
  "what is this game about", "design constraints", "GDD init", "start a GDD", "write a feature
  document", "define design pillars", "audit my GDD", "consolidate design docs", "GDD structure",
  "feature doc template", "design document version", "document integration", "GDD checklist",
  "balance design template".
---

# Unity Designer — Core Design Hub

## Purpose

This is the entry point for the superunity-design plugin. Use it to understand the project's design foundations, choose the right sub-skill for a task, and follow the recommended design workflow. This skill is **genre-agnostic** — it works for any Unity game: platformer, top-down, FPS, RPG, puzzle, action, simulation, or any hybrid.

---

## Establishing Game Context

Before designing anything, establish the project's identity. If the project already has a GDD or design document, read it. If not, work with the user to define these:

```
Genre:       [e.g. 2D platformer, 3D action-adventure, top-down roguelike, 2.5D puzzle game]
Tone:        [e.g. dark and atmospheric, lighthearted, emotional and restrained, comedic]
Perspective: [e.g. side-scrolling, isometric, third-person, first-person, top-down]
Core loop:   [e.g. explore > fight > loot > upgrade, discover > solve > advance]
Mechanics:   [list of core mechanics the game uses or plans to use]
Dialogue:    [e.g. fully voiced, text-heavy, minimal, none]
```

**Important**: Do not assume a genre or tone. Always ask or read the project context before applying design advice.

---

## Design Pillars

Every project should define 3-5 design pillars — core principles that filter every design decision. A good pillar is:

- **Actionable**: Any team member can apply it without asking
- **Specific**: It can reject a feature that conflicts with it
- **Project-specific**: It reflects this game's identity, not generic truisms

### Pillar Structure

```
Pillar Name
  Intent:  One sentence explaining the principle
  Do:      2-3 concrete design choices this pillar supports
  Don't:   2-3 things this pillar rules out
```

### Example Pillars (for reference — always define project-specific ones)

| Example pillar | Intent | Genre fit |
|----------------|--------|-----------|
| Clarity Over Complexity | Player always understands what to do and what happened | Puzzle games, platformers |
| Fewer Mechanics, More Depth | Small set of mechanics that evolve and combine | Puzzle, action, metroidvania |
| Chaos is the Content | Emergent systems that create unpredictable situations | Roguelikes, sandbox, simulation |
| Mastery Through Repetition | Same encounters become easier as skill improves | Soulslike, rhythm, shmup |
| Story Through Action | Player does the story, not watches it | Narrative-driven, immersive sim |
| Player Expression | Multiple valid approaches to every problem | RPG, immersive sim, sandbox |

If the project has no pillars yet, guide the user to define them before detailed design work begins.

---

## Design Workflow

Follow this order when designing a new scene, level, or area. Each step maps to a sub-skill:

```
Step 1 — BRAINSTORM        Generate raw ideas for mechanics, levels, or narrative
           |                 -> unity-brainstorming
Step 2 — MECHANICS         Define or refine the mechanics this section uses
           |                 -> unity-mechanics
Step 3 — CHALLENGES        Structure gameplay challenges around those mechanics
           |                 -> unity-puzzle
Step 4 — NARRATIVE         Embed story into the gameplay and environment
           |                 -> unity-narrative
Step 5 — LEVEL LAYOUT      Place challenges, paths, and beats in space
           |                 -> unity-level
Step 6 — CAMERA            Frame the space and plan camera behavior
           |                 -> unity-camera
Step 7 — VISUAL FEEDBACK   Add clarity, feedback, animation, and juice
           |                 -> unity-visual-feedback
Step 8 — AUDIO             Design sound, music, silence for the section
                             -> unity-audio
```

**Not every task requires all 8 steps.** Match the starting point to what already exists:
- New area from scratch -> start at Step 1
- Mechanic already decided, need challenges -> start at Step 3
- Level built, needs polish -> start at Step 7
- Single scene needs audio -> go directly to Step 8

---

## Skill Routing Guide

| User intent | Route to | Skill name |
|-------------|----------|------------|
| "I need ideas" / "I'm stuck" / "brainstorm" | Idea generation | `unity-brainstorming` |
| "Design a mechanic" / "how should X work" / "player ability" | Mechanic design | `unity-mechanics` |
| "Design a puzzle" / "challenge structure" / "encounter design" | Challenge design | `unity-puzzle` |
| "Story moment" / "narrative scene" / "what does this level say" | Narrative integration | `unity-narrative` |
| "Design a level" / "level layout" / "pacing" / "graybox" | Level design | `unity-level` |
| "Camera setup" / "room framing" / "Cinemachine" | Camera design | `unity-camera` |
| "Game feel" / "feedback" / "screen shake" / "animation states" | Visual feedback & polish | `unity-visual-feedback` |
| "UI design" / "HUD" / "inventory screen" / "diegetic UI" | UI & UX design | `unity-visual-feedback` (Layer 5) |
| "Audio" / "music" / "SFX" / "silence" / "AudioMixer" | Audio design | `unity-audio` |
| General design question / unclear intent / "where do I start" | This hub skill | `unity-designer` |

### Disambiguation — When Requests Are Ambiguous

Some user requests could match multiple skills. Use these rules:

| Ambiguous request | How to disambiguate | Route |
|---|---|---|
| "Design this scene" | Does the user have a layout? | **No layout** -> `unity-level` first. **Has layout, needs emotion** -> `unity-narrative`. **Has both, needs full pass** -> use the 8-step workflow. |
| "Make this feel better" | Is it the mechanic, the feedback, or the sound? | **Mechanic doesn't work right** -> `unity-mechanics`. **Mechanic works but actions feel flat** -> `unity-visual-feedback` -> `unity-audio`. **Sound is wrong/missing** -> `unity-audio`. |
| "Teach this mechanic" | At what scale? | **Game-wide arc** (introduce early, deepen later) -> `unity-mechanics` (Evolution Framework). **Per-encounter sequence** (how a challenge teaches) -> `unity-puzzle` (Challenge Structure Model). **Level beat placement** -> `unity-level` (references `unity-puzzle` for structure). |
| "This level tells no story" | Is it the narrative design or the environment? | **No emotional intent defined** -> `unity-narrative`. **Intent exists but space doesn't convey it** -> `unity-level` + `unity-visual-feedback`. |
| "Design a boss fight" | Multi-skill task. | Start `unity-mechanics` (combat mechanic) -> `unity-puzzle` (encounter structure) -> `unity-level` (arena layout) -> `unity-audio` (music). |

### When Multiple Skills Apply

Some tasks span multiple skills. Route to the **primary** skill first, then follow its cross-references:

| Task | Primary skill | Then |
|------|--------------|------|
| "Design this room from scratch" | `unity-level` | -> challenges -> camera -> feedback -> audio |
| "Make this action feel better" | `unity-visual-feedback` | -> audio (for sound response) |
| "This challenge needs a story reason" | `unity-narrative` | -> puzzle (for integration) |
| "Add music to this scene" | `unity-audio` | -> camera (if music syncs with camera moves) |
| "Camera for a narrative beat" | `unity-camera` | -> narrative (for the beat's emotional intent) |
| "Teach a mechanic through a level" | `unity-level` | -> mechanics (for evolution stage) -> puzzle (for structure) |
| "Design a UI/HUD" | `unity-visual-feedback` (Layer 5) | -> narrative (for information hierarchy) |

---

## Cross-Skill Design Sequences

The workflow above is the complete 8-step pipeline. The sequences below are common task-specific subsets — use these when the task doesn't require the full pipeline.

### Full Scene Design (most common)

```
1. What happens here narratively?           -> unity-narrative
2. What mechanic does the player use?       -> unity-mechanics
3. What challenge tests that mechanic?      -> unity-puzzle
4. Where does everything go in space?       -> unity-level
5. How does the camera present the space?   -> unity-camera
6. What does every action look and feel like?-> unity-visual-feedback
7. What does every action sound like?       -> unity-audio
```

### Mechanic-First Design

```
1. Define the mechanic and its evolution     -> unity-mechanics
2. Build challenges that teach and test it   -> unity-puzzle
3. Place the challenge sequence in a level   -> unity-level
4. Add story context to the sequence         -> unity-narrative
```

### Polish Pass (existing content)

```
1. Audit visual clarity and feedback         -> unity-visual-feedback
2. Audit camera framing and transitions      -> unity-camera
3. Audit audio: music, SFX, silence          -> unity-audio
4. Audit pacing and confusion points         -> unity-level
```

### Action Feel (something feels flat or unresponsive)

```
1. Check the mechanic works as intended         -> unity-mechanics
2. Design visual feedback for the action         -> unity-visual-feedback
3. Design audio response for the action          -> unity-audio
```

Visual feedback STARTS the feedback chain. Audio COMPLETES it. Neither skill alone covers "action feel."

### Emotional Beat Design

```
1. Define the emotional moment               -> unity-narrative
2. Frame it with camera                      -> unity-camera
3. Design the silence and music              -> unity-audio
4. Add visual weight (animation, lighting)   -> unity-visual-feedback
```

---

## Terminology — Shared Across All Skills

Use these terms consistently. All sub-skills follow this glossary:

| Term | Definition | Scope |
|------|-----------|-------|
| **Level** | A complete playable space with its own structure and pacing | The unit `unity-level` designs |
| **Scene** | A narrative/emotional moment within a level | The unit `unity-narrative` designs |
| **Area** | A broad region of the game (city, dungeon, forest) containing multiple levels | Game structure term |
| **Zone** | A region within a level with unified camera or gameplay behavior | Used by `unity-camera` and `unity-level` |
| **Room / Space** | A single bounded area within a level | Level layout term |
| **Challenge** | Any gameplay test — puzzle, encounter, traversal, stealth | The unit `unity-puzzle` designs |
| **Encounter** | A combat-specific challenge | Subset of challenge |
| **Mechanic** | A player ability or interaction rule | The unit `unity-mechanics` designs |
| **Feedback** | The full response chain to a player action (visual + audio + world state) | Owned jointly: `unity-visual-feedback` starts it, `unity-audio` completes the audio layer |

### Teaching Frameworks — Three Scales

Three skills describe how players learn. They operate at **different scales** and are **not interchangeable**:

| Framework | Skill | Scale | Stages | Purpose |
|-----------|-------|-------|--------|---------|
| **Mechanic Evolution** | `unity-mechanics` | Game-wide | Introduce → Challenge → Combine (3) | How a mechanic deepens across the entire game |
| **Challenge Structure** | `unity-puzzle` | Per-sequence | Introduction → Reinforcement → Twist → Mastery (4) | How a sequence of challenges teaches one concept |
| **Level Teaching** | `unity-level` | Per-level beat | References `unity-puzzle`'s Challenge Structure | How a level's beats introduce and test mechanics |

`unity-puzzle` owns the authoritative per-encounter teaching framework. `unity-level` applies it to level layout. `unity-mechanics` tracks the game-wide arc.

---

## Design Constraints

Constraints should be defined per-project based on the game's genre, scope, and pillars. Common constraint categories to define:

### Mechanic Constraints
- How many core mechanics does the game support?
- What input complexity is acceptable? (single-input vs. combos)
- How do mechanics evolve across the game?

### Challenge / Puzzle Constraints
- How many new concepts per challenge?
- How is failure handled?
- How is information communicated to the player?

### Level Constraints
- What is the level structure? (linear, branching, open)
- How does the environment guide the player?
- What is the prototyping workflow?

### Narrative Constraints
- How is story delivered? (dialogue, environment, cutscene, mechanics)
- What is the dialogue budget?
- How are story beats integrated with gameplay?

### Camera Constraints
- What perspective does the game use?
- When does the camera deviate from default behavior?
- What are the rules for cinematic moments?

### Visual Feedback Constraints
- What is the feedback hierarchy?
- How is visual clarity maintained?
- What is the UI philosophy? (minimal, HUD-heavy, diegetic)

### Audio Constraints
- What is the audio identity?
- When does music play vs. silence?
- What is the volume hierarchy?

---

## Proposal Formats — Quick Reference

Each sub-skill defines a proposal format for its domain. Use these when producing a design document:

| Domain | Proposal format | Defined in |
|--------|----------------|------------|
| Mechanic | Mechanic Proposal | `unity-mechanics` |
| Challenge / Puzzle | Challenge Proposal | `unity-puzzle` |
| Narrative scene | Scene Proposal | `unity-narrative` |
| Level | Level Proposal | `unity-level` |
| Camera | Scene Camera Proposal | `unity-camera` |
| Visual feedback | Action-Feedback Proposal | `unity-visual-feedback` |
| Music cue | Scene Music Proposal | `unity-audio` |
| SFX | Action-Sound Mapping | `unity-audio` |

---

## Anti-Patterns — Design-Wide

These apply across all disciplines:

| Anti-pattern | Symptom | Fix |
|---|---|---|
| **Feature creep** | New mechanic for every new situation | Use existing mechanics in new combinations |
| **Tutorial dependency** | Pop-ups explain what to do | Redesign the environment or encounter to teach |
| **Narrative interruption** | Cutscene stops gameplay for exposition | Integrate story into the gameplay itself |
| **Polish without clarity** | Screen shake and particles on an unreadable scene | Apply visual clarity first, then juice |
| **Constant audio** | Music and SFX fill every second | Design silence; let earned moments land |
| **Camera passivity** | Camera follows player identically everywhere | Use context-appropriate camera behavior per zone |
| **Scope denial** | "We'll add more mechanics later" | Define a mechanic budget and stick to it |
| **Genre mismatch** | Applying design patterns from a different genre without adapting | Always validate patterns against your game's pillars |

---

## Skill Index

| Skill | Domain | Key output |
|-------|--------|-----------|
| `unity-brainstorming` | Idea generation | Raw ideas via SCAMPER, Six Hats, morphological matrix |
| `unity-mechanics` | Mechanic design | Mechanic proposals with evolution and constraints |
| `unity-puzzle` | Challenge design | Challenge proposals with structure, teaching, and communication |
| `unity-narrative` | Narrative integration | Scene proposals with storytelling and thematic mechanics |
| `unity-level` | Level design | Level proposals with layout, flow, psychology, and graybox |
| `unity-camera` | Camera design | Scene camera proposals with framing, transitions, cinematics |
| `unity-visual-feedback` | Visual feedback & polish | Action-feedback proposals with clarity, animation, juice, and UI |
| `unity-audio` | Audio design | Music strategy, SFX mapping, silence design, AudioMixer implementation |

---

## GDD Documentation

Handle GDD tasks directly from this skill. Use the project's defined pillars and constraints — do not invent default ones.

### Usage Patterns

```
"GDD init"              -> Initialise a new project GDD from scratch
"GDD audit"             -> Audit an existing GDD for completeness
"GDD consolidate"       -> Merge scattered design docs into a single GDD
"feature doc [name]"    -> Generate a Feature Document for a system
"design pillars"        -> Define or review the project's design pillars
"balance template"      -> Generate a numerical balance design template
```

### Two-Layer Architecture

```
Master Document  ->  links to all Feature Documents (never duplicates them)
Feature Documents  ->  one per major system (combat, character, economy, etc.)
```

Master Document required sections (P0): Executive Summary, Design Pillars, Core Gameplay, Game Systems
P1: Narrative & World, Character Design, Level Design, UI/UX, Development Plan
P2: Audio Direction, Risk Assessment

### Feature Document Template

```markdown
# [System Name] — Feature Document

## Design Goal
> What problem does this system solve? What experience does it create?

## Core Mechanics
### Fundamental Rules / Numerical Design / Edge Cases

## Player Experience
### Intended Feel / Risks and Negative Experiences

## System Relationships
### Depends On / Affects

## Implementation Priority (LoQ)
| Tier        | Contents                      | Status |
|-------------|-------------------------------|--------|
| Core        | Minimum playable version      |        |
| Expected    | Features players expect       |        |
| Desired     | Nice-to-have additions        |        |
| Aspirational| Ideal state if time allows    |        |

## Change Log
| Version | Date | Change |
```

### GDD Audit Checklist

```
# Executive Summary  [ ] name/tagline  [ ] genre  [ ] platform  [ ] audience  [ ] elevator pitch  [ ] USP
# Design Pillars     [ ] 3-5 principles exist  [ ] each has Do/Don't examples
# Core Gameplay      [ ] game loop  [ ] win/lose conditions  [ ] control scheme  [ ] session length
# Game Systems       [ ] every core system has a Feature Doc  [ ] dependencies mapped  [ ] numerics documented
# Consistency        [ ] glossary exists  [ ] versions consistent  [ ] no contradictions  [ ] links valid
```

### Document Consolidation Workflow

```
1. Inventory -> list all design files, tag by topic/date, flag duplicates
2. Establish authority -> one authoritative doc per topic; mark others deprecated
3. Build Master shell -> create Master Document, extract systems to Feature Docs
4. Migrate content -> P0 first; resolve contradictions (newer/more complete wins)
5. Validate -> run audit checklist; verify version numbers and cross-links
```

### Version Control

```
vX.Y  ->  X increments on structural change, Y on content updates
Every Feature Document inherits the Master Document's major version.
```

### Common GDD Failures

| Problem | Fix |
|---------|-----|
| Design contradictions | One authoritative doc per topic; build a glossary |
| Over-engineered GDD | Master <= 20 pages; link to Feature Docs, never duplicate |
| Missing pillars | Define pillars before production; every feature answers to them |
| Terminology drift | Shared glossary; enforce consistently |

---

## Commands (User-Invoked)

| Command | What it does |
|---------|-------------|
| `/superunity-design:design-scene` | Full 8-step design workflow for a scene — produces combined design document |
| `/superunity-design:design-review` | Audit a design against pillars, constraints, and anti-patterns |
| `/superunity-design:design-brief` | Compile all design proposals from conversation into a handoff document |
| `/superunity-design:polish-pass` | 4-step polish audit: visual feedback -> camera -> audio -> pacing |
| `/superunity-design:mechanic-test` | Evaluate a mechanic against constraints, evolution, and integration matrix |
