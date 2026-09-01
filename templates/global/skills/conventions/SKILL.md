---
name: conventions
description: Resolve, show, or create the coding conventions for the language in play — checking the repo's docs/conventions.md first, then the personal standards directory. Use before writing code in an unfamiliar project, or to add standards for a new language.
argument-hint: "[language]"
---

# Conventions

## Resolution order

1. `docs/conventions.md` in the current repo — project overrides, wins on conflict
2. `~/.claude/standards/<language>.md` — my personal standard for that language
3. `~/.claude/rules/10-code-style.md` — cross-language defaults

## What is on disk right now

```!
echo "--- repo ---"
test -f docs/conventions.md && echo "docs/conventions.md: present" || echo "docs/conventions.md: absent"
echo "--- personal standards ---"
ls ~/.claude/standards/ 2>/dev/null | grep -v '^_' | grep -v '^README' || echo "(none)"
```

## What to do

**If asked for a language that has a standards file:** read it, summarise the
five things that most affect the code about to be written, and proceed.

**If asked for a language with no standards file:** offer to create one. Do it
like this:

1. If the repo already has code in that language, read a representative sample —
   3 to 5 files across source and tests — and infer what is actually being done.
   Read the config files too (`pyproject.toml`, `build.gradle`, `tsconfig.json`,
   `.editorconfig`, lint configs), since they hold the real answers.
2. Fill in `~/.claude/standards/<language>.md` using
   `~/.claude/standards/_template.md` as the shape.
3. Mark every inferred line with `<!-- inferred -->` so I know what to check.
4. Show me the file and ask me to correct it before saving.

**If a project needs to override a personal standard:** write only the deltas
into `docs/conventions.md` in that repo, with a line at the top saying which
personal standard it overrides. Never copy the whole file.

## Conflicts

When the repo's existing code disagrees with the standards file, follow the
existing code and tell me about the divergence. Consistency inside one codebase
beats correctness against an external document. Do not silently reformat
someone else's code to match my standard.
