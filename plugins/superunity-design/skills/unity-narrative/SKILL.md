---
name: unity-narrative
description: >
  This skill should be used when designing story moments for any Unity game — including integrating
  narrative into gameplay, designing environmental storytelling, writing scenes with or without
  dialogue, tying a mechanic to an emotional meaning, designing dialogue systems, or producing
  a narrative scene proposal. Trigger phrases include: "design a story moment", "narrative scene",
  "environmental storytelling", "how does this level feel emotionally", "story design",
  "dialogue writing", "what does this scene say", "narrative integration", "scene proposal",
  "emotional beat", "story through gameplay", "what does the player feel here",
  "cutscene design", "branching narrative", "lore design".
---

# Unity Narrative Designer

> Integrate story into the game experience — through environment, action, dialogue, and systems

## When to Use This Skill

- Designing a scene that carries emotional weight
- Deciding what a level or area communicates to the player emotionally
- Tying a mechanic's use to a story meaning
- Writing a scene proposal for review or handoff
- Designing how story is delivered (environmental, dialogue, cutscene, mechanical)
- Building a narrative system (branching dialogue, lore, collectible storytelling)

> **To generate story ideas** use `unity-brainstorming` (standalone skill).
> **For challenge design in narrative context** use `unity-puzzle` (this plugin). Note: `unity-puzzle` has its own narrative integration checklist for challenge-narrative fit.
> **For camera framing and cinematic moves** use `unity-camera` (this plugin). Camera framing IS narrative — `unity-camera` owns how to frame emotional moments visually.
> **For visual feedback and polish** use `unity-visual-feedback` (this plugin).

---

## Core Philosophy

### Story Must Serve the Game
Narrative is not a separate layer applied on top of gameplay. The best game stories are inseparable from the mechanics, level design, and player actions. Before adding narrative, ask: *"How does this story moment change how the game feels to play?"*

### Match the Storytelling to the Genre
Different games require different narrative approaches. A minimalist platformer tells story through environment. An RPG tells story through dialogue and choice. A horror game tells story through atmosphere and absence. There is no single correct approach — only the one that fits your game.

### Respect the Player's Agency
Players come to games to act, not to watch. Even in narrative-heavy games, the player should feel like a participant in the story, not an audience member. Prioritise interactive storytelling over passive delivery.

---

## Narrative Delivery Methods

Choose the methods that fit your game's genre and scope:

| Method | Best for | Strengths | Risks |
|--------|---------|-----------|-------|
| **Environmental storytelling** | All genres | Non-intrusive, rewards exploration | Easy to miss, hard to convey complex plot |
| **Dialogue (linear)** | Action, platformer, linear narrative | Clear, controlled pacing | Can interrupt gameplay flow |
| **Dialogue (branching)** | RPG, adventure, visual novel | Player agency, replayability | Expensive to produce, hard to test |
| **Mechanical storytelling** | All genres | Deeply integrated, unforgettable | Hard to design, requires mechanic-narrative alignment |
| **Cutscenes** | Narrative-heavy, action set-pieces | Cinematic impact, full control | Interrupts gameplay, expensive, skippable |
| **Collectible lore** | Open-world, exploration, soulslike | Optional depth, rewards exploration | Players may never read it |
| **Systems-driven narrative** | Roguelike, sandbox, simulation | Emergent, unique per player | Hard to control emotional beats |
| **UI / text overlay** | Many genres | Simple, low-cost | Can feel disconnected from the world |

### Choosing Your Mix

Most games use 2-3 methods as their primary narrative tools. Define your narrative delivery mix early:

```
Primary method:   [the main way story is delivered — most scenes use this]
Secondary method: [supports the primary — used for variety or emphasis]
Accent method:    [rare, reserved for special moments — high impact because of scarcity]
```

---

## The Three Narrative Layers

Build every scene across all three layers simultaneously:

| Layer | What it is | Tools |
|-------|-----------|-------|
| **Environment** | The world tells its own history | Destroyed objects, worn paths, abandoned items, light and shadow, architecture |
| **Action** | Player behavior carries meaning | What the player does — mechanics, movement, choices — reinforces the emotional truth |
| **Explicit** | Direct communication of story | Dialogue, text, voice-over, cutscene — the layer most players remember, but least essential |

**Rule**: If only one layer is working, the scene is not ready. At least two layers must contribute for the scene to feel grounded.

---

## Key Questions — Ask Before Designing Any Scene

```
1. What does this space say emotionally before the player does anything?
2. What does the player do here — and what does that action mean?
3. What does the player understand after leaving that they didn't before?
4. Which narrative delivery methods does this scene use?
5. Does this scene integrate with gameplay, or interrupt it?
```

---

## Thematic Mechanic Design

Each core mechanic can carry a narrative meaning that reinforces the game's themes. Design the pairing intentionally:

### Examples Across Genres

| Mechanic | Literal function | Narrative meaning |
|----------|----------------|------------------|
| **Healing others** | Restore ally HP | Compassion, sacrifice (costs resource to give) |
| **Destruction** | Break objects/walls | Irreversible change, consequence |
| **Building** | Place structures | Creation, protection, home |
| **Stealth** | Avoid detection | Vulnerability, powerlessness, observation |
| **Dialogue choice** | Select response | Agency, values, identity |
| **Carrying / escorting** | Move a person or object | Burden, responsibility, care |
| **Time manipulation** | Rewind or slow time | Regret, control, the desire to undo |

**Design rule**: Introduce the mechanic's literal use first. Let the player master it. Then place it in a story context where the emotional meaning becomes unmistakable.

---

## Silent / Environmental Storytelling Techniques

Even games with heavy dialogue benefit from environmental narrative. These techniques work in any genre:

Detailed patterns at [references/narrative_techniques.md].

| Technique | How to apply | Example |
|-----------|-------------|---------|
| **Object history** | Place objects that imply a before-state | A child's drawing in an abandoned bunker |
| **Worn paths** | Show where people have been | Grass worn between two points; scratches on a door |
| **Parallel staging** | Put player action and story meaning in the same space | Player repairs a bridge while evidence of its destruction is visible |
| **Animation / movement pacing** | Use character speed to convey emotion | Character moves slowly through loss; urgently through danger |
| **Light as tone** | Warm light for safety; cool light for danger | Safe areas are warm; hostile areas are cold and blue |
| **Absence** | What's missing tells a story | Empty chairs at a table set for four |

---

## Character Arc Integration

Every character in the game has an underlying emotional journey. Design scenes to advance that arc through what the player witnesses or does.

**Arc framework:**
- **Want**: What the character is consciously pursuing (external goal)
- **Need**: What they actually require to grow (internal truth)
- **Flaw**: The belief that blocks their growth
- **Ghost**: The past event that created the flaw

**Design application**: Each act or major section should move the character closer to — or further from — their Need. Whether this is communicated through dialogue, environment, or mechanics depends on the game's narrative delivery mix.

Full character arc patterns at [references/narrative_techniques.md].

---

## Scene Proposal Format

Use this output format for every narrative scene. Full reference at [references/narrative_designer.md].

```markdown
## Scene: [Name]

**Location**: Where does this happen in the game world?

**Story position**: Where in the game's progression — what has just happened before this?

**Scene description**:
[What the player sees on entry — 3-5 sentences, visual only. No internal states.]

**Player actions**:
1. [What the player does — mechanic + physical action]
2. [Optional second action]

**Narrative delivery**: [Which methods does this scene use? Environmental / dialogue / mechanical / cutscene]

**Emotional outcome**:
[What the player should feel after leaving — one sentence]

**Gameplay integration**:
[How does the scene connect to the gameplay in this section?
Does the challenge have narrative meaning? Does failing feel like something?]

**Dialogue / text** (if any):
[Key lines or text. Note whether skippable.]

**Environmental version**:
[Describe how the scene communicates its meaning through environment alone.
If it cannot, consider strengthening the environmental layer.]
```

---

## Narrative Constraints (Define Per-Project)

Define these based on your game's genre and scope:

```
Delivery:
- Primary narrative method: [environmental / dialogue / cutscene / mechanical]
- Maximum cutscene length: [project-specific]
- Dialogue density: [heavy / moderate / minimal / none]

Integration:
- [ ] Story moments are integrated with gameplay where possible
- [ ] Every major mechanic has a declared thematic meaning
- [ ] The game's narrative delivery mix is consistent

Quality:
- [ ] Scenes work on at least two of the three narrative layers
- [ ] Character arcs are advanced through action, not just exposition
- [ ] Implementation is feasible with available systems and tools
```

---

## Anti-Patterns

| Anti-pattern | Symptom | Fix |
|---|---|---|
| **Exposition dump** | Character explains the world in a long speech | Break into environmental evidence, discoverable lore, or shorter dialogue across scenes |
| **Gameplay pause** | Story moment freezes player input unnecessarily | Embed the story beat inside gameplay, or keep the interruption brief and earned |
| **Stated emotion** | "I'm so sad about what happened" | Show through animation, pacing, environment — let the player infer |
| **Orphan scene** | Story beat has no connection to the gameplay around it | Find the mechanic or challenge that expresses the same truth |
| **Lore overload** | Walls of text or long codex entries nobody reads | Shorten to key details; make lore discoverable and optional |
| **Narrative-gameplay mismatch** | Story says urgency but gameplay allows idle exploration | Align narrative tone with gameplay pacing and mechanics |

---

## Related Skills in This Plugin

| Need | Skill |
|------|-------|
| Place this scene in a level | `unity-level` |
| Design the mechanic that carries the scene | `unity-mechanics` |
| Design the challenge the scene wraps around | `unity-puzzle` |
| Design visual atmosphere (light, camera) | `unity-visual-feedback` |
| Design audio for the emotional moment | `unity-audio` |

## Additional Resources

- **[references/narrative_techniques.md]** — Detailed environmental storytelling patterns, silent storytelling techniques, character arc examples
- **[references/narrative_designer.md]** — Source role definition and output style reference
