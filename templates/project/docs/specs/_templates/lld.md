# LLD — <Feature name>

**Satisfies:** R1, R2 (see requirements.md)
**Status:** draft | agreed

## 1. Entities and value objects

| Name | Kind | Identity | State owned | Invariants |
|------|------|----------|-------------|------------|
| | entity / value object | | | |

## 2. Relationships

```mermaid
classDiagram
```

Cardinality and ownership for each edge.

## 3. Class design

Signatures only. No method bodies in this document.

### 3.1 `<ClassName>`
**Responsibility:** one sentence. If it needs "and", split the class.

Attributes:
```
- name: Type          # visibility, mutability
```

Public methods:
```
+ methodName(param: Type): ReturnType
```

Private methods:
```
- helperName(param: Type): ReturnType
```

**SOLID applied:** which principle, and the pressure that justified it. Leave
blank if none — that is the normal answer early on.

**Generics:** the type parameter, its bound, and why that bound.

## 4. DSA fit

| Method | Operation | Candidate | Complexity | Chosen? | Why |
|--------|-----------|-----------|------------|---------|-----|
| | | | | | |

"A list and a loop" is a legitimate row. At small n it is the right answer, and
recording that you checked is the point.

## 5. Traces

Happy path plus two edge cases from requirements.md §5, as an ordered call list.

## 6. Deferred

What this design leaves for later scope, and the seam that will let it in.
