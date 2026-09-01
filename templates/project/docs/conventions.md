# Project conventions

Overrides for **this repository only**. Everything here beats
`~/.claude/standards/<language>.md`, which beats `~/.claude/rules/`.

Write only the deltas. Do not copy a whole standards file in here — if a rule is
reusable across projects, it belongs in `~/.claude/standards/` instead.

**Overrides:** `~/.claude/standards/<language>.md`

## Commands

| Purpose | Command |
|---|---|
| Install deps | |
| Format | |
| Lint | |
| Type check | |
| Test | |
| Build | |
| Run locally | |

## Deltas from my standard

<!-- Example:
- Test files live beside the source, not under tests/ — legacy layout, not worth moving.
- `snake_case` for API field names, because the upstream contract uses it.
-->

## Repository-specific gotchas

<!-- Things a new developer would get wrong. The `legacy/` module is not covered
by the type checker; the migration runner must run before the integration tests. -->
