# Testing

A feature is not finished until it has tests that pass. Write them in the same
task as the code, before moving to the next task.

## File and naming conventions
- One test file per unit under test, mirroring the source path.
- Test names state behaviour, not method names:
  `returns_empty_list_when_no_active_tenants`, not `testGetTenants`.
- Follow the repo's existing suffix (`_test`, `.test.`, `Test`, `test_`)
  consistently. Never mix styles in one project.

## Test structure
- Arrange / Act / Assert, visually separated by blank lines.
- One behaviour per test. Multiple asserts are fine if they check one behaviour.
- No logic in tests: no loops, no conditionals, no computed expected values.
- Fixtures and builders over copy-pasted setup, once the third duplicate shows up.

## What to cover
For every unit, at minimum:
- The happy path.
- Each edge case listed in `requirements.md`.
- Each error branch, asserting the error type and message.
- Boundaries: empty, single element, maximum, null/absent.

## What not to do
- Don't test private methods directly — test them through the public surface.
- Don't mock what you own unless it's slow or non-deterministic. Prefer real
  collaborators for in-process code.
- Don't assert on log output as a substitute for asserting on behaviour.
- Don't write a test that passes before the code exists.

## Running
Run the suite after every task and report the real output. If a test is slow,
say so; don't quietly skip it.
