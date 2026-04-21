---
name: unity-code-review
description: "This skill should be used when the user asks to review Unity code, requests a code review, wants to check code before merging, or says 'review my changes', 'check this before merge', 'run a code review', or 'what should I look for in review'. Covers requesting review via a code-reviewer subagent, receiving and acting on review feedback, and a Unity-specific review checklist. Not for test-only verification (use unity-verification) or final branch cleanup (use unity-finishing-branch)."
---

# Code Review (Unity)

## Overview

Review early, review often. Verify before implementing.

## Part 1: Requesting Code Review

### When to Request

**Mandatory:**
- After each task in subagent-driven development (`superunity:unity-subagent-dev`)
- After completing a major feature
- Before merge to main

**Valuable but optional:**
- When stuck (fresh perspective often unblocks)
- Before refactoring (baseline understanding of current state)
- After fixing a complex bug

### How to Request

**1. Get git SHAs:**
```bash
BASE_SHA=$(git rev-parse origin/main)   # or the SHA before task started
HEAD_SHA=$(git rev-parse HEAD)
```

**2. Dispatch a code-reviewer subagent:**

Dispatch using the Task tool with subagent_type: general-purpose, using the template at `./unity-code-reviewer-prompt.md`. Read the template file and fill in all placeholders before dispatching.

**Placeholders:**
- `{WHAT_WAS_IMPLEMENTED}` — what you just built (one paragraph)
- `{PLAN_OR_REQUIREMENTS}` — plan file path or inline task spec
- `{BASE_SHA}` — commit before the task
- `{HEAD_SHA}` — current HEAD
- `{DESCRIPTION}` — brief summary (files changed, test count)

**3. Act on feedback:**
- Fix **Critical** issues immediately — do not proceed
- Fix **Important** issues before moving to the next task
- Note **Minor** issues — fix opportunistically or in a cleanup pass
- Push back with technical reasoning if feedback is wrong

### Example

```
[Completed Task 3: InventoryManager with EditMode tests]

BASE_SHA=$(git log --oneline | grep "Task 2" | awk '{print $1}')
HEAD_SHA=$(git rev-parse HEAD)

[Dispatch unity-code-reviewer subagent]
  WHAT_WAS_IMPLEMENTED: Pure C# InventoryManager with add/remove/query,
                         driven by ItemData ScriptableObject, events for UI binding
  PLAN_OR_REQUIREMENTS: Task 3 from docs/plans/2026-02-22-inventory.md
  BASE_SHA: a7981ec
  HEAD_SHA: 3df7661
  DESCRIPTION: 3 files added, 5 EditMode tests, all passing

[Subagent returns]:
  Important: ItemData ScriptableObject has a scene object reference in _defaultContainer
  Minor: InventoryManager event naming inconsistent with project conventions
  Assessment: Fix Important issue before proceeding

[Fix ScriptableObject reference — scene refs in SOs cause serialization bugs after domain reload]
[Continue to Task 4]
```

### Integration with Workflows

| Workflow | When to Review |
|----------|----------------|
| `superunity:unity-subagent-dev` | After EACH task — catch issues before they compound |
| `superunity:unity-executing-plans` | After each batch of 3–5 tasks |
| Ad-hoc development | Before merge; when stuck |

---

## Part 2: Receiving Code Review

### The Response Pattern

```
WHEN receiving code review feedback:

1. READ    — Complete feedback before reacting
2. CLARIFY — Restate each item in own words, or ask for clarification on unclear items
3. VERIFY  — Check against codebase reality (read actual code, not from memory)
4. EVALUATE — Technically sound for THIS codebase and Unity version?
5. RESPOND — Technical acknowledgment or reasoned pushback
6. IMPLEMENT — One item at a time, run tests after each
```

### Response Guidelines

Every feedback item must be acknowledged — either by a concrete action or by explicit technical reasoning for why it was not acted upon.

- Restate the technical requirement
- Ask clarifying questions if unclear
- Push back with technical reasoning if the feedback is incorrect
- Show the fix — actions over words
- Avoid performative responses ("You're absolutely right!", "Great point!") — just fix and move on

### Handling Unclear Feedback

If any feedback item is unclear — **stop. Ask before implementing anything.**

Partial understanding leads to wrong implementation. Items may be interdependent.

```
Reviewer: "Fix items 1-6"
You understand 1, 2, 3, 6. Unclear on 4, 5.

❌ Implement 1, 2, 3, 6 now — ask about 4, 5 later
✅ "Understand items 1, 2, 3, 6. Need clarification on 4 and 5 before proceeding."
```

### Verifying Feedback Before Acting

**Before implementing any suggestion:**

| Check | Question |
|-------|----------|
| Correct for this Unity version? | Does this API exist in the project's Unity version? |
| Breaks existing behavior? | Run tests — do any fail after the change? |
| Does reviewer have full context? | Do they know why the current implementation exists? |
| Conflicts with architectural decisions? | Does it violate the project's pure C# / MonoBehaviour separation? |
| YAGNI? | Is the suggested feature or abstraction actually used anywhere? |

**YAGNI check for "professional" suggestions:**
```
IF reviewer suggests "implementing properly" with extra abstraction:
  Search codebase for actual usage

  IF unused: "Nothing currently calls this. Remove it (YAGNI)?"
  IF used: Then implement properly
```

### Reviewer Blind Spot Guard

A reviewer working from a diff does not have the full architectural context of the project. A suggestion may be technically correct in isolation while being wrong for this codebase.

**If a suggestion seems correct but conflicts with established project architecture:**

1. Verify the architectural documentation (plan files, `CLAUDE.md`, design decisions)
2. Check whether the current pattern was a deliberate decision — not an oversight
3. Confirm with the user before changing any established architectural pattern

```
Reviewer: "Use a singleton for AudioManager — it's the Unity standard"
Project architecture: Dependency injection was chosen deliberately — no singletons

❌ Accept the suggestion because the reviewer seems authoritative
✅ "The project avoids singletons by design (see docs/plans/architecture.md).
   AudioManager is injected at scene root. Confirm if you want to revisit this decision."
```

Reviewers can be wrong about architectural fit. Technical correctness in the abstract does not override established project decisions. Escalate to the user — do not silently change the architecture.

### When to Push Back

Push back when the suggestion:
- Breaks existing tests or functionality
- Introduces hidden Unity coupling (e.g., `GameObject.Find`, forced singleton)
- Violates the project's architectural separation (domain logic pushed into MonoBehaviour)
- Is technically incorrect for this Unity version or render pipeline
- Adds abstraction layers for hypothetical future use (YAGNI)
- Conflicts with the user's established architectural decisions

**How to push back:**
- Use technical reasoning, not defensiveness
- Reference specific tests or code that prove the current approach is correct
- Ask specific questions that expose the reviewer's assumption

**How to correct yourself if your pushback was wrong:**
```
✅ "Verified — you're correct. My initial understanding was wrong because [reason]. Fixing."
❌ Long apology
❌ Over-explaining why you pushed back
```

### Implementation Order for Multi-Item Feedback

1. Clarify anything unclear — before touching any code
2. Fix in this order:
   - Blocking issues (broken functionality, memory leaks, `.meta` files missing)
   - Unity-specific correctness (serialization errors, lifecycle violations, event leaks)
   - Architecture violations
   - Simple cleanup (naming, style)
3. Test after each fix individually
4. Verify no other tests broke

**If feedback suggests an architectural change:**
- Run the full test suite before making the change (establish a baseline)
- Make the change
- Run the full test suite again
- Confirm no regressions in unrelated systems — architectural changes propagate in non-obvious ways in Unity (serialized references, execution order, event wiring)

---

## Unity-Specific Review Checklist

The full review checklist is defined in `./unity-code-reviewer-prompt.md` — this is the canonical source for both subagent reviews and self-review before requesting. It covers Architecture, Public API, Unity Lifecycle, Serialization, Performance, Async/Concurrency, Code Quality, Regression Risk, Testing, Scene/Prefab Safety, Git Hygiene, and Batchmode/CI.

For quick pre-review self-checks on individual files, dispatch the `unity-script-analyzer` agent.

---

## Red Flags

**When requesting:**
- Skipping review because "it's a simple change"
- Ignoring Critical issues and proceeding anyway
- Moving to the next task with unfixed Important issues

**When receiving:**
- Implementing before verifying
- Performative agreement without technical check
- Silently ignoring a feedback item without action or technical reasoning
- Accepting suggestions that introduce `GameObject.Find`, hidden singletons, or ScriptableObject scene references
- Not pushing back when the feedback violates established architecture
- Changing an established architectural pattern without confirming with the user

## Related Skills

- **superunity:unity-subagent-dev** — Review is mandatory after each subagent task
- **superunity:unity-verification** — Final check before claiming complete
- **superunity:unity-finishing-branch** — Full review before merge
