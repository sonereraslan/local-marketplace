---
name: unity-systematic-debugging
description: "This skill provides a systematic four-phase debugging process for Unity projects. It should be used when the user encounters a Unity bug, NullReferenceException, test failure, unexpected runtime behavior, compile error, build failure, or performance problem. Trigger phrases include 'debug this', 'fix this error', 'why is this null', 'test is failing', 'getting an exception', 'not working as expected', 'investigate this bug'. This skill should be activated BEFORE proposing any fix. Should NOT be used for writing new features, creating tests from scratch (use unity-tdd), or code review (use unity-code-review)."
---

# Systematic Debugging (Unity)

## Overview

Random fixes waste time and create new bugs. Quick patches mask underlying issues. Unity has specific failure modes that require a disciplined approach: null references from destroyed objects, execution order dependencies, serialization gaps, coroutine timing, and physics callback ordering.

**Core principle:** Identify the root cause before attempting fixes. Symptom-level fixes create regressions.

**Rule:** Complete Phase 1 (root cause investigation) before proposing any fix.

**Especially important when:**
- Under time pressure (emergencies make guessing tempting)
- "Just one quick fix" seems obvious
- Multiple fixes have already been tried
- The issue is not fully understood

## The Four Phases

Complete each phase before proceeding to the next.

### Phase 1: Root Cause Investigation

**Complete this phase before attempting any fix.** Dispatch the `unity-error-analyzer` agent to assist with initial error analysis if a stack trace or Console output is available.

#### 1. Read the Unity Console Completely

- Read the full stack trace — don't stop at the first line
- Note the exact exception type, file, and line number
- Check for warnings above the error — they often reveal the real cause
- Look for `[ExecuteInEditMode]` vs runtime context clues
- Common Unity error patterns to recognize immediately:

| Error | Likely Root Cause |
|-------|-------------------|
| `NullReferenceException` in `Start`/`Awake` | Missing Inspector reference or wrong initialization order |
| `NullReferenceException` after scene change | Object destroyed, reference not cleared |
| `MissingReferenceException` | Reference to a destroyed object still held |
| `UnassignedReferenceException` | `[SerializeField]` field left null in Inspector |
| `SerializationException` | Data class not marked `[System.Serializable]` |
| Test fails in EditMode but passes in PlayMode | Hidden `MonoBehaviour`/`Application` dependency in logic |
| Test fails in PlayMode intermittently | Coroutine timing, frame ordering, or physics step assumption |
| Domain reload breaks references | Static state not reset, or `[InitializeOnLoad]` ordering issue |

#### 2. Reproduce Consistently

- Can you trigger it reliably?
- Is it **always**, **sometimes**, or **only in build**?
- Does it depend on scene load order, frame timing, or specific input?
- If not reproducible → add diagnostic logging, don't guess

#### 3. Check Recent Changes

- `git diff` — what changed that could cause this?
- New package version, Unity upgrade, or render pipeline change?
- Was a ScriptableObject or Prefab modified?
- Was a scene saved with unintended overrides?

#### 4. Gather Evidence Across Unity Layers

**Unity systems have multiple layers — identify which layer is failing BEFORE fixing:**

```
For each system boundary, add temporary Debug.Log:

Layer 1: Data / Config
  Debug.Log($"[DEBUG] Config loaded: {config != null}, value: {config?.someField}");

Layer 2: MonoBehaviour lifecycle
  void Awake() { Debug.Log($"[DEBUG] Awake — {gameObject.name}, scene: {gameObject.scene.name}"); }
  void OnEnable() { Debug.Log($"[DEBUG] OnEnable — {gameObject.name}"); }

Layer 3: Event / Signal
  Debug.Log($"[DEBUG] Event fired: {eventName}, listener count: {onEvent?.GetInvocationList().Length}");

Layer 4: Runtime effect
  Debug.Log($"[DEBUG] Effect applied: expected {expected}, got {actual}");

Layer 5: Frame & Execution Order
  Debug.Log($"[DEBUG] Frame: {Time.frameCount}, fixedTime: {Time.fixedTime}");
  // Log in Awake, OnEnable, and Start to capture the initialization sequence
```

Run once to identify WHERE it breaks — then investigate only that layer.

**Remove all `[DEBUG]` logs before committing the fix.**

#### 5. Capture Runtime State Snapshot

Before forming hypotheses, capture a snapshot of critical runtime state:

- Active scene name (`SceneManager.GetActiveScene().name`)
- Loaded additive scenes (`SceneManager.GetAllScenes()`)
- `Time.timeScale`
- `Application.isPlaying`
- Object instance IDs involved
- Relevant static field values
- Event subscription counts (`event?.GetInvocationList().Length`)

Bugs often hide in invisible global or static state. Capture it explicitly before assuming the cause.

#### 6. Unity-Specific Diagnostic Checks

Run these checks systematically before forming a hypothesis:

| Check | How |
|-------|-----|
| Is the object destroyed before access? | Log `gameObject != null` at the point of use |
| Is the reference assigned in Inspector? | Check Prefab and scene file — not just the script |
| Is Awake/Start ordering assumed? | Check if fix requires `[DefaultExecutionOrder]` |
| Is this a coroutine timing issue? | Log frame numbers with `Time.frameCount` |
| Is the ScriptableObject stale after domain reload? | Check if it implements `OnEnable` for re-initialization |
| Is the issue only in builds? | Check `#if UNITY_EDITOR` guards, strip debugging |
| Is physics involved? | Confirm collision layers/matrix in `ProjectSettings/Physics` |
| Is this a threading issue? | Unity API must be called from main thread only |
| Is static state leaking between tests or scenes? | Check all `static` fields — reset in `[SetUp]` or `OnEnable` |
| Is domain reload disabled (Enter Play Mode settings)? | Check `ProjectSettings/EditorSettings` — static state won't reset if disabled |
| Is Script Execution Order set unexpectedly? | Check `ProjectSettings/Script Execution Order` for hidden ordering |
| Is Addressables or async loading involved? | Log async completion callbacks — Awake/Start may run before asset is ready |

### Phase 2: Pattern Analysis

**Find the pattern before fixing:**

1. **Find working examples in the same project** — what similar code works?
2. **Compare against working code** — list every difference, however small
3. **Check Unity docs for lifecycle guarantees** — don't assume execution order
4. **Understand Unity version constraints** — API may behave differently across versions
5. **Analyze Scene vs Prefab context:**
   - Does the bug occur in a Prefab edited in Prefab Mode, or only when placed in a scene?
   - Are Prefab overrides in the scene masking or exposing a Prefab-level bug?
   - Are Prefab Variants involved — could a base Prefab value be inherited unexpectedly?
   - Does the object behave differently as a Prefab instance vs a scene-native object?

### Phase 3: Hypothesis and Testing

**Scientific method:**

1. **Define the failure boundary**
   - What is the exact line where behavior diverges from expected?
   - What was the last state where everything was correct?
   - What is the smallest input or action that reproduces the failure?
   - Define the boundary before naming the cause — vague boundaries produce vague hypotheses.

2. **Form a single hypothesis**
   - "I think X is the root cause because Y"
   - Be specific: name the object, the lifecycle event, the frame, the value
   - Don't say "timing issue" — say "AudioManager.Play() is called before AudioSource component is initialized in Awake"

3. **Test minimally**
   - Make the SMALLEST possible change to test the hypothesis
   - One variable at a time — don't fix multiple things at once
   - Add a single `Debug.Log` to confirm the assumption before changing code

4. **Verify before continuing**
   - Did it work? Yes → Phase 4
   - Didn't work? Form NEW hypothesis
   - Do NOT add more fixes on top of an unverified fix

5. **When you don't know**
   - Say "I don't understand X"
   - Don't pretend to know
   - Ask — or add more diagnostic logging to gather evidence

### Phase 4: Implementation

**Fix the root cause, not the symptom:**

1. **Create a failing test case first**
   - If logic is pure C#: write an EditMode test that reproduces the failure
   - If scene-dependent: write a PlayMode test or a minimal reproduction scene
   - Use `superunity:unity-tdd` for the failing test approach
   - MUST have a reproducible failure before fixing. If you cannot reproduce the failure, do NOT attempt a fix. Return to Phase 1.

2. **Implement a single fix**
   - Address the root cause identified in Phase 1
   - ONE change at a time
   - No "while I'm here" improvements
   - No bundled refactoring

3. **Verify the fix**
   - Test passes?
   - No other tests broken?
   - Console clean — no new warnings?
   - Behavior correct in Play Mode?

4. **If fix doesn't work — 2-attempt limit**
   - STOP after 2 failed attempts
   - Return to Phase 1 with new information from the failed attempts
   - **After 3+ failures: question the architecture** (see below)
   - Do NOT attempt Fix #4 without stopping to reassess

5. **If 3+ fixes failed: question the architecture**

   Pattern indicating architectural problem:
   - Each fix reveals new coupling or shared state problem elsewhere
   - Fixes require touching many unrelated files
   - Each fix creates new symptoms in a different system

   STOP and identify:
   - Which design principle is violated? (SRP — class does too much; DIP — depends on concrete; hidden coupling — implicit shared state)
   - Which specific class is responsible for the violation?
   - What is the dependency chain that makes a targeted fix impossible?

   Do NOT proceed with tactical fixes when a systemic issue is identified. Discuss with user before attempting more fixes.

## Red Flags

Any of these patterns indicate incomplete investigation. Return to Phase 1 before continuing.

| Impulse | Correct Action |
|---------|----------------|
| "Add a delay / `yield return null` to fix timing" | Find the actual frame or lifecycle dependency |
| "Wrap it in a null check so it doesn't throw" | Find why the reference is null |
| "Use `FindObjectOfType` to get the reference" | Fix the injection or serialized reference |
| "Change the script execution order" | Fix the initialization dependency |
| "Add `DontDestroyOnLoad` to keep it alive" | Fix the lifetime design |
| "Make it static so it's accessible everywhere" | Fix the dependency injection |
| "Works in Editor, must be a build stripping issue" | Verify first — don't assume |
| "Only breaks after scene reload — ignore for now" | That's a real bug. Investigate. |
| "Disable domain reload to stop the error" | Fix the underlying state reset issue |
| "Issue is simple, don't need process" | Simple bugs have root causes. Process is fast for simple bugs. |
| "Emergency, no time for process" | Systematic debugging is faster than thrashing |
| "One more fix attempt" (after 2+ failures) | 3+ failures indicate an architectural problem. Stop and reassess. |

## Quick Reference

| Phase | Key Activities | Success Criteria | Stop Condition |
|-------|---------------|------------------|----------------|
| **1. Root Cause** | Read Console, reproduce, check changes, gather Unity layer evidence, snapshot runtime state | Understand WHAT and WHY | Guessing fixes without evidence |
| **2. Pattern** | Find working examples, compare lifecycle and dependencies, analyze Scene vs Prefab context | Identify the difference | Blaming Unity behavior without verification |
| **3. Hypothesis** | Define failure boundary, form specific theory, test minimally with one Debug.Log | Confirmed or new hypothesis | Testing multiple simultaneous changes |
| **4. Implementation** | Create failing test, single fix, verify tests + Play Mode | Bug resolved, tests pass, Console clean | Recurring bug after fix — re-enter Phase 1 |

## Related Skills

- **superunity:unity-tdd** — Create the failing test case in Phase 4
- **superunity:unity-verification** — Verify the fix is complete before claiming done
- **unity-error-analyzer agent** — Dispatch in Phase 1 to autonomously analyze Console errors, stack traces, and log output
