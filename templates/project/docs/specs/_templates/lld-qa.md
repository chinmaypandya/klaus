# LLD Q&A — <feature name>

Two sub-stages, tracked with a `**Stage:**` tag per question so a resume knows
which part it's in. Finish all `entities` questions before starting any
`class-design` question — the class design depends on the entities being
settled.

---

## Q1: <question about an entity, relationship, or invariant>
**Stage:** entities
**Status:** pending

<!-- Entities stage: what are the things with identity or state, what
     distinguishes an entity from a value object here, what invariant must
     always hold, how do these things relate and with what cardinality.

     Once entities are settled, confirm the relationship diagram with the
     user before opening any class-design question — that confirmation is
     itself worth recording as an answered question here, not skipped
     silently. -->

## Q2: <question about a class's responsibility or a method's signature>
**Stage:** class-design
**Status:** pending

<!-- Class-design stage: one question per genuine ambiguity — a method's
     exact signature, whether a capability belongs on this class or a
     collaborator, whether a SOLID split is warranted yet. Do not ask about
     things you can default sensibly; state the default and move on. -->