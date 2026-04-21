# Unity Implementer Subagent Prompt Template

Use this template when dispatching an implementer subagent for a Unity task.

```
Dispatch using the Task tool with subagent_type: general-purpose
  description: "Implement Task N: [task name]"
  prompt: |
    You are implementing Task N: [task name] in a Unity project.

    ## Task Description

    [FULL TEXT of task from plan — paste it here, do not make subagent read the file]

    ## Architectural Context

    [Scene-setting: overall feature goal, how this task fits, key dependencies,
     existing patterns in the codebase, Unity version, render pipeline]

    ## Before You Begin

    State the following explicitly before writing any code:

    1. **Task goal in one sentence** — what will exist after this task that didn't before
    2. **Task type:**
       - Domain logic (pure C# — no MonoBehaviour, no Unity API)
       - MonoBehaviour / Component (Unity lifecycle, scene wiring)
       - UI (Canvas, TextMeshPro, event bindings)
       - Tooling (Editor script, custom inspector, ScriptableObject wizard)
    3. **Test strategy:** EditMode / PlayMode / Manual Editor — and why

    If you have questions about requirements, approach, dependencies, or anything unclear:
    **Ask them now.** Raise all concerns before starting work.

    ## Your Job

    Once clear on requirements:
    1. Follow task steps exactly as specified in the plan
    2. Write tests first if task calls for TDD (see superunity:unity-tdd)
    3. Keep Unity glue (MonoBehaviour, events, scene refs) separate from pure C# domain logic
    4. Avoid hidden scene dependencies (no GameObject.Find, no implicit singleton access unless architecturally approved)
    5. Avoid static state unless the plan explicitly requires it
    6. Add [SerializeField] only to fields that genuinely need Inspector exposure
    7. Stage .meta files alongside every new file (do NOT commit per task — commit once at end of feature)
    8. Verify Unity compiles cleanly after each logical code unit — do NOT continue with red Console errors
    9. If using MonoBehaviour:
       - Use Awake for internal initialization
       - Use OnEnable/OnDisable for event subscription lifecycle
       - Do not rely on script execution order unless explicitly required
       - Ensure all event subscriptions are paired with proper unsubscription (OnEnable/OnDisable or Dispose pattern)
       - No dangling static events

    **While you work:** If you encounter anything unexpected or unclear, ask. Don't guess.

    ## Before Reporting Back: Self-Review

    Explicitly confirm each item below before handing off:

    **Spec:**
    - [ ] Fully implemented everything in the task spec
    - [ ] Did not build anything not requested (YAGNI)
    - [ ] Did not introduce additional interfaces, base classes, or abstraction layers without immediate need
    - [ ] Followed existing project patterns

    **Unity Quality:**
    - [ ] SRP respected — each class has one reason to change
    - [ ] No hidden coupling — dependencies are visible and intentional
    - [ ] No per-frame allocations (no `new` in Update, no LINQ in hot paths)
    - [ ] Correct serialization attributes used ([SerializeField], [System.Serializable])
    - [ ] No unintended runtime object creation (Instantiate without pooling if scale demands it)
    - [ ] Event subscriptions properly paired with unsubscription — no leaks
    - [ ] .meta files staged alongside all new files
    - [ ] No Library/, Temp/, or Obj/ files staged
    - [ ] All tests pass (EditMode / PlayMode as applicable)
    - [ ] Console is clean — 0 errors, 0 unexpected warnings

    If you find issues during self-review, fix them before reporting.

    ## Report Format

    When done, report:
    - Task goal (one sentence)
    - Task type and test strategy used
    - What you implemented (files created/modified)
    - Test results (X/X passing, EditMode/PlayMode)
    - Files staged (ready for feature commit)
    - Self-review checklist: confirmed or issues found and fixed
    - Any architectural risks or technical debt introduced (if any)
    - Any open concerns or questions
```
