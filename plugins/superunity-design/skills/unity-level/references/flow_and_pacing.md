# Level Flow and Pacing — Reference

## Intensity Curve Patterns

### Pattern 1 — Standard Arc (recommended for most levels)
```
Intensity
   ^
 H |         ####
 M |   ##   #    #
 L | ##  ###       ##
   +--------------------->
     entry  peak  exit
```
Use for: mid-game levels, mechanic combination levels, standard action stages.

### Pattern 2 — Double Peak (for longer levels)
```
Intensity
   ^
 H |   ###       ###
 M |  #   ##   ##   #
 L | #      ###       #
   +--------------------->
     entry  mid  peak  exit
```
Use for: longer levels with two distinct challenge sequences. Insert a rest beat at the valley.

### Pattern 3 — Slow Burn (for narrative-heavy levels)
```
Intensity
   ^
 H |               ####
 M |         #####
 L | #########
   +--------------------->
     entry           exit
```
Use for: emotional reveals, late-game levels where atmosphere precedes action.

### Pattern 4 — Relief Arc (for levels after a hard section)
```
Intensity
   ^
 H |
 M | ##########
 L |           ########
   +--------------------->
     entry            exit
```
Use for: levels immediately following a climax or boss encounter. Let the player breathe.

### Pattern 5 — Spike (boss / set-piece)
```
Intensity
   ^
 H |      #####
 M |    ##     ##
 L | ###         ###
   +--------------------->
     setup peak  reward
```
Use for: boss encounters, set-piece moments, arena challenges. Sharp rise, sharp fall.

---

## Macro Flow — Across the Full Game

### Early Game
**Goal**: Establish each mechanic cleanly, build confidence.

- Each level or section introduces ONE mechanic or concept
- Challenge sequence: Introduction -> Simple -> Variant only (no Twist or Mastery yet)
- Emotional register: curiosity, safety, early wonder
- Intensity ceiling: medium — never push to high early on
- Recovery: generous — checkpoints after every challenge beat

### Mid Game
**Goal**: Combine mechanics, raise stakes, introduce complication.

- Levels pair two mechanics or concepts (both already known)
- Challenge sequence uses full arc: Easy -> Medium -> Twist -> Payoff
- Emotional register: tension, cost, growing understanding
- Intensity ceiling: high — but always followed by a rest beat
- Recovery: moderate — before the climax challenge

### Late Game
**Goal**: Mastery + emotional weight. Player proves full understanding.

- Levels use the full mechanic vocabulary
- Challenge design trusts the player — no re-teaching
- Emotional register: weight, sacrifice, resolution
- Intensity ceiling: high — but the tension is emotional, not just mechanical
- Recovery: sparse before climax, generous before narrative resolution

---

## Pacing Interventions

Use these when a level's flow is off:

| Problem | Diagnosis | Fix |
|---------|-----------|-----|
| Level feels too long | Too many encounters at the same intensity | Cut one encounter, or reduce one from Twist to Variant |
| Level feels too easy | No intensity peak | Elevate the climax — add a constraint or combination requirement |
| Player is exhausted | Two hard sections stacked without rest | Insert one low-intensity beat (exploration, narrative, breathing room) |
| Level feels disconnected | Challenge beats don't build on each other | Ensure each challenge uses the same mechanic with escalating constraint |
| Player gives up | Frustration loop exceeds ~3 failed attempts | Add environmental guidance; shorten the failure feedback loop |
| Level feels repetitive | Same challenge type repeated | Vary the challenge type or space design between beats |

---

## Mechanic Introduction Timing

When to introduce a new mechanic in the game's progression:

```
Rule: Never introduce a new mechanic when:
  - The player is already managing one unfamiliar mechanic
  - The space is visually busy or confusing
  - The emotional intensity is high

Introduce a new mechanic when:
  - The space is calm and readable
  - The player has just succeeded (confidence is high)
  - The introduction has a low-risk preview (environment demonstrates, NPC shows, or tutorial context)
```

### Introduction Level Structure
When an entire level or section exists to introduce one mechanic:

```
Beat 1 — Preview:   Player WATCHES the mechanic work (environment, NPC, scripted event)
Beat 2 — Prompted:  Very obvious first use — only one thing to interact with
Beat 3 — Confirmed: Same use, slightly different arrangement (no new constraints yet)
Beat 4 — Extended:  One gentle new context — builds confidence, not pressure
```

---

## Player Fatigue Diagnosis

Signs a level is causing player fatigue (from playtest observation):

| Observed behaviour | Meaning |
|-------------------|---------|
| Repeated failed attempts at same challenge | Challenge is unclear or unfair, not too hard |
| Player stops exploring, moves directly to exit | Mental energy is depleted — level is too long |
| Player skips environmental details | Visual overload or pacing is too dense |
| Player repeats a completed challenge | They are unsure the solution was correct — feedback is weak |
| Player quits and re-launches | Frustration loop hit without relief |
| Player avoids optional content | Either fatigued or optional content isn't compelling |

**Response**: If two or more of these appear in the same level, the intensity ceiling is too high for too long. Insert a rest beat or reduce challenge count.
