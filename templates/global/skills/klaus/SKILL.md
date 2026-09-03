---
name: klaus
description: Single entry point for the structured workflow. Detects whether a request starts a new feature or continues one in progress, resumes at the correct phase using state.md, and drives requirements, LLD, HLD, planning and implementation forward one step at a time through tracked Q&A files. Use this for any request to build, add, fix or continue a feature — "let's build X", "add Y", "keep going on Z".
argument-hint: "<what you want to build, or nothing to resume the current feature>"
---

# /klaus — the orchestrator

You are driving a phased workflow, not writing code on request. Every turn
through this skill does exactly one small thing — ask one question, confirm
one design, implement one task — then stops. Momentum toward "just finish it"
is the failure mode to guard against here more than anything else.

## Step 0 — always, before anything else

Find every `docs/specs/*/state.md` in the current repo. This tells you what's
already in flight; never skip this even if the request sounds like a brand
new feature, since it might be a continuation you haven't recognized yet.

```!
find docs/specs -maxdepth 2 -name state.md 2>/dev/null
```

For each one found, read its `Phase`, `Status` and `Resume pointer`. Then
decide which of the two branches below you're in.

## Branch A — this is a new feature

True when: no `state.md` matches the request, or the user explicitly says
this is something new.

1. Propose a short kebab-case slug from the request (`connect-4`, not
   `connect_four_game` or `feature-1`). State it back in one line along with
   your one-sentence understanding of the ask, and ask for confirmation —
   this is the one moment in the whole flow where confirming *before* writing
   anything is worth the extra turn, since the slug and folder name are
   annoying to change later.
2. On confirmation, create the folder and seed it from the repo's templates
   if present, otherwise from the shapes below:
   - `docs/specs/<slug>/state.md`
   - `docs/specs/<slug>/requirements-qa.md`
3. Set `state.md` phase to `requirements`, status `in-progress`.
4. Fall into the **requirements loop** below, in the same turn.

Use `docs/specs/_templates/state.md` and `docs/specs/_templates/requirements-qa.md`
as the shape when they exist in this repo; otherwise use the shapes embedded
in this file's sections below.

## Branch B — this is a continuation

True when: a `state.md` matches, and its status isn't `done`.

Report where things stand in **one line**, then continue automatically —
do not re-ask "should we continue?" or re-confirm the phase. The state file
existing and being readable is the confirmation.

> Resuming `connect-4` — requirements phase, 3 of 5 questions answered.

Then jump straight to the loop for whatever phase `state.md` names. Do not
re-derive context in prose before acting; the state file already told you
where you are.

**Before acting on any pointer, re-read the referenced Q&A file top to
bottom.** A pointer that says "Q4 pending" is a hint, not a fact — someone
may have hand-edited the file since. Trust what the file says now over what
the pointer claims.

---

## The requirements loop

File: `docs/specs/<slug>/requirements-qa.md`.

1. Read the whole file. Find the first question with `**Status:** pending`.
2. If one exists: ask exactly that question, nothing else, and stop. Do not
   bundle a second question into the same message even if it feels related —
   one at a time is the entire point of this file existing.
3. If none exists but requirements haven't been finalized: decide whether
   more questions are needed. At minimum, before closing this phase, you must
   have asked about: the actors/players involved, the core rules or behaviour
   walked through step by step, what's in scope, what's explicitly out of
   scope, what's later scope, and what "done" looks like. If any of those is
   uncovered, append a new question block with `**Status:** pending` and ask
   it. Append — never renumber or delete existing questions.
4. When the user answers: find that exact pending question in the file
   (re-read, don't assume it's still the same one your pointer named), record
   the answer in the user's own words, flip its status to `answered`, then go
   back to step 2 in the same turn — either ask the next question or close
   the phase. Do not stop mid-turn just because you updated a file; keep
   going until you've either asked a new question or finalized the phase.
5. Closing the phase: write `docs/specs/<slug>/requirements.md` from the
   answered set — same shape the standalone `/spec` skill produces (in-scope,
   out-of-scope, later-scope, edge cases, acceptance criteria). Run the edge
   case sweep described in `/spec`'s own instructions before finalizing;
   delegate to the `edge-case-hunter` subagent if the feature is non-trivial.
   Update `state.md`: phase → `lld`, status → `in-progress`, resume pointer →
   "entities". Report the transition in one line and continue into the LLD
   loop in the same turn, unless the answered questions were thin enough that
   confirming with the user first is clearly warranted — use judgement, but
   default to continuing.

## The LLD loop

File: `docs/specs/<slug>/lld-qa.md`. Two stages, `entities` then
`class-design` — never open a class-design question while entities questions
remain pending.

**Entities stage:** identify the nouns with identity or state, distinguish
entities from value objects, state invariants, define relationships and
cardinality. Ask about genuine ambiguities one at a time, same loop mechanic
as requirements. When settled, present the relationship set (a short Mermaid
`classDiagram` is worth including inline) and get explicit confirmation
before moving to class-design — record that confirmation as an answered
question in the file, don't just take it silently.

**Class-design stage:** for each class, responsibility in one sentence,
signatures only — no method bodies. Ask one-at-a-time about anything not
obvious from the requirements: a method's exact signature, whether a
capability belongs here or on a collaborator, whether a SOLID split is
warranted yet (name the principle and the pressure if you apply one), whether
a generic is warranted (state the bound). Default sensibly and move on rather
than asking about things with an obvious answer.

Before closing: run the DSA-fit pass from `/lld`'s own instructions — for any
method more than a straight-line call, name the candidate approaches and
justify the choice against expected input size. "A list and a loop" is a
legitimate, honestly-reported answer.

Closing: write `lld.md` in the same shape `/lld` produces. Update `state.md`:
phase → `hld`, resume pointer cleared. Report and continue.

## The HLD gate

Not every feature needs this. Ask exactly one question to decide:

> Is there more than one process, service, or datastore involved here, or
> meaningful load/security/concurrency concerns? (A single CLI program
> usually doesn't need this step.)

If no: write one line in `state.md`'s Notes section explaining the skip, set
phase → `plan`, and continue immediately. If yes: run the same network /
storage / concurrency / caching / security / failure / observability sweep
`/hld` uses, as its own one-question-at-a-time loop against an `hld-qa.md`
you create from `/hld`'s document shape. Close by writing `hld.md`, phase →
`plan`.

## The plan phase

Not a Q&A loop — generate the task table per `/plan`'s own shape, show it in
full, and ask for confirmation or edits in one message. On confirmation,
write `plan.md`, set phase → `implement`, resume pointer → the first task ID,
and continue into the implement loop in the same turn.

## The implement loop

File: `docs/specs/<slug>/plan.md`. One task per `/klaus` turn — never start a
second task in the same turn, even if the first was small.

1. Re-read `plan.md`. Find the resume pointer's task; confirm its dependencies
   are `done` (re-check, don't trust the pointer blindly).
2. Follow `/implement`'s own build order exactly: failing test first and show
   it fail for the right reason, then the smallest implementation that passes
   and matches the LLD signatures, then documentation on every public member,
   then the full suite run with real output reported, then the project's
   formatter and linter commands from `docs/conventions.md` →
   `~/.claude/standards/<language>.md`.
3. **Commit.** Stage only the files this task touched — never a blanket
   `git add -A`. Message format: `<task-id>: <short imperative summary>`,
   with a body explaining *why* if the shape isn't self-evident from the
   diff. One task can be more than one commit if it's cleaner that way (e.g.
   test scaffolding as one commit, implementation as a second) — prefer
   several small honest commits over one that bundles unrelated changes.
4. Update `plan.md`: tick the task's definition-of-done boxes, status → done.
5. Append a journal entry (same four-field shape as the standalone `/journal`
   skill: what, why this shape, watch out for, refs) and a changelog entry if
   the change is user-visible — via changie if configured, else the
   Keep-a-Changelog format.
6. Update `state.md`: resume pointer → next task ID, or phase → `done` if
   that was the last task.
7. Report: files touched, test results, commit(s) made, and
   `Next: /klaus` to continue, or `Next: /klaus` will report the feature done.

**Stop here.** Do not start the next task, fix unrelated issues you noticed,
or refactor code you didn't touch — note them instead and let the next turn,
or the user, decide.

## Cross-cutting rules

- **Never silently skip the file-update half of a turn.** Asking a question
  or writing code without updating the tracking file first is the single
  most likely way this drifts out of sync over a long-running feature.
- **When in doubt about whether to ask or default,** ask only if the answer
  would change what gets built; otherwise state the default inline and move
  on. This applies at every phase, not just requirements.
- **The individual `/spec`, `/lld`, `/hld`, `/plan`, `/implement`, `/journal`
  skills still exist** as a manual override — invoke one directly to jump
  into a specific phase without going through detection. They read and write
  the same `state.md` and `*-qa.md` files, so switching between `/klaus` and
  a direct phase command mid-feature is always safe.
- **If `state.md` and reality disagree** (e.g. `plan.md` shows a task done
  that the codebase doesn't reflect), say so explicitly and ask before
  proceeding rather than trusting either source blindly.