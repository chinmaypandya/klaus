# Requirements Q&A — <feature name>

One question live at a time. `/klaus` (or `/spec` directly) reads this file
top to bottom on every turn to find the first `pending` question — never
trust a pointer without re-reading the file, in case of a hand-edit.

Rules for this file:
- Never delete a question once asked. If it becomes irrelevant, mark it
  `skipped` with a one-line reason instead of removing it — the record of
  why matters as much as the answer.
- An answer is recorded in the user's own words when possible, not
  paraphrased away. Paraphrase only to compress something very long.
- When every question is `answered` or `skipped`, requirements.md is
  generated from this file and the phase advances.

---

## Q1: <question text>
**Status:** pending
**Why this matters:** <one line on what this answer would change>

<!-- Add more questions as they come up during the conversation — this file
     grows as understanding grows. It does not need to be complete on the
     first pass. Cover at minimum: the actors involved, the core rules or
     behaviour, what "done" looks like, and an explicit in-scope/out-of-scope/
     later-scope split before closing this phase. -->