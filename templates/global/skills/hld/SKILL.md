---
name: hld
description: Produce a high-level design — components, data flow, then a structured pass over network, storage, concurrency, caching, security, failure and observability. Simplest viable answer first, with the upgrade path named. Use for anything with more than one process, service, or datastore.
argument-hint: "[feature-slug]"
disable-model-invocation: true
---

# Phase 3 — High-level design

Feature: `$0`. Read `docs/specs/$0/requirements.md`, and `lld.md` if it exists.
Write to `docs/specs/$0/hld.md`.

## The rule for this phase

For every question below, give **the simplest thing that satisfies the stated
requirements**, then name the signal that would force the next step up. Do not
design for load that is not in the requirements. A single process with a
Postgres table is a valid answer and often the right one.

Format every answer as: **Now** / **Trigger to change** / **Then**.

## Order of work

### Step 1 — Components and flow
The boxes, what each owns, and the arrows between them. One Mermaid diagram.
Mark trust boundaries on it.

### Step 2 — The question sweep

Work through these in order. Skip a section only by writing "N/A — <reason>".

**Network and API**
- Protocol and why (REST / gRPC / queue / batch).
- Sync or async, and what the caller does while waiting.
- Contract: endpoints or messages, with request and response shapes.
- Versioning strategy, and what a breaking change looks like.
- Timeouts at every hop. Give numbers.

**Data and storage**
- What is stored, where, and who owns the schema.
- Access patterns first, then the schema that serves them.
- Consistency required: strong, read-your-writes, or eventual — and why that
  level and not a weaker one.
- Migration and rollback story.

**Concurrency**
- What can run at the same time, and what must not.
- Where shared mutable state exists, and how it is guarded.
- Idempotency: which operations need it and what the key is.
- Ordering guarantees, if any are needed.

**Caching**
- Do we need one yet? Default answer is no. Justify a yes with a number from
  the requirements.
- If yes: what is cached, where, keyed by what, TTL, and the invalidation
  trigger.
- What is the correct behaviour on a stale read.

**Security**
- Authentication: who proves identity, how.
- Authorisation: the actual rule, per operation.
- Secrets: where they live, how they rotate.
- Input validation boundary — the one place untrusted data is parsed.
- What is logged and what must never be.

**Failure**
- For each dependency: what happens when it is slow, and when it is down.
- Retry policy with backoff, and which operations are safe to retry.
- Partial failure: what state can we be left in, and how do we detect it.
- Blast radius of the worst realistic failure.

**Observability**
- The three or four metrics that would tell you this is broken.
- What gets logged at which level, with which correlation id.
- The one alert worth waking someone for.

**Deployment**
- How it ships, how it rolls back, how config differs per environment.

### Step 3 — Trade-offs
The two or three decisions that could reasonably have gone the other way, with
what you gave up. Anything here that closes off an alternative gets an ADR in
`docs/decisions/`.

## Document shape

If `docs/specs/_templates/hld.md` exists in this repo, use it as the shape
instead of the outline here. The repo's template wins.

## Finish

End with: the count of sections answered vs. marked N/A, and `Next: /plan $0`.
