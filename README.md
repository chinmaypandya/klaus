# Klaus

A structured engineering workflow for Claude Code, configured **once per
machine**. Your repos hold their own specs, plans and journal — never a copy of
your rules.

```bash
curl -fsSL https://raw.githubusercontent.com/chinmaypandya/klaus/main/install.sh | bash
```

Then, in any repository:

```bash
klaus init
claude
```

```
/spec payment-retry  "retries duplicate charges on gateway timeout"
/lld payment-retry
/hld payment-retry
/plan payment-retry
/implement payment-retry T1
```

---

## What problem this solves

Two, really.

**Your standards live in one place.** Not a `CLAUDE.md` pasted into forty repos
that drift apart the moment you change your mind about naming. One
`~/.claude/`, every project.

**Claude stops jumping to code.** Every phase is a separate command that
produces a document and then stops. Requirements before design, design before
tasks, one task at a time — with tests and docs — before the next.

## Install

```bash
# one-liner (clones to ~/.klaus, symlinks `klaus` into ~/.local/bin)
curl -fsSL https://raw.githubusercontent.com/chinmaypandya/klaus/main/install.sh | bash

# or from a clone
git clone https://github.com/chinmaypandya/klaus ~/.klaus
bash ~/.klaus/install.sh

# or from an unpacked zip, from inside the directory
bash install.sh
```

`--link` symlinks the templates so edits in the clone take effect immediately and
your setup is version-controlled. `--copy` takes a snapshot instead.

One caveat: Cowork sessions on the desktop app skip a `~/.claude/CLAUDE.md` that
is itself a symlink. If you use Cowork, install with `--copy`.

Downloaded the zip instead of cloning? `install.sh` restores the executable bit
itself, so `bash install.sh` from the unpacked directory is all you need.

Restart Claude Code afterwards — a running session will not see new directories.

## Commands

| Command | What it does |
|---|---|
| `klaus install [--link\|--copy]` | Write the global setup into `~/.claude` |
| `klaus init [dir]` | Scaffold `docs/` artifacts in a repository |
| `klaus lang <language>` | Add a standards file from the template |
| `klaus doctor` | Verify the install, flag oversized context files |
| `klaus uninstall` | Remove installed files, backing them up first |

`--dry-run` works on all of them. `CLAUDE_CONFIG_DIR` overrides `~/.claude`.

## The workflow

| Command | Produces | Contains |
|---|---|---|
| `/spec <slug> <problem>` | `requirements.md` | in / out / later scope, edge case sweep, acceptance criteria |
| `/lld <slug>` | `lld.md` | entities and relationships → class design (signatures only) → DSA fit → traces |
| `/hld <slug>` | `hld.md` | network, storage, concurrency, caching, security, failure, observability |
| `/plan <slug>` | `plan.md` | ordered tasks, each with a definition of done |
| `/implement <slug> <task>` | code | one task: tests first, then code, then docs — then it stops |
| `/journal <what>` | `journal.md` | what, why this shape, watch out for, refs |
| `/conventions [lang]` | — | resolve, show, or bootstrap a standards file |
| `/ship [ci\|release]` | workflows | GitHub Actions for CI and for versioned releases |

The six phase skills carry `disable-model-invocation: true`, so Claude can never
start a phase on its own. You drive every transition.

Not every feature needs every phase. A bug fix can go straight to `/plan`.

## What lives where, and when it loads

| Path | Loads | Purpose |
|---|---|---|
| `~/.claude/CLAUDE.md` | every session | The working agreement. Short by design |
| `~/.claude/rules/*.md` | every session | Workflow, style, docs, testing, artifacts |
| `~/.claude/standards/*.md` | on demand | Per-language conventions |
| `~/.claude/skills/*/SKILL.md` | when invoked | The phase workflows |
| `~/.claude/agents/*.md` | when delegated | Two read-only reviewers |

The split is the design. `CLAUDE.md` and `rules/` sit in context for every
message, so they stay under ~270 lines total. The long procedural documents —
the LLD framework, the HLD question sweep, the release checklist — live in
skills and cost nothing until you type the command. Language standards are not
rules for the same reason: you do not want Java conventions loaded while writing
Python.

## What a project ends up holding

```
<repo>/
├── docs/
│   ├── conventions.md              # deltas from your standard, this repo only
│   ├── journal.md
│   ├── decisions/ADR-0001-*.md
│   └── specs/
│       ├── _templates/             # edit these to change every future document
│       └── <feature-slug>/
│           ├── requirements.md
│           ├── lld.md
│           ├── hld.md
│           └── plan.md
└── .claude/                        # optional, project-scoped settings and rules
```

Nothing here duplicates the global setup.

## Adding a language

```bash
klaus lang go
```

Writes `~/.claude/standards/go.md` from the template. Fill it in, or let Claude
infer it from an existing codebase:

```
/conventions go
```

It reads the config files and a sample of the source, marks every inferred line
with `<!-- inferred -->`, and asks you to correct it before saving.

Three filled examples ship here — Python, Java, TypeScript. **Edit them before
your first session.** Claude follows them literally, so a line you disagree with
will show up in your code.

## The two subagents

- **`edge-case-hunter`** — read-only, used during `/spec`. Seven lenses (input
  space, cardinality, time and ordering, concurrency, failure, authorisation,
  lifecycle), returns a ranked table capped at 15 rows so it stays specific to
  your system rather than generic.
- **`convention-reviewer`** — read-only, run after `/implement`. Reviews the diff
  against your standards. It flags over-engineering as loudly as omissions,
  which is the failure mode that matters when applying SOLID gradually.

Two is deliberate. Subagent descriptions cost context in every session.

## Design notes

**Rules are context, not enforcement.** Claude reads them and tries to follow
them; it can decide otherwise. For anything that must happen every time — run
the formatter after an edit, block a commit without tests — use a hook, which
runs as a shell command at a fixed lifecycle event regardless of what Claude
decides. This kit ships no hooks on purpose. Add one once the rest has settled.

**Adherence falls as files grow.** `klaus doctor` warns when `CLAUDE.md` passes
200 lines, and CI fails the build. If you are tempted to add a paragraph, ask
whether it belongs in a skill instead.

**Path-scoped rules** load only when Claude touches matching files:

```markdown
---
paths:
  - "**/*.tf"
  - "infra/**/*"
---
# Infrastructure rules
```

## Verifying

```bash
klaus doctor
```

Inside Claude Code:

```
/context   CLAUDE.md and rules appear under "Memory files"
/skills    the eight commands are listed
/doctor    flags oversized memory files and duplicate agent names
```

If a skill will not trigger by name, run `claude --debug` — malformed YAML
frontmatter loads the body with empty metadata, so `/name` still works but
Claude has no description to match against.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). `python3 scripts/validate.py` before you
open a PR; CI runs shellcheck, the validator, and a real install on Linux and
macOS.

## License

MIT
