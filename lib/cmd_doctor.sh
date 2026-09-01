#!/usr/bin/env bash
# klaus doctor — verify the installation

cmd_doctor() {
  local dest fail=0
  dest="$(claude_dir)"

  head1 "Checking $dest"

  check() {
    if [ -e "$1" ]; then ok "$2"; else warn "missing: $2"; fail=1; fi
  }

  check "$dest/CLAUDE.md"          "CLAUDE.md"
  check "$dest/rules"              "rules/"
  check "$dest/standards"          "standards/"
  check "$dest/skills"             "skills/"
  check "$dest/agents"             "agents/"
  check "$dest/settings.json"      "settings.json"

  head1 "Skills"
  local s n=0
  for s in "$dest"/skills/*/SKILL.md; do
    [ -e "$s" ] || continue
    n=$((n+1))
    if head -n 1 "$s" | grep -q '^---$'; then
      ok "/$(basename "$(dirname "$s")")"
    else
      warn "/$(basename "$(dirname "$s")") — frontmatter must start on line 1"
      fail=1
    fi
  done
  [ "$n" -eq 0 ] && { warn "no skills found"; fail=1; }

  head1 "Agents"
  for s in "$dest"/agents/*.md; do
    [ -e "$s" ] || continue
    if grep -q '^name:' "$s" && grep -q '^description:' "$s"; then
      ok "$(basename "$s" .md)"
    else
      warn "$(basename "$s") — needs both name and description in frontmatter"
      fail=1
    fi
  done

  head1 "Context cost"
  if [ -f "$dest/CLAUDE.md" ]; then
    local lines; lines=$(wc -l < "$dest/CLAUDE.md" | tr -d ' ')
    if [ "$lines" -gt 200 ]; then
      warn "CLAUDE.md is $lines lines — over 200 hurts adherence, move detail into a skill"
    else
      ok "CLAUDE.md $lines lines"
    fi
  fi
  if [ -d "$dest/rules" ]; then
    local total; total=$(cat "$dest"/rules/*.md 2>/dev/null | wc -l | tr -d ' ')
    info "rules/ $total lines (loaded every session)"
  fi

  head1 "Settings"
  if command -v python3 >/dev/null 2>&1 && [ -f "$dest/settings.json" ]; then
    if python3 -c "import json,sys;json.load(open(sys.argv[1]))" "$dest/settings.json" 2>/dev/null; then
      ok "settings.json is valid JSON"
    else
      warn "settings.json is not valid JSON"; fail=1
    fi
  fi
  [ -f "$dest/settings.json.klaus-new" ] && \
    warn "settings.json.klaus-new is waiting to be merged"

  say ""
  if [ "$fail" = 0 ]; then
    ok "All good. Run /context inside Claude Code to confirm what actually loaded."
  else
    warn "Some checks failed. 'klaus install' will repair the missing pieces."
    return 1
  fi
}
