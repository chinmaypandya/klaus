#!/usr/bin/env bash
# klaus init — scaffold the project-side artifacts in the current repo

cmd_init() {
  local force="skip" target="."
  while [ $# -gt 0 ]; do
    case "$1" in
      --force) force="force" ;;
      -*) die "init: unknown option $1" ;;
      *) target="$1" ;;
    esac
    shift
  done

  local root; root="$(klaus_root)"
  [ -d "$target" ] || die "no such directory: $target"
  cd "$target" || die "cannot enter $target"

  head1 "Scaffolding project artifacts in $(pwd)"

  if [ ! -d .git ]; then
    warn "not a git repository — continuing anyway"
  fi

  run mkdir -p docs/decisions docs/specs/_templates

  local f rel
  while IFS= read -r f; do
    rel="${f#"$root/templates/project/"}"
    write_file "$rel" "$force" < "$f"
  done < <(find "$root/templates/project" -type f | sort)

  # Only project-specific things belong in the repo. Nothing from templates/global
  # is copied here — that is the whole point of the split.
  head1 "Next"
  cat <<'MSG'
  In Claude Code, just say what you want:   /klaus let's build <feature>
  It detects new vs. continuing work and drives requirements → LLD → HLD →
  plan → implement automatically, one step at a time.

  To jump into one phase directly instead: /spec, /lld, /hld, /plan, /implement.

  Edit docs/conventions.md only for rules unique to THIS repo. Anything reusable
  belongs in ~/.claude/standards/.
MSG
}
