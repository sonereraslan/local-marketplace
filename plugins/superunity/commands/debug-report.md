---
name: debug-report
description: Generate a structured debugging report with project context, recent changes, and Phase 1 checklist
argument-hint: "[error message or description]"
---

# Debug Report Generator

Generate a structured debugging report to jumpstart the systematic debugging process.

## Steps

1. **Gather project context automatically:**
   - Read `ProjectSettings/ProjectVersion.txt` for Unity version
   - Run `git log --oneline -5` for recent commits
   - Run `git diff --stat` for uncommitted changes
   - Check if a feature branch is active (not main/master)

2. **Ask the user for the error details** (if not provided as argument):
   - Use AskUserQuestion to ask: "Paste the full Unity Console error, stack trace, or describe the unexpected behavior."

3. **Dispatch the `unity-error-analyzer` agent** with the error details and project context for initial analysis.

4. **Present the debugging report** in this format:

```markdown
## Debug Report

**Date:** [current date]
**Unity Version:** [from ProjectVersion.txt]
**Branch:** [current git branch]

### Error
[Error message or description]

### Initial Analysis
[Results from unity-error-analyzer agent]

### Recent Changes
[git log --oneline -5]

### Uncommitted Changes
[git diff --stat]

### Phase 1 Checklist
- [ ] Console output read completely (full stack trace, warnings above error)
- [ ] Error reproduced consistently (always / sometimes / only in build)
- [ ] Recent changes reviewed for potential cause
- [ ] Unity layer identified (Data, Lifecycle, Event, Runtime, Frame order)
- [ ] Runtime state snapshot captured (scene, timeScale, static fields)
- [ ] Unity-specific diagnostic checks completed

### Next Steps
[Based on the initial analysis, suggest which Phase 1 checks to prioritize]
```

5. **Invoke the `superunity:unity-systematic-debugging` skill** to continue with the full debugging process.
