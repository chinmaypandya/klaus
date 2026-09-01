# Python standards

> Sample file. Edit it to match how you actually work — Claude follows this
> literally.

## Toolchain
- Version: 3.12+
- Package manager: `uv` (fallback: `pip` + `venv`)
- Formatter: `ruff format .`
- Linter: `ruff check . --fix`
- Type checker: `mypy --strict src/`
- Test runner: `pytest -q`

## Layout
```
src/<package>/          # importable code, no scripts
  __init__.py
  domain/               # entities, value objects, no I/O
  services/             # use cases, orchestration
  adapters/             # db, http, filesystem — the only place SDKs appear
tests/
  unit/                 # mirrors src/ path for path
  integration/
```

## Naming
- Files / modules: `snake_case.py`
- Classes: `PascalCase`
- Functions / methods: `snake_case`, verb-first
- Constants: `UPPER_SNAKE_CASE`
- Private members: single leading underscore; double only to avoid real clashes
- Test files: `test_<module>.py`, tests named `test_<behaviour>`

## Types and generics
- Full annotations on every public function; `mypy --strict` must pass.
- Prefer `TypeVar` with a bound over a bare one:
  `TEntity = TypeVar("TEntity", bound=BaseEntity)`.
- Use `Protocol` for structural ports rather than ABCs, unless shared
  implementation is genuinely needed.
- Nullability is `X | None`, never a magic sentinel.
- `@dataclass(frozen=True, slots=True)` for value objects.

## Errors
- One base exception per package: `class <Package>Error(Exception)`.
- Domain code raises domain errors; adapters translate library exceptions at the
  boundary and never leak them upward.
- Never `except Exception:` without re-raising or logging with context.
- Never use exceptions for control flow in a hot path.

## Documentation
Google-style docstrings, sections always in this order:

```python
def resolve_active_tenant(tenant_id: TenantId) -> Tenant:
    """Return the tenant currently accepting writes for the given id.

    Args:
        tenant_id: Identifier issued at onboarding. Must be non-empty.

    Returns:
        The active tenant.

    Raises:
        TenantNotFoundError: No tenant exists with this id.
        TenantSuspendedError: The tenant exists but is not accepting writes.
    """
```

## Testing
- `pytest`, plain `assert`.
- One behaviour per test, AAA with blank-line separation.
- `pytest.mark.parametrize` for boundary tables — never a loop in the test body.
- Fixtures in `conftest.py` at the narrowest scope that works.
- Mock only across the adapter boundary.

## Dependency rules
- Allowed: stdlib, `pydantic`, `httpx`, `pytest`, `ruff`, `mypy`.
- Requires justification: anything pulling a C extension or a transitive tree > 5.
- Banned: `requests` (use `httpx`), bare `unittest.mock.patch` on our own code.

## Idioms to prefer
- Comprehensions over `map`/`filter`.
- `pathlib.Path` over `os.path`.
- Context managers for anything with a lifecycle.

## Idioms to avoid
- Mutable default arguments.
- `*args, **kwargs` on public APIs.
- Module-level side effects at import time.
