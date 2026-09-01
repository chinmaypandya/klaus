---
name: plan
description: Break an agreed design into an ordered list of small tasks, each independently implementable, documentable and testable in one sitting. Use after LLD (and HLD if applicable) and before any code.
argument-hint: "[feature-slug]"
disable-model-invocation: true
---

# Phase 4 — Task breakdown

Feature: `$0`. Read `docs/specs/$0/requirements.md` and `lld.md` (and `hld.md`
if present). Write to `docs/specs/$0/plan.md`.

## What makes a good task here

- One vertical slice that leaves the codebase working and tested when it lands.
- Small enough to implement, document and test in one sitting.
- Has a definition of done you could hand to someone else.
- Ordered so that each task's dependencies are already done. Say the dependency
  explicitly, don't imply it by position.

Split a task if it touches more than one class for more than one reason, or if
its definition of done needs "and also".

**Task 1 is almost always scaffolding**: the folder structure, the empty module,
the test harness wired into CI. Getting a red test running before any real code
is the point.

## Document shape

If `docs/specs/_templates/plan.md` exists in this repo, use it as the shape and
ignore the outline below — the repo's template wins, because editing it is how I
change every future document at once. Otherwise use this:


```markdown
# Plan — <Feature name>

**Design:** ./lld.md   **Requirements:** ./requirements.md

## Task list

| ID | Task | Implements | Depends on | Status |
|----|------|-----------|-----------|--------|
| T1 | Scaffold module + failing test harness | — | — | todo |
| T2 | `Tenant` value object + invariants | LLD §3.1 | T1 | todo |
| T3 | `TenantRepository` port + in-memory adapter | LLD §3.2, R1 | T2 | todo |

Status is one of: todo, in-progress, done, blocked.

## Task detail

### T2 — <name>
**Implements:** LLD §3.1, requirement R2
**Depends on:** T1

**Scope:** what changes, file by file.

**Definition of done:**
- [ ] Code written and formatted
- [ ] Doc comments on every public member
- [ ] Unit tests: happy path + edge cases E1, E4
- [ ] Full suite passes
- [ ] `plan.md` status updated
- [ ] Journal entry added

**Out of scope for this task:** the things a reader would assume are included.
```

## Rules

- Do not implement anything in this phase.
- If the design turns out to be under-specified while breaking it down, stop and
  say which LLD section needs to go back a phase. Do not fill the gap silently.
- Keep the whole plan to a size I can read in one go. If it exceeds ~15 tasks,
  the feature should have been split at the requirements stage — say so.

## Finish

End with: the task count, the critical path, and `Next: /implement $0 T1`.
