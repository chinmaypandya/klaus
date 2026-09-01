---
name: implement
description: Implement exactly one task from a feature plan, with documentation and tests, then stop. Use for every coding step so work stays reviewable one task at a time.
argument-hint: "[feature-slug] [task-id]"
disable-model-invocation: true
---

# Phase 5 — Implement one task

Feature `$0`, task `$1`.

## Before writing anything

1. Read `docs/specs/$0/plan.md` and find task `$1`. If it doesn't exist, list the
   available task IDs and stop.
2. Check its dependencies are `done`. If not, say which and stop.
3. Read the LLD section the task implements.
4. Resolve conventions: `docs/conventions.md` → `~/.claude/standards/<lang>.md`.
   If neither covers the language, say so and offer `/conventions` before
   proceeding.
5. Read the two or three existing files closest to what you are about to write,
   so the new code matches what is already there.

State in two lines what you're about to build and which files you'll touch. Then
build it.

## Build order

1. **Test first.** Write the failing tests from the task's definition of done and
   the edge case IDs it references. Run them. Show me they fail for the right
   reason.
2. **Implement.** The smallest thing that makes them pass and matches the LLD
   signatures. If the LLD is wrong, say so and stop — don't quietly deviate.
3. **Document.** Doc comments on every public member, in the format from the
   conventions file. Module header if this is a new module.
4. **Run the whole suite**, not just the new tests. Report the real output.
5. **Format and lint** using the project's commands.

## Then stop

Update these in the same turn:
- `plan.md`: set task status to `done`, tick the definition-of-done boxes.
- Journal: run the `/journal` steps for this task.

Report:
- Files added and changed, one line each.
- Test results: counts, and the names of anything skipped.
- Anything you noticed that belongs in a later task — as a note, not a fix.
- `Next: /implement $0 <next-task-id>`

**Do not start the next task.** Do not fix unrelated things you noticed. Do not
refactor code you did not touch. If something outside the task is broken, say so
and let me decide.

## Scope guards

- No new dependency without asking first.
- No new abstraction that has one caller.
- No change to a file outside the task's stated scope without saying why.
