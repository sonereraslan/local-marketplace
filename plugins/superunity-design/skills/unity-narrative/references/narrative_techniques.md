# Narrative Techniques — Reference

## Environmental Storytelling Patterns

### Before-State Objects
Place objects that imply something happened before the player arrived. The player reconstructs the story from evidence.

| Object | Implied story |
|--------|--------------|
| Child's toy at an evacuation point | A family fled; someone was left behind |
| Two chairs facing each other, one knocked over | An argument, an arrest, a departure |
| Food half-eaten on a table | They left in a hurry |
| Flowers placed on a spot of disturbed earth | Someone is buried here, and someone came back |
| A photograph facing down | The person in it is gone, or wrong |
| Workbench covered in failed prototypes | Someone was obsessed, desperate, or determined |
| A locked door with scratches on the inside | Someone was trapped here |

**Design principle**: Never place an object that has no implied history. Every prop is either scenery (no story) or evidence (has a before-state). Know which one each object is.

### Worn Paths
Show where people have been by showing what their presence has done to the space.

- Grass worn away between two points -> people travelled this route regularly
- Handprints on a wall at child height -> children lived or played here
- Rope worn smooth in one spot -> something was pulled here repeatedly
- Candle wax pooled on a floor -> someone waited here, often, in the dark
- Bullet holes clustered at one height -> a firefight happened at this position
- Paint worn from a door handle -> this door was used constantly

### Parallel Staging
Place the player's action and the story's meaning in the same visual frame.

- Player clears debris to open a path -> in the background, old photos of the place before destruction
- Player repairs a broken mechanism -> a letter about reconciliation is pinned to the wall
- Player defeats enemies in a child's room -> toys and drawings surround the combat
- Player builds a shelter -> ruins of an old shelter visible nearby

---

## Silent Storytelling Techniques

### Animation as Emotion
Character movement speed and posture communicates emotional state without dialogue.

| Emotional state | Animation cue |
|----------------|--------------|
| Grief | Slow walk, hunched posture, pauses at objects |
| Fear | Quick, small movements; frequent stops to check surroundings |
| Determination | Steady pace, no hesitation |
| Exhaustion | Heavy foot plants, slower response to input |
| Hope | Slightly faster than baseline, upright posture |
| Anger | Sharp movements, shorter idle cycles |
| Confidence | Wide stance, fluid transitions between states |

**Unity implementation**: Use Animator parameters to blend between states based on story flags rather than input velocity.

### Light as Memory
Establish a consistent light language early and maintain it throughout the game.

| Light type | Emotional meaning |
|-----------|------------------|
| Warm, golden, directional | Safety, memory, the past as it was |
| Cool blue-grey, diffuse | The present danger; isolation |
| Harsh top light | Exposure, judgement, no shelter |
| Near-dark with a single source | Intimacy, secrecy, survival |
| Sudden bright light after darkness | Relief, revelation, arrival |
| Flickering or unstable light | Uncertainty, instability, something wrong |
| Coloured light (red, green) | Unnatural, corrupted, or otherworldly |

### Sound as Absence
Silence is a storytelling tool. Remove ambient sound to signal that something is wrong before the player sees it. Restore it when safety returns.

### Space as Emotion
The size and openness of a space communicates emotional state:
- Tight corridors -> claustrophobia, pressure, confinement
- Vast open spaces -> isolation, freedom, vulnerability
- Vertical spaces -> awe, insignificance, aspiration
- Cluttered spaces -> chaos, neglect, lived-in history
- Empty spaces -> loss, aftermath, abandonment

---

## Character Arc — Detailed Framework

### Want / Need / Flaw / Ghost

**Want** — The external goal the character consciously pursues. The player sees this first.
**Need** — The internal truth the character must accept to grow. The player feels this last.
**Flaw** — The defence mechanism that blocks the Need. It was once useful; now it causes harm.
**Ghost** — The past wound that created the Flaw. The player may never see this directly.

**Story arc**: The character pursues their Want. The Flaw causes repeated failures. The Ghost is gradually revealed through environment and gameplay moments. By the late game, the character must choose between clinging to the Flaw or accepting the Need.

### Arc Types in Games

| Arc type | What happens | How the player experiences it |
|----------|-------------|-------------------------------|
| **Positive** | Character accepts their Need, overcomes Flaw | Player's actions gradually unlock new capabilities that mirror growth |
| **Negative** | Character cannot accept Need, falls | Player witnesses the character making wrong choices — through gameplay, not just cutscenes |
| **Flat** | Character's belief is correct; the world changes | Player changes the world around a stable protagonist |
| **Corruption** | Character starts good, is changed by the world | Player's actions gradually shift from heroic to morally grey |

### Communicating Character Arc by Genre

| Genre | Primary arc delivery | Secondary |
|-------|---------------------|-----------|
| **Minimal dialogue** (platformer, puzzle) | Animation changes, environmental reflection, mechanic evolution | Optional collectible text |
| **Dialogue-heavy** (RPG, adventure) | Branching dialogue, NPC reactions, quest consequences | Environmental reinforcement |
| **Action-focused** (shooter, action) | Mechanic unlocks/changes, level progression, set-pieces | Brief dialogue, environmental storytelling |
| **Systems-driven** (roguelike, sandbox) | Emergent narrative from system interactions | Flavour text, procedural events |

---

## Narrative Integration Patterns

### Mechanic as Metaphor
The most powerful game narratives use mechanics themselves as storytelling:

| Mechanic | Literal function | Narrative potential |
|----------|----------------|-------------------|
| Healing | Restore HP | Compassion, sacrifice, cost of care |
| Destruction | Break objects | Irreversibility, consequence, power |
| Carrying | Transport items/people | Burden, responsibility, protection |
| Stealth | Avoid detection | Vulnerability, powerlessness, patience |
| Building | Place structures | Creation, safety, control |
| Choice | Select options | Agency, identity, values |
| Repetition | Do the same action repeatedly | Endurance, monotony, ritual |

**Design lesson**: Repetitive mechanics in narrative context communicate endurance and cost. Let the player be in the difficulty — don't shortcut past it.

### NPC/Companion as Emotional Proxy
If the game has an NPC or companion, they can express what the player character cannot:

1. Reacts to objects in the environment (investigates, hesitates, retreats)
2. Initiates comfort or concern in quiet moments
3. Carries or interacts with items that have narrative weight
4. Changes behavior across the game to reflect the evolving story

**Design lesson**: Every companion behaviour that is not strictly functional is a story beat.

---

## Scene Analysis — Reference Examples

### Environmental Storytelling (any genre)
A well-designed narrative space works through layers:

**Layer 1 — Macro**: The overall space tells a story (ruined city = war; overgrown lab = abandonment)
**Layer 2 — Meso**: Specific arrangements tell local stories (a barricade = someone fought here)
**Layer 3 — Micro**: Individual objects tell personal stories (a child's drawing = someone young was here)

All three layers should be present in narrative-important spaces.

### The Slow Crossing Pattern
A long, mechanically simple traversal communicates weight and endurance:
- The mechanic is basic (walk, dig, carry)
- The duration is longer than usual
- The audio shifts (sparse, ambient, tense)
- The visual environment tells the cost (destruction, danger, scale)

Works in any genre where you want the player to *feel* the distance.

### The Quiet Room Pattern
After a high-intensity section, place a space with:
- No enemies, no puzzles, no pressure
- Environmental details that reward observation
- Optional story elements (letters, objects, vistas)
- Audio that settles into calm

The quiet room is where the story lives. It earns its impact from the contrast with what came before.

---

## Narrative Structure — Three-Act Applied to Game Progression

| Act | Emotional register | Mechanic relationship |
|-----|------------------|----------------------|
| **Early game** | Curiosity, discovery, safety | Mechanics introduced gently; world feels intact or inviting |
| **Mid game** | Tension, cost, complication | Mechanics used in harder contexts; world shows conflict or change |
| **Late game** | Resolution, sacrifice, or transformation | Mechanics combined with full narrative weight; world is irrevocably changed |

### Scene Pacing Within a Level
Every level or major section benefits from: one moment of beauty, one moment of difficulty, one moment of quiet. The quiet moment is where the story lives.
