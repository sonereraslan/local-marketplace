---
name: unity-level
description: >
  This skill should be used when designing, laying out, or prototyping a level for any Unity game —
  including structuring a level's flow, placing challenges and encounters, guiding the player through
  space, calibrating pacing and intensity, predicting player confusion, or setting up a graybox
  prototype in Unity. Trigger phrases include: "design a level", "level layout", "level structure",
  "encounter placement", "player path", "level pacing", "level flow", "level intensity curve",
  "player confusion points", "where should the player go", "level too hard", "level feels flat",
  "graybox this level", "prototype the level", "level proposal", "level feels too long",
  "open world area design", "dungeon layout", "arena design".
---

# Unity Level Designer

> Design levels that guide, challenge, and carry meaning — clear paths, honest difficulty, earned payoffs

## When to Use This Skill

- Laying out a new level from scratch (any genre or perspective)
- Placing challenges, encounters, or points of interest within a space
- Diagnosing pacing problems (too long, too hard, too flat)
- Predicting where players will get confused
- Setting up a Unity graybox prototype for iteration

> **Design the challenges first** using `unity-puzzle` (this plugin).
> **Embed narrative moments** using `unity-narrative` (this plugin).
> **Design visual atmosphere** using `unity-visual-feedback` (this plugin).

---

## Four-Phase Workflow

Approach every level through these four lenses in order:

```
Phase 1 — LAYOUT      What goes where? (rooms, paths, encounter positions)
Phase 2 — FLOW        How does intensity change over time? (pacing curve)
Phase 3 — PSYCHOLOGY  Where will the player be confused? (clarity audit)
Phase 4 — GRAYBOX     Build it fast in Unity, test, iterate
```

Never jump to graybox before layout and flow are resolved on paper.

---

## Phase 1: Level Structure

### Structure Templates by Genre

Choose and adapt the structure that fits your game:

**Linear (platformer, action, narrative)**
```
1. ENTRY          Safe zone — establish the space, zero pressure
2. INTRODUCTION   Remind or introduce the mechanic for this section
3. CHALLENGE SEQ  1-3 challenges building in complexity
4. CLIMAX         The hardest or most emotionally weighted moment
5. RESOLUTION     Breathing room, transition, reward
```

**Hub & Spoke (metroidvania, adventure, RPG)**
```
1. HUB            Central safe space — connects to multiple paths
2. SPOKES         Each path focuses on one mechanic or theme
3. GATES          Progress requires abilities or items from other spokes
4. RETURN         Player returns to hub with new capability
5. EXPANSION      Hub changes or reveals new paths after milestones
```

**Arena / Encounter (action, roguelike, shooter)**
```
1. APPROACH       Player sees the arena space before engaging
2. SETUP          Initial enemy wave or environmental state
3. ESCALATION     Pressure increases — new enemies, shrinking space, timer
4. CLIMAX         Peak difficulty / most demanding moment
5. REWARD         Loot, narrative, or passage opens
```

**Open Zone (open-world, exploration, sandbox)**
```
1. VISTAS         Elevated points that reveal points of interest
2. LANDMARKS      Distinctive features that aid navigation
3. DENSITY ZONES  Areas of high activity vs. quiet travel
4. GATING         Soft gates (difficulty) or hard gates (abilities/items)
5. DISCOVERY      Hidden content rewards exploration
```

### Level Layout Rules (Universal)

- **Player always knows where to go (or knows they're exploring).** If a playtester stops and looks around in a linear game, the path is unclear — not the player.
- **Use environment to guide, not arrows.** Light, framing, movement, architectural lines, enemy placement, and item trails all direct attention.
- **Dead ends must be intentional.** A dead end that rewards exploration is a feature. An accidental dead end is a design failure.
- **Scale to the idea.** One mechanic, one emotional register, one core experience per section. Scale up only if the idea genuinely needs space.

### Player Path Design

Define the intended path before placing any challenges:

```markdown
Entry point -> [beat 1] -> [beat 2] -> [beat 3] -> Exit point

For each beat, answer:
- What does the player see on arrival?
- What is the single most visible element?
- What draws them forward (or invites exploration)?
```

Full layout patterns at [references/level_designer.md].

---

## Phase 2: Flow and Pacing

### Micro Flow (Inside a Level)

```
Easy -> Medium -> Twist -> Payoff

Easy:   Player applies known mechanic, confirms understanding
Medium: Constraint added — timing, space, or combination
Twist:  Expectation subverted — something familiar used in a new way
Payoff: Player applies full understanding; emotional or narrative reward
```

### Macro Flow (Across Levels / Game Progression)

| Game phase | Design focus | Mechanic relationship |
|-----------|-------------|----------------------|
| **Early** | Teach — one mechanic at a time, forgiving environment | Mechanics in isolation, generous recovery |
| **Mid** | Combine — multiple mechanics together | Compound challenges, tighter demands |
| **Late** | Mastery + emotional weight | Full mechanic vocabulary, narrative payoff |

### Intensity Curve

Every level or section should have a readable intensity shape:

```
Intensity
   ^
 H |         ####
 M |   ##   #    #
 L | ##  ###       ##
   +--------------------> Time
     entry  peak  exit
```

Common shapes:
- **Rising** (entry -> peak -> exit): Standard action level
- **Valley** (high -> low -> high): Calm between storm — narrative breathing room
- **Plateau** (sustained mid): Exploration, gradual discovery
- **Spike** (low -> sharp peak -> low): Boss encounter, set-piece moment

Avoid: flat line (no tension), all-high (player exhaustion), all-low (no engagement).

Detailed pacing patterns and intensity curve examples at [references/flow_and_pacing.md].

---

## Phase 3: Player Psychology

### Teaching Mechanics Through Level Beats

When a level introduces a mechanic, map the level beats to the **Challenge Structure Model** defined in `unity-puzzle` (the authoritative per-encounter teaching framework):

```
Level beat 1 → INTRODUCTION   — Safe space, one clear path, mechanic demonstrated or obvious
Level beat 2 → REINFORCEMENT  — Same mechanic, new arrangement, player must think
Level beat 3 → TWIST          — One constraint or combination subverts the pattern
Level beat 4 → MASTERY        — No guidance, player applies full understanding
```

> **How to use**: When placing challenge beats in a level, use this mapping. For the full framework (including communication design, difficulty calibration, and hint systems), see `unity-puzzle`.
> **For game-wide mechanic evolution** (how a mechanic deepens across the entire game), see `unity-mechanics` (Evolution Framework).

### Visual Hierarchy

The most important interactive element must be the most visually prominent:

| Priority | Visual treatment |
|----------|----------------|
| **Primary** (do this now) | Brightest, most saturated, in movement or light |
| **Secondary** (important but not urgent) | Midtone, still, readable |
| **Background** (context only) | Low contrast, desaturated, static |

### Confusion Audit

Before finalising any layout, run this checklist:

```
- [ ] Is the entry point / current objective unambiguous?
- [ ] Can the player see or infer their goal from the start?
- [ ] Are all interactive objects visually distinct from scenery?
- [ ] Does a wrong attempt produce readable feedback?
- [ ] Is there a safe place to observe before committing?
- [ ] Would a new player know what to try first?
- [ ] For open layouts: are landmarks and sightlines guiding exploration?
```

### Common Confusion Sources

| Confusion point | Cause | Fix |
|----------------|-------|-----|
| Player doesn't move | Entry space has equal visual weight everywhere | Add a light source or moving element at the intended first destination |
| Player ignores interactive object | Object blends with background | Increase contrast; add idle animation or ambient particle |
| Player attempts wrong solution repeatedly | Failure state gives no feedback | Add a clear visual/audio response to wrong attempts |
| Player backtracks unnecessarily | Path forward not visible from current position | Reposition camera or open a sightline to the next beat |
| Player gets lost in open area | No landmarks or visual hierarchy | Add distinctive landmarks visible from multiple angles |

---

## Phase 4: Graybox Prototype

### Unity Setup

Build the graybox before any visual polish. Use ProBuilder or Unity primitives only.

```
Placeholder colour convention:
- White / light grey   -> floor and safe platforms
- Dark grey            -> walls and background geometry
- Yellow               -> interactive objects (pushable, climbable, usable)
- Red                  -> hazards and enemies
- Green                -> goal / exit / reward
- Blue                 -> NPC or companion positions
- Orange               -> optional / secret areas
```

### Graybox Workflow

```
Step 1 — Rough layout
  Place rooms, paths, and spaces using flat planes and cubes
  Mark entry, challenge beats, and exit with coloured primitives
  No detail — only scale and position

Step 2 — Test player movement
  Walk the intended path
  Check: does it feel the right size? Too long? Too cramped?
  Adjust scale before adding any challenge elements

Step 3 — Add challenge elements
  Place interactive objects and enemies at intended positions
  Test each challenge in sequence
  Check confusion points from Phase 3 against actual experience

Step 4 — Iterate
  One change at a time
  Test after each change
  Do not polish until challenge and flow feel correct
```

**Core principle**: *If it's not fun in graybox, it won't be fun with art.*

Full graybox setup guide and ProBuilder workflow at [references/graybox_guide.md].

---

## Level Proposal Format

```markdown
## Level: [Name]

**Game position**: Where does this level sit in the overall game progression?

**Mechanic focus**: Which core mechanic(s) does this level primarily use?

**Emotional register**: What should the player feel in this space?

**Structure** (use the template that fits your game):
1. [Beat 1: what the player sees and feels]
2. [Beat 2: how the mechanic is introduced or used]
3. [Beat 3: challenge sequence]
4. [Beat 4: climax or peak moment]
5. [Beat 5: resolution or transition]

**Player path**: Entry -> [beat] -> [beat] -> Exit

**Key visual cues**: What guides the player at each beat?

**Confusion audit**: Where might the player stop? What is the fix?

**Intensity shape**: Sketch the low-mid-high curve across the level.

**Graybox priority**: What must be tested first?
```

---

## Anti-Patterns

| Anti-pattern | Symptom | Fix |
|---|---|---|
| **Over-designed level** | Too many rooms, too many ideas | One core idea per section — cut everything else |
| **Flat intensity** | Every encounter feels the same difficulty | Apply micro flow: easy -> medium -> twist -> payoff |
| **Invisible path** | Player wanders without direction | Add a light source, movement, or architectural line pointing forward |
| **Stacked hard encounters** | Player frustration builds without release | Insert a breathing room beat between hard sections |
| **Tutorial text dependency** | Pop-up explains how to interact | Redesign the first encounter so the space teaches it |
| **Graybox skipped** | Level built with art before gameplay tested | Always test core gameplay in graybox; rework before visual polish |
| **Empty space** | Areas with nothing to do between encounters | Either fill with micro-rewards/atmosphere or shrink the space |

---

## Related Skills in This Plugin

| Need | Skill |
|------|-------|
| Design the challenges this level contains | `unity-puzzle` |
| Per-encounter teaching framework (Challenge Structure Model) | `unity-puzzle` |
| Game-wide mechanic evolution arc | `unity-mechanics` |
| Embed a narrative moment in the level | `unity-narrative` |
| Design visual atmosphere and feedback | `unity-visual-feedback` |
| Design audio for the level's emotional register | `unity-audio` |

## Additional Resources

- **[references/level_designer.md]** — Source role definitions (Level Designer, Flow Expert, Player Psychology, Graybox Specialist)
- **[references/flow_and_pacing.md]** — Detailed intensity curve patterns, macro flow examples, level fatigue diagnosis
- **[references/graybox_guide.md]** — Unity ProBuilder workflow, placeholder conventions, iteration checklist
