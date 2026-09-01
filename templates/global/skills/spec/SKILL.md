---
name: spec
description: Turn a rough problem statement into a scoped requirements document with in-scope, out-of-scope, later-scope, and enumerated edge cases. Use at the very start of any new feature, before any design or code.
argument-hint: "[feature-slug] [one-line problem statement]"
disable-model-invocation: true
---

# Phase 1 — Requirements

Feature: `$0`. Problem statement: `$ARGUMENTS`.

Write to `docs/specs/$0/requirements.md`. If the directory exists, read the
current file first and amend it rather than overwriting.

## How to run this phase

1. Restate the problem in one sentence. If you cannot, ask for the missing piece
   and stop.
2. Draft the document below.
3. Ask me at most three questions, one at a time, about anything that would
   change the shape of the solution. Do not ask about things you can default.
4. When I confirm, write the file and stop. Do not proceed to design.

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

End with: the requirement count, the count of unconfirmed edge cases, and the
single sentence `Next: /lld $0`.
