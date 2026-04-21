---
name: unity-puzzle
description: >
  This skill should be used when designing gameplay challenges, puzzles, or encounters for any
  Unity game — including structuring a challenge around an existing mechanic, sequencing encounters
  across a level, ensuring challenges teach without frustrating, or writing a challenge proposal.
  Trigger phrases include: "design a puzzle", "design a challenge", "encounter design",
  "challenge structure", "puzzle for this mechanic", "how should this puzzle work",
  "challenge sequence", "encounter too hard", "teaching moment", "introduce a mechanic through
  a challenge", "challenge flow", "puzzle proposal", "encounter readability",
  "difficulty calibration", "challenge fits narrative", "combat encounter design",
  "enemy encounter layout".
---

# Unity Challenge & Puzzle Designer

> Build challenges that teach, test, and carry meaning — one idea at a time

## When to Use This Skill

- Designing a specific challenge or puzzle around an existing mechanic
- Designing combat encounters, environmental puzzles, or skill-based challenges
- Sequencing multiple challenges within a level section
- Ensuring a challenge teaches without frustrating
- Writing a complete challenge proposal for review
- Diagnosing why an encounter feels unclear or unfair

> **Design the mechanic first** using `unity-mechanics` (this plugin).
> **Place the challenge in a level** using `unity-level` (this plugin).
> **Tie the challenge to a story beat** using `unity-narrative` (this plugin).
> **Generate raw challenge ideas** using `unity-brainstorming` (standalone skill).

---

## Core Philosophy

### One Idea Per Challenge
Every challenge tests exactly one concept. If a challenge requires two new ideas simultaneously, split it into two challenges. Complexity comes from combinations of already-understood concepts — not from stacking unknowns.

### The Fairness Contract
All information needed to overcome the challenge must be available before the player commits to an attempt. No hidden elements. No logic that contradicts established rules. If the player fails, it must be because they misread the situation — not because the game withheld information.

### Challenges Are Teachers
Every challenge exists to deepen the player's understanding of a mechanic, the world, or the system. Before designing a challenge, answer: *"What will the player know after completing this that they didn't know before?"*

---

## Challenge Types by Genre

This skill covers all forms of gameplay challenges:

| Challenge type | Genres | Core design question |
|---------------|--------|---------------------|
| **Environmental puzzle** | Platformer, adventure, puzzle | How does the player manipulate the space to progress? |
| **Combat encounter** | Action, RPG, shooter | How does the enemy composition test the player's abilities? |
| **Traversal challenge** | Platformer, action | How does the space test the player's movement skills? |
| **Stealth section** | Stealth, action-adventure | How does observation and timing create tension? |
| **Resource puzzle** | Strategy, survival, RPG | How does scarcity force meaningful decisions? |
| **Social / dialogue challenge** | RPG, visual novel | How does information and choice create meaningful outcomes? |
| **Timing / rhythm challenge** | Rhythm, action | How does pattern recognition and execution create flow? |

The frameworks below apply to all types. Adapt the vocabulary to your genre.

---

## Challenge Structure Model (Authoritative Teaching Framework)

This is the **authoritative per-encounter teaching sequence** used across the plugin. `unity-level` references this framework when placing teaching beats in a level layout. `unity-mechanics` tracks the separate game-wide evolution arc (Introduce → Challenge → Combine).

Every challenge — regardless of type or genre — follows this four-stage arc:

```
1. INTRODUCTION    Low-risk environment, no harsh consequence
   -----------     One clear path, obvious goal
        |
2. REINFORCEMENT   Same mechanic, new arrangement
   -------------   Player must think, not just act
        |
3. TWIST           Add one constraint or combination
   -----           Subverts the pattern just learned
        |
4. MASTERY         Player applies full understanding
   -------         No guidance — earned independence
```

**Important**: These are not four separate challenges. They are the four beats within a single challenge sequence around one mechanic or concept. A full sequence typically spans 3-6 rooms, encounters, or stages.

---

## Challenge Proposal Format

Use this for every challenge before building it in Unity.

```markdown
## Challenge: [Name]

**Type**: Puzzle / Combat encounter / Traversal / Stealth / Resource / Other

**Mechanic tested**: Which core mechanic or skill does this challenge use?

**Stage in sequence**: Introduction / Reinforcement / Twist / Mastery

**Player goal**: What must the player achieve? (One sentence, clear to the player)

**Setup**: What does the player see/encounter when they enter?

**Solution / approach**:
1. [First observable element and player action]
2. [Result / new state]
3. [Second action]
4. [Resolution]

**What the player learns**: Complete this sentence — "After this, the player understands that [mechanic/skill] can be used to ___."

**Communication**: How does the challenge communicate itself without explicit instructions?
- Affordance: What makes the interactive elements look interactable / threats look threatening?
- Feedback: What happens when the player uses the wrong approach?
- Direction: What draws attention to the correct starting point?

**Narrative context**: Where does this challenge sit in the story? What does completing it mean?

**Failure state**: What happens when the player fails? Is it readable and fair?
```

---

## Complexity Progression

Apply this within any mechanic's teaching sequence:

| Stage | What changes | Design goal |
|-------|-------------|-------------|
| **Simple** | Mechanic alone, one path, zero ambiguity | Player understands the rule |
| **Variant** | Same mechanic, different spatial/situational arrangement | Player generalises the rule |
| **Combined** | Two mechanics or skills must work together | Player sees a new capability |
| **Subverted** | Established expectation is safely overturned | Player internalises deep understanding |

**Rule**: Never reach Combined before both mechanics have been through Simple and Variant independently.

---

## Communication — Designing Without Tutorials

Challenges should teach through the environment and encounter design, not through text. Replace every tutorial pop-up with one of these:

| Technique | How to apply | Example |
|-----------|-------------|---------|
| **Safe preview** | Show the mechanic's result before the player needs to use it | Enemy attacks a destructible wall in the background before the player reaches a similar wall |
| **Visual affordance** | Make interactive elements look different from scenery | Climbable surfaces have worn edges; pushable objects have visible weight |
| **Light and contrast** | Use brightness or saturation to direct attention | The important element is lit; everything else is dimmer |
| **Echo structure** | Show a completed version before the player reaches the uncompleted version | Player sees an open gate with a lever; later encounters a closed gate with a lever |
| **Failure readability** | Wrong attempt must produce a clear, readable response | Player attacks armored enemy from the front -> shield spark + no damage; back is visually unarmored |

---

## Difficulty Calibration

Difficulty is not about complexity of the solution — it is about **distance between information and action**.

```
Difficulty = (number of logical steps) x (visibility of each step)

Low difficulty:   Few steps + all elements visible immediately
Medium difficulty: More steps OR one element requires exploration to find
High difficulty:  Multiple steps + player must synthesise information across the space
```

**Calibration rules (genre-adaptable):**
- No challenge should require more than 4 logical steps for the player's first encounter with a mechanic
- If a challenge feels too hard, reduce the number of steps first — before adding hints
- If a challenge feels too easy, obscure one element (not the solution logic) — never add arbitrary steps
- For combat: difficulty comes from enemy composition and space design, not from inflated stats

---

## Hint / Assistance System

Three-tier assistance system — offer in sequence, never all at once:

| Tier | Content | Trigger condition |
|------|---------|------------------|
| **1 — Directional** | Points attention without explaining | After extended time without meaningful progress |
| **2 — Specific** | Names the relevant element or approach | After continued struggle |
| **3 — Solution** | States the action directly | After extended failure or on player request |

**Design rule**: A challenge that requires a Tier 2 hint in playtesting needs its communication redesigned — not better hints.

---

## Challenge-Mechanic Reference Matrix

For each core mechanic, identify the natural challenge archetypes:

| Mechanic type | Natural challenge | Twist variation |
|----------|-------------------|-----------------|
| **Movement ability** | Traversal that requires the ability | Traversal while avoiding hazards or under time pressure |
| **Combat ability** | Enemies that require the ability to defeat | Enemy combinations that require switching between abilities |
| **Manipulation** | Objects that must be positioned or combined | Object must travel through a hazard or space the player cannot |
| **Observation** | Patterns that must be read and acted on | Two patterns must be navigated simultaneously |
| **Resource** | Scarcity that forces prioritisation | Resource required for two competing goals |
| **Combined** | Two mechanics required together | One system holds a state while the other acts |

---

## Narrative Integration (Challenge-Specific)

Every challenge should feel like it belongs in the world. The challenge should feel like *the world presenting a situation*, not an arbitrary roadblock.

> **For full narrative design** (emotional intent, delivery methods, scene proposals) use `unity-narrative`. This checklist covers only the challenge-narrative fit.

**Integration checklist:**
- [ ] The challenge location makes sense given the world and story
- [ ] The required mechanic reflects the character's abilities (not arbitrary)
- [ ] Completing the challenge advances the player's position — physically, narratively, or emotionally
- [ ] Failing the challenge does not feel like narrative failure — only mechanical failure

---

## Anti-Patterns

| Anti-pattern | Symptom | Fix |
|---|---|---|
| **The guessing challenge** | Player tries random things until one works | Add a visible rule that makes the correct approach logical |
| **The inventory puzzle** | Player must have an item from earlier they didn't know they'd need | Make required elements available at the point of need |
| **The stacked unknown** | Two new concepts introduced in the same challenge | Split into two challenges; teach each concept separately |
| **The silent failure** | Wrong attempt produces no response | Add a readable failure state — sound, visual, or consequence |
| **The over-hinted challenge** | Solution is so telegraphed the player acts without thinking | Remove one hint layer; trust the communication design |
| **The narrative orphan** | Challenge exists in a vacuum, no contextual reason for it | Embed in a scene with a world reason for the obstacle |
| **The stat wall** | Challenge is hard because numbers are high, not because it tests skill | Redesign to test player understanding, not stat thresholds |

---

## Related Skills in This Plugin

| Need | Skill |
|------|-------|
| Design the mechanic the challenge uses | `unity-mechanics` |
| Place challenge sequence within a level | `unity-level` |
| Tie the challenge to a story moment | `unity-narrative` |
| Design visual feedback for challenge states | `unity-visual-feedback` |
| Design audio response (success, failure, ambience) | `unity-audio` |
