---
name: unity-mechanics
description: >
  This skill should be used when designing, proposing, or refining gameplay mechanics for any
  Unity game — including proposing player abilities, designing interaction systems, structuring
  contextual interactions, defining mechanic constraints, or mapping how a mechanic evolves
  across the game. Trigger phrases include: "design a mechanic", "propose a mechanic",
  "what mechanics should my game have", "player ability design", "interaction system",
  "combat mechanic", "movement mechanic", "contextual interaction system", "how should X mechanic work",
  "mechanic evolution", "mechanic tied to narrative", "mechanic constraints",
  "mechanic versatility", "can this mechanic do more".
---

# Unity Mechanics Designer

> Design meaningful mechanics that serve your game's core experience — depth over breadth, clarity over complexity

## When to Use This Skill

- Proposing a new player ability or interaction system
- Evaluating whether an existing mechanic has enough depth
- Mapping how a mechanic evolves across the game
- Tying a mechanic's design to the game's themes
- Checking a mechanic against the project's constraints

> **To generate raw mechanic ideas first** use `unity-brainstorming` (standalone skill).
> **For challenge design using these mechanics** use `unity-puzzle` (this plugin).
> **For narrative tie-in** use `unity-narrative` (this plugin).

---

## Design Principles

These three principles govern mechanic design regardless of genre:

### 1. One Mechanic = Many Uses
A mechanic must serve multiple distinct gameplay situations before it earns its place. If it solves only one type of problem, it is not a mechanic — it is a key. Keys bloat the design.

### 2. Mechanics Evolve, They Don't Multiply
Introduce one mechanic fully before adding another. Complexity comes from combining and deepening existing mechanics, not from adding new ones. Define a mechanic budget for your project and respect it.

### 3. Every Mechanic Must Teach Something
Each mechanic should communicate a truth about the game world, the character, or the system. The player should be able to say: *"Oh — this world works like that."*

---

## Mechanic Proposal Format

Use this structure for every new mechanic.

```markdown
## Mechanic: [Name]

**One-line description**: What the player does, in plain language.

**Player input**: Button / gesture / key / mouse action. Define the input complexity.

**Thematic tie**: What does this mechanic say about the world, the character, or the game's themes?

**Gameplay uses** (list 3+):
1. [Primary use case]
2. [Secondary use case]
3. [Tertiary / exploration use]
4. [Optional: combined use with another mechanic]

**Evolution across the game**:
- Early game (Introduce): Simplest version — one correct use, safe environment
- Mid game (Challenge): New constraint applied — pressure, risk, limited resource
- Late game (Combine): Used in combination with other mechanics for compound situations

**Constraints check**:
- [ ] Readable without a UI tooltip
- [ ] Input complexity matches the project's control scheme
- [ ] Fails gracefully — wrong use produces a clear, readable result
- [ ] Does not require another mechanic to be learned first
- [ ] Fits within the project's mechanic budget
```

---

## Reference Mechanic Patterns by Genre

These archetypes illustrate mechanic design across different genres. Use as starting points, not fixed solutions.

### Platformer / Action

| Mechanic | Core input | Thematic meaning | Application |
|----------|-----------|-------------------|-------------|
| **Dash / dodge** | Single button | Commitment, risk-reward | I-frames through danger, gap crossing, combat spacing |
| **Wall interaction** | Contextual | Mastery of environment | Wall jump, wall slide, wall climb — spatial puzzles |
| **Grapple / hook** | Aim + fire | Connection, reaching | Traversal, pulling objects, swinging over gaps |

### RPG / Adventure

| Mechanic | Core input | Thematic meaning | Application |
|----------|-----------|-------------------|-------------|
| **Dialogue choice** | Selection | Agency, consequence | Branching narrative, reputation, quest resolution |
| **Crafting** | Combine items | Resourcefulness | Equipment creation, consumables, problem-solving |
| **Ability tree** | Unlock + use | Growth, identity | Build variety, playstyle expression |

### Puzzle / Strategy

| Mechanic | Core input | Thematic meaning | Application |
|----------|-----------|-------------------|-------------|
| **Object manipulation** | Grab / place | Understanding the world | Push/pull/carry for spatial puzzles |
| **Time / state control** | Toggle / rewind | Perspective, consequence | Before/after states, timeline puzzles |
| **Companion command** | Send / recall | Trust, cooperation | Reach inaccessible areas, multi-agent puzzles |

### Top-Down / Tactical

| Mechanic | Core input | Thematic meaning | Application |
|----------|-----------|-------------------|-------------|
| **Cover system** | Context + position | Caution, tactical thinking | Reduce incoming damage, set up flanks |
| **Overwatch / stance** | Mode toggle | Control, prediction | Area denial, reaction shots |
| **Resource allocation** | Drag / assign | Leadership, trade-offs | Unit placement, supply management |

---

## Mechanic-Gameplay-Theme Integration

A well-designed mechanic operates on all three layers simultaneously. Map each proposed mechanic against this matrix before committing:

| Layer | Question | Weak answer | Strong answer |
|-------|----------|-------------|---------------|
| **Mechanic** | Does it work on its own? | "It's needed for a specific situation" | "It solves a class of problems" |
| **Gameplay** | Does it create interesting decisions? | "There's one right way to use it" | "Multiple valid approaches exist" |
| **Theme** | Does using it reinforce the game's identity? | "It's just a button" | "Using it says something about the experience" |

---

## Mechanic Constraint Checklist

Run this before finalising any mechanic:

```
Input
- [ ] Input complexity matches the game's control scheme
- [ ] Works on all target platforms with the same feel
- [ ] Does not require a tutorial screen to understand the first time

Readability
- [ ] The affordance is visible — player can see what can be interacted with
- [ ] Failed use gives a clear visual/audio response (not silent failure)
- [ ] First encounter is in a low-risk environment

Scope
- [ ] Multiple distinct gameplay uses exist
- [ ] Does not overlap with an existing mechanic's core purpose
- [ ] Total core mechanic count stays within the project's budget
- [ ] Fits the game's genre and pacing expectations
```

---

## Mechanic Evolution Framework

Map every mechanic through three stages across the **entire game**. This is the game-wide arc — how a mechanic deepens from introduction to mastery over hours of play.

> **This is not the per-encounter teaching sequence.** For how a *challenge sequence* teaches a mechanic step-by-step, see `unity-puzzle` (Challenge Structure Model). Evolution is the macro arc; challenge structure is the micro arc.

A mechanic that cannot evolve should be questioned.

```
Stage 1 — INTRODUCE
  Mechanic in its simplest form
  One obvious use, zero ambiguity
  Low-risk environment, forgiving of wrong attempts
  Goal: player understands what the mechanic IS

Stage 2 — CHALLENGE
  Add one constraint (time / space / resource / enemy / risk)
  Player must think before acting, not just act
  Wrong use now has a consequence
  Goal: player understands what the mechanic COSTS

Stage 3 — COMBINE
  Pair with one other mechanic to solve a compound problem
  Neither mechanic alone is sufficient
  The combination reveals a new capability neither had alone
  Goal: player understands what the mechanic CAN BECOME
```

**Example — Dash mechanic evolution:**
- Stage 1: Dash across a gap that's too wide to jump -> player learns the dash
- Stage 2: Dash through a hazard using i-frames -> timing required, consequence for mistiming
- Stage 3: Dash off a wall-jump to reach a platform neither mechanic reaches alone

**Example — Dialogue choice evolution:**
- Stage 1: Choose between two clear options with immediate visible results
- Stage 2: Choices have delayed consequences that surface later
- Stage 3: Information from exploration changes what dialogue options are available

---

## Anti-Patterns

Avoid these when evaluating or proposing mechanics:

| Anti-pattern | Symptom | Fix |
|---|---|---|
| **The key mechanic** | Only solves one type of situation | Find 2+ more uses or cut the mechanic |
| **The tutorial mechanic** | Requires on-screen instruction to use | Redesign the first encounter as environmental teaching |
| **The forgotten mechanic** | Only used early on, never seen again | Add mid-game and late-game evolution, or cut it |
| **The complex input** | Requires unintuitive button combinations | Simplify input; move complexity to the situation design |
| **The parallel mechanic** | Two mechanics that solve the same class of problem | Merge into one or differentiate their domains |
| **The genre import** | Mechanic borrowed from another genre without adaptation | Validate against your game's pillars and feel |

---

## Output Example

```markdown
## Mechanic: Gravity Flip

**One-line description**: Player toggles gravity direction for themselves, switching between floor and ceiling.

**Player input**: Single button (Space / A button). Press to flip; press again to return.

**Thematic tie**: The world is unstable — what feels solid can be inverted.
Reinforces the game's theme of shifting perspectives.

**Gameplay uses**:
1. Reach platforms on the ceiling that are inaccessible by jumping
2. Avoid floor-based hazards by walking on the ceiling
3. Solve spatial puzzles where items must be moved between floor and ceiling
4. Combined with dash: flip mid-air to chain into a ceiling dash

**Evolution across the game**:
- Early game: Flip in a safe room to walk on the ceiling and reach the exit
- Mid game: Flip while avoiding hazards on both surfaces — timing matters
- Late game: Chain gravity flip with dash to navigate vertical shafts with hazards on all sides
```

---

## Related Skills in This Plugin

| Need | Skill |
|------|-------|
| Generate raw mechanic ideas | `unity-brainstorming` (standalone) |
| Design challenges using these mechanics | `unity-puzzle` |
| Tie mechanic to narrative themes | `unity-narrative` |
| Teach mechanic through level geometry | `unity-level` |
| Design mechanic feedback (sound, feel) | `unity-visual-feedback` |
| Design audio response to mechanic use | `unity-audio` |
