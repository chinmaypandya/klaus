---
name: journal
description: Record what was just built as a dated journal entry, and add a changelog entry via changie when the repo uses it. Use after finishing a task, a decision, or a debugging session worth remembering.
argument-hint: "[what happened]"
---

# Journal and changelog

Two different records, both short.

## 1. Journal — for me, later

Append to `docs/journal.md` (create it with an `# Journal` heading if absent).
Newest entries at the top, under a date heading.

```markdown
## 2026-09-01

### T4 — Tenant lookup cache
**Feature:** tenant-routing
**What:** Added a read-through cache in `TenantResolver`, keyed by tenant id,
60s TTL.
**Why this shape:** Repository call was the hot path at 4 calls per request;
TTL over invalidation because tenant records change at most daily.
**Watch out for:** Cache is per-process. Any future multi-instance deploy needs
this revisited — see hld.md §caching.
**Refs:** plan.md T4, lld.md §3.4
```

Rules for entries:
- Four fields: what, why this shape, watch out for, refs. Skip a field only if it
  would be empty.
- "Why this shape" is the whole point. An entry that only says what changed is
  worth nothing in six months — git already says that.
- Record dead ends too. An entry saying "tried X, it failed because Y" saves the
  most time.
- Two to six lines. If it needs more, it is an ADR.

## 2. Changelog — for users

Check for changie first:

```!
test -f .changie.yaml && echo "changie: yes" || echo "changie: no"
```

**If changie is configured:** run `changie new` non-interactively with the right
kind and body, or write the YAML fragment into `.changes/unreleased/` directly
following the existing files' format. Read one existing fragment first to match
the shape. Never edit `CHANGELOG.md` by hand — changie owns it.

**If changie is not configured:** append under an `## [Unreleased]` heading in
`CHANGELOG.md`, Keep a Changelog format, one of Added / Changed / Deprecated /
Removed / Fixed / Security.

Only user-visible changes get a changelog entry. Refactors, test additions and
internal renames go in the journal only.

## When to write an ADR instead

If the thing you're recording closes off an alternative that a future developer
would reasonably reach for, it belongs in `docs/decisions/ADR-NNNN-<slug>.md`:

```markdown
# ADR-0004: <Title>

**Date:** 2026-09-01   **Status:** accepted

## Context
The forces at play. No solution yet.

## Decision
What we are doing, in the active voice.

## Consequences
What gets easier, what gets harder, what we can no longer do cheaply.

## Alternatives considered
Each with the reason it lost.
```

Then link the ADR from the journal entry rather than repeating it.
