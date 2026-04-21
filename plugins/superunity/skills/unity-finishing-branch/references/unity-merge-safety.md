# Unity Merge Safety

Unity has binary-adjacent file formats that conflict differently from plain text. Know these before merging.

## `.meta` File Conflicts

The most dangerous Unity merge conflict.

`.meta` files contain GUIDs that other assets use to reference each other. If two branches create a file at the same path and generate different `.meta` GUIDs, all references to that asset will silently point to the wrong GUID.

**After any merge:**
```bash
git diff HEAD~1 HEAD -- "*.meta" | grep "^+guid:"
```

If a GUID changed for an existing file — stop and do not push. Restore the original GUID:
```bash
git show HEAD~1:Assets/path/to/file.meta > Assets/path/to/file.meta
```

## Scene File Conflicts (`.unity`)

Scene files are serialized YAML. Conflicts are mergeable but risky.

- If two branches both modified the same scene, resolve conflicts by re-applying changes manually in the Editor rather than editing the YAML text directly
- After resolving: open the scene in the Editor, confirm no missing references, re-save

## Prefab File Conflicts (`.prefab`)

Same approach as scene files. Resolve in the Editor, not in the YAML text. After resolving: open the Prefab in Prefab Mode, confirm hierarchy and Inspector values are intact.

## Animator Controller Conflicts (`.controller`)

Animator Controllers are serialized YAML containing state machines, transitions, and parameters. Git conflicts are mergeable but easy to corrupt.

After resolving a conflict and opening Unity:
- Open the **Animator** window and inspect the affected controller
- Confirm all states and transitions are intact
- Confirm all parameters exist and are correctly typed (float, int, bool, trigger)
- Play a relevant animation clip through a transition to confirm runtime behavior

## Addressables / AssetBundle Safety

If the project uses Addressables:
- After merging, rebuild Addressables content (`Window > Asset Management > Addressables > Groups > Build > New Build`)
- Confirm 0 missing key warnings in the build output
- Confirm no duplicate address conflicts
- Confirm no remote catalogue mismatches if using remote hosting
