# Standards

One file per language. These are **not** loaded into every session — a skill or
rule pulls in the relevant one when that language is in play. That keeps the
setup language-independent: add a file here and it becomes part of the system
with no other change.

Naming: lowercase language name, e.g. `python.md`, `java.md`, `typescript.md`,
`go.md`, `rust.md`, `kotlin.md`, `csharp.md`.

Start from `_template.md`. Delete sections that don't apply — an empty section is
worse than a missing one.

Precedence when writing code:
`docs/conventions.md` in the repo → this directory → `~/.claude/rules/`.
