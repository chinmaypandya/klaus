# Contributing

## Layout

```
bin/klaus                  CLI dispatcher
lib/                       one file per subcommand, plus common.sh
install.sh                 curl-able bootstrap
scripts/validate.py        frontmatter and size checks (runs in CI)
templates/global/          everything that lands in ~/.claude
templates/project/         everything `klaus init` writes into a repo
```

Nothing outside `templates/` ends up on a user's machine except `bin/` and
`lib/`. If you are adding behaviour, it goes in `lib/`; if you are adding
guidance for Claude, it goes in `templates/`.

## Adding a skill

1. `templates/global/skills/<name>/SKILL.md`, frontmatter on line 1.
2. `description` is what Claude matches against, so lead with the trigger case.
3. Add `disable-model-invocation: true` if the skill has side effects or marks a
   phase transition the user should drive.
4. Quote any `argument-hint` containing brackets — unquoted `[a] [b]` is invalid
   YAML.
5. `python3 scripts/validate.py`.

Keep `SKILL.md` under about 150 lines. Skill content stays in the conversation
across turns once invoked, so every line is a recurring token cost.

## Adding a language standard

Copy `templates/global/standards/_template.md`. Fill it with what you actually
do, not what you aspire to — Claude follows these literally. Under 120 lines.

## Editing rules or CLAUDE.md

These load into every session, so they compete with the user's actual prompt for
attention. Before adding a line, ask whether it belongs in a skill (loads on
demand) or a path-scoped rule (loads only for matching files) instead.

Hard budget: `CLAUDE.md` under 200 lines, each rules file under about 60. CI
fails the build if `CLAUDE.md` grows past 200.

## Testing locally

```bash
export CLAUDE_CONFIG_DIR=/tmp/klaus-test
./bin/klaus install --copy
./bin/klaus doctor
mkdir -p /tmp/repo && cd /tmp/repo && git init -q . && klaus init
```

`--dry-run` on any command shows what would happen without touching disk.

## Style

- POSIX-ish bash, `set -euo pipefail`, passes `shellcheck -x`.
- Two-space indent in shell.
- Every user-facing string goes through `ok`, `info`, `warn` or `die` so colour
  and `NO_COLOR` behave consistently.
