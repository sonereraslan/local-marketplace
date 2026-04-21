---
name: unity-brainstorming
description: >
  This skill should be used when the user wants to brainstorm Unity game design ideas,
  including gameplay mechanics, level design concepts, narrative direction, or any creative
  game design problem. Trigger phrases include: "brainstorm mechanics", "ideate level design",
  "let's come up with ideas", "mechanic ideas", "what could the story be",
  "how should the level feel", "generate gameplay ideas", "mechanic brainstorm",
  "narrative brainstorm", "level brainstorm", "stuck on game design", "game idea",
  "combat design ideas", "enemy design brainstorm", "system design ideas".
---

# Unity Game Brainstorming — Mechanics, Levels & Narrative

> Structured creative thinking for game design — from raw idea to actionable concept

## When to Use This Skill

- Stuck on what mechanic to add next
- Designing a new level, area, or encounter
- Exploring narrative direction or story beats
- Expanding on an existing mechanic or system
- Breaking out of a creative block
- Comparing design approaches for a feature

---

## Core Principle: Diverge First, Converge Later

```
  Game Design Thinking Flow

  DIVERGE -----------------------> CONVERGE

  +---------------+           +----------------+
  |  Generate     |           |  Evaluate      |
  |  ---------    |  EXPLORE  |  ----------    |
  | * Quantity    | --------> | * Feasibility  |
  | * No judgment |           | * Fun factor   |
  | * Wild is OK  |           | * Scope fit    |
  +---------------+           +----------------+

  Rule: Never evaluate while generating.
```

---

## Brainstorm Methods

### Classic Brainstorm (Solo or with Claude)

```
1. Define the design problem clearly (2 min)
   Example: "How might we make the second world feel distinct from the first?"

2. Generate without filtering (10 min)
   - Aim for 10-20 raw ideas minimum
   - Include bad ideas — they unlock good ones

3. Combine and extend (5 min)
   - Merge similar ideas
   - Push promising ones further

4. Evaluate and select (5 min)
   - Feasible for current scope?
   - Fun to play, not just clever on paper?
   - Pick 1-3 to prototype
```

### SCAMPER for Game Mechanics

Apply to any existing mechanic to generate variants:

| Letter | Technique | Game Design Question |
|--------|-----------|----------------------|
| **S** | Substitute | Swap a core property — what if gravity pulled sideways instead of down? |
| **C** | Combine | Merge two mechanics — what if the jump also activated a puzzle element? |
| **A** | Adapt | Borrow from another genre — how would a sokoban box work in your game? |
| **M** | Modify | Change scale or intensity — make the mechanic very fast, very slow, or tiny |
| **P** | Put to other use | Use an obstacle as a tool — an enemy you ride instead of avoid |
| **E** | Eliminate | Remove a standard feature — what if there's no jump? no health bar? no death? |
| **R** | Reverse | Flip the goal — instead of moving the player, move the world |

### Six Hats for Design Decisions

Use when evaluating a mechanic, level, or system idea:

```
White Hat — Facts:   "What do we know about how players use this?"
Red Hat   — Feel:    "Does this feel satisfying? Frustrating? Fair?"
Black Hat — Risk:    "Where will players get stuck or confused?"
Yellow Hat — Value:  "What makes this fun or meaningful?"
Green Hat — Ideas:   "How can we push this further or fix the weak spots?"
Blue Hat  — Process: "What's the next step to test this?"
```

---

## Mechanics Ideation

### Morphological Matrix — Generate Mechanic Combinations

Build combinations by picking one item from each row:

| Dimension     | Option A       | Option B        | Option C         | Option D        |
|---------------|----------------|-----------------|------------------|-----------------|
| **Core verb** | Push / Pull    | Freeze / Thaw   | Grow / Shrink    | Light / Dark    |
| **Affects**   | Player         | Environment     | Enemies          | Time            |
| **Trigger**   | Button press   | Proximity       | Sequence / order | Timer           |
| **Constraint**| Limited uses   | Cooldown        | Resource cost    | Line of sight   |
| **Feedback**  | Physics chain  | Sound + visual  | Camera shift     | World state change |

Example random combination: `Freeze -> Environment -> Proximity -> Line of sight -> Physics chain`
-> Freezing nearby objects when the player looks at them, which can trigger chain reactions

### Reverse Thinking — Mechanic Variants

```
Bad version:  "How would this mechanic feel terrible to play?"
               -> Too slow, unpredictable, punishes curiosity

Invert those: -> Add speed, clear cause-effect, reward exploration
               -> These become design requirements for the good version
```

### Genre-Specific Mechanic Prompts

| Genre | Brainstorm prompts |
|-------|-------------------|
| **Platformer** | What movement verb is missing? What makes traversal unique? |
| **RPG** | What system creates meaningful build variety? How does choice matter? |
| **Action** | What makes combat feel distinct? What's the risk-reward loop? |
| **Puzzle** | What single rule creates the most interesting situations? |
| **Horror** | What mechanic makes the player feel vulnerable? What restricts power? |
| **Strategy** | What creates interesting trade-offs? What rewards planning? |
| **Roguelike** | What creates run variety? What makes each attempt feel different? |

---

## Level Design Brainstorming

### The HMW Format for Level Intent

Frame each level with a "How Might We" question before designing it:

- "How might we teach this mechanic without text?"
- "How might we make this corridor feel dangerous without enemies?"
- "How might we reward a player who backtracks?"
- "How might we create tension in an open space?"

### Level Brainstorm Dimensions

Generate ideas along these axes for any level:

| Axis | Questions to explore |
|------|----------------------|
| **Space** | Vertical or horizontal? Open or tight? Linear or branching? Indoor or outdoor? |
| **Tempo** | Fast section into slow? Pressure then release? Slow build to climax? |
| **Teaching** | What mechanic does this level introduce, challenge, or combine? |
| **Surprise** | Where does the player's expectation get subverted — safely? |
| **Emotion** | Should this level feel tense, playful, melancholy, triumphant, eerie? |

### Random Stimulus — Level Concept Generator

```
1. Pick a random word (use any noun)
2. List 5 properties of that word
3. Force-connect each property to level design

Example — Word: "Echo"
Properties: delay, repetition, fading, bouncing off walls, distortion
-> Level where platforms activate with a delay after stepping on them
-> A section that must be run twice but changes the second time
-> Sound cues that fade with distance as navigation hints
-> Walls that "reflect" the player's movement in a mirrored section
```

---

## Narrative Brainstorming

### Core Story Questions (Start Here)

Before brainstorming story, anchor on:
- **What does the player character want?** (goal)
- **What do they fear or resist?** (internal conflict)
- **What does the world ask of them?** (external pressure)

### Narrative SCAMPER

| Technique | Story Application |
|-----------|------------------|
| **Substitute** | Swap the protagonist's motivation — same events, different emotional meaning |
| **Combine** | Merge two themes — loneliness + environmental decay = world that fades when alone |
| **Adapt** | Borrow a narrative structure — what if this were a fairy tale? A myth? A memory? |
| **Modify** | Change the emotional register — same story, but told as comedy or horror |
| **Eliminate** | Remove explicit exposition — can the story be told entirely through level design? |
| **Reverse** | Start at the end — player knows the outcome, the mystery is the how/why |

### Environmental Narrative Brainstorm

```
For each area, ask:
1. What happened here before the player arrived?
2. What evidence of that remains?
3. What does the player's presence change or reveal?

Tools: background detail, object placement, lighting shifts,
       enemy behavior, ambient sound, destructible vs. preserved objects
```

---

## Idea Evaluation Matrix

After generating ideas, score each one:

```
Impact on Fun
     ^
High |  * Prototype Now  |  * Worth the scope  |
     |  (simple + fun)    |  (complex but great)  |
     |--------------------+-----------------------|
Low  |  Cut               |  Validate first       |
     |                    |  (build a tiny test)  |
     +--------------------+----------------------->
     Low                  High              Implementation Cost
```

### Evaluation Criteria for Game Ideas

| Dimension | Questions |
|-----------|-----------|
| **Fun** | Is this fun to play, or only clever to design? |
| **Clarity** | Can a new player understand this in 30 seconds? |
| **Scope** | Does this fit the current build phase? |
| **Cohesion** | Does it reinforce the game's existing feel and theme? |

---

## AI-Assisted Brainstorming Prompts

Use these with Claude to generate fast:

```
Role-play prompts:
"Imagine you're a 10-year-old playing this. What would confuse or delight you?"
"You're the level designer for [reference game]. What would you do with this mechanic?"
"The player just lost for the fifth time here. What are they feeling?"

Constraint prompts:
"Design this level using only 3 element types."
"Give me 5 ways to teach this mechanic without any UI or text."
"How would this mechanic work if the player had no [standard ability]?"

Narrative prompts:
"If this world were described in one sentence by someone who lived here, what would they say?"
"What's the saddest version of this story? The most hopeful version?"
```

---

## When You're Stuck

```
1. Reframe the problem   — "How might we..." instead of "How do we..."
2. Add a constraint      — Limits often unlock creativity (no jump, one screen, no combat)
3. Change the player     — Design for a cautious player, then an impatient one
4. Zoom out              — What's the emotional arc of the whole game? Where does this fit?
5. Prototype cheaply     — A 5-minute paper prototype beats an hour of theorizing
6. Borrow deliberately   — Name 3 games with a similar problem. What did they do?
```

---

## Game Design Idea Template

```markdown
## Idea: [Name]

**One line:** [What it is in plain language]

**Type:** [ ] Mechanic  [ ] Level concept  [ ] Narrative beat  [ ] System  [ ] Encounter

**Core experience:** What should the player feel?

**How it works:** Describe the loop or moment in concrete terms.

**What makes it interesting:** The twist, tension, or surprise.

**Risk:** Where could this fail or frustrate?

**Smallest test:** How do we validate this in under 2 hours of work?

**Fits the game because:** [Link to tone, theme, pillars, or existing systems]
```
