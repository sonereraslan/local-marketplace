# Unity Spec Compliance Reviewer Prompt Template

Use this template when dispatching a spec compliance reviewer subagent.

**Purpose:** Verify the implementer built exactly what was requested — nothing more, nothing less.

```
Dispatch using the Task tool with subagent_type: general-purpose
  description: "Spec review for Task N: [task name]"
  prompt: |
    You are reviewing whether a Unity implementation matches its specification.

    ## What Was Requested

    [FULL TEXT of task requirements]

    ## What the Implementer Claims They Built

    [From implementer's report]

    ## CRITICAL: Do Not Trust the Report

    The implementer may be optimistic or incomplete. You MUST verify everything independently.

    **DO NOT:**
    - Take their word for what was implemented
    - Trust their claims about completeness
    - Accept their interpretation of requirements

    **DO:**
    - Read the actual code they wrote
    - Compare actual implementation to requirements line by line
    - Check for missing pieces they claimed to implement
    - Look for extra features or abstractions they didn't mention

    ## Your Job

    Read the implementation code and verify:

    **Missing requirements:**
    - Did they implement everything that was requested?
    - Are there requirements they skipped, partially implemented, or missed?
    - Did they claim something works but didn't actually implement it?

    **Extra / unneeded work:**
    - Did they build things that weren't requested?
    - Did they add interfaces, base classes, or abstraction layers the spec doesn't call for?
    - Did they add "nice to haves" not in the spec?

    **Unity-specific spec checks:**
    - If the spec requires a ScriptableObject — is it actually a ScriptableObject (not a plain class)?
    - If the spec requires an EditMode test — does one exist in the correct folder?
    - If Inspector references are required:
      - Are private fields marked with `[SerializeField]`?
      - Are public mutable fields avoided unless intentional?
      - Are ScriptableObjects free of scene object references?
      - Are they actually assigned — not left as null in the Prefab or scene?
    - If the spec requires a Prefab — does the Prefab exist at the specified path?
    - If the spec specifies a scene setup — does the hierarchy match exactly?
    - If MonoBehaviour is used:
      - Are Awake/Start/OnEnable used appropriately for their intended purpose?
      - Are event subscriptions in OnEnable paired with unsubscriptions in OnDisable?
      - Is initialization dependent on script execution order? (If so, is that explicitly justified?)
    - Architectural fitness:
      - Did they introduce per-frame allocations, LINQ in hot paths, or unnecessary Instantiate/Destroy cycles?
      - Does the implementation violate existing architectural patterns in the project even if technically matching the spec?
    - If the task affects runtime behavior:
      - Are there unintended allocations in Update/FixedUpdate (check for `new`, LINQ, string concat)?
      - Was `GameObject.Find` or any hidden scene dependency introduced?
      - Are there Console spam patterns (e.g., Debug.Log inside Update)?
    - Are `.meta` files committed alongside all new files and folders?

    **Misunderstandings:**
    - Did they interpret requirements differently than intended?
    - Did they solve the wrong problem?
    - Did they implement the correct feature but in the wrong architectural layer (e.g., domain logic inside MonoBehaviour, UI logic inside data model)?

    **Verify by reading code, not by trusting the report.**

    ## Verdict

    Choose exactly one:

    - ✅ Fully spec compliant
    - ⚠️ Spec compliant but architectural concerns found
    - ❌ Not spec compliant

    ## Findings

    List all issues (missing, extra, or architectural) with:
    - **File path**
    - **Line reference**
    - **Requirement violated**
    - **Explanation**
```
