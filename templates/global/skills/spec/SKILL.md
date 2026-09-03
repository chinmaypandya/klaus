---
name: spec
description: Turn a rough problem statement into a scoped requirements document with in-scope, out-of-scope, later-scope, and enumerated edge cases. Use at the very start of any new feature, before any design or code.
argument-hint: "[feature-slug] [one-line problem statement]"
disable-model-invocation: true
---

# Phase 1 — Requirements

Feature: `$0`. Problem statement: `$ARGUMENTS`.

This is the same phase `/klaus` runs automatically — invoke this directly only
to jump straight into requirements without going through `/klaus`'s
new-vs-continuing detection. Both read and write the same files, so switching
between the two mid-feature is always safe.

## How to run this phase

Track everything in `docs/specs/$0/requirements-qa.md` (shape:
`docs/specs/_templates/requirements-qa.md` if present, else the format
embedded in `~/.claude/skills/klaus/SKILL.md`). One question live at a time:

1. If `requirements-qa.md` doesn't exist yet, create it and add a first
   question from the problem statement.
2. Read the file top to bottom. Find the first `pending` question, ask
   exactly that, and stop. Never bundle a second question into the same
   message.
3. On an answer: record it in my own words, flip status to `answered`, then
   immediately check for the next gap — cover at minimum actors, the core
   behaviour walked through step by step, in/out/later scope, and what "done"
   looks like — before asking the next question or closing the phase.
4. When every question is answered or explicitly skipped with a reason, write
   `requirements.md` from the file and stop. Do not proceed to design.

Do not write code, class names, or file layouts in this phase.

## Document shape

If `docs/specs/_templates/requirements.md` exists in this repo, use it as the shape and
ignore the outline below — the repo's template wins, because editing it is how I
change every future document at once. Otherwise use this:


```markdown
# <Feature name>

**Status:** draft | agreed
**Slug:** <feature-slug>
**Date:** <YYYY-MM-DD>

## 1. Problem
One paragraph. What is broken or missing, and for whom.

## 2. Goals
What "done" looks like, stated as outcomes not implementations.

## 3. Scope

### 3.1 In scope
| ID | Requirement | Priority |
|----|-------------|----------|
| R1 | ... | must |
| R2 | ... | should |

### 3.2 Out of scope
Things deliberately excluded, each with a one-line reason. This section stops
scope creep later, so be explicit rather than exhaustive.

### 3.3 Later scope
Things we intend to do but not now, with the trigger that would pull them in.

## 4. Actors and inputs
Who or what calls this, and with what.

## 5. Edge cases
| ID | Case | Expected behaviour | Confirmed? |
|----|------|--------------------|------------|
| E1 | Empty input | ... | proposed |
| E2 | Duplicate submission | ... | proposed |

Cover at minimum: empty, null/absent, maximum size, duplicate, concurrent,
out-of-order, malformed, unauthorised, downstream unavailable, partial failure,
retry after partial success. Drop the ones that genuinely cannot occur and say
why in one line.

## 6. Constraints
Performance, compliance, compatibility, deadline — only real ones.

## 7. Assumptions
Everything you defaulted rather than asked about. I will correct these.

## 8. Open questions
Numbered, each blocking or non-blocking.

## 9. Acceptance criteria
Given / When / Then, one per must-have requirement. These become tests later.
```

## Edge case sweep

Before showing me the draft, run a second pass over section 5 specifically
looking for cases the happy path hides: what happens on the second call, what
happens if two callers race, what happens if the process dies halfway. Add any
you find.

If the feature is non-trivial, delegate this sweep to the `edge-case-hunter`
subagent and merge its findings.

## Finish

If `docs/specs/$0/state.md` exists, update it: phase → `lld`, status →
`in-progress`. If it doesn't exist (this phase was invoked standalone, not
via `/klaus`), don't create one — that file is `/klaus`'s bookkeeping, not
required for manual use.

End with: the requirement count, the count of unconfirmed edge cases, and the
single sentence `Next: /lld $0`.
