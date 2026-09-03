# Project artifacts

Only project-specific material lives in the repo. Global rules stay in
`~/.claude/`. Never copy `~/.claude/rules/` or `~/.claude/standards/` into a
project.

## Layout

```
<repo>/
├── docs/
│   ├── conventions.md              # optional; overrides ~/.claude/standards/
│   ├── journal.md                  # running log (or .changes/ if changie)
│   ├── decisions/
│   │   └── ADR-0001-<slug>.md
│   └── specs/
│       └── <feature-slug>/
│           ├── state.md            # phase, status, resume pointer — /klaus reads this first
│           ├── requirements-qa.md  # one question at a time, updated in place
│           ├── requirements.md     # written when the Q&A closes
│           ├── lld-qa.md
│           ├── lld.md
│           ├── hld-qa.md           # only when HLD applies
│           ├── hld.md
│           └── plan.md             # the task list, with status
└── .claude/
    ├── settings.json               # optional, project-scoped, committed
    └── rules/                      # optional, only for rules unique to THIS repo
```

## Rules
- `<feature-slug>` is kebab-case and stable. Never rename it mid-flight.
- `state.md` is the single source of truth for what phase a feature is in.
  `plan.md` is the single source of truth for which tasks are done. Update the
  relevant one in the same turn that changes it — never in a separate pass.
- A `*-qa.md` file is append-only. A question that becomes irrelevant is
  marked `skipped` with a reason, never deleted — the record of why matters.
- An ADR is written when a decision closes off an alternative a future developer
  would reasonably reach for. Not for every choice.
- A repo-level `.claude/rules/` file is for things true only of this repo (a
  legacy module's quirks, a vendor SDK's constraints). Anything reusable belongs
  in `~/.claude/standards/`.

## Cross-referencing
- `lld.md` links back to the requirement IDs it satisfies.
- `plan.md` tasks link to the LLD section they implement.
- Journal entries name the task ID they close.

This trail is what makes the work reviewable months later.
