#!/usr/bin/env bash
# Shared helpers. Sourced by bin/klaus; not executable on its own.

KLAUS_VERSION="0.1.0"

# Colours only when attached to a terminal.
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  C_DIM=$'\033[2m'; C_RED=$'\033[31m'; C_GRN=$'\033[32m'
  C_YEL=$'\033[33m'; C_BLD=$'\033[1m'; C_OFF=$'\033[0m'
else
  C_DIM=""; C_RED=""; C_GRN=""; C_YEL=""; C_BLD=""; C_OFF=""
fi

DRY_RUN=${DRY_RUN:-0}

say()   { printf '%s\n' "$*"; }
head1() { printf '\n%s%s%s\n' "$C_BLD" "$*" "$C_OFF"; }
ok()    { printf '  %s✓%s %s\n' "$C_GRN" "$C_OFF" "$*"; }
info()  { printf '  %s·%s %s\n' "$C_DIM" "$C_OFF" "$*"; }
warn()  { printf '  %s!%s %s\n' "$C_YEL" "$C_OFF" "$*" >&2; }
die()   { printf '%serror:%s %s\n' "$C_RED" "$C_OFF" "$*" >&2; exit 1; }

# run <cmd...> — honours DRY_RUN
run() {
  if [ "$DRY_RUN" = 1 ]; then printf '  %swould:%s %s\n' "$C_DIM" "$C_OFF" "$*"; return 0; fi
  "$@"
}

# Where the templates live, resolved from this file's location.
klaus_root() {
  local src="${BASH_SOURCE[0]}" dir
  while [ -L "$src" ]; do
    dir="$(cd -P "$(dirname "$src")" && pwd)"
    src="$(readlink "$src")"
    case "$src" in /*) ;; *) src="$dir/$src" ;; esac
  done
  cd -P "$(dirname "$src")/.." && pwd
}

claude_dir() { printf '%s' "${CLAUDE_CONFIG_DIR:-$HOME/.claude}"; }

# backup_path <path> <backup-dir> — move an existing path aside
backup_path() {
  local path="$1" backup="$2"
  [ -e "$path" ] || [ -L "$path" ] || return 0
  run mkdir -p "$backup"
  run cp -R "$path" "$backup/"
  run rm -rf "$path"
  [ "$DRY_RUN" = 1 ] || info "backed up $(basename "$path")"
}

# write_file <dest> <mode: skip|force> — reads content from stdin
# skip:  leave an existing file alone
# force: overwrite
write_file() {
  local dest="$1" mode="${2:-skip}" content
  content="$(cat)"
  if [ -e "$dest" ] && [ "$mode" = skip ]; then
    info "kept $dest (already exists)"
    return 0
  fi
  if [ "$DRY_RUN" = 1 ]; then
    printf '  %swould write:%s %s\n' "$C_DIM" "$C_OFF" "$dest"; return 0
  fi
  mkdir -p "$(dirname "$dest")"
  printf '%s\n' "$content" > "$dest"
  ok "wrote $dest"
}

# copy_tree <src> <dest> <link|copy>
copy_tree() {
  local src="$1" dest="$2" mode="${3:-copy}"
  [ -e "$src" ] || die "missing template: $src"
  if [ "$mode" = link ]; then
    run ln -s "$src" "$dest"
    [ "$DRY_RUN" = 1 ] || ok "linked $dest -> $src"
  else
    mkdir -p "$(dirname "$dest")" 2>/dev/null || true
    run cp -R "$src" "$dest"
    [ "$DRY_RUN" = 1 ] || ok "installed $dest"
  fi
}

confirm() {
  [ "${ASSUME_YES:-0}" = 1 ] && return 0
  [ -t 0 ] || return 0
  local reply
  printf '%s [y/N] ' "$1"
  read -r reply
  case "$reply" in [yY]*) return 0 ;; *) return 1 ;; esac
}
