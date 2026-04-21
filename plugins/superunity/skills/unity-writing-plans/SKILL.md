---
name: unity-writing-plans
description: "This skill should be used when the user wants to write an implementation plan, create a task breakdown, or plan out a Unity feature before writing code. Trigger phrases include: 'write a plan', 'create a plan', 'plan this feature', 'break this into tasks', 'implementation plan', 'plan before coding'. The user typically has a spec, design doc, or requirements for a multi-step Unity task and wants a structured plan before touching any code or creating any assets."
---

# Writing Unity Implementation Plans

## Overview

Write comprehensive implementation plans assuming the engineer:

- Has zero context about our Unity project structure
- Does not know our folder conventions or naming patterns
- Is weak at test design in Unity Test Framework
- May over-engineer unless constrained
- Is skilled at C# but not yet aligned with our architecture

Document everything they need to know:

- Which folders to create
- Which C# scripts to create/modify (exact paths)
- Which Prefabs / ScriptableObjects to create
- Which Scenes to touch
- Inspector configuration steps
- How to wire references
- How to test (EditMode / PlayMode)
- How to validate in the Unity Editor

Enforce: DRY, YAGNI, SOLID (especially SRP), Composition over inheritance, TDD where possible. Commit once per feature (not per task) — keep changes staged until the feature is complete.

**Announce at start:** "Using the unity-writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated Git branch.

**Save plans to:** `docs/plans/YYYY-MM-DD-<feature-name>.md`

## Bite-Sized Task Granularity

**Steps should be atomic and reviewable.** Default: 2-5 minutes per step. For repetitive mechanical tasks (e.g., creating multiple similar ScriptableObjects, adding the same component to several prefabs), batching is allowed.

- "Create folder `Assets/Scripts/Inventory/`" — step
- "Create empty C# script `InventoryManager.cs`" — step
- "Write failing EditMode test for AddItem" — step
- "Run EditMode tests and confirm failure" — step
- "Implement minimal AddItem logic" — step
- "Run tests and confirm pass" — step
- "Create ScriptableObject `ItemData.asset`" — step
- "Create Prefab and assign references in Inspector" — step
- "Create 5 item assets: Sword, Shield, Potion, Ring, Helmet" — batched step (mechanical)
- "Commit" — only at the end of the feature, not after every task

**Never combine design decisions into one step. Mechanical repetition can be batched.**

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use the unity-executing-plans skill to implement this plan task-by-task. (Note: if this skill has been renamed, check available superunity skills for the current execution skill.)

**Goal:** [One sentence describing what this builds]

**Classification:** [Core Gameplay / Meta System / UI / Technical Infrastructure / Tooling]

**Architecture:** [2-3 sentences about approach]

**Unity Version:** [e.g., 2022.3 LTS]

**Dependencies:** [Packages required — e.g., TextMeshPro, Input System, Addressables]

**Build Targets:** [e.g., PC/Mac, Mobile, WebGL — affects design choices]

---
```

## Task Structure

````markdown
### Task N: [Component Name]

**Category:** [Script / ScriptableObject / Prefab / Scene Setup / Test / Configuration]

**Files:**
- Create: `Assets/Scripts/Inventory/InventoryManager.cs`
- Create: `Assets/ScriptableObjects/Items/ItemData.cs`
- Test: `Assets/Tests/EditMode/Inventory/InventoryManagerTests.cs`
- Prefab: `Assets/Prefabs/UI/InventoryPanel.prefab`

**Step 1: Write the failing EditMode test**

```csharp
using NUnit.Framework;

[TestFixture]
public class InventoryManagerTests
{
    [Test]
    public void AddItem_WhenInventoryEmpty_AddsItemSuccessfully()
    {
        var inventory = new InventoryManager();
        var item = ScriptableObject.CreateInstance<ItemData>();
        item.itemName = "Sword";

        inventory.AddItem(item);

        Assert.AreEqual(1, inventory.ItemCount);
    }
}
```

**Step 2: Run test to verify it fails**

Run: Unity > Window > General > Test Runner > EditMode > Run All
Expected: FAIL — `InventoryManager` class not found

**Step 3: Write minimal implementation**

```csharp
using System.Collections.Generic;
using UnityEngine;

public class InventoryManager
{
    private readonly List<ItemData> _items = new();

    public int ItemCount => _items.Count;

    public void AddItem(ItemData item)
    {
        _items.Add(item);
    }
}
```

**Step 4: Run test to verify it passes**

Run: Unity > Test Runner > EditMode > Run All
Expected: PASS (1/1)

**Step 5: Stage files (commit at end of feature)**

```bash
git add Assets/Scripts/Inventory/InventoryManager.cs
git add Assets/Scripts/Inventory/InventoryManager.cs.meta
git add Assets/Tests/EditMode/Inventory/InventoryManagerTests.cs
git add Assets/Tests/EditMode/Inventory/InventoryManagerTests.cs.meta
# Do NOT commit yet — commit once when the entire feature is complete
```
````

## Unity-Specific Plan Rules

### Always Include .meta Files

Every file and folder in Unity generates a `.meta` file. **Always include `.meta` files in git add commands.** Missing `.meta` files break references.

### Test Strategy Per Task

| Logic Type | Test Type | Where |
|------------|-----------|-------|
| Pure C# logic (no MonoBehaviour) | EditMode test | `Assets/Tests/EditMode/` |
| MonoBehaviour integration | PlayMode test | `Assets/Tests/PlayMode/` |
| Scene-dependent behavior | PlayMode test with scene load | `Assets/Tests/PlayMode/` |
| ScriptableObject validation | EditMode test | `Assets/Tests/EditMode/` |
| Editor tool | EditMode test | `Assets/Tests/EditMode/` |

**Prefer EditMode tests.** Extract core logic into plain C# classes that don't inherit MonoBehaviour. This makes testing fast and reliable.

**Use TDD where logic can be isolated.** Visual / experiential tuning (animation curves, particle effects, UI layout tweaking, shader parameters) does not require TDD — validate these through manual inspection in the Editor.

### Performance Considerations

**Every task that creates runtime behavior must state:**

| Concern | What to Specify |
|---------|----------------|
| **Update frequency** | Does this run every frame (Update), at fixed intervals (FixedUpdate), or event-driven? Justify the choice. |
| **Allocation strategy** | Does this allocate at runtime? Use object pooling? Pre-allocate in Awake? Avoid per-frame allocations. |
| **Expected scale** | How many instances? 10? 100? 10,000? Design changes drastically at different scales. State the assumption explicitly. |

Example in a task:
```markdown
**Performance:**
- Update: Event-driven (OnHealthChanged), no per-frame cost
- Allocation: Pool of 20 damage numbers, pre-allocated in Awake
- Scale: Max 50 active enemies at once, each with one health component
```

### Assembly Definition Requirements

If test folders don't have `.asmdef` files, include a step to create them:

```
Assets/Tests/EditMode/EditModeTests.asmdef  → references: project assemblies + UnityEngine.TestRunner + NUnit
Assets/Tests/PlayMode/PlayModeTests.asmdef  → references: project assemblies + UnityEngine.TestRunner + NUnit (+ check "Test Assemblies")
```

### Inspector Configuration Steps

When a task involves Inspector setup, be explicit:

```markdown
**Step N: Configure Inspector references**

1. Select `Assets/Prefabs/Player/PlayerController.prefab`
2. In Inspector, find `PlayerMovement` component
3. Set `Move Speed` to `5.0`
4. Drag `Assets/ScriptableObjects/PlayerConfig.asset` into `Config` field
5. Verify no missing references (no yellow warning icons)
```

### Scene Hierarchy Steps

When a task involves scene setup:

```markdown
**Step N: Set up scene hierarchy**

1. Open `Assets/Scenes/GameScene.unity`
2. Create empty GameObject: `--- MANAGERS ---` (separator)
3. Create empty GameObject: `GameManager`
4. Add component: `GameManager.cs`
5. Create child: `GameManager > AudioManager`
6. Save scene (Ctrl+S)
```

## Plan Checklist

Before finalizing any plan, verify every item:

- [ ] Exact file paths (including folder path under Assets/)
- [ ] `.meta` files included in all git commands
- [ ] Code detail level appropriate: complete for core logic, skeleton for boilerplate, pseudocode for complex logic
- [ ] Inspector steps list exact field names and values
- [ ] Scene steps list exact hierarchy and component assignments

## When Planning Is Blocked

Do not write around blockers. Surface them immediately.

**Plan step requires modifying a system not mentioned in the design:**
- Stop — do not expand scope silently
- State exactly which system would be touched and why
- Return to `superunity:unity-exploring-project` to revise the design before continuing

**Required package or Unity API doesn't exist in this project:**
- Stop — do not assume the user will install it
- State the missing dependency explicitly
- Ask the user to install it, or revise the design to avoid it

**Writing the plan reveals tight coupling the design didn't anticipate:**
- Stop — do not plan around the coupling
- State which classes or systems are coupled and why it's a problem
- Return to `superunity:unity-exploring-project` to update the architecture before continuing

**Scope is much larger than the design assumed:**
- Do not write a plan that exceeds what was approved
- Split: define what goes in this plan, and explicitly list what is deferred
- Get user confirmation on the scope before finalizing

**Red flags — STOP:**
- A step requires touching more than 3 systems → the design is under-specified, go back to exploring
- You're writing pseudocode because the approach is unclear → the design didn't decide the architecture, go back to exploring
- Steps keep depending on each other → tasks aren't atomic, break them down further

## Execution Handoff

After saving the plan, offer execution choice:

**"Plan complete and saved to `docs/plans/<filename>.md`. Two execution options:**

**1. Subagent-Driven (this session)** — I dispatch fresh subagent per task, review between tasks, fast iteration

**2. Parallel Session (separate)** — Open new session with executing-plans, batch execution with checkpoints

**Which approach?**"

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use superunity:unity-subagent-dev
- Stay in this session
- Fresh subagent per task + code review

**If Parallel Session chosen:**
- Guide them to open new session on the branch
- **REQUIRED SUB-SKILL:** New session uses superunity:unity-executing-plans
