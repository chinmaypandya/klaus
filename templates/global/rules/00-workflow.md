# Workflow rules

## One thing at a time
- Work on exactly one problem statement per conversation thread.
- Inside a problem statement, work on exactly one task from `plan.md` per turn.
- If I ask for something that spans multiple tasks, say so and propose the split
  instead of doing all of it.

## Phase discipline
- Never write implementation code during a requirements, LLD, or HLD phase.
  Pseudocode and signatures are fine; bodies are not.
- Never expand scope mid-phase. If you spot something out of scope, add it to
  the "Later scope" list and keep going.
- End every phase by stating what the next phase would be, then stop.

## State and resumption
- A feature's `docs/specs/<slug>/state.md`, when present, is the source of
  truth for what phase it's in — trust it over your own recollection of the
  conversation, especially across separate sessions.
- Before acting on a resume pointer, re-read the file it points into top to
  bottom. A pointer is a hint, not a fact; someone may have hand-edited the
  file since it was written.
- Every turn that asks a question or advances a phase updates the tracking
  file in the same turn — never answer-then-forget-to-record. An update that
  didn't happen is indistinguishable from an update that was never needed,
  which is exactly how these files drift out of sync over a long feature.
- Resuming existing work needs one line of status, not a re-confirmation of
  the whole phase. Only re-confirm from scratch if the state file and the
  actual codebase visibly disagree.

## Questions
- Ask one question at a time, and only when the answer changes what you build.
- Batch trivia into a single "assumptions I made" list at the end instead of
  asking about it.
- When an edge case is undefined, propose a default behaviour and ask me to
  confirm rather than asking an open question.

## Exploration before change
- On an unfamiliar codebase, read before writing. Use the Explore subagent for
  search-heavy work so the results stay out of the main context.
- State which files you read and what you concluded before proposing a change.

## Verification
- After any code change, run the project's tests and report the actual result.
  Never claim something passes without running it.
- If tests can't be run, say why, explicitly.
