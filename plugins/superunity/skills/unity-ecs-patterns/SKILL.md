---
name: unity-ecs-patterns
description: This skill should be used when the user is working with Unity DOTS — Entity Component System, Job System, or Burst Compiler. Trigger phrases include "ECS", "DOTS", "ISystem", "IJobEntity", "entity component system", "SystemAPI", "EntityQuery", "entity command buffer", "ECB", "baking", "authoring component", "Baker", "Aspect", "IAspect", "NativeArray", "IJobParallelFor", "BurstCompile", "structural change", "singleton component", "convert to ECS", "data-oriented", "Jobs system".
---

# Unity ECS Patterns

> Production patterns for Unity DOTS: Entity Component System, Job System, and Burst Compiler

## When to Use This Skill

- Building high-performance Unity games with DOTS
- Managing thousands of entities efficiently
- Implementing data-oriented game systems
- Optimising CPU-bound game logic
- Converting MonoBehaviour/OOP code to ECS
- Using the Job System and Burst Compiler for parallelism

---

## ECS vs OOP — When to Use Which

| Aspect | MonoBehaviour / OOP | ECS / DOTS |
|--------|--------------------|-----------:|
| Data layout | Object-oriented (scattered) | Data-oriented (contiguous) |
| Memory access | Cache-unfriendly | Cache-friendly |
| Processing | Per-object | Batched by archetype |
| Scaling | Degrades with count | Linear scaling |
| Best for | Complex behaviours, editor tools | Mass simulation, performance-critical paths |

**Rule of thumb**: Use MonoBehaviour for game logic that runs on a handful of objects. Use ECS when you need hundreds or thousands of the same thing processed every frame.

---

## Core Concepts

```
Entity     — Lightweight ID only (no data, no behaviour)
Component  — Pure data struct, no methods (IComponentData)
System     — Logic that queries and processes components (ISystem)
World      — Container that owns all entities and systems
Archetype  — A unique combination of component types
Chunk      — 16KB memory block holding all entities of the same archetype
```

### Component Types

| Type | Interface | Use for |
|------|-----------|---------|
| **Data component** | `IComponentData` | Per-entity data (Speed, Health, Position) |
| **Tag component** | `IComponentData` (zero-size) | Filtering queries without data (EnemyTag) |
| **Buffer component** | `IBufferElementData` | Variable-length array per entity (inventory) |
| **Shared component** | `ISharedComponentData` | Groups entities by value (TeamId, MaterialId) |
| **Enableable component** | `IEnableableComponent` | Toggle on/off without structural change |
| **Singleton component** | `IComponentData` | One entity, global access via `SystemAPI.GetSingleton<T>()` |

---

## Pattern Overview

| Pattern | What it solves | Reference |
|---------|---------------|-----------|
| 1. Basic ECS Setup | Defining components: data, tag, buffer, shared | `references/patterns.md` Pattern 1 |
| 2. ISystem + IJobEntity | The recommended system + job combination | `references/patterns.md` Pattern 2 |
| 3. Entity Queries | Filtering entities by component presence/absence | `references/patterns.md` Pattern 3 |
| 4. Entity Command Buffers | Deferred structural changes (create/destroy/add/remove) | `references/patterns.md` Pattern 4 |
| 5. Aspects | Grouping components into a clean reusable API | `references/patterns.md` Pattern 5 |
| 6. Singleton Components | Global config/state accessible from any system | `references/patterns.md` Pattern 6 |
| 7. Baking | Converting GameObjects/MonoBehaviours to ECS at load time | `references/patterns.md` Pattern 7 |
| 8. Jobs + Native Collections | Manual parallelism with spatial hashing / custom data | `references/patterns.md` Pattern 8 |

---

## Key Rules

### System design

- **Always use `ISystem`** over `SystemBase` — unmanaged, Burst-compatible, no GC overhead
- **`[BurstCompile]` on every method** in an `ISystem` (`OnCreate`, `OnUpdate`, `OnDestroy`)
- **`RequireForUpdate<T>()`** in `OnCreate` to skip the system when no matching entities exist
- **`ScheduleParallel`** over `Schedule` whenever the job has no ordering dependency

### Structural changes

- **Never structural-change inside a job** — use an Entity Command Buffer (ECB)
- **Pick the right ECB system group**: `BeginSimulation` for spawning, `EndSimulation` for cleanup
- **Prefer enableable components** (`IEnableableComponent`) over add/remove in hot paths — no ECB, no sync point

### Memory

- **Dispose all `Persistent` allocations** in `OnDestroy` — `NativeArray`, `NativeHashMap`, etc.
- **Pass `state.Dependency`** into and out of every scheduled job to chain dependencies correctly
- **Never use managed types** (`string`, `List<T>`, `class`) inside Burst-compiled code

---

## Performance Quick Reference

```csharp
// 1. BurstCompile on the system and every method
[BurstCompile]
public partial struct MySystem : ISystem
{
    [BurstCompile] public void OnCreate(ref SystemState state) { }
    [BurstCompile] public void OnUpdate(ref SystemState state) { }
    [BurstCompile] public void OnDestroy(ref SystemState state) { }
}

// 2. IJobEntity — preferred over manual SystemAPI.Query loops for scheduling
[BurstCompile]
partial struct MyJob : IJobEntity
{
    void Execute(ref LocalTransform t, in Speed s) { }
}
state.Dependency = new MyJob().ScheduleParallel(state.Dependency);

// 3. Enableable component — avoid structural change overhead
SystemAPI.SetComponentEnabled<Stunned>(entity, true);  // no ECB, no sync point
```

---

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Using `SystemBase` instead of `ISystem` | Switch to `ISystem` — better performance, Burst-compatible |
| Structural change inside a job | Use `EntityCommandBuffer` — deferred, thread-safe |
| Forgetting `[BurstCompile]` on job/system | Add it to every struct and method in the hot path |
| Leaking `Persistent` native collections | Call `.Dispose()` in `OnDestroy` |
| Not chaining `state.Dependency` | Pass it into `Schedule`/`ScheduleParallel`, assign the result back |
| Add/remove component every frame | Use `IEnableableComponent` instead — no sync point |
| Ignoring chunk utilisation | Group related entities so they share archetypes and fill chunks efficiently |

---

## Resources

- [Unity Entities documentation](https://docs.unity3d.com/Packages/com.unity.entities@latest)
- [Unity DOTS samples (GitHub)](https://github.com/Unity-Technologies/EntityComponentSystemSamples)
- [Burst Compiler user guide](https://docs.unity3d.com/Packages/com.unity.burst@latest)
- Full code patterns → `references/patterns.md`
