#!/usr/bin/env bash
# klaus lang <name> — add a language standards file from the template

cmd_lang() {
  local name="${1:-}"
  [ -n "$name" ] || die "usage: klaus lang <language>   (e.g. klaus lang go)"

  local root dest file
  root="$(klaus_root)"
  dest="$(claude_dir)/standards"
  file="$dest/$(printf '%s' "$name" | tr '[:upper:]' '[:lower:]').md"

  [ -d "$dest" ] || die "standards directory not found — run 'klaus install' first"

  if [ -e "$file" ]; then
    warn "$file already exists"
    say "  Open it, or ask Claude: /conventions $name"
    return 0
  fi

  head1 "Adding $name standard"

  if [ "$DRY_RUN" = 1 ]; then
    info "would create $file from _template.md"
    return 0
  fi

  # Substitute the name and drop the template's own instruction block, which is
  # guidance for whoever copies the file, not guidance for Claude.
  mkdir -p "$dest"
  awk -v lang="$name" '
    /^> / { next }
    { gsub(/<Language>/, lang); print }
  ' "$root/templates/global/standards/_template.md" \
    | cat -s > "$file"

  ok "created $file"

  say ""
  say "  Fill it in by hand, or let Claude infer it from an existing repo:"
  say "    cd <repo> && claude"
  say "    /conventions $name"
}
