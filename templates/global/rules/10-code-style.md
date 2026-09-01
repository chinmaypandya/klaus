# Code style

Language-specific rules live in `~/.claude/standards/<language>.md` and override
anything here. These are the cross-language defaults.

## Naming
- Method names are verb phrases that state the outcome: `resolveActiveTenant()`,
  not `getTenant2()` or `handle()`.
- Boolean names read as predicates: `isExpired`, `hasPendingWrites`, `canRetry`.
- Collections are plural; singular names mean single values. No `dataList`,
  `infoObj`, `theMap` — name the contents.
- Be consistent within a codebase over being correct in the abstract. If the
  repo says `fetch*`, don't introduce `retrieve*`.
- No abbreviations except ones the domain already uses. `cfg`, `mgr`, `svc` are
  out; `id`, `url`, `http` are in.

## Class design
- One reason to change per class. When a class starts needing "and" to describe
  it, that's the split signal.
- The constructor takes what the object needs to be valid; nothing optional that
  silently changes behaviour.
- Prefer composition. Reach for inheritance only for a genuine is-a with a
  stable contract.
- Keep the public surface as small as the callers require. Everything else is
  private until a second caller proves otherwise.

## SOLID, applied gradually
Apply one principle at a time, when the pain is already visible:

| Signal | Principle | Move |
|---|---|---|
| Class changes for two unrelated reasons | SRP | Split it |
| Adding a case means editing a switch | OCP | Strategy / polymorphism |
| A subclass throws on an inherited method | LSP | Wrong hierarchy — recompose |
| Callers depend on methods they never call | ISP | Split the interface |
| Business logic imports a driver or SDK | DIP | Introduce a port |

Say which principle you applied and which signal triggered it. Do not
pre-emptively add interfaces with one implementation.

## Generics
- Use a generic when two or more concrete versions already exist or are
  committed to. Not before.
- Always bound the type parameter to the narrowest thing that works
  (`T extends Comparable<T>`, `T: Protocol`, `T extends BaseEntity`). An
  unbounded parameter usually means the abstraction is wrong.
- Name type parameters for their role when it isn't obvious: `TEntity`, `TKey`,
  `TResult` — not `T`, `U`, `V` in a five-parameter signature.
- If a generic makes a call site harder to read, keep the concrete version.

## Structure
- Functions do one thing at one level of abstraction. Mixed levels in one body
  is the extract-method signal.
- Guard clauses over nested conditionals. Return early.
- No dead code, no commented-out blocks, no `TODO` without an issue reference.
