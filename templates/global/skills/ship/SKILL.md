---
name: ship
description: Set up or review the GitHub Actions pipelines — a CI workflow that runs tests on every push, and a separate release workflow that versions, tags, builds the changelog and publishes. Use when starting a repo or when the pipeline needs changing.
argument-hint: "[ci|release|both]"
disable-model-invocation: true
---

# CI/CD

Two separate pipelines. Never combine them — CI runs constantly, release runs
deliberately.

## Before writing anything

```!
echo "--- workflows ---"; ls -1 .github/workflows/ 2>/dev/null || echo "(none)"
echo "--- release tooling ---"
test -f .changie.yaml && echo "changie: yes" || echo "changie: no"
echo "--- project markers ---"
ls -1 package.json pyproject.toml go.mod Cargo.toml build.gradle* pom.xml 2>/dev/null || echo "(none detected)"
```

Read any existing workflow before proposing a change. Match its style.

## Pipeline 1 — CI (`.github/workflows/ci.yml`)

Triggers on push to any branch and on pull requests. Jobs, in this order, each
failing fast:

1. **lint** — formatter check (not write) and linter
2. **typecheck** — where the language has one
3. **test** — full suite with coverage output
4. **build** — proves the artifact compiles/packages

Requirements:
- Pin action versions to a major tag (`actions/checkout@v4`), never `@master`.
- Cache the dependency directory keyed on the lockfile hash.
- Matrix over the language versions actually supported, no more.
- Upload test results and coverage as artifacts.
- Concurrency group per ref with `cancel-in-progress: true`, so pushes supersede.
- Minimal `permissions:` block — `contents: read` unless more is needed.
- No secrets in CI unless a test genuinely requires one.

Branch protection: require the CI check before merge. Say so; I'll enable it.

## Pipeline 2 — Release (`.github/workflows/release.yml`)

Triggers on `workflow_dispatch` with a bump input (patch/minor/major), or on a
tag push — pick one and be consistent. Steps:

1. Re-run the full test suite. Never release on a stale CI result.
2. Determine the next version:
   - **changie present:** `changie batch <bump>` then `changie merge`, which
     consumes `.changes/unreleased/` and updates `CHANGELOG.md`.
   - **no changie:** derive from conventional commits, or take the dispatch
     input. Say which you chose.
3. Write the version to wherever the project keeps it (`package.json`,
   `pyproject.toml`, `gradle.properties`, a `version.txt`) — one source of truth,
   never two.
4. Commit the version bump and changelog, tag `vX.Y.Z`, push both.
5. Build the artifact.
6. Create the GitHub Release with the changelog section as the body.
7. Publish to the registry, if there is one.

Requirements:
- `permissions: contents: write` on this workflow only.
- Publish credentials from OIDC where the registry supports it, otherwise a
  repository secret. Never a personal token in plain config.
- The whole thing must be re-runnable: if step 6 fails, re-running must not
  create a second tag.
- Dry-run mode as a dispatch input, defaulting to true the first few times.

## Review mode

If workflows already exist, don't rewrite them. Report:
- What's missing against the lists above.
- Anything unpinned, over-permissioned, or leaking secrets to forks.
- Anything slow that caching would fix.

Then propose the smallest change that closes the biggest gap, and stop.
