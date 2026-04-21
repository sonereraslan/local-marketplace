---
name: unity-verification
description: "This skill should be used when a user asks to verify Unity work, confirm tests pass, check that a bug is fixed, validate a build, finalize a task, or mark work as complete. Trigger phrases include 'verify this works', 'run the tests', 'is this done', 'check the build', 'confirm it compiles', 'mark this task complete', 'does it pass', 'finalize this feature'. Should NOT be used for initial exploration, writing plans, or debugging — use unity-systematic-debugging for failures discovered during verification."
---

# Verification Before Completion (Unity)

## Overview

This skill ensures all completion claims are backed by fresh verification evidence from the Unity Editor.

**Rule:** Do not claim any task is complete, fixed, or passing without fresh verification evidence from the current session. Unity compilation, test results, and Console state can change without notice — always verify fresh.

## The Gate Function

Before claiming any status:

1. **Identify** — What evidence proves this claim in Unity?
2. **Run** — Execute the full verification (fresh, complete, not cached)
3. **Read** — Full output: test count, error count, Console warnings
4. **Verify** — Does the output confirm the claim?
   - If no: state actual status with evidence
   - If yes: state claim with evidence
5. **Claim** — Only then make the claim

Complete all five steps before making any claim.

## Unity Verification Matrix

| Claim | Required Evidence | Not Sufficient |
|-------|------------------|----------------|
| Tests pass | Unity Test Runner: 0 failures (EditMode + PlayMode) | "Should pass", previous run, agent report |
| Console clean | Unity Console: 0 errors, 0 unexpected warnings | "Looks fine", no visible errors in view |
| Bug fixed | Original symptom reproduced in Play Mode: no longer occurs | Code changed, "assumed fixed" |
| Build succeeds | BuildPipeline or CLI batchmode: exit 0, 0 errors | Compilation passed, "should build" |
| Domain reload safe | Enter + exit Play Mode: Console remains clean | "I didn't touch serialization" |
| Scene/Prefab intact | Opened in Editor: no missing references, no unintended overrides | "I didn't touch the scene" |
| Regression test valid | Red→fix→Green cycle confirmed | "I wrote a test" (without seeing it fail first) |
| Subagent completed | VCS diff verified + Unity Console clean | Subagent reports "success" |
| Requirements met | Line-by-line checklist against plan + Play Mode check | "Tests pass, task complete" |
| Cross-platform safe | Tested on all active build targets | "Works in Editor" |

## Ordered Verification Steps

Run these in order before claiming any task complete.

**Step 1 — Compile**
- Unity Console shows 0 compile errors
- **Log Severity Policy:** Warnings introduced by new code are treated as errors unless explicitly justified. Do not proceed with new warnings unexplained.

**Step 2 — Test Runner**
- Run full EditMode suite: 0 failures, 0 skipped (`[Ignore]`)
- Run full PlayMode suite: 0 failures, 0 skipped
- Confirm test count matches expected (no tests silently removed)

**Step 3 — Determinism Check**
- Re-run the full test suite a second time
- Confirm identical results between runs
- Confirm no intermittent failures, no order-dependent failures
- If results differ between runs → **STOP. Investigate flakiness before claiming success.**

**Step 4 — Console Clean**
- Enter Play Mode
- Exercise the feature or scenario
- Exit Play Mode
- Console: 0 errors, 0 unexpected warnings during the session

**Step 5 — Domain Reload & Static Leak Control**
- Enter Play Mode, then exit
- Check Console for `MissingReferenceException`, `UnassignedReferenceException`, or serialization errors
- Confirm no static events remain subscribed after exiting Play Mode
- Confirm no singleton instances persist unintentionally
- Confirm no static caches retain stale scene references

**Step 6 — Serialized Field Migration**
- If any serialized field was renamed or removed:
  - Confirm `[FormerlySerializedAs]` is applied where required
  - Confirm no data loss in existing Prefabs or ScriptableObjects
  - Open affected Prefabs in the Editor and verify Inspector values are intact

**Step 7 — Scene and Prefab Integrity**
- Open modified scenes and Prefabs in the Editor
- Confirm no missing references (pink or "None (Missing)" in Inspector)
- Confirm no unintended Prefab overrides
- Confirm no unintended changes to Lighting settings
- Confirm Build Settings scene list is unchanged
- Confirm no accidental layer or tag changes

**Step 8 — Performance Sanity** *(if feature affects runtime)*
- Open Unity Profiler and enter Play Mode
- Confirm no new GC allocation spikes during feature execution
- Confirm no new per-frame allocations in `Update` / `FixedUpdate`
- Confirm no unexpected CPU spikes during normal execution
- For detailed hot path rules and profiler guidance, consult `${CLAUDE_PLUGIN_ROOT}/references/unity-performance-checklist.md`

**Step 9 — Build Verification** *(if feature affects runtime)*
- Run a development build or batchmode build
- Confirm 0 build errors
- Confirm no managed code stripping errors
- Confirm no missing Assembly Definition reference errors

**Step 10 — API Contract Check**
- Were any public method signatures changed?
- Were any public fields removed or renamed?
- Were any `UnityEvent` or C# events renamed?
- If yes: verify all consumers (other scripts, Prefabs, scene wiring) are updated

**Step 11 — Regression Surface Review**
- Identify systems that depend on the modified code
- Confirm they still behave correctly in Play Mode
- Spot-check integration points that are not covered by automated tests

**Step 12 — Requirements Checklist**
- Re-read the task spec or plan
- Verify each requirement line by line
- Report gaps explicitly — "Tests pass" is not "requirements met"

**Step 13 — Git State**
- `git status` — no uncommitted changes that belong to the task
- All `.meta` files present for new files and folders
- No debug `Debug.Log` statements in committed code

## Red Flags

Do not use success-implying language (done, fixed, passing, all good) until the verification steps above have been completed with confirming output.

- Using "should", "probably", "seems to", "looks like it works"
- Trusting a subagent's success report without independently verifying
- Running only EditMode tests and skipping PlayMode (or vice versa)
- Checking Console in Edit Mode only — not verifying after entering Play Mode
- Test results differ between two runs — flakiness, not passing
- New warnings left unexplained
- Serialized field renamed without `[FormerlySerializedAs]` check

## Common Mistakes

| Assumption | Correct Action |
|------------|----------------|
| "Should compile fine" | Run the compile and read the Console |
| "Tests were passing before my change" | Run them now — changes break things silently |
| "Tests passed once, good enough" | Run a second time — flaky tests pass sometimes |
| "Agent said it completed" | Verify VCS diff and Console independently |
| "Console is clean in Edit Mode" | Enter Play Mode — domain reload surfaces new errors |
| "I only changed one line" | One-line changes can break serialized references and event wiring |
| "I didn't rename any serialized fields" | Check if refactoring tools renamed them silently |
| "It works in Editor, no need to build" | Stripping and assembly resolution behave differently in builds |

## Quick Claim Patterns

| Claim | Valid Evidence | Not Valid |
|-------|--------------|-----------|
| "Tests pass" | Run twice, identical results: "42 pass, 0 fail" both runs | Run once and move on |
| "Console clean" | Enter Play Mode, exercise feature, exit, 0 errors | "I don't see red errors" without entering Play Mode |
| "Domain reload safe" | Enter/exit Play Mode, Console clean, no persisted statics | "I didn't touch serialization" |
| "Subagent task verified" | Git diff matches expected changes + Console clean | Trust the subagent report alone |

## Related Skills

- **superunity:unity-systematic-debugging** — If verification reveals a failure, debug before claiming anything
- **superunity:unity-tdd** — Ensures a failing test exists before fixing, so verification has something real to check
- **superunity:unity-finishing-branch** — Final verification gate before merge
