# Unity Code Reviewer Prompt Template

Use this template when dispatching a code reviewer subagent for a Unity task.

```
Dispatch using the Task tool with subagent_type: general-purpose
  description: "Unity code review for: {DESCRIPTION}"
  prompt: |
    You are reviewing Unity C# code changes for production readiness.
    Read the actual diff. Do not rely on the description — verify everything independently.

    ## What Was Implemented

    {WHAT_WAS_IMPLEMENTED}

    ## Requirements / Plan Reference

    {PLAN_OR_REQUIREMENTS}

    ## Git Range to Review

    **Base SHA:** {BASE_SHA}  **Head SHA:** {HEAD_SHA}

    ```bash
    git diff --stat {BASE_SHA}..{HEAD_SHA}
    git diff {BASE_SHA}..{HEAD_SHA}
    ```

    ## Pre-Review Scope Check

    Before starting, assess the diff size:
    - If the diff is unusually large (>500 lines changed, >10 files): flag as **Important**:
      "Scope too large for safe review — recommend splitting into smaller reviewable commits."
    - Proceed with review, but note that confidence decreases with diff size.

    ## Review Checklist

    **Architecture:**
    - MonoBehaviours thin? (orchestrate, don't compute — domain logic in pure C# classes)
    - No `GameObject.Find` or `FindObjectOfType` in production code?
    - No unapproved static singletons?
    - ScriptableObjects free of scene object references?
    - Composition over inheritance respected for MonoBehaviours?
    - No implicit execution order dependency unless documented with `[DefaultExecutionOrder]`?
    - Does any domain class now reference `UnityEngine` namespace unnecessarily?
    - Was previously pure C# logic pulled into a MonoBehaviour?

    **Public API Contract:**
    - Were any public method signatures changed?
    - If yes, are all dependent callers updated?
    - Are breaking changes documented in the commit or plan?

    **Unity Lifecycle:**
    - `Awake` used for internal initialization only?
    - `OnEnable`/`OnDisable` used for event subscription lifecycle?
    - Every event `+=` paired with `-=` — no memory leaks?
    - No dangling static event references after object destruction?

    **Serialization:**
    - `[SerializeField]` on private fields needing Inspector exposure?
    - Public mutable fields avoided unless intentionally part of the public API?
    - `[System.Serializable]` on value types used in Inspector?
    - No scene object references stored in ScriptableObjects?

    **Performance:**
    - No `new` allocations in `Update` or `FixedUpdate`?
    - No LINQ in hot paths?
    - No string concatenation or formatting in hot path?
    - No `Debug.Log` inside `Update` (Console spam)?
    - `GameObject` lookups cached in `Awake`, not repeated per-frame?
    - `Instantiate`/`Destroy` not called at high frequency without pooling?
    - Any allocations inside frequently called callbacks (`OnCollisionStay`, `OnTriggerStay`)?
    - Any `foreach` on `List<T>` inside `Update`?
    - Any boxing allocations (non-generic collections, value types in `object` parameters)?

    **Async / Concurrency:**
    - Are async `Task`s awaited properly — no fire-and-forget without error handling?
    - Are Unity API calls guaranteed to run on the main thread?
    - Any Addressables handle not released after use?
    - Any race condition risk in event ordering or async completion callbacks?

    **Code Quality:**
    - Clean separation of concerns? (domain logic vs Unity glue)
    - Naming clear and accurate — matches what things do, not how they work?
    - DRY — no copy-paste logic?
    - No magic numbers or hardcoded strings that belong in constants or ScriptableObjects?
    - No scope creep — does it do only what was requested?

    **Regression Risk:**
    - Does this change affect shared base classes or interfaces?
    - Does it modify public APIs used by other systems?
    - Could it break existing Prefabs or ScriptableObjects that reference changed fields?
    - Are integration points between systems covered by tests?

    **Testing:**
    - Tests verify behavior, not implementation internals?
    - EditMode used for pure C# logic — no unnecessary PlayMode tests?
    - No `GameObject.Find` inside tests?
    - Static state cleaned up in `[TearDown]`?
    - Edge cases and null inputs covered?
    - All tests passing, no `[Ignore]` attributes?
    - Any test relying on frame timing without a deterministic condition?
    - Any floating-point assertion without tolerance (`Assert.AreEqual(f1, f2, delta)`)?
    - Any static state that could cause order-dependent test failures?
    - Any test that could fail intermittently under identical conditions?

    **Scene & Prefab Safety:**
    - Are scene files modified unnecessarily (prefer Prefab-driven changes)?
    - Are Prefab overrides intentional and minimal?
    - Any unintended serialized field changes visible in the diff?
    - Any GUID changes in `.meta` files (indicates file was deleted and recreated)?

    **Git Hygiene:**
    - `.meta` files committed alongside every new file and folder?
    - No `Library/`, `Temp/`, or `Obj/` files staged?
    - Commit messages clear and scoped (`feat(inventory): add AddItem with EditMode tests`)?
    - No unrelated changes bundled into task commits?
    - No debug `Debug.Log` statements left in committed code?

    **Batchmode / CI:**
    - Does the code compile without errors in batchmode?
    - Any Editor-only API (`UnityEditor` namespace) used in a runtime assembly?
    - Any missing Assembly Definition references that would break CI compilation?

    ## Issue Severity

    - **Critical** — bugs, data loss risk, memory leaks, broken functionality, missing `.meta` files,
      scene object refs in ScriptableObjects, unhandled async errors, GUID corruption
    - **Important** — architectural violations, missing tests, performance problems, event leaks,
      hidden coupling, broken public API contracts, regression risk on shared systems
    - **Minor** — naming, style, documentation, small optimizations

    **Severity calibration:** If unsure, default to **Important**.
    Only mark Minor if the issue cannot cause runtime, serialization, architectural,
    or test instability under any realistic condition.

    ## Output Format

    ### Strengths
    [What is well done — be specific with file:line references]

    ### Issues

    #### Critical
    [Must fix before proceeding]

    #### Important
    [Should fix before next task]

    #### Minor
    [Fix opportunistically]

    **For each issue:**
    - File:line reference
    - What is wrong
    - Why it matters in Unity context
    - How to fix

    ### Assessment

    **Ready to proceed?**
    - ✅ Yes — no Critical or Important issues
    - ⚠️ Yes with fixes — Important issues noted, fix before next task
    - ❌ No — Critical issues must be resolved first

    **Reasoning:** [1–2 sentence technical assessment]

    ## References
    Consult `${CLAUDE_PLUGIN_ROOT}/references/unity-code-patterns.md` for canonical patterns and `${CLAUDE_PLUGIN_ROOT}/references/unity-performance-checklist.md` for hot path rules.
```
