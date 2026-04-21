---
name: unity-writing-gdd
description: >
  This skill should be used when the user needs to create, structure, audit, or consolidate
  game design documentation — including initialising a GDD, writing Feature Documents, defining
  design pillars, auditing GDD completeness, consolidating scattered design notes into a unified
  document, or managing document versioning. Trigger phrases include: "GDD init", "start a GDD",
  "write a feature document", "define design pillars", "audit my GDD", "consolidate design docs",
  "GDD structure", "feature doc template", "design document version", "document integration",
  "game doc organisation", "GDD checklist", "balance design template".
---

# Unity Game Planner

> Professional game documentation framework — structure, audit, and consolidate GDDs to industry standard

## When to Use This Skill

- Starting a new GDD from scratch
- Writing a Feature Document for a specific system
- Defining or reviewing design pillars
- Auditing an existing GDD for completeness
- Consolidating scattered design notes into one unified document
- Managing GDD versioning and terminology consistency

> **For design theory and constraints** (pillars, mechanics framework, anti-patterns) use `unity-designer`.
> **For generating design ideas** use `unity-brainstorming`.

---

## Usage Patterns

```
"GDD init"              -> Initialise a new project GDD from scratch
"GDD audit"             -> Audit an existing GDD for completeness
"GDD consolidate"       -> Merge scattered design docs into a single GDD
"feature doc [name]"    -> Generate a Feature Document for a system
"design pillars"        -> Define or review the project's design pillars
"balance template"      -> Generate a numerical balance design template
```

---

## GDD Core Philosophy

Industry consensus: **there is no single standard format**, but these principles apply universally:

| Principle | What it means |
|-----------|--------------|
| **Living Document** | Continuously updated — not a one-time deliverable |
| **Agile & Lightweight** | Avoid hundred-page documents nobody reads |
| **Findable** | Information must be locatable within seconds |
| **Visual** | Games are a visual medium — documents should use diagrams, tables, and visuals |

---

## Two-Layer Architecture

```
+--------------------------------------------------------+
|  Master Document                                        |
|  +-- Executive summary, vision, design pillars         |
|  +-- Core gameplay overview                            |
|  +-- Links to all Feature Documents                    |
+--------------------------------------------------------+
                          |
+--------------------------------------------------------+
|  Feature Documents (one per major system)               |
|  +-- Combat system                                     |
|  +-- Character system                                  |
|  +-- Economy system                                    |
|  +-- Movement system                                   |
|  +-- ...                                               |
+--------------------------------------------------------+
```

**Rule**: The Master Document links — it does not duplicate. Never copy-paste from Feature Docs into Master.

---

## Master Document — Required Sections

| Section | Contents | Priority |
|---------|----------|----------|
| **1. Executive Summary** | Game name, genre, platform, target audience, elevator pitch | P0 required |
| **2. Design Pillars** | 3-5 core design principles; the filter for all decisions | P0 required |
| **3. Core Gameplay** | Game loop, win/lose conditions, control scheme | P0 required |
| **4. Game Systems** | System overviews with links to Feature Documents | P0 required |
| **5. Narrative & World** | Story outline, setting summary | P1 important |
| **6. Character Design** | Key character overviews | P1 important |
| **7. Level Design** | Level structure, progression | P1 important |
| **8. UI/UX** | Interface flow, HUD design | P1 important |
| **9. Business Model** | Pricing, monetisation strategy | P1 important |
| **10. Development Plan** | Milestones, schedule | P1 important |
| **11. Audio Direction** | Audio style guidelines | P2 supplementary |
| **12. Risk Assessment** | Known risks and mitigations | P2 supplementary |

---

## Feature Document Template

```markdown
# [System Name] — Feature Document

## Design Goal
> What problem does this system solve? What experience does it create?

## Core Mechanics
### Fundamental Rules
### Numerical Design
### Edge Cases

## Player Experience
### Intended Feel
### Risks and Negative Experiences

## System Relationships
### Depends On
### Affects

## Implementation Priority (LoQ)
| Tier | Contents | Status |
|------|----------|--------|
| Core | Minimum playable version | |
| Expected | Features players expect | |
| Desired | Nice-to-have additions | |
| Aspirational | Ideal state if time allows | |

## Change Log
| Version | Date | Change |
|---------|------|--------|
```

---

## GDD Audit Checklist

Run this when reviewing an existing GDD for gaps:

```
# Executive Summary
  [ ] Game name and tagline
  [ ] Genre clearly defined
  [ ] Target platform(s)
  [ ] Target audience
  [ ] Elevator pitch (30-second version)
  [ ] Unique selling point (USP)

# Design Pillars
  [ ] 3-5 core design principles exist
  [ ] Each pillar has clear Do / Don't examples

# Core Gameplay
  [ ] Game loop diagram or description
  [ ] Win and lose conditions documented
  [ ] Control scheme per platform
  [ ] Target session length

# Game Systems
  [ ] Every core system has a Feature Document
  [ ] System dependencies are explicitly mapped
  [ ] Numerical design has a documented rationale

# Consistency
  [ ] Terminology is unified (glossary exists)
  [ ] Version numbers are consistent across docs
  [ ] No contradictory descriptions
  [ ] All internal links are valid
```

---

## Design Pillars

### What Makes a Good Design Pillar

Design pillars are 3-5 core principles that filter every design decision. A pillar must be:

| Good pillar | Bad pillar |
|-------------|-----------|
| Can be used to reject a feature that conflicts with it | "It should be fun" — too obvious |
| Any team member can apply it without asking | "It should look great" — not actionable |
| Specific to this project | "Players will enjoy it" — unmeasurable |

### Pillar Structure

Each pillar should include:
1. **Name** — short, memorable
2. **Intent** — one sentence explaining the principle
3. **Do examples** — 2-3 concrete design choices this pillar supports
4. **Don't examples** — 2-3 things this pillar rules out

### How to Define Pillars

If the project has no design pillars yet, guide the user through these steps:

```
1. What is the core experience you want the player to have?
2. What 3 adjectives describe how the game should feel?
3. For each adjective, what design choices support it? What choices contradict it?
4. Phrase each as a principle: "[Value] over [alternative]" or "[Action verb] [quality]"
5. Test: can this pillar reject a feature? If not, it's too vague.
```

**Important**: Design pillars are project-specific. Do not apply default pillars — always define them from the project's identity.

---

## Numerical Balance Documentation Template

Use this to document expected performance per system:

```
Expected per round:
+-- Resource income:   + X (base) + Y (skill-triggered)
+-- Resource spending: - Z (playing N cards/actions)
+-- Damage output:     A-B range
+-- Damage received:   C-D range

Expected per encounter (R rounds):
+-- Total damage output:   (A-B) x R
+-- Total damage received: (C-D) x R
+-- Net result:            remaining resources, items gained

Enemy HP benchmarks (based on player output):
+-- Standard group:  output x 2   (cleared in ~2 rounds)
+-- Elite single:    output x 3-4
+-- Boss:            output x 5-7 (includes multi-phase)
```

---

## Document Consolidation Workflow

Use when merging scattered design notes into a unified GDD:

```
Step 1 — Inventory existing documents
  +-- List all design-related files
  +-- Tag each with topic and version/date
  +-- Flag duplicates and contradictions

Step 2 — Establish authoritative sources
  +-- One authoritative document per topic
  +-- Mark others as deprecated or "to merge"
  +-- Create a shared glossary for terminology

Step 3 — Build the Master Document structure
  +-- Create the Master Document shell
  +-- Extract large systems into Feature Documents
  +-- Set up cross-reference links

Step 4 — Migrate and integrate content
  +-- Move content by priority (P0 first)
  +-- Resolve contradictions (prefer most recent or most complete)
  +-- Delete redundant content — don't archive what's truly obsolete

Step 5 — Validate and clean up
  +-- Run the GDD audit checklist
  +-- Confirm version numbers are consistent
  +-- Verify all cross-reference links are valid
```

### Contradiction Resolution

When two documents describe the same system differently:

```
Found contradiction
       |
Which version is more recent?
       |
  +-- A is newer -> prefer A
  |
  +-- Unclear / same date -> which is more complete?
                               |
                    +-- A is more complete -> use A
                    +-- Both incomplete -> redesign the system
```

---

## Sharp Edges

Documentation-specific failure modes:

### SE-1: Over-engineered GDD *(high)*
GDD grows to hundreds of pages nobody reads. Team works from memory instead.
- **Fix**: Master Document capped at 10-20 pages. Only systems in active development need detailed Feature Docs. Link, don't duplicate.

### SE-2: Design Contradictions *(critical)*
Same system described differently across documents. Developers don't know which version to implement.
- **Fix**: Designate one authoritative document per topic. Build a glossary. Mark outdated documents as deprecated explicitly.

### SE-3: Missing Design Pillars *(high)*
Features accumulate without direction. No framework for rejecting misaligned requests.
- **Fix**: Define 3-5 pillars before production begins. Every feature proposal must answer: *"How does this strengthen the core experience?"*

---

## Common Documentation Problems

| Problem | Symptom | Fix |
|---------|---------|-----|
| Design contradictions | Same system described differently | Designate authoritative doc, unify terminology |
| Missing pillars | Feature creep, unfocused design | Define pillars, cut anything that conflicts |
| Over-engineered GDD | Document too long — nobody reads it | Split into Feature Docs, keep Master lean |
| Terminology drift | Same concept has multiple names | Build and enforce a shared glossary |
| Isolated documents | Notes scattered with no index | Create Master Document as central index |

---

## Version Control Rules

```
Version format: vX.Y

X = Major version (significant structural change)
Y = Minor version (content updates, corrections)

Increment rules:
- New chapter or system added -> X +1
- Content correction or expansion -> Y +1
- Terminology or formatting unification -> Y +1

Every Feature Document inherits the Master Document's major version.
```

---

## Reference Resources

- [Nuclino — GDD Template](https://www.nuclino.com/articles/game-design-document-template)
- [Game Design Skills — GDD Guide](https://gamedesignskills.com/game-design/document/)
- [Unity — Fill Out a Game Design Document](https://learn.unity.com/tutorial/fill-out-a-game-design-document)
