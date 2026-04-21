---
name: unity-exploring-project
description: "This skill should be used when the user wants to design or plan a new Unity feature, system, or behavior before writing code. Trigger phrases include 'I want to build', 'design a system for', 'let us add a feature', 'plan out', 'how should I architect', 'I need a new system', 'create a feature for'. Explores project context, clarifies requirements through dialogue, and produces an approved design document. Should NOT be used for bug fixes, code review, test writing, or executing an already-written plan."
---

# Exploring Unity Project Before Implementation

## Overview

Help turn ideas into fully formed designs through collaborative dialogue, grounded in the actual Unity project structure.

Start by understanding the current project context (folder layout, existing systems, Unity version, render pipeline), then ask questions one at a time to refine the idea. Once you understand what you're building, present the design and get user approval.

**HARD GATE:** Do NOT invoke any implementation skill, write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it. This applies to EVERY project regardless of perceived simplicity.

## Anti-Pattern: "This Is Too Simple To Need A Design"

Every project goes through this process. A health bar, a single MonoBehaviour, a ScriptableObject config — all of them. "Simple" projects are where unexamined assumptions cause the most wasted work. The design can be short (a few sentences for truly simple projects), but you MUST present it and get approval.

## Checklist

You MUST create a task for each of these items and complete them in order:

1. **Explore project context** — scan folders, packages, Unity version, render pipeline, tags, input, existing patterns
2. **Classify the feature** — determine category and coupling risks
3. **Ask clarifying questions** — one at a time, understand purpose/constraints/success criteria
4. **Propose 2-3 approaches** — with trade-offs, scale considerations, and your recommendation
5. **Present design** — in sections scaled to complexity, get user approval after each section
6. **Write design doc** — save to `<project-root>/docs/plans/YYYY-MM-DD-<topic>-design.md` and commit
7. **Transition to implementation** — invoke superunity:unity-writing-plans to create implementation plan

## Skill Invocation Flow

1. Receive user message describing a new feature, system, or behavior
2. Explore project context (scan folders, packages, Unity version)
3. Classify the feature and identify coupling risks
4. Ask clarifying questions one at a time
5. Propose 2-3 approaches with trade-offs
6. Present design in sections, get user approval after each
7. If user rejects a section, revise and re-present
8. Once fully approved, write design doc to `<project-root>/docs/plans/`
9. Invoke `superunity:unity-writing-plans` — this is the only valid next skill

## Step 1: Explore Project Context

**Before asking anything, scan the Unity project.** Dispatch the `unity-project-scanner` agent to gather project context autonomously (Unity version, packages, folder structure, patterns, test infrastructure). Use its output as the foundation for the steps below.

```
Check in this order:
1. ProjectSettings/ProjectVersion.txt        → Unity version
2. Packages/manifest.json                    → installed packages (URP/HDRP, Addressables, etc.)
3. ProjectSettings/TagManager.asset          → custom tags and layers in use
4. ProjectSettings/InputManager.asset        → input axes and bindings (old input system)
5. Assets/ top-level folder structure        → project conventions
6. Assets/Scripts/ or Assets/_Scripts/       → code organization pattern
7. Assets/Prefabs/ or similar                → prefab conventions
8. Assets/Scenes/                            → scene structure
9. Assembly definitions (.asmdef files)      → code boundary definitions
10. Tests/ or Assets/Tests/                  → existing test infrastructure
11. Recent git commits (if git repo)         → what's been worked on
12. Any existing CLAUDE.md or README         → project docs
```

**If the project folder is NOT accessible:**

Ask the user to describe the following explicitly before proceeding:

1. **Unity version** (e.g., 2022.3 LTS, 6000.x)
2. **Render pipeline** (Built-in, URP, HDRP)
3. **Input system** (old InputManager, new Input System package, or both)
4. **Folder conventions** (how Assets/ is organized)
5. **Current architecture pattern** (MonoBehaviour-heavy, ScriptableObject-driven, ECS/DOTS, MVC, etc.)

Do NOT proceed with design until you have this context — either from scanning or from the user.

**Unity-specific context to identify:**

| Context | Why It Matters |
|---------|---------------|
| Unity version | API availability, feature support |
| Render pipeline (URP/HDRP/Built-in) | Shader/material approach |
| Input system (old vs new) | Input handling pattern |
| Tags and layers (TagManager) | Collision matrix, object categorization |
| Input axes (InputManager) | Existing input bindings to respect |
| Existing architecture pattern | MonoBehaviour-heavy? ScriptableObject-driven? ECS? |
| Assembly definitions (.asmdef) | Code organization boundaries |
| Test folders (EditMode/PlayMode) | Testing infrastructure exists? |
| Addressables vs Resources | Asset loading strategy |

## Step 2: Classify the Feature

**Before diving into questions, classify what is being built:**

Classify the feature as one of:

| Category | Examples |
|----------|----------|
| **Core Gameplay** | Player controller, combat system, inventory, AI behavior |
| **Meta System** | Progression, matchmaking, leaderboards, analytics |
| **UI** | HUD, menus, popups, settings screens |
| **Technical Infrastructure** | Save system, networking layer, asset pipeline, object pooling |
| **Tooling** | Editor tools, debug utilities, level editor, data importers |

**Tooling note:** If the feature involves a node-based visual editor (dialogue trees, state machines, quest editors, ability systems), consider Unity Graph Toolkit (GTK). Consult `${CLAUDE_PLUGIN_ROOT}/references/gtk-architecture-patterns.md` for architecture patterns and execution models.

**Why classify?** Each category has different coupling patterns, testing strategies, and lifecycle concerns. A UI feature should not depend on core gameplay internals. A meta system should not reach into technical infrastructure directly.

**Identify Coupling Risks:**

After classification, explicitly identify potential tight coupling risks:

- What other systems does this feature need to talk to?
- Can those dependencies be abstracted behind interfaces or events?
- Are there hidden dependencies through singletons, static state, or shared ScriptableObjects?
- Will this feature force changes in unrelated systems?

State the coupling risks and how to avoid them before proceeding.

## Step 3: Ask Clarifying Questions

**One question at a time.** Prefer multiple choice when possible.

**Player & outcome questions (ask these first):**

- What problem does this solve for the player?
- What is the player-facing outcome?
- How will you know this feature is successful? (metrics, feel, user feedback)

**Unity-specific questions to consider:**

- Is this a runtime feature or Editor tool?
- Should this work in both Editor and builds?
- Does this need to survive scene loads (DontDestroyOnLoad)?
- Single instance (singleton/service) or many instances (component)?
- Data-driven (ScriptableObject) or hardcoded?
- Does this interact with physics? Animation? UI?
- Performance-critical (Update loop) or event-driven?
- Multiplayer considerations?

## Step 4: Propose Approaches

**Always propose 2-3 approaches with trade-offs.**

### Scale & Future-Proofing

**Determine the project scale first — it changes everything:**

| Scale | Characteristics | Design Implications |
|-------|----------------|---------------------|
| **Small Prototype** | Quick iteration, throwaway code OK | Minimal abstraction, direct references, fast to build |
| **Mid Project** | Growing team/scope, needs maintainability | Interfaces, events, clear boundaries, some abstraction |
| **Live Service** | Long-lived, frequent updates, multiple developers | Full decoupling, service locator/DI, feature flags, backwards compatibility |

### Explicit Considerations

**For every approach, address these explicitly:**

| Concern | What to State |
|---------|--------------|
| **Concurrency / Async** | Does this need async operations? UniTask vs Coroutines vs async/await? Threading concerns? |
| **Save System Strategy** | Does this produce data that needs saving? How does it integrate with existing save system (PlayerPrefs, JSON, binary, cloud)? |
| **Build Target** | Does behavior differ across platforms (mobile vs PC vs console)? Memory/performance constraints? Input differences? |

### Common Unity Architecture Decisions

| Decision | Option A | Option B | Option C |
|----------|----------|----------|----------|
| Data storage | ScriptableObject | JSON/PlayerPrefs | Static class |
| Communication | Events/UnityEvent | Direct reference | ScriptableObject channel |
| Lifecycle | MonoBehaviour | Plain C# class + manager | Static utility |
| UI binding | Direct reference | Event-driven | Data binding framework |
| Object creation | Instantiate prefab | Object pooling | Addressables |
| Async pattern | Coroutines | UniTask | C# async/await |

**Lead with your recommended option and explain why.**

## Step 5: Present the Design

Once you understand what you're building, present the design:

- Scale each section to its complexity
- Ask after each section whether it looks right
- Be ready to go back and clarify

**Design sections to cover:**

1. **Classification** — category, coupling risks identified, mitigation strategy
2. **Architecture** — which pattern, why, how components connect
3. **Folder structure** — where new files go, following project conventions
4. **Component design** — MonoBehaviours, ScriptableObjects, plain C# classes
5. **Data flow** — how data moves between components
6. **Scene setup** — what goes in the scene hierarchy, prefab structure
7. **Error handling** — null checks, missing references, edge cases
8. **Testing strategy:**
   - **EditMode tests** for pure logic (no MonoBehaviour dependency)
   - **PlayMode tests** for integration and scene-dependent behavior
   - **Can core logic be extracted to pure C# classes for testability?** If yes, do it. Testable logic should NOT live inside MonoBehaviours.
9. **Scale & platform notes** — concurrency, save integration, build target concerns

## When Exploration Is Blocked

These are the only valid blockers. Handle each explicitly — do not abandon the process.

**Design can't converge after multiple clarifying rounds:**
- Summarize the specific contradiction or open decision in one sentence
- Identify the single question that unblocks progress
- Ask it directly — do not ask multiple questions at once
- If the user still can't decide: propose the simplest approach, state the assumption explicitly, and proceed with that assumption documented in the design

**User can't choose between proposed approaches:**
- Remove approaches that don't fit the project scale
- Recommend one explicitly with a clear reason
- Ask for confirmation on that recommendation only

**Design reveals a hard constraint not known before:**
(e.g., Unity version missing a required API, package not available, render pipeline incompatible)
- Stop immediately — do not work around it silently
- State the constraint and its impact
- Ask the user how they want to resolve it before continuing

**Scope is much larger than expected:**
- Do not expand the design to cover everything
- Scope down: define what is in and what is explicitly out
- Document the out-of-scope items for later

**Red flags — STOP:**
- You've asked the same question twice in different forms → the user doesn't know the answer, make the decision for them and document it
- You're designing for hypothetical future requirements → apply YAGNI, cut the scope
- The design keeps growing with each question → you're not deciding, you're collecting. Propose a design now.

## After the Design

**Documentation:**
- Write the validated design to `<project-root>/docs/plans/YYYY-MM-DD-<topic>-design.md`
- Commit the design document to git

**Implementation:**
- Invoke superunity:unity-writing-plans to create a detailed implementation plan
- Do NOT invoke any other skill. unity-writing-plans is the next step.

## Key Principles

- **One question at a time** — Don't overwhelm with multiple questions
- **Multiple choice preferred** — Easier to answer than open-ended
- **YAGNI ruthlessly** — Design for extension, not for prediction. Remove features you don't need today. If it's not in the requirements, it's not in the design.
- **Composition over inheritance** — Prefer small, focused components
- **Explore alternatives** — Always propose 2-3 approaches before settling
- **Incremental validation** — Present design sections, get approval before moving on
- **Respect existing patterns** — Match the project's conventions, don't introduce new ones without reason
- **Testability drives architecture** — If you can't test it, redesign it. Extract logic into pure C# classes.
- **Name the coupling** — Every dependency should be visible and intentional. Hidden coupling is a design bug.
