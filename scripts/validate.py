#!/usr/bin/env python3
"""Validate every SKILL.md and agent file in templates/global.

Checks that frontmatter starts on line 1, parses as YAML, carries the required
keys, and uses only fields Claude Code recognises. Run from the repo root.
"""

from __future__ import annotations

import pathlib
import sys

import yaml

SKILL_FIELDS = {
    "name", "description", "when_to_use", "argument-hint", "arguments",
    "disable-model-invocation", "user-invocable", "allowed-tools",
    "disallowed-tools", "model", "effort", "context", "agent", "background",
    "hooks", "paths", "shell", "metadata", "license", "compatibility",
}
AGENT_FIELDS = {
    "name", "description", "tools", "disallowedTools", "model", "permissionMode",
    "maxTurns", "skills", "mcpServers", "hooks", "memory", "background", "effort",
    "isolation", "color", "initialPrompt", "experimental",
}

ROOT = pathlib.Path(__file__).resolve().parent.parent
GLOBAL = ROOT / "templates" / "global"


def check(path: pathlib.Path, allowed: set[str], required: set[str]) -> list[str]:
    """Return a list of problems found in one frontmatter block."""
    rel = path.relative_to(ROOT)
    text = path.read_text()
    if not text.startswith("---\n"):
        return [f"{rel}: frontmatter must start on line 1"]
    try:
        front = yaml.safe_load(text.split("---\n")[1]) or {}
    except yaml.YAMLError as exc:
        return [f"{rel}: frontmatter is not valid YAML — {exc}"]

    problems = []
    for key in sorted(required - set(front)):
        problems.append(f"{rel}: missing required field '{key}'")
    for key in sorted(set(front) - allowed):
        problems.append(f"{rel}: unknown field '{key}'")
    for key in ("argument-hint", "description", "name"):
        if key in front and not isinstance(front[key], str):
            problems.append(
                f"{rel}: '{key}' parsed as {type(front[key]).__name__}, not a string "
                "— quote the value"
            )
    return problems


def main() -> int:
    problems: list[str] = []
    checked = 0

    for skill in sorted(GLOBAL.glob("skills/*/SKILL.md")):
        checked += 1
        problems += check(skill, SKILL_FIELDS, {"name", "description"})

    for agent in sorted(GLOBAL.glob("agents/*.md")):
        checked += 1
        problems += check(agent, AGENT_FIELDS, {"name", "description"})

    claude_md = GLOBAL / "CLAUDE.md"
    lines = len(claude_md.read_text().splitlines())
    if lines > 200:
        problems.append(f"CLAUDE.md is {lines} lines; keep it under 200")

    for problem in problems:
        print(f"FAIL {problem}", file=sys.stderr)

    if problems:
        print(f"\n{len(problems)} problem(s) in {checked} file(s)", file=sys.stderr)
        return 1

    print(f"OK  {checked} files valid, CLAUDE.md {lines} lines")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
