---
name: unity-finishing-branch
description: "This skill should be used when the user says 'I'm done with this feature branch', 'merge my work back', 'finish this branch', 'create a PR for this', 'ready to merge', 'wrap up this branch', 'clean up and merge', or 'discard this branch'. Runs full Unity verification, resolves Unity-specific pre-merge requirements (meta GUIDs, scene/Prefab integrity), then presents structured options for local merge, Pull Request, keep, or discard. Do not use for mid-development verification (use unity-verification) or debugging (use unity-systematic-debugging)."
---

# Finishing a Development Branch (Unity)

## Overview

Guide completion of Unity development work through full verification, then present clear integration options.

**Core principle:** Verify everything → Present options → Execute choice → Clean up.

**Announce at start:** "Using `superunity:unity-finishing-branch` to complete this work."

## The Process

### Step 1: Run Full Unity Verification

**Before presenting any options, complete the full `superunity:unity-verification` checklist.**

This is not optional. The checklist covers compile, test runner (EditMode + PlayMode), determinism, Console clean, domain reload, static leak control, serialized field migration, scene/Prefab integrity, performance sanity, build verification, API contract, regression surface, and requirements.

**If verification was run earlier in this session, it must be re-run on the current HEAD commit. Do not rely on earlier results.** Any commit since the last run could have introduced a regression.

**If any verification step fails:**
```
Verification failed at Step [N]: [description of failure]

[Show evidence — test output, Console error, or failing requirement]

Cannot proceed with merge or PR until resolved.
Use superunity:unity-systematic-debugging to investigate.
```

Stop. Do not proceed to Step 2.

**If all verification steps pass:** Continue to Step 2.

### Step 2: Unity Pre-Merge Checklist

Run these final checks before presenting integration options:

- [ ] All `.meta` files committed alongside every new file and folder
- [ ] No `Debug.Log` statements left in committed production code
- [ ] No compile warnings from new code left unexplained
- [ ] No `[Ignore]` attributes on tests
- [ ] No unintended changes in `ProjectSettings/` (especially Input, Tags & Layers, Physics)
- [ ] No `Library/`, `Temp/`, or `Obj/` files staged
- [ ] Branch is ahead of base — no divergence that would cause unexpected conflicts
- [ ] Confirm working on feature branch — **not on main or master**

```bash
git status              # confirm clean working tree — check for Library/Temp/Obj
git diff --name-only HEAD origin/<base>  # confirm no unintended ProjectSettings changes
git log --oneline -5    # confirm commit history looks correct
git branch              # confirm not on main/master
```

If any item fails — fix it before continuing.

### Step 3: Determine Base Branch

```bash
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
git log --oneline <base>..HEAD        # commits that will be merged
git log --oneline HEAD..<base>        # commits on base not yet in this branch
```

Confirm with user if base branch is ambiguous.

If the branch is significantly behind base (many commits on base not in this branch):
- Recommend rebasing onto base or merging base in first
- Large divergence increases the risk of scene/Prefab YAML conflicts and `.meta` GUID collisions
- Do not proceed to Step 4 until divergence is resolved or user explicitly accepts the risk

### Step 4: Present Options

```
Verification complete. All tests pass, Console clean, branch ready.

What would you like to do?

1. Push and create a Pull Request
2. Keep the branch as-is (I'll handle it later)
3. Discard this work

Which option?
```

Do not add explanation. Keep the options concise.

### Step 5: Execute Choice

#### Option 1: Push and Create Pull Request

```bash
git push -u origin <feature-branch>

gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
- <bullet: what feature or fix was implemented>
- <bullet: architectural approach — e.g. pure C# domain logic, ScriptableObject-driven>
- <bullet: scope — files changed, systems affected>

## Unity Context
- **Unity version:** <e.g. 2022.3.45f1>
- **Render pipeline:** <URP / HDRP / Built-in>
- **Test results:** <N> EditMode passing, <N> PlayMode passing
- **Scenes modified:** <list or "none">
- **Prefabs modified:** <list or "none">
- **Build targets tested:** <e.g. PC Standalone, Android>

## Verification
- [ ] Full test suite passes (EditMode + PlayMode)
- [ ] Console clean after Play Mode enter/exit
- [ ] Domain reload safe — no serialization errors
- [ ] `.meta` files committed for all new assets
- [ ] No Debug.Log in production code
- [ ] Build passes (batchmode)
EOF
)"
```

Then: Cleanup worktree (Step 5).

#### Option 2: Keep As-Is

Report: "Keeping branch `<name>`. Worktree preserved at `<path>`."

**Do not clean up the worktree.**

#### Option 3: Discard

**Confirm first — show exactly what will be lost:**

```
This will permanently delete:
- Branch: <name>
- Commits: <list from git log --oneline <base>..HEAD>
- Worktree at: <path> (if applicable)

Type 'discard' to confirm.
```

Wait for the exact word "discard". Do not proceed on "yes" or "ok".

If confirmed:
```bash
git checkout <base-branch>
git branch -D <feature-branch>
```

Then: Cleanup worktree (Step 5).

### Step 5: Cleanup Worktree

**For Options 1, 3:**
```bash
git worktree list | grep <feature-branch-name>
# If a worktree exists for the feature branch:
git worktree remove <worktree-path>
```

**For Option 2:** Keep the worktree.

## Unity Merge Safety

For detailed merge conflict guidance covering `.meta` GUIDs, scene files, Prefab files, Animator Controllers, and Addressables, read `${CLAUDE_PLUGIN_ROOT}/skills/unity-finishing-branch/references/unity-merge-safety.md`. Consult this reference whenever performing Option 1 (local merge) or resolving any merge conflict involving Unity assets.

## Quick Reference

| Option | Push | Keep Worktree | Delete Branch |
|--------|------|---------------|---------------|
| 1. Create PR | ✓ | ✓ | — |
| 2. Keep as-is | — | ✓ | — |
| 3. Discard | — | — | ✓ (force) |

## Red Flags

**Never:**
- Present integration options before completing `superunity:unity-verification`
- Merge locally — always use Pull Requests (local merges risk corrupting Unity scene/Prefab YAML)
- Push with unresolved `.meta` GUID conflicts
- Force-push without explicit user request
- Proceed with failing tests or unclean Console
- Delete work without typed "discard" confirmation
- Operate on main or master directly

**Always:**
- Run the full verification checklist before Step 3
- Use Pull Requests for integration — never local merge
- Get typed confirmation before discarding

## Integration

**Called by:**
- **superunity:unity-subagent-dev** — After all tasks pass spec and quality review
- **superunity:unity-executing-plans** — After all batches complete

**Requires:**
- **superunity:unity-verification** — Full verification in Step 1

**If verification fails, use:**
- **superunity:unity-systematic-debugging** — Investigate before retrying
