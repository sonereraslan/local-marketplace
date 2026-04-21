---
name: unity-subagent-dev
description: "This skill should be used when the user wants to execute an implementation plan by dispatching independent tasks to subagents, with spec compliance and code quality reviews after each task. Relevant when the user says 'execute my plan with subagents', 'implement these tasks one at a time', 'run my plan in this session', 'dispatch tasks from my plan', or 'implement plan with reviews'. Each task gets a fresh subagent context and two-stage Unity-aware review."
---

# Subagent-Driven Development (Unity)

Execute plan by dispatching a fresh subagent per task, with two-stage review after each: spec compliance first, then Unity code quality.

**Core principle:** Fresh subagent per task + two-stage review (spec then quality) = high quality, fast iteration.

**Senior Unity principles enforced:**
- Architecture consistency over local optimization
- Composition over inheritance (especially for MonoBehaviours)
- Isolate pure C# domain logic from Unity-specific glue code
- Minimize hidden coupling (no implicit scene dependencies)
- Validate runtime behavior, not just compilation
- Avoid premature abstraction, but always leave extension points

## When to Use

- Have an implementation plan with mostly independent tasks
- Want to stay in this session (vs. parallel session with `unity-executing-plans`)
- Want fresh subagent per task (no context pollution) with two-stage review

## The Process

1. Read plan, extract tasks, restate architectural intent, create task list
2. For each task:
   a. Dispatch implementer subagent (read and fill `./implementer-prompt.md`)
   b. If implementer asks questions, answer them, then re-dispatch
   c. Implementer implements, tests, stages files, self-reviews
   d. Dispatch spec reviewer (read and fill `./spec-reviewer-prompt.md`)
   e. If not spec compliant, implementer fixes gaps, re-review
   f. Dispatch code quality reviewer (read and fill `./code-quality-reviewer-prompt.md`)
   g. If not quality approved, implementer fixes issues, re-review
   h. Mark task complete
3. After all tasks: dispatch final reviewer for entire implementation
4. Invoke `superunity:unity-finishing-branch`

## Prompt Templates

Before dispatching any subagent, read the corresponding prompt template file and fill in all bracketed placeholders with actual task content.

- `./implementer-prompt.md` — Dispatch implementer subagent
- `./spec-reviewer-prompt.md` — Dispatch spec compliance reviewer subagent
- `./code-quality-reviewer-prompt.md` — Dispatch code quality reviewer subagent

## Implementer Subagent Requirements

For every dispatched implementer subagent, enforce the following structure:

### Before Implementation

The implementer must explicitly state:
1. **Task goal in one sentence** — what will exist after this task that didn't before
2. **Task type classification:**
   - Domain logic (pure C# — no MonoBehaviour, no Unity API)
   - MonoBehaviour / Component (Unity lifecycle, scene wiring)
   - UI (Canvas, TextMeshPro, event bindings)
   - Tooling (Editor script, custom inspector, ScriptableObject wizard)
3. **Test strategy confirmation:**
   - EditMode if domain logic or ScriptableObject
   - PlayMode if scene-dependent, lifecycle-dependent, or physics-dependent
   - Manual Editor validation if UI/visual tuning

### During Implementation

The implementer must:
- Keep Unity glue (MonoBehaviour, Unity events, scene refs) separate from pure C# domain logic
- Avoid hidden scene dependencies (no `GameObject.Find`, no implicit singleton access unless architecturally approved)
- Avoid static state unless the plan explicitly requires it
- Add `[SerializeField]` only to fields that need Inspector exposure — not as a habit

### Self-Review Checklist (required before reporting)

The implementer must explicitly confirm every item in the self-review checklist defined in `./implementer-prompt.md` before handing off. This covers both spec compliance (nothing missing, no extras, no premature abstraction) and Unity quality (SRP, coupling, allocations, serialization, .meta files, tests, console).

## Example Workflow

```
You: Using unity-subagent-dev to execute this plan.

[Read plan: docs/plans/2026-02-22-inventory-system.md]
[Extract all 4 tasks with full text and context]
[Restate architectural intent: "Pure C# InventoryManager, driven by ScriptableObject items,
 bound to UI via events — no direct MonoBehaviour dependencies in domain layer."]
[Create task list]

Task 1: InventoryManager (pure C# logic)

[Dispatch implementer subagent with full task text + Unity context]

Implementer: "Should ItemData be a ScriptableObject or a plain class?"

You: "ScriptableObject — needs Inspector assignability."

Implementer before work:
  Goal: "Create an InventoryManager that adds/removes items and raises events."
  Type: Domain logic (pure C#)
  Tests: EditMode

Implementer after work:
  - Created ItemData ScriptableObject
  - Created InventoryManager pure C# class
  - Wrote 3 EditMode tests, 3/3 passing
  - Staged with .meta files (commit at end of feature, not per task)
  Self-review confirmed:
  Spec: ✅ Nothing missing, ✅ No extras, ✅ No premature abstraction
  Unity: ✅ SRP, ✅ No coupling, ✅ No allocations, ✅ Serialization correct,
         ✅ No unintended instantiation, ✅ Event subscriptions paired, ✅ .meta included, ✅ Console clean

[Dispatch spec reviewer]
Spec reviewer: ✅ Spec compliant

[Dispatch code quality reviewer]
Code reviewer: Approved. Minor: Add XML doc to public API.

[Mark Task 1 complete]
```

## Red Flags

**Never:**
- Start implementation on main/master — always confirm feature branch first
- Skip reviews (spec compliance OR code quality)
- Proceed to code quality review before spec is ✅
- Dispatch multiple implementer subagents in parallel (file conflicts)
- Make subagent read plan file — provide full task text instead
- Skip scene-setting context or architectural intent
- Ignore subagent questions — answer before letting them proceed
- Accept "close enough" on spec compliance
- Let implementer self-review replace actual review
- Move to next task while either review has open issues

**If subagent asks questions:**
- Answer clearly, include Unity-specific context (project structure, existing patterns, Unity version)
- Don't rush them into implementation

**If reviewer finds issues:**
- Same implementer subagent fixes them
- Reviewer re-reviews — don't skip the loop
- Don't move on until both reviews are ✅

**If subagent fails task:**
- Use `superunity:unity-systematic-debugging` to identify root cause before dispatching again
- Dispatch a new fix subagent with specific, targeted instructions based on the debugging findings
- Don't try to fix manually — context pollution degrades quality

## Integration

**Required workflow skills:**
- **superunity:unity-writing-plans** — Creates the plan this skill executes
- **superunity:unity-finishing-branch** — Complete development after all tasks

**Subagents should use:**
- **superunity:unity-tdd** — Test-first implementation for each task

**Alternative workflow:**
- **superunity:unity-executing-plans** — Use for parallel session instead
