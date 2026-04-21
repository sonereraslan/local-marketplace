# Graybox Guide — Unity Reference

## Core Principle

**"If it's not fun in graybox, it won't be fun with art."**

Graybox reveals layout problems, pacing problems, and challenge clarity problems. All of these are expensive to fix after art is applied. Graybox is not a step to skip — it is the design step.

---

## Unity Setup

### Option A — ProBuilder (recommended)
ProBuilder allows fast in-editor mesh creation without leaving Unity.

```
Install: Package Manager -> search "ProBuilder" -> Install
Create mesh: Tools -> ProBuilder -> New ProBuilder Mesh
```

ProBuilder advantages:
- Resize and reshape in-editor without going to an external tool
- Extrude faces to create platforms, walls, and ledges in seconds
- Easy to iterate — select, resize, move without breaking references

### Option B — Primitive Primitives
Use if ProBuilder is not available or for very early rough layout:

```
GameObject -> 3D Object -> Cube / Plane / Cylinder
Scale to need using Transform
```

Faster to place, harder to reshape. Use for initial blocking only.

---

## Placeholder Colour Convention

Apply these using Materials with unlit shaders (no lighting needed in graybox):

| Colour | Hex | Represents |
|--------|-----|------------|
| White / light grey | `#E0E0E0` | Floor, safe platforms, walkable surfaces |
| Dark grey | `#404040` | Walls, background, non-interactive surfaces |
| Yellow | `#FFD700` | Interactive objects (pushable, climbable, usable, levers, doors) |
| Red | `#FF4040` | Hazards (spikes, patrol zones, kill planes, enemies) |
| Green | `#40C040` | Goal, exit, challenge completion trigger |
| Blue | `#4080FF` | NPC positions, ally spawns, key characters |
| Orange | `#FF8020` | Collectibles, optional paths, secrets |
| Purple | `#8040C0` | Triggers, event zones, scripted events |

**Rule**: Apply colours before testing. A graybox without colour coding is harder to read than one with it.

---

## Step-by-Step Graybox Workflow

### Step 1 — Paper Layout First
Before opening Unity, sketch the level on paper or a whiteboard:
- Mark entry, each challenge beat, and exit
- Draw the intended player path as a single line
- Identify sightlines (what the player sees when they arrive at each beat)

Only open Unity when the paper sketch answers: *"Does this level make sense as a sequence of spaces?"*

### Step 2 — Rough Blocking (15-30 min)

Create rooms and paths using flat geometry. No detail.

```
For each beat in the level:
  - One plane for the floor
  - Cubes for walls if needed
  - Mark the beat's position with a coloured primitive (yellow = challenge here)
```

**Check at this stage:**
- Does the level feel the right physical size?
- Is the player path readable from above?
- Are there any accidental dead ends?

### Step 3 — Scale Test

Walk the level with the player character before adding any challenge elements.

```
Test checklist:
- [ ] Walk the intended path in real time — does it feel too long?
- [ ] Do the spaces feel appropriately sized for the gameplay?
- [ ] Are movement distances achievable with the player's abilities?
- [ ] Does the camera show what it needs to at each beat?
```

Adjust scale now. Resizing after challenge elements are placed is painful.

### Step 4 — Place Challenge Elements

Add interactive objects (yellow) and hazards (red) at the positions defined in the level proposal.

```
For each challenge:
  - Place all required objects (interactive items, switches, enemies, obstacles)
  - Mark the goal position (green)
  - Mark any hazards (red)
  - Mark NPC/ally positions (blue)
  - Test the intended approach manually
```

**Check at this stage:**
- Can you complete each challenge cleanly?
- Is the correct starting point visible on arrival?
- Does a wrong attempt produce a readable result?

### Step 5 — Confusion Audit in Engine

Walk the level as if you have never seen it:

```
- [ ] Does the entry establish a clear direction?
- [ ] Is the challenge goal visible before the player commits?
- [ ] Are interactive objects (yellow) obviously different from walls (dark grey)?
- [ ] Does every failure state make the mistake clear?
- [ ] Is the exit (green) visible or inferable from the climax area?
- [ ] For open layouts: are landmarks visible and distinct?
```

Mark any failures. Fix before moving to polish.

### Step 6 — Iterate One Thing at a Time

```
Change ONE element -> Test -> Observe -> Repeat

Never change multiple things between tests.
If the problem is unclear, add a playtester.
If the challenge solution feels good but the path is confusing, fix path first.
```

---

## Common Graybox Problems

| Problem | Graybox symptom | Fix |
|---------|----------------|-----|
| Level too large | Walking between beats feels empty and slow | Compress the space; challenge beats should be reachable in 5-15 seconds of movement |
| Challenge not visible on arrival | Player walks past without noticing | Move challenge into direct sightline at beat entry; add yellow colour to attract eye |
| Movement feels wrong | Player overshoots or undershoots consistently | Adjust distances and gaps; check player controller physics settings |
| Player ignores NPC/ally | NPC spawn (blue) placed out of sightline | Move NPC to player's natural forward direction |
| Level feels the same throughout | All rooms are the same shape and scale | Vary ceiling height; alternate open and tight spaces to create rhythm |
| Player gets lost | No clear direction in open spaces | Add landmarks, sightlines, or environmental guides |

---

## Graybox -> Polish Handoff

When graybox testing is complete and the level is approved, provide the art/polish team with:

```
- Screenshot of the graybox from above (level map view)
- Annotated path diagram (entry -> beats -> exit)
- Colour-coded object list (which coloured objects represent what)
- Confusion audit results (what was fixed and why)
- Intensity curve sketch for the level
- Any camera requirements (forced angles, cinemachine triggers)
```

**Do not begin visual polish until:**
- All challenges complete correctly in graybox
- Confusion audit shows zero unresolved issues
- Flow has been tested by at least one fresh player
