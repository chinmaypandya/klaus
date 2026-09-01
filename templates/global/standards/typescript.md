# TypeScript standards

> Sample file. Edit to taste.

## Toolchain
- Version: TS 5.5+, Node 22 LTS
- Package manager: `pnpm`
- Formatter: `pnpm format` (Prettier)
- Linter: `pnpm lint` (ESLint, `@typescript-eslint` strict-type-checked)
- Test runner: `pnpm test` (Vitest)

## Layout
```
src/
  domain/       # types + pure logic, zero imports from node_modules
  services/     # use cases
  adapters/     # http, db, fs
  index.ts      # composition root, the only place wiring happens
tests/          # mirrors src/
```

## Naming
- Files: `kebab-case.ts`; one primary export per file, named after the file.
- Types / interfaces / classes: `PascalCase`, no `I` prefix.
- Functions / variables: `camelCase`, verb-first for functions.
- Constants: `UPPER_SNAKE_CASE` only for true module-level constants.
- Tests: `<name>.test.ts` beside the mirror path in `tests/`.

## Types and generics
- `strict: true`, `noUncheckedIndexedAccess: true`, `exactOptionalPropertyTypes: true`.
- `any` is banned. Use `unknown` and narrow.
- Constrain every type parameter: `<TEntity extends BaseEntity>`,
  `<TKey extends string>`.
- Prefer discriminated unions over optional-field soup.
- Branded types for ids: `type TenantId = string & { readonly __brand: 'TenantId' }`.
- `type` for unions and aliases, `interface` for object contracts that get
  implemented.

## Errors
- Custom error classes extending a package-level base, with a `code` field.
- Adapters translate library errors at the boundary.
- Return `Result<T, E>` for expected failures in domain code; throw only for
  genuinely exceptional conditions.
- Never reject with a non-Error value.

## Documentation
TSDoc on every exported symbol, sections in this order:

```ts
/**
 * Returns the tenant currently accepting writes for the given id.
 *
 * @param tenantId - Identifier issued at onboarding. Must be non-empty.
 * @returns The active tenant.
 * @throws {TenantNotFoundError} No tenant exists with this id.
 * @throws {TenantSuspendedError} The tenant is not accepting writes.
 */
```

## Testing
- Vitest, `describe` per unit, `it('returns ... when ...')`.
- AAA with blank-line separation. No logic in tests.
- `it.each` for boundary tables.
- `vi.mock` only at the adapter boundary; never mock own domain modules.
- MSW for HTTP boundaries rather than stubbing fetch.

## Dependency rules
- Allowed: `zod`, `vitest`, `msw`.
- Requires justification: anything adding a build step or a polyfill.
- Banned: `lodash` (use stdlib), default exports, `moment`.

## Idioms to prefer
- `const` everywhere; `readonly` on arrays and object fields by default.
- Narrow at the edge (parse with `zod`), trust internally.
- Named exports only.

## Idioms to avoid
- Barrel files (`index.ts` re-exporting everything).
- Enums — use `as const` object + union type.
- Non-null assertion `!`.
