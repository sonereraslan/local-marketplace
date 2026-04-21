---
name: using-superunity
description: This skill should be used when starting any conversation involving Unity 3D game development, C# scripting, MonoBehaviour, ScriptableObject, or Unity Editor workflows. It establishes the skill discovery and invocation process for all Unity tasks. Relevant when the user says things like "help me build a Unity feature," "fix my Unity bug," "create a C# script for Unity," "set up a Unity project," or any reference to Unity game development.
---

## Priority

Skill invocation is the highest priority action. Always invoke applicable skills before any other response, including clarifying questions. If there is even a small chance a skill applies, invoke it first — if it turns out to be wrong for the situation, you can disregard it.

## How to Access Skills

Use the `Skill` tool. When you invoke a skill, its content is loaded and presented to you — follow it directly. Never use the Read tool on skill files.

# Using SuperUnity Skills

## The Rule

**Invoke relevant or requested skills BEFORE any response or action.** Even a small chance a skill might apply means invoke it. If the skill turns out to be wrong for the situation, you don't need to use it.

## Skill Invocation Flow

1. Receive user message
2. Check if it's Unity-related
3. If yes, check if any skill applies
4. Invoke the skill using the Skill tool
5. Announce: "Using [skill] to [purpose]"
6. If the skill has a checklist, create a task per item
7. Follow the skill content exactly
8. Respond (including any clarifications)

If the task is not Unity-related, respond normally.

## Available Skills

| Skill | When to Use |
|-------|-------------|
| `superunity:unity-exploring-project` | Before any creative/feature work — explore project context, intent, design before code |
| `superunity:unity-writing-plans` | Have spec/requirements, need implementation plan before coding |
| `superunity:unity-executing-plans` | Have a written plan, need to execute it with review checkpoints |
| `superunity:unity-subagent-dev` | Executing plan with independent tasks, dispatch subagent per task |
| `superunity:unity-systematic-debugging` | Any bug, test failure, or unexpected behavior |
| `superunity:unity-tdd` | Implementing any feature or bugfix — write test first |
| `superunity:unity-code-review` | After completing tasks or before merging |
| `superunity:unity-verification` | About to claim work is complete — evidence before claims |
| `superunity:unity-finishing-branch` | Implementation complete, need to integrate the work |
| `superunity:unity-ecs-patterns` | Working with Unity DOTS — ECS, Job System, Burst Compiler, baking, authoring components |

## Available Agents

Use the `Agent` tool to dispatch these. Agents run autonomously and return results. Prefer agents for targeted, single-purpose tasks. Prefer skills for multi-step workflows.

| Agent | When to Use |
|-------|-------------|
| `superunity:unity-script-analyzer` | "Analyse my script", quick single-file analysis for issues, anti-patterns, performance |
| `superunity:unity-error-analyzer` | "What's this error?", analyse Unity Console errors, stack traces, NullReferenceExceptions, test failures |
| `superunity:unity-test-writer` | "Write tests for this class", generate EditMode or PlayMode tests for existing code |
| `superunity:unity-project-scanner` | "Scan this project", summarize project structure, packages, conventions, architecture |

**When to use an agent vs a skill:**
- **Agent:** User wants a specific, bounded result (analyse this script, write tests for this class, explain this error)
- **Skill:** User wants to follow a process/workflow (debug a problem, plan a feature, do a code review)

## Skill Priority

When multiple skills could apply, use this order:

1. **Process skills first** (exploring-project, debugging) — determine HOW to approach
2. **Implementation skills second** (TDD, code-review, verification) — guide execution

"Let's build X" → exploring-project first, then implementation skills.
"Fix this bug" → debugging first, then verification skills.

## Skill Types

**Rigid** (TDD, debugging, verification): Follow exactly. Don't adapt away discipline.

**Flexible** (exploring-project, ecs-patterns): Adapt principles to context.

The skill itself tells you which.

## Common Scenarios That Still Require Skill Invocation

| Scenario | Why a Skill Applies |
|----------|-------------------|
| "This is just a simple question" | Questions are tasks. Check for applicable skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "This doesn't need a formal skill" | If a skill exists for the task, invoke it. |
| "I remember this skill" | Skills evolve. Always invoke the current version. |
| "The skill seems like overkill" | Simple things become complex. Invoke it. |
| "I'll just do this one thing first" | Check for skills BEFORE doing anything. |

## User Instructions

User instructions describe WHAT to do, not HOW. "Add X" or "Fix Y" doesn't mean skip skill workflows — skills define the process for accomplishing those goals.
