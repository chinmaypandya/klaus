#!/usr/bin/env bash
# klaus uninstall — remove what klaus installed, leave everything else

cmd_uninstall() {
  local dest stamp backup
  dest="$(claude_dir)"
  stamp="$(date +%Y%m%d-%H%M%S)"
  backup="$dest/.klaus-backup-$stamp"

  head1 "Removing klaus files from $dest"
  say "  This removes CLAUDE.md, rules/, standards/, skills/ and agents/."
  say "  They are copied to $backup first."
  say "  settings.json and everything else is left alone."
  say ""

  confirm "Continue?" || { say "Cancelled."; return 0; }

  local item
  for item in CLAUDE.md rules standards skills agents; do
    backup_path "$dest/$item" "$backup"
  done
  ok "done — backup at $backup"
}
