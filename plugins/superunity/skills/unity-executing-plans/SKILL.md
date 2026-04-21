---
name: unity-executing-plans
description: "This skill should be used when the user asks to execute, implement, or follow a Unity implementation plan. Common triggers include 'execute the plan', 'implement the plan', 'start building from the plan', 'run the tasks in the plan', or 'follow the plan step by step'. Handles batch execution of plan tasks with compilation verification, review checkpoints between batches, and blocker escalation. Use this after a plan has been written with unity-writing-plans."
---

# Executing Unity Plans

## Overview

Load plan, review critically, execute tasks in batches, report for review between batches. Unity projects have compile cycles and Editor reloads — account for these in pacing. Ensure all modified Assets (Scenes, Prefabs, ScriptableObjects) are explicitly saved to disk before reporting.

**Core principle:** Batch execution with checkpoints for architect review. Verify compilation after every logical code unit.

**Announce at start:** "Using the unity-executing-plans skill to implement this plan."

## Execution Flow

1. Confirm a dedicated feature branch exists (never execute on main/master)
2. Load and review plan — raise concerns if any
3. If concerns, discuss with user before proceeding
4. Execute batch (3-5 tasks depending on complexity)
5. Verify compilation + run tests
6. Report results to user
7. Wait for user feedback — apply changes if needed
8. If more tasks remain, repeat from step 4
9. When all tasks complete, invoke `superunity:unity-finishing-branch`

### Step 1: Load and Review Plan

1. **Prerequisite:** Confirm a dedicated feature branch exists. If on main/master, stop and create or switch to a feature branch before proceeding.
2. Read plan file from `docs/plans/`
3. Review critically — identify questions or concerns:
   - Are file paths valid for this project's structure?
   - Do referenced packages exist in `Packages/manifest.json`?
   - Are assembly definitions set up for test folders?
   - Does the plan match the project's existing patterns?
4. If concerns: Raise them with user before starting
5. If no concerns: Create task list and proceed

### Step 2: Execute Batch

**Default: 3-5 tasks depending on complexity**

For each task:
1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. After a logical code unit is completed (not necessarily every single line change), wait for Unity to recompile and verify no errors
4. Run verifications as specified (EditMode/PlayMode tests)
5. Stage files as you go — confirm `.meta` files are included in staged changes. Do NOT commit per task; commit once when the feature is complete.
6. If the feature affects runtime systems (Update loops, physics, spawning, UI refresh), briefly validate in Play Mode and check:
   - No excessive GC allocations
   - No unexpected spikes in Profiler
   - No error spam in Console during runtime
7. If Prefabs or Scenes were modified:
   - Confirm no unintended overrides
   - Ensure scene is saved intentionally
   - Verify no missing serialized references
8. Mark as completed

**Unity compile check between logical units:**
```
After completing a logical code unit:
  - Wait for Unity to recompile (watch console)
  - If compile errors: FIX BEFORE CONTINUING
  - Do NOT proceed to next step with red errors in Console
```

### Step 3: Report

When batch complete, report:

```markdown
## Batch N Complete

**Tasks completed:** [list]

**Compilation:**
- Errors: 0 (required to proceed)
- Warnings: [list]
- New warnings introduced in this batch: [yes/no — if yes, justify]

**Tests:**
- EditMode: X/X passing
- PlayMode: X/X passing (if applicable)

**Runtime validation:** [Clean / Issues found — describe]

**Files changed:** [list with paths]

**Staged files:** [list of files staged for the feature commit]

Ready for feedback.
```

### Step 4: Continue

Based on feedback:
- Apply changes if needed
- Execute next batch
- Repeat until complete

### Step 5: Complete Development

After all tasks complete and verified:
- Run full test suite (EditMode + PlayMode)
- Confirm no skipped tests
- If CI pipeline exists, ensure branch passes CI before invoking finishing skill
- Announce: "I'm using the unity-finishing-branch skill to complete this work."
- **REQUIRED SUB-SKILL:** Use superunity:unity-finishing-branch
- Follow that skill to verify tests, present options, execute choice

## Unity-Specific Blockers

**STOP executing immediately when:**

| Blocker | Action |
|---------|--------|
| Compile error after code change | Fix before continuing. If the fix takes more than 2 attempts, revert to the last working commit and use `superunity:unity-systematic-debugging` to find root cause before retrying. |
| Missing package dependency | Stop. Ask user to install via Package Manager. |
| Missing assembly definition | Create `.asmdef` before writing tests. |
| Scene merge conflict | Stop. Do NOT resolve automatically — ask user. |
| Missing prefab/asset reference | Stop. Reference may need manual wiring in Inspector. |
| Test fails unexpectedly | Use `superunity:unity-systematic-debugging`. Do NOT comment out tests or guess at fixes. |
| Plan references wrong file paths | Stop. Ask user to clarify project structure. |
| Unity version API mismatch | Stop. Plan may need updating for this Unity version. |
| Large-scale refactor required beyond current task scope | Stop. Revisit plan and confirm architectural change with user. |

**Ask for clarification rather than guessing. Never force through blockers.**

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- User updates the plan based on your feedback
- Fundamental approach needs rethinking
- Implementation reveals inconsistencies in the plan — pause and propose a minimal plan update before continuing

## Execution Checklist

- [ ] Dedicated feature branch confirmed (not main/master)
- [ ] Plan reviewed critically before starting
- [ ] Compilation verified after every logical code unit — red Console = full stop
- [ ] `.meta` files included in staged changes
- [ ] All modified Assets saved to disk before reporting (Scenes, Prefabs, ScriptableObjects)
- [ ] Verifications not skipped (tests, Inspector checks, runtime validation)
- [ ] Between batches: report and wait for feedback
- [ ] When blocked: stop and ask, never guess

## Integration

**Required workflow skills:**
- **superunity:unity-writing-plans** — Creates the plan this skill executes
- **superunity:unity-finishing-branch** — Complete development after all tasks
- **superunity:unity-verification** — Verify before claiming completion

**Subagents should use:**
- **superunity:unity-tdd** — For test-first implementation of each task
