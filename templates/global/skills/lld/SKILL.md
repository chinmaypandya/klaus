---
name: lld
description: Produce a low-level design — entities and relationships, class design with attributes and method signatures only, then a check for which DSA patterns fit. Use after requirements are agreed and before any implementation.
argument-hint: "[feature-slug]"
disable-model-invocation: true
---

# Phase 2 — Low-level design

Feature: `$0`. Read `docs/specs/$0/requirements.md` first. If it is missing, stop
and tell me to run `/spec` instead.

Write to `docs/specs/$0/lld.md`. This is the same phase `/klaus` runs
automatically — invoke this directly only to jump straight into LLD.

**Signatures only in this phase.** Attributes, method names, parameters, return
types, visibility. No method bodies. No implementation.

## Order of work

Track ambiguities in `docs/specs/$0/lld-qa.md`, one question live at a time —
same mechanic as `/spec`. Two stages, `entities` then `class-design`; finish
every entities question before opening a class-design one.

### Stage 1 — Entities and relationships
Identify the nouns in the requirements that carry state or identity. For each:
what it is, what identifies it, what state it owns, what invariants must always
hold. Then the relationships between them, with cardinality and ownership.

Distinguish entities (have identity, mutable) from value objects (no identity,
immutable) explicitly — this decision drives most of the class design.

Draw the relationships as a Mermaid class diagram. Ask about anything genuinely
ambiguous one at a time via `lld-qa.md`; default and move on for anything with
an obvious answer. When settled, present the diagram and get explicit
confirmation before stage 2 — record that confirmation as an answered question,
not a silent assumption.

### Stage 2 — Class design
For each class: responsibility in one sentence, then attributes, then public
methods, then private methods. Signatures only.

Check each class against these before showing it to me:
- Can you describe it without "and"? If not, split it.
- Is every public method used by something in the requirements? If not, drop it.
- Does any method name need a comment to explain it? Rename it.
- Is there an interface here with exactly one implementation and no second one
  planned? Remove the interface until a second one exists.

Apply SOLID only where a requirement already creates the pressure. Name the
principle and the pressure. Do not apply all five.

Use generics only where two concrete variants exist in the requirements, and
bound the parameter. State the bound and why it is that bound.

### Step 3 — DSA fit (not a Q&A stage — run this yourself, confirm the table)
structure or algorithm actually fits, and justify it against the expected input
size from the requirements.

Present as a table:

| Method | Operation | Candidate | Complexity | Chosen? | Why |
|---|---|---|---|---|---|
| `findOverlapping` | interval overlap | sort + sweep | O(n log n) | yes | n < 10k, no updates |
| | | interval tree | O(log n) query | no | build cost not repaid at this n |

Be honest when the answer is "a list and a loop" — at small n that is the right
answer, and saying so out loud is the point of this step.

### Step 4 — Trace
Walk one happy path and two edge cases from `requirements.md` §5 through the
classes, naming each call in order. This is where a missing method shows up.

## Document shape

If `docs/specs/_templates/lld.md` exists in this repo, use it as the shape
instead of the outline here. The repo's template wins.


```markdown
# LLD — <Feature name>

**Satisfies:** R1, R2, R4 (from requirements.md)
**Status:** draft | agreed

## 1. Entities and value objects
## 2. Relationships   (+ Mermaid classDiagram)
## 3. Class design    (one subsection per class, signatures only)
## 4. DSA fit         (the table above)
## 5. Traces          (happy path + 2 edge cases)
## 6. Deferred        (what this design deliberately leaves for later scope,
                       and where the seam is that will let it in)
```

## Finish

If `docs/specs/$0/state.md` exists, update it: phase → `hld`, resume pointer
cleared.

End with: which requirement IDs are covered, which are not yet, and either
`Next: /hld $0` (if there is a system around this) or `Next: /plan $0`.
