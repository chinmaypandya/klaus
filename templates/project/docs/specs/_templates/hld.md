# HLD — <Feature name>

**Satisfies:** (requirement IDs)
**Status:** draft | agreed

Answer every section as **Now** / **Trigger to change** / **Then**. The simplest
thing that satisfies the stated requirements wins. Mark a section `N/A — reason`
rather than deleting it.

## 1. Components and flow

```mermaid
flowchart LR
```

Mark trust boundaries.

## 2. Network and API
Protocol and why. Sync or async. Contract. Versioning. Timeouts, with numbers.

## 3. Data and storage
What is stored, where, who owns the schema. Access patterns first, then schema.
Consistency level and why not a weaker one. Migration and rollback.

## 4. Concurrency
What runs concurrently and what must not. Shared mutable state and its guard.
Idempotency keys. Ordering guarantees.

## 5. Caching
Default answer is no. A yes needs a number from the requirements. If yes: what,
where, key, TTL, invalidation trigger, correct behaviour on a stale read.

## 6. Security
Authentication. Authorisation rule per operation. Secrets and rotation. The one
place untrusted input is parsed. What is logged and what must never be.

## 7. Failure
Per dependency: slow, and down. Retry policy and which operations are safe to
retry. Partial failure states and how they are detected. Blast radius.

## 8. Observability
The three or four metrics that reveal breakage. Log levels and correlation id.
The one alert worth waking someone for.

## 9. Deployment
How it ships, how it rolls back, how config differs per environment.

## 10. Trade-offs
The decisions that could reasonably have gone the other way, and what was given
up. Anything closing off an alternative gets an ADR.
