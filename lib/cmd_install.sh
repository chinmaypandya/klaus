#!/usr/bin/env bash
# klaus install — write the global setup into ~/.claude

cmd_install() {
  local mode="copy" root dest backup stamp
  while [ $# -gt 0 ]; do
    case "$1" in
      --link) mode="link" ;;
      --copy) mode="copy" ;;
      *) die "install: unknown option $1" ;;
    esac
    shift
  done

  root="$(klaus_root)"
  dest="$(claude_dir)"
  stamp="$(date +%Y%m%d-%H%M%S)"
  backup="$dest/.klaus-backup-$stamp"

  head1 "Installing global setup"
  info "source: $root/templates/global"
  info "target: $dest"
  info "mode:   $mode"

  run mkdir -p "$dest"

  local item
  for item in CLAUDE.md rules standards skills agents; do
    backup_path "$dest/$item" "$backup"
    copy_tree "$root/templates/global/$item" "$dest/$item" "$mode"
  done

  # settings.json is never clobbered: it is yours, and merging JSON blind is worse
  # than making you do it.
  if [ -e "$dest/settings.json" ]; then
    run cp "$root/templates/global/settings.json" "$dest/settings.json.klaus-new"
    warn "settings.json exists — wrote settings.json.klaus-new beside it to merge by hand"
  else
    copy_tree "$root/templates/global/settings.json" "$dest/settings.json" copy
  fi

  [ -d "$backup" ] && info "backups in $backup"

  head1 "Next"
  cat <<'MSG'
  1. Restart Claude Code. A running session will not see new directories.
  2. /context  — CLAUDE.md and rules should appear under "Memory files".
  3. /skills   — spec, lld, hld, plan, implement, journal, conventions, ship.
  4. Edit ~/.claude/standards/<language>.md to match how you actually work.
  5. In a repo: klaus init
MSG
}
