# Unity Performance Checklist

Quick reference for performance verification and optimization. Consult during verification (Step 8) and code review.

## Hot Path Rules (Update / FixedUpdate / LateUpdate)

- No `new` allocations (arrays, lists, strings, delegates)
- No LINQ (`Where`, `Select`, `FirstOrDefault`)
- No string concatenation or `string.Format`
- No `Debug.Log` (Console spam causes frame drops)
- No `GetComponent<T>()` — cache in `Awake`
- No `GameObject.Find` or `FindObjectOfType`
- No `foreach` on `List<T>` (minor but avoidable in tight loops)
- No boxing (value types passed as `object`)

## Instantiate / Destroy

- High-frequency spawn/despawn → use object pooling
- `Instantiate` allocates, triggers `Awake`/`Start` — expensive per-frame
- `Destroy` triggers GC — batch with pooling

## Physics

- Use layers + collision matrix to reduce checks
- Discrete collision detection unless objects move fast (then Continuous)
- `Physics.Raycast` with `LayerMask` parameter — cheaper than checking all layers
- `Physics.OverlapSphere` cheaper than trigger colliders for area checks
- Never move Rigidbody objects with `Transform.position` — use `Rigidbody.MovePosition` or forces

## Rendering

- Static Batching for non-moving objects (mark as Static in Inspector)
- Dynamic Batching for small moving objects (auto if < 300 vertices)
- Share materials — different material instances break batching
- LOD Groups for distant objects
- Occlusion culling for indoor/complex scenes
- Minimize draw calls: combine meshes, use texture atlases

## Memory

- Avoid per-frame allocations (profile with Profiler → GC Alloc column)
- Reuse collections (`List.Clear()` instead of `new List<T>()`)
- Cache `WaitForSeconds` instances: `private readonly WaitForSeconds wait = new WaitForSeconds(1f);`
- Unload unused assets after scene transitions: `Resources.UnloadUnusedAssets()`
- Addressables: release handles after use

## Scripting

- Remove empty `Update`, `FixedUpdate`, `LateUpdate` methods (Unity calls them even if empty)
- Use `CompareTag("Enemy")` instead of `gameObject.tag == "Enemy"` (avoids string alloc)
- `TryGetComponent<T>` avoids null-check overhead in Unity 2019.2+
- Prefer `SetActive(false)` over `Destroy` for reusable objects

## Profiler Quick Start

1. Window > Analysis > Profiler
2. Enter Play Mode
3. Look for:
   - **CPU:** spikes in your scripts (expand hierarchy)
   - **GC Alloc:** any allocation > 0 in Update methods
   - **Rendering:** draw call count, batches saved
   - **Memory:** total allocated, GC collections per frame

## Build vs Editor

Editor performance is not representative. Always profile in a Development Build:
- File > Build Settings > Development Build (checked)
- Autoconnect Profiler (checked)
- Run build, Profiler connects automatically
