# Unity ECS — Code Patterns

## Pattern 1: Basic ECS Setup

Defines the four fundamental component types.

```csharp
using Unity.Entities;
using Unity.Mathematics;
using Unity.Transforms;
using Unity.Burst;
using Unity.Collections;

// Component: Pure data, no methods
public struct Speed : IComponentData
{
    public float Value;
}

public struct Health : IComponentData
{
    public float Current;
    public float Max;
}

public struct Target : IComponentData
{
    public Entity Value;
}

// Tag component (zero-size marker)
public struct EnemyTag : IComponentData { }
public struct PlayerTag : IComponentData { }

// Buffer component (variable-size array per entity)
[InternalBufferCapacity(8)]
public struct InventoryItem : IBufferElementData
{
    public int ItemId;
    public int Quantity;
}

// Shared component (groups entities by value)
public struct TeamId : ISharedComponentData
{
    public int Value;
}
```

---

## Pattern 2: Systems with ISystem (Recommended)

`ISystem` is unmanaged and Burst-compatible — always prefer over `SystemBase`.

```csharp
using Unity.Entities;
using Unity.Transforms;
using Unity.Mathematics;
using Unity.Burst;

// Simple foreach — auto-generates job internally
[BurstCompile]
public partial struct MovementSystem : ISystem
{
    [BurstCompile]
    public void OnCreate(ref SystemState state)
    {
        state.RequireForUpdate<Speed>();
    }

    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        float deltaTime = SystemAPI.Time.DeltaTime;

        foreach (var (transform, speed) in
            SystemAPI.Query<RefRW<LocalTransform>, RefRO<Speed>>())
        {
            transform.ValueRW.Position +=
                new float3(0, 0, speed.ValueRO.Value * deltaTime);
        }
    }

    [BurstCompile]
    public void OnDestroy(ref SystemState state) { }
}

// With explicit IJobEntity for more scheduling control
[BurstCompile]
public partial struct MovementJobSystem : ISystem
{
    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        var job = new MoveJob { DeltaTime = SystemAPI.Time.DeltaTime };
        state.Dependency = job.ScheduleParallel(state.Dependency);
    }
}

[BurstCompile]
public partial struct MoveJob : IJobEntity
{
    public float DeltaTime;

    void Execute(ref LocalTransform transform, in Speed speed)
    {
        transform.Position += new float3(0, 0, speed.Value * DeltaTime);
    }
}
```

---

## Pattern 3: Entity Queries

```csharp
[BurstCompile]
public partial struct QueryExamplesSystem : ISystem
{
    private EntityQuery _enemyQuery;

    public void OnCreate(ref SystemState state)
    {
        // Manual query builder for complex filter combinations
        _enemyQuery = new EntityQueryBuilder(Allocator.Temp)
            .WithAll<EnemyTag, Health, LocalTransform>()
            .WithNone<Dead>()
            .WithOptions(EntityQueryOptions.FilterWriteGroup)
            .Build(ref state);
    }

    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        // SystemAPI.Query — simplest approach
        foreach (var (health, entity) in
            SystemAPI.Query<RefRW<Health>>()
                .WithAll<EnemyTag>()
                .WithEntityAccess())
        {
            if (health.ValueRO.Current <= 0)
            {
                SystemAPI.GetSingleton<EndSimulationEntityCommandBufferSystem.Singleton>()
                    .CreateCommandBuffer(state.WorldUnmanaged)
                    .DestroyEntity(entity);
            }
        }

        // Utility queries
        int enemyCount = _enemyQuery.CalculateEntityCount();
        var enemies    = _enemyQuery.ToEntityArray(Allocator.Temp);
        var healths    = _enemyQuery.ToComponentDataArray<Health>(Allocator.Temp);
    }
}
```

---

## Pattern 4: Entity Command Buffers (Structural Changes)

Structural changes (create / destroy / add component / remove component) must be deferred via ECB — they cannot happen inside a job.

```csharp
[BurstCompile]
[UpdateInGroup(typeof(SimulationSystemGroup))]
public partial struct SpawnSystem : ISystem
{
    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        var ecbSingleton = SystemAPI.GetSingleton<BeginSimulationEntityCommandBufferSystem.Singleton>();
        var ecb = ecbSingleton.CreateCommandBuffer(state.WorldUnmanaged);

        foreach (var (spawner, transform) in
            SystemAPI.Query<RefRW<Spawner>, RefRO<LocalTransform>>())
        {
            spawner.ValueRW.Timer -= SystemAPI.Time.DeltaTime;

            if (spawner.ValueRO.Timer <= 0)
            {
                spawner.ValueRW.Timer = spawner.ValueRO.Interval;

                Entity newEntity = ecb.Instantiate(spawner.ValueRO.Prefab);

                ecb.SetComponent(newEntity, new LocalTransform
                {
                    Position = transform.ValueRO.Position,
                    Rotation = quaternion.identity,
                    Scale    = 1f
                });

                ecb.AddComponent(newEntity, new Speed { Value = 5f });
            }
        }
    }
}

// Parallel ECB — requires index parameter
[BurstCompile]
public partial struct ParallelSpawnJob : IJobEntity
{
    public EntityCommandBuffer.ParallelWriter ECB;

    void Execute([EntityIndexInQuery] int index, in Spawner spawner)
    {
        Entity e = ECB.Instantiate(index, spawner.Prefab);
        ECB.AddComponent(index, e, new Speed { Value = 5f });
    }
}
```

---

## Pattern 5: Aspect (Grouping Components)

Aspects bundle related components into a clean API — ideal for complex entities.

```csharp
using Unity.Entities;
using Unity.Transforms;
using Unity.Mathematics;

public readonly partial struct CharacterAspect : IAspect
{
    public readonly Entity Entity;

    private readonly RefRW<LocalTransform> _transform;
    private readonly RefRO<Speed>          _speed;
    private readonly RefRW<Health>         _health;

    [Optional]
    private readonly RefRO<Shield> _shield;

    private readonly DynamicBuffer<InventoryItem> _inventory;

    public float3 Position
    {
        get => _transform.ValueRO.Position;
        set => _transform.ValueRW.Position = value;
    }

    public float CurrentHealth => _health.ValueRO.Current;
    public float MaxHealth     => _health.ValueRO.Max;
    public float MoveSpeed     => _speed.ValueRO.Value;
    public bool  HasShield     => _shield.IsValid;
    public float ShieldAmount  => HasShield ? _shield.ValueRO.Amount : 0f;

    public void TakeDamage(float amount)
    {
        float remaining = HasShield
            ? math.max(0, amount - _shield.ValueRO.Amount)
            : amount;

        _health.ValueRW.Current = math.max(0, _health.ValueRO.Current - remaining);
    }

    public void Move(float3 direction, float deltaTime)
    {
        _transform.ValueRW.Position += direction * _speed.ValueRO.Value * deltaTime;
    }

    public void AddItem(int itemId, int quantity)
    {
        _inventory.Add(new InventoryItem { ItemId = itemId, Quantity = quantity });
    }
}

// Using aspect in a system
[BurstCompile]
public partial struct CharacterSystem : ISystem
{
    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        float dt = SystemAPI.Time.DeltaTime;

        foreach (var character in SystemAPI.Query<CharacterAspect>())
        {
            character.Move(new float3(1, 0, 0), dt);

            if (character.CurrentHealth < character.MaxHealth * 0.5f)
            {
                // Low health logic
            }
        }
    }
}
```

---

## Pattern 6: Singleton Components

One entity holds config/state data accessed globally by systems.

```csharp
public struct GameConfig : IComponentData
{
    public float DifficultyMultiplier;
    public int   MaxEnemies;
    public float SpawnRate;
}

public struct GameState : IComponentData
{
    public int   Score;
    public int   Wave;
    public float TimeRemaining;
}

// Create singletons at world initialisation
public partial struct GameInitSystem : ISystem
{
    public void OnCreate(ref SystemState state)
    {
        var entity = state.EntityManager.CreateEntity();

        state.EntityManager.AddComponentData(entity, new GameConfig
        {
            DifficultyMultiplier = 1.0f,
            MaxEnemies           = 100,
            SpawnRate            = 2.0f
        });

        state.EntityManager.AddComponentData(entity, new GameState
        {
            Score         = 0,
            Wave          = 1,
            TimeRemaining = 120f
        });
    }
}

// Accessing singletons in any system
[BurstCompile]
public partial struct ScoreSystem : ISystem
{
    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        var config = SystemAPI.GetSingleton<GameConfig>();                    // read
        ref var gs = ref SystemAPI.GetSingletonRW<GameState>().ValueRW;       // write
        gs.TimeRemaining -= SystemAPI.Time.DeltaTime;

        if (SystemAPI.HasSingleton<GameConfig>()) { /* optional existence check */ }
    }
}
```

---

## Pattern 7: Baking (Converting GameObjects to Entities)

Authoring components live on GameObjects in the Editor. Bakers convert them to ECS data at build/subscene load time.

```csharp
using Unity.Entities;
using UnityEngine;

// Authoring component — MonoBehaviour, Editor only
public class EnemyAuthoring : MonoBehaviour
{
    public float      Speed = 5f;
    public float      Health = 100f;
    public GameObject ProjectilePrefab;

    class Baker : Baker<EnemyAuthoring>
    {
        public override void Bake(EnemyAuthoring authoring)
        {
            var entity = GetEntity(TransformUsageFlags.Dynamic);

            AddComponent(entity, new Speed  { Value = authoring.Speed });
            AddComponent(entity, new Health { Current = authoring.Health, Max = authoring.Health });
            AddComponent(entity, new EnemyTag());

            if (authoring.ProjectilePrefab != null)
            {
                AddComponent(entity, new ProjectilePrefab
                {
                    Value = GetEntity(authoring.ProjectilePrefab, TransformUsageFlags.Dynamic)
                });
            }
        }
    }
}

// Baking a buffer of prefabs
public class SpawnerAuthoring : MonoBehaviour
{
    public GameObject[] Prefabs;
    public float        Interval = 1f;

    class Baker : Baker<SpawnerAuthoring>
    {
        public override void Bake(SpawnerAuthoring authoring)
        {
            var entity = GetEntity(TransformUsageFlags.Dynamic);

            AddComponent(entity, new Spawner
            {
                Interval = authoring.Interval,
                Timer    = 0f
            });

            var buffer = AddBuffer<SpawnPrefabElement>(entity);
            foreach (var prefab in authoring.Prefabs)
            {
                buffer.Add(new SpawnPrefabElement
                {
                    Prefab = GetEntity(prefab, TransformUsageFlags.Dynamic)
                });
            }

            DependsOn(authoring.Prefabs); // invalidate bake if prefabs change
        }
    }
}
```

---

## Pattern 8: Jobs with Native Collections

Use when you need spatial hashing, custom data structures, or manual parallelism.

```csharp
using Unity.Jobs;
using Unity.Collections;
using Unity.Burst;
using Unity.Mathematics;

[BurstCompile]
public struct SpatialHashJob : IJobParallelFor
{
    [ReadOnly]
    public NativeArray<float3> Positions;

    public NativeParallelMultiHashMap<int, int>.ParallelWriter HashMap;

    public float CellSize;

    public void Execute(int index)
    {
        float3 pos  = Positions[index];
        int    hash = GetHash(pos);
        HashMap.Add(hash, index);
    }

    int GetHash(float3 pos)
    {
        int x = (int)math.floor(pos.x / CellSize);
        int y = (int)math.floor(pos.y / CellSize);
        int z = (int)math.floor(pos.z / CellSize);
        return x * 73856093 ^ y * 19349663 ^ z * 83492791;
    }
}

[BurstCompile]
public partial struct SpatialHashSystem : ISystem
{
    private NativeParallelMultiHashMap<int, int> _hashMap;

    public void OnCreate(ref SystemState state)
    {
        _hashMap = new NativeParallelMultiHashMap<int, int>(10000, Allocator.Persistent);
    }

    public void OnDestroy(ref SystemState state)
    {
        _hashMap.Dispose(); // Always dispose Persistent allocations
    }

    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        var query = SystemAPI.QueryBuilder().WithAll<LocalTransform>().Build();
        int count = query.CalculateEntityCount();

        if (_hashMap.Capacity < count) _hashMap.Capacity = count * 2;
        _hashMap.Clear();

        var positions  = query.ToComponentDataArray<LocalTransform>(Allocator.TempJob);
        var posFloat3  = new NativeArray<float3>(count, Allocator.TempJob);

        for (int i = 0; i < count; i++) posFloat3[i] = positions[i].Position;

        var hashJob = new SpatialHashJob
        {
            Positions = posFloat3,
            HashMap   = _hashMap.AsParallelWriter(),
            CellSize  = 10f
        };

        state.Dependency = hashJob.Schedule(count, 64, state.Dependency);

        positions.Dispose(state.Dependency);
        posFloat3.Dispose(state.Dependency);
    }
}
```

---

## Enableable Components (Avoid Structural Changes in Hot Paths)

Instead of adding/removing components per frame, use enableable components:

```csharp
// Declare the component as enableable
public struct Sleeping : IComponentData, IEnableableComponent { }
public struct Stunned  : IComponentData, IEnableableComponent { }

// Toggle in a system — no structural change, no ECB needed
[BurstCompile]
public partial struct SleepSystem : ISystem
{
    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        foreach (var (health, entity) in
            SystemAPI.Query<RefRO<Health>>().WithEntityAccess())
        {
            bool shouldSleep = health.ValueRO.Current <= 0;
            SystemAPI.SetComponentEnabled<Sleeping>(entity, shouldSleep);
        }
    }
}
```
