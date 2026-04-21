# superunity

Comprehensive Unity 3D development plugin for Claude Code — exploring, planning, TDD, debugging, code review, subagent orchestration, verification, and tutorial scriptwriting.

---

## Installation

```
/plugin marketplace add sonereraslan/local-marketplace
```

Reload after edits:

```
/reload-plugins
```

---

## Usage

Skills and hooks auto-trigger based on your message or tool use. Agents are dispatched explicitly. The hub skill `using-superunity` loads at session start and routes every Unity request to the right skill or agent.

Typical flow:

1. `unity-exploring-project` — understand the task
2. `unity-writing-plans` — write a plan
3. `unity-executing-plans` (or `unity-subagent-dev`) — implement with `unity-tdd`
4. `unity-code-review` + `unity-verification` — check before claiming done
5. `unity-finishing-branch` — integrate

---

## Skills

| Skill | Purpose |
|-------|---------|
| `using-superunity` | Session-start router — picks the right skill or agent for each request |
| `unity-exploring-project` | Explore project intent, context, and design before code |
| `unity-writing-plans` | Turn a spec into a reviewable implementation plan |
| `unity-executing-plans` | Execute a plan with review checkpoints |
| `unity-subagent-dev` | Dispatch independent plan tasks to subagents |
| `unity-systematic-debugging` | Four-phase debugging process for any bug or test failure |
| `unity-tdd` | Test-first development for features and bugfixes |
| `unity-code-review` | Review changes before merge |
| `unity-verification` | Evidence-based completion check |
| `unity-finishing-branch` | Integrate the work once a branch is done |
| `unity-ecs-patterns` | Unity DOTS — ECS, Job System, Burst, baking, authoring |

---

## Agents

| Agent | Purpose |
|-------|---------|
| `unity-script-analyzer` | Quick single-file analysis for issues, anti-patterns, performance |
| `unity-error-analyzer` | Diagnose Console errors, stack traces, test failures |
| `unity-test-writer` | Generate EditMode or PlayMode tests for existing code |
| `unity-project-scanner` | Summarise project structure, packages, conventions |
| `unity-tutorial-scriptwriter` | Turn finished code or a debug journey into a YouTube tutorial script |

---

## Commands

| Command | Purpose |
|---------|---------|
| `/superunity:debug-report` | Generate a structured debugging report with project context and Phase 1 checklist |

---

## Hooks

| Hook | Event | Purpose |
|------|-------|---------|
| `session-start.sh` | SessionStart | Announces plugin powers and loads the `using-superunity` skill |
| `check-unity-gitignore.sh` | PreToolUse (Bash) | Warns before committing Unity-generated folders that should be ignored |
| `check-debug-logs.sh` | PreToolUse (Bash) | Flags stray `Debug.Log` calls before they ship |

---

## Testing

```
/agents             # list loaded agents
/reload-plugins     # reload after edits
```

Trigger a skill by phrasing a message matching its description, or invoke explicitly:

```
/superunity:unity-writing-plans
@"unity-tutorial-scriptwriter" turn the player controller we just built into a video
```

-------

# superunity-design

Genre-agnostic game design toolkit for Unity — 10 auto-triggered design skills and 5 specialist agents covering brainstorming, mechanics, levels, narrative, camera, feedback, audio, and GDD work. Supports any genre.


## Usage

Skills auto-trigger based on your message. The hub skill `unity-designer` routes ambiguous requests and establishes project context (genre, pillars, terminology). Agents are dispatched explicitly for bounded deliverables.

Typical flow:

1. `unity-designer` — set project context and pillars
2. `unity-brainstorming` → `unity-mechanics` — generate and evaluate ideas
3. `unity-level` / `unity-puzzle` / `unity-narrative` — design the scene
4. `unity-camera` → `unity-visual-feedback` → `unity-audio` — polish the feel
5. `unity-writing-gdd` — consolidate into documentation

---

## Skills

| Skill | Purpose |
|-------|---------|
| `unity-designer` | Routing hub — establishes project context and directs design questions |
| `unity-brainstorming` | Idea generation using SCAMPER, HMW, and constraint frameworks |
| `unity-mechanics` | Mechanic design, constraint checklist, game-wide evolution framework |
| `unity-puzzle` | Challenge and encounter design — authoritative per-encounter teaching model |
| `unity-narrative` | Narrative layering, emotional beats, scene proposals, delivery methods |
| `unity-level` | Level layout, pacing, beat-by-beat teaching, graybox approach |
| `unity-camera` | Cinemachine setup for any perspective — 2D, 2.5D, top-down, first/third-person |
| `unity-visual-feedback` | Visual hierarchy, juice, animation states, UI routing, game feel |
| `unity-audio` | Audio identity, volume hierarchy, adaptive music, silence as design |
| `unity-writing-gdd` | GDD initialisation, feature documents, audit, consolidation |

---

## Agents

| Agent | Purpose |
|-------|---------|
| `design-scene` | Full 8-step design pipeline for a scene or level |
| `design-review` | Audit a design against project pillars, constraints, and anti-patterns |
| `design-brief` | Compile design proposals into a structured handoff document |
| `polish-pass` | 4-discipline polish audit — visual feedback, camera, audio, pacing |
| `mechanic-test` | Mechanic evaluation returning READY / NEEDS WORK / CUT |

---

## Commands & Hooks

This plugin ships **no commands and no hooks** — it is pure skills and agents. All routing and invocation go through the `unity-designer` hub skill or explicit agent dispatch.

---

## Design Pillars

Pillars are defined per-project. `unity-designer` guides you through setting them based on your genre, tone, and goals. Example pillars:

- **Platformer** — Clarity Over Complexity, Emotion Through Restraint, Story Through Action
- **Action/RPG** — Player Agency, Risk-Reward Balance, Build Diversity
- **Horror** — Vulnerability, Atmosphere Over Action, Dread Through Anticipation

All design decisions are filtered through your pillars.

---

## Testing

```
/agents             # list loaded agents
/reload-plugins     # reload after edits
```

Trigger a skill by phrasing a message matching its description, or invoke explicitly:

```
/superunity-design:unity-writing-gdd
@"mechanic-test" evaluate a grapple hook mechanic
@"polish-pass" the river crossing level works but feels flat
```
