# Working agreement

These instructions apply to every project on this machine. Project repos carry
only their own artifacts (specs, plans, journal, decisions) — never a copy of
these rules.

## How I work

I work **one problem statement at a time**, in phases. Do not run ahead of the
current phase, and do not start the next one until I say so.

| Phase | Skill | Output |
|---|---|---|
| 1. Requirements | `/spec` | `docs/specs/<feature>/requirements.md` |
| 2. Low-level design | `/lld` | `docs/specs/<feature>/lld.md` |
| 3. High-level design | `/hld` | `docs/specs/<feature>/hld.md` |
| 4. Task breakdown | `/plan` | `docs/specs/<feature>/plan.md` |
| 5. Build, one task | `/implement` | code + docs + tests, one task only |
| 6. Record | `/journal` | `docs/journal.md` or a changie entry |

Not every feature needs every phase. A bug fix may go straight to `/plan`. A new
service needs all six. Ask me which phases apply if it isn't obvious.

**Stop-and-ask beats guess-and-build.** If a requirement is ambiguous, ask.
If an edge case is undefined, list it and ask. One question at a time.

## Before writing any code

Resolve the conventions for the language in play, in this order — first hit wins:

1. `docs/conventions.md` in the current repo
2. `~/.claude/standards/<language>.md`
3. The general rules in `~/.claude/rules/`

If neither of the first two exists for the language, say so and offer to run
`/conventions` to create one. Never invent a convention silently.

## Design defaults

- **Simple first, extensible always.** Build the least complex thing that works
  today, structured so the next feature is an addition rather than a rewrite.
- **SOLID incrementally.** Apply a principle when the code is already feeling
  the pain it solves — not on day one, and not all five at once. Name the
  principle when you apply it and say what pain it addresses.
- **Generics with bounds.** Abstract with generics where duplication is real,
  but constrain the type parameter so the class or method stays concrete and
  readable. An unbounded `T` everywhere is a smell, not an abstraction.
- **Readability is the acceptance criterion.** A developer new to the codebase
  should understand intent from method names alone. If a comment is needed to
  explain what a method does, rename the method instead.

## Non-negotiables per unit of work

A task is not done until all three exist:

1. The code
2. Its documentation (see `~/.claude/rules/20-documentation.md`)
3. Its tests, passing (see `~/.claude/rules/30-testing.md`)

Do not move to the next task with any of the three missing.

## Project artifacts

Everything project-specific lives in the repo under `docs/`. Layout and rules
are in `~/.claude/rules/40-project-artifacts.md`.

## Tone

Be direct. Push back when a design is wrong. Point out the trade-off I am making
before I make it, not after. Don't pad responses with restatements of what I
just said.
