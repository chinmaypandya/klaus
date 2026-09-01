# Java standards

> Sample file. Edit to taste.

## Toolchain
- Version: Java 21 (LTS)
- Build: Gradle (Kotlin DSL)
- Formatter: `./gradlew spotlessApply` (google-java-format, AOSP)
- Linter: Error Prone + NullAway
- Test runner: `./gradlew test`

## Layout
```
src/main/java/<group>/<artifact>/
  domain/          # entities, value objects, no framework imports
  application/     # use cases / services
  infrastructure/  # JPA, HTTP clients, messaging
  api/             # controllers, DTOs
src/test/java/     # mirrors main package for package
```

## Naming
- Classes: `PascalCase`; interfaces are nouns without an `I` prefix.
- One implementation of an interface is named for what it does
  (`JdbcTenantRepository`), never `TenantRepositoryImpl`.
- Methods: `camelCase`, verb-first.
- Constants: `UPPER_SNAKE_CASE`.
- Tests: `<ClassUnderTest>Test`, methods
  `should<Outcome>_when<Condition>`.

## Types and generics
- Bound every type parameter to the narrowest useful type:
  `<T extends BaseEntity>`, `<K extends Comparable<K>>`.
- Use `? extends` / `? super` at API boundaries (PECS), not internally.
- Never return `null` from a public method — `Optional<T>` or an empty
  collection.
- `record` for value objects; `sealed interface` + records for closed
  hierarchies.

## Errors
- One checked base exception per bounded context, unchecked for programmer error.
- Infrastructure exceptions are translated at the adapter boundary.
- Never swallow an exception. Never `catch (Exception e)` outside a top-level
  handler.

## Documentation
Javadoc on every public type and method, sections in this order:

```java
/**
 * Returns the tenant currently accepting writes for the given id.
 *
 * @param tenantId identifier issued at onboarding; must not be blank
 * @return the active tenant, never {@code null}
 * @throws TenantNotFoundException if no tenant exists with this id
 * @throws TenantSuspendedException if the tenant is not accepting writes
 */
```

## Testing
- JUnit 5 + AssertJ. No Hamcrest.
- `@Nested` classes group by scenario; `@DisplayName` on each.
- `@ParameterizedTest` for boundary tables.
- Mockito only across ports. Never mock a value object or a class you own and
  can construct cheaply.
- Testcontainers for anything touching a real datastore.

## Dependency rules
- Allowed: Spring Boot starters, Jackson, AssertJ, Testcontainers.
- Requires justification: anything with a Guava or Apache Commons transitive.
- Banned: field injection, `@Autowired` on fields, static mutable state.

## Idioms to prefer
- Constructor injection, final fields.
- Streams for transformation; plain loops when the stream is harder to read.
- `var` only when the right-hand side names the type.

## Idioms to avoid
- Lombok on domain types (`record` instead).
- Setters on entities — model state changes as named methods.
