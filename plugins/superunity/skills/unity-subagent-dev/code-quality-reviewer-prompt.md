# Unity Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent.

**Purpose:** Verify the implementation is well-built — clean, tested, maintainable, and Unity-idiomatic.

**Only dispatch after spec compliance review returns ✅ or ⚠️ (not ❌).**

```
Dispatch using the Task tool with subagent_type: general-purpose
  description: "Code quality review for Task N: [task name]"
  prompt: |
    You are reviewing the code quality of a Unity implementation.
    Spec compliance has already been verified. Your job is to assess how well it is built.

    ## What Was Implemented

    [From implementer's report — task goal, type, files changed]

    ## Plan / Requirements Reference

    Task N from [plan-file path]

    ## Git Range to Review

    **Base SHA:** [commit before task]
    **Head SHA:** [current commit]

    ```bash
    git diff --stat {BASE_SHA}..{HEAD_SHA}
    git diff {BASE_SHA}..{HEAD_SHA}
    ```

    ## Review Checklist

    **Code Quality:**
    - Clean separation of concerns? (domain logic vs Unity glue)
    - Proper null handling and defensive checks for Unity objects?
    - Naming clear and accurate — matches what things do, not how they work?
    - DRY — no copy-paste logic?
    - No magic numbers or hardcoded strings that belong in constants or ScriptableObjects?

    **Unity Architecture:**
    - MonoBehaviours thin? (orchestrate, don't compute)
    - Pure C# classes used for domain logic?
    - Composition over inheritance respected?
    - No hidden scene dependencies (GameObject.Find, static singletons without explicit approval)?
    - ScriptableObjects free of scene object references?
    - Appropriate use of interfaces for testability and decoupling?

    **Unity Lifecycle:**
    - Awake used for internal initialization only?
    - OnEnable/OnDisable used for event subscription lifecycle?
    - No reliance on script execution order unless explicitly documented?
    - All event subscriptions properly paired with unsubscriptions — no memory leaks?
    - No dangling static event references?

    **Performance:**
    - No per-frame allocations (no `new`, LINQ, or string concat in Update/FixedUpdate)?
    - No unnecessary Instantiate/Destroy — object pooling used where scale demands it?
    - No Console spam in hot paths (Debug.Log inside Update)?
    - GameObject lookups cached in Awake, not repeated per-frame?

    **Serialization:**
    - `[SerializeField]` used on private fields needing Inspector exposure?
    - Public mutable fields avoided unless intentionally part of the API?
    - `[System.Serializable]` on value types used in Inspector?
    - No scene object references stored in ScriptableObjects?

    **Testing:**
    - Tests verify behavior, not just that methods were called?
    - EditMode tests used for pure C# logic?
    - PlayMode tests used only where scene/lifecycle dependency genuinely required?
    - No test-only methods added to production classes?
    - Edge cases and null inputs covered?
    - All tests passing, no skipped tests?

    **Git Hygiene:**
    - `.meta` files committed alongside every new file and folder?
    - Commit messages clear and scoped (e.g., `feat(inventory): add AddItem with EditMode tests`)?
    - No unrelated changes bundled into task commits?

    ## Issue Severity

    - **Critical** — bugs, data loss risk, broken functionality, memory leaks, missing .meta files
    - **Important** — architectural violations, missing tests, performance problems, hidden coupling
    - **Minor** — naming, style, missing XML docs, small optimizations

    ## Output Format

    ### Strengths
    [What is well done — be specific with file:line references]

    ### Issues

    #### Critical
    [Bugs, memory leaks, broken functionality — must fix before proceeding]

    #### Important
    [Architecture violations, test gaps, performance issues, hidden coupling]

    #### Minor
    [Naming, style, documentation improvements]

    **For each issue:**
    - File:line reference
    - What is wrong
    - Why it matters in Unity context
    - How to fix

    ### Verdict

    - ✅ Approved
    - ⚠️ Approved with minor issues noted (can proceed, fix opportunistically)
    - ❌ Needs fixes before proceeding — [list Critical and Important issues]
```
