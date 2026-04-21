---
name: unity-tdd
description: "This skill should be used when the user asks to write tests first, do TDD, implement a feature or bugfix using test-driven development, add unit tests before coding, write EditMode or PlayMode tests, or set up Unity Test Runner. Also applies when a user says 'red green refactor', 'write a failing test', or 'test-first'. Should NOT be used for manual playtesting, visual tuning, running existing tests without writing new ones, or post-implementation test additions."
---

# Test-Driven Development (Unity)

## Overview

Write the test first. Watch it fail. Write minimal code to pass.

**Core principle:** If you didn't watch the test fail, you don't know if it tests the right thing.

## When to Use

**Always (write tests first):**
- New domain logic (game rules, calculations, state machines)
- Bug fixes where the failure can be isolated to C# logic
- Refactoring pure C# classes
- ScriptableObject data and methods

**TDD where logic can be isolated. Visual and experiential tuning does not require TDD.**

**Exceptions (discuss with user):**
- Visual/experiential tuning (particle effects, camera shake, animation curves, game feel)
- Throwaway prototype scenes
- Procedural content generation requiring human judgment

**Tests must be deterministic.**
If a test can pass and fail intermittently under identical conditions, it is invalid and must be fixed before continuing development.

## The Iron Law

**Rule: No production code without a failing test first.**

If code was written before the test, delete it and start fresh from the test. Do not keep it as reference or adapt it while writing tests. Implement from tests only.

## Test Type Selection

Choose test type BEFORE writing any test. This determines the test folder, `.asmdef` references, and what Unity systems are available.

| Logic Type | Test Type | Rationale |
|-----------|-----------|-----------|
| Pure C# calculations, state, rules | EditMode | Fast, no Unity overhead, no domain reload cost |
| ScriptableObject data and methods | EditMode | No scene required, runs headlessly |
| MonoBehaviour lifecycle (Awake, Start, Update) | PlayMode | Requires Unity runtime |
| Physics interactions | PlayMode | Requires physics simulation |
| Coroutines | PlayMode | Requires frame execution |
| Scene loading / unloading | PlayMode | Requires Scene system |
| UI Canvas interactions | PlayMode | Requires UI system |
| Visual-only tuning (particles, curves, feel) | No test | Human judgment required |

**Default to EditMode.** Use PlayMode only when the behavior genuinely requires Unity runtime. A test that imports `UnityEngine` in EditMode is a warning sign that logic may not be properly separated from Unity glue code.

If you choose PlayMode for logic that could run in EditMode, you must justify the lifecycle or runtime dependency explicitly.

## Project Setup

Every test folder requires an Assembly Definition (`.asmdef`) file. Without it, Unity will not compile the tests.

```
Assets/
├── Tests/
│   ├── EditMode/
│   │   ├── YourProject.Tests.EditMode.asmdef
│   │   └── Combat/
│   │       └── DamageCalculatorTests.cs
│   └── PlayMode/
│       ├── YourProject.Tests.PlayMode.asmdef
│       └── UI/
│           └── HealthBarTests.cs
```

`.asmdef` for EditMode tests:
```json
{
  "name": "YourProject.Tests.EditMode",
  "references": ["YourProject.Runtime"],
  "includePlatforms": ["Editor"],
  "optionalUnityReferences": ["TestRunner"]
}
```

`.asmdef` for PlayMode tests:
```json
{
  "name": "YourProject.Tests.PlayMode",
  "references": ["YourProject.Runtime"],
  "optionalUnityReferences": ["TestRunner"]
}
```

**Always commit `.meta` files alongside every new test file and folder.**

## Red-Green-Refactor

### RED — Write a Failing Test

Write one test that specifies the behavior you want.

**EditMode example (pure C# domain logic):**
```csharp
// Assets/Tests/EditMode/Combat/DamageCalculatorTests.cs
using NUnit.Framework;

public class DamageCalculatorTests
{
    [Test]
    public void Calculate_WithCriticalHit_AppliesDoubleMultiplier()
    {
        var calculator = new DamageCalculator();

        int result = calculator.Calculate(baseDamage: 10, isCritical: true);

        Assert.AreEqual(20, result);
    }
}
```

**PlayMode example (lifecycle or scene dependency):**
```csharp
// Assets/Tests/PlayMode/UI/HealthBarTests.cs
using System.Collections;
using NUnit.Framework;
using UnityEngine;
using UnityEngine.TestTools;

public class HealthBarTests
{
    [UnityTest]
    public IEnumerator HealthBar_WhenHealthDecreases_UpdatesFillAmount()
    {
        var go = new GameObject();
        var healthBar = go.AddComponent<HealthBar>();
        healthBar.SetMaxHealth(100);

        healthBar.SetHealth(50);
        yield return null; // wait one frame for UI update

        Assert.AreEqual(0.5f, healthBar.FillAmount, 0.001f);
        Object.Destroy(go);
    }
}
```

**Requirements:**
- One behavior per test
- Test name: `MethodName_Condition_ExpectedResult`
- Real code — no mocks unless an external dependency genuinely requires isolation
- EditMode: `[Test]` attribute, synchronous, no `yield`
- PlayMode: `[UnityTest]` attribute, returns `IEnumerator`, use `yield return null` for frame waits

### Verify RED — Watch It Fail

**This step is required.**

Open Unity Test Runner: **Window → General → Test Runner**

- Select the test
- Click Run
- Confirm: test fails with the expected message

**Test passes immediately?** You are testing existing behavior. Fix the test — it is testing the wrong thing.

**Test errors on compile?** Fix the compile error, re-run until it fails for the right reason.

**Test throws an unexpected exception?** That is not a correct RED — fix the test setup first.

### GREEN — Minimal Code

Write the simplest production code that makes the test pass.

**Good:**
```csharp
public class DamageCalculator
{
    public int Calculate(int baseDamage, bool isCritical)
    {
        return isCritical ? baseDamage * 2 : baseDamage;
    }
}
```

**Bad:**
```csharp
public class DamageCalculator
{
    [SerializeField] private float criticalMultiplier = 2f;
    [SerializeField] private float armorPenetration = 0f;
    public event System.Action<int> OnDamageCalculated;

    public int Calculate(int baseDamage, bool isCritical, float armor = 0f)
    {
        // YAGNI — none of this was asked for by the test
    }
}
```

Don't add `[SerializeField]`, events, or configuration that no test requires yet.

### Verify GREEN — Watch It Pass

**This step is required.**

Run in Unity Test Runner:
- Test passes
- Other tests still pass
- Console is clean (0 errors, 0 unexpected warnings)

**Test fails?** Fix code, not test.

**Other tests fail?** Fix now, before continuing.

### REFACTOR — Clean Up

After green only:
- Remove duplication
- Improve names
- Extract private helpers

Keep tests green. Don't add behavior.

### Repeat

Next failing test for next behavior.

## Good Tests

| Quality | Good | Bad |
|---------|------|-----|
| **Minimal** | One behavior. "and" in name? Split it. | `Calculate_WithCritAndShield_AndRaisesEvent` |
| **Clear name** | `Calculate_WithCriticalHit_AppliesDoubleMultiplier` | `TestDamage1` |
| **Behavior, not internals** | Tests observable output (return value, event raised, state changed) | Tests which internal method was called |
| **Isolated** | No `GameObject.Find`, no static singletons | Breaks when scene structure changes |
| **Self-cleaning** | `[TearDown]` destroys created GameObjects | Leaves objects that pollute later tests |

## Unity Anti-Patterns

See companion file `./unity-testing-anti-patterns.md` for Unity-specific testing failures:
- Testing MonoBehaviour internals instead of observable output
- Adding test-only methods to MonoBehaviours or ScriptableObjects
- Using `GameObject.Find` or static singletons inside tests
- Incomplete mock ScriptableObjects missing required fields
- PlayMode tests where EditMode would suffice

## Verification Checklist

Before reporting a task complete:

**TDD Discipline:**
- [ ] Watched each test fail before implementing
- [ ] Each test failed for the expected reason (feature missing, not compile error)
- [ ] Wrote minimal code to pass each test

**Unity Test Quality:**
- [ ] EditMode used for pure C# logic — no unnecessary PlayMode tests
- [ ] PlayMode used only where lifecycle, physics, or scene dependency is genuine
- [ ] Test names follow `MethodName_Condition_ExpectedResult` pattern
- [ ] No `GameObject.Find` or static singletons inside tests
- [ ] GameObjects created in tests are destroyed in `[TearDown]` or at test end
- [ ] No test-only methods added to production MonoBehaviours or ScriptableObjects

**Isolation guarantees:**
- [ ] Test does not depend on execution order
- [ ] Test passes when run individually
- [ ] Test passes when run as part of full suite
- [ ] No static state leaks between tests
- [ ] All static events unsubscribed in `[TearDown]`

**Results:**
- [ ] All tests pass in Unity Test Runner
- [ ] No skipped tests (`[Ignore]` attributes)
- [ ] Console clean (0 errors, 0 unexpected warnings)
- [ ] `.meta` files committed alongside all new test files and folders
- [ ] Tests pass in batchmode via command line (CI compatible)
- [ ] No platform-specific test failures

All items must be confirmed before reporting a task as complete.

## When Stuck

| Problem | Unity Solution |
|---------|----------------|
| Don't know how to test MonoBehaviour behavior | Extract the logic to a pure C# class. Test that in EditMode. |
| Test requires complex scene setup | Use `new GameObject()` — no full scene needed for most cases |
| Must access a singleton in test | Inject an interface instead. Provide a test double. |
| Coroutine behavior needs testing | Use `[UnityTest]` with `yield return null` or `yield return new WaitForFixedUpdate()` |
| Physics behavior hard to reproduce | Set up Rigidbody explicitly; `yield return new WaitForFixedUpdate()` |
| Test setup is enormous | Domain too coupled. Extract pure C# and test that instead. |
| Can't isolate because of static event | Static events are a coupling problem. Fix the design. |
| Addressables async load | Use `[UnityTest]` and `yield return handle.Task`; verify completion before asserting. |

## Common Misconceptions

| Misconception | Correction |
|---------------|------------|
| "Can't test Unity code" | Only MonoBehaviour glue is hard to test. Extract domain logic to pure C#. |
| "Too slow in Play Mode" | Most logic belongs in EditMode. Move it there. |
| "Visual behavior can't be tested" | Visual tuning is exempt. Logic that drives visuals is not. |
| "I'll add tests after" | Tests passing immediately prove nothing. Write the test first to see it catch the missing behavior. |
| "Already tested it manually in Play Mode" | Manual testing is ad-hoc. Not repeatable. Not a regression guard. |
| "Just this one MonoBehaviour" | MonoBehaviours without extracted logic are untestable by design. |
| "The scene setup is too complex to test" | Design problem. Logic embedded in scene hierarchy = untestable architecture. |

## Red Flags

If any of these occur, the TDD cycle has been broken. Fix the process before continuing.

- Code written before test
- Test added after implementation
- Test passes immediately on first run
- Can't explain why the test failed

For the full list of Unity-specific testing red flags, see `./unity-testing-anti-patterns.md`.

## Property-Based Testing

For critical calculation-heavy systems (combat, economy, progression), consider property-based testing alongside example-based tests:

1. **Define invariants** — properties that must always hold regardless of input
   - `damage >= 0` always (no negative damage)
   - `finalPrice <= basePrice` when any discount is applied
   - `level * xpPerLevel <= totalXP` for any valid player state

2. **Generate multiple input combinations** — instead of hand-picking values, enumerate a range of inputs to probe the invariant

3. **Validate the invariant always holds** — a single counterexample disproves the invariant and reveals a bug

**EditMode example:**
```csharp
[Test]
public void DamageCalculator_ForAnyPositiveInput_DamageIsNeverNegative(
    [Values(0, 1, 50, 100, 9999)] int baseDamage,
    [Values(0f, 0.5f, 1f)] float armorReduction)
{
    var calculator = new DamageCalculator();

    int result = calculator.Calculate(baseDamage, armorReduction);

    Assert.GreaterOrEqual(result, 0);
}
```

Unity's NUnit supports `[Values]` and `[Range]` attributes for parameterized tests — no external library required for basic property testing. For exhaustive generation, consider **FsCheck** (available via NuGet) with NUnit integration.

Property-based tests belong in EditMode. They are pure C# invariant checks — no scene, no Unity runtime.

## Debugging Integration

Bug found? Write a failing test that reproduces it. Follow the TDD cycle. The test proves the fix and prevents regression.

Never fix a bug without a test.

## Related Skills

- **superunity:unity-systematic-debugging** — When you cannot reproduce a failure in order to write the test
- **superunity:unity-verification** — Verify the full implementation before claiming done
- **unity-test-writer agent** — When TDD reveals existing untested code that needs coverage retroactively, dispatch this agent to generate tests for that code
