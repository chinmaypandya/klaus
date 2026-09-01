# <Feature name>

**Status:** draft | agreed
**Slug:** <feature-slug>
**Date:** YYYY-MM-DD

## 1. Problem
One paragraph. What is broken or missing, and for whom.

## 2. Goals
What "done" looks like, as outcomes not implementations.

## 3. Scope

### 3.1 In scope
| ID | Requirement | Priority |
|----|-------------|----------|
| R1 | | must |
| R2 | | should |

### 3.2 Out of scope
Deliberately excluded, each with a one-line reason. Be explicit rather than
exhaustive — this section is what stops scope creep three weeks from now.

### 3.3 Later scope
Intended but not now, each with the trigger that would pull it in.

## 4. Actors and inputs
Who or what calls this, and with what.

## 5. Edge cases
| ID | Case | Expected behaviour | Confirmed? |
|----|------|--------------------|------------|
| E1 | | | proposed |

Sweep at minimum: empty, null/absent, maximum size, duplicate, concurrent,
out-of-order, malformed, unauthorised, downstream unavailable, partial failure,
retry after partial success.

## 6. Constraints
Performance, compliance, compatibility, deadline. Real ones only.

## 7. Assumptions
Everything defaulted rather than asked about.

## 8. Open questions
Numbered; mark each blocking or non-blocking.

## 9. Acceptance criteria
Given / When / Then, one per must-have requirement. These become tests.
