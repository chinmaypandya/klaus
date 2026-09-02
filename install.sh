#!/usr/bin/env bash
# Bootstrap installer for klaus.
#
#   curl -fsSL https://raw.githubusercontent.com/<you>/klaus/main/install.sh | bash
#
# Clones (or updates) the repo into ~/.klaus, installs the global Claude Code
# setup into ~/.claude, and puts the `klaus` command on your PATH.
#
# Environment:
#   KLAUS_REPO      git URL to clone           (default: the GitHub repo above)
#   KLAUS_HOME      where to keep the clone    (default: ~/.klaus)
#   KLAUS_BIN       where to link `klaus`      (default: ~/.local/bin)
#   KLAUS_REF       branch or tag to check out (default: main)
#   KLAUS_MODE      link | copy                (default: link)

set -euo pipefail

KLAUS_REPO="${KLAUS_REPO:-https://github.com/<you>/klaus.git}"
KLAUS_HOME="${KLAUS_HOME:-$HOME/.klaus}"
KLAUS_BIN="${KLAUS_BIN:-$HOME/.local/bin}"
KLAUS_REF="${KLAUS_REF:-main}"
KLAUS_MODE="${KLAUS_MODE:-link}"

red()  { printf '\033[31m%s\033[0m\n' "$*" >&2; }
grn()  { printf '\033[32m%s\033[0m\n' "$*"; }
bld()  { printf '\n\033[1m%s\033[0m\n' "$*"; }
die()  { red "error: $*"; exit 1; }

command -v git >/dev/null 2>&1 || die "git is required"

bld "klaus installer"

if [ -d "$KLAUS_HOME/.git" ]; then
  echo "  updating $KLAUS_HOME"
  git -C "$KLAUS_HOME" fetch --quiet origin "$KLAUS_REF"
  git -C "$KLAUS_HOME" checkout --quiet "$KLAUS_REF"
  git -C "$KLAUS_HOME" pull --quiet --ff-only origin "$KLAUS_REF"
elif [ -f "${BASH_SOURCE[0]:-}" ] && [ -f "$(dirname "${BASH_SOURCE[0]}")/bin/klaus" ]; then
  # Running from a local checkout or an unpacked zip: use it in place.
  KLAUS_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  echo "  using local checkout at $KLAUS_HOME"
else
  echo "  cloning $KLAUS_REPO"
  git clone --quiet --depth 1 --branch "$KLAUS_REF" "$KLAUS_REPO" "$KLAUS_HOME"
fi

chmod +x "$KLAUS_HOME/bin/klaus" "$KLAUS_HOME/install.sh" \
         "$KLAUS_HOME/scripts/validate.py" 2>/dev/null || true

mkdir -p "$KLAUS_BIN"
ln -sf "$KLAUS_HOME/bin/klaus" "$KLAUS_BIN/klaus"
grn "  linked $KLAUS_BIN/klaus"

"$KLAUS_HOME/bin/klaus" install "--$KLAUS_MODE"

# --- put KLAUS_BIN on PATH permanently -------------------------------------
# Editing someone's shell profile is intrusive, so this is idempotent, marked,
# and skippable with KLAUS_NO_PATH=1.

PATH_MARKER="# added by the klaus installer"

manual_path_note() {
  bld "One more step"
  echo "  $KLAUS_BIN is not on your PATH. Add this to your shell profile:"
  echo ""
  echo "    export PATH=\"\$PATH:$KLAUS_BIN\""
}

wire_path() {
  # Already on PATH: nothing to do.
  case ":$PATH:" in
    *":$KLAUS_BIN:"*) echo "  $KLAUS_BIN already on PATH"; return 0 ;;
  esac

  if [ "${KLAUS_NO_PATH:-0}" = 1 ]; then
    manual_path_note
    return 0
  fi

  local shell_name profile line
  shell_name="$(basename "${SHELL:-bash}")"

  case "$shell_name" in
    zsh)
      profile="${ZDOTDIR:-$HOME}/.zshrc"
      line="export PATH=\"\$PATH:$KLAUS_BIN\""
      ;;
    bash)
      # macOS login shells read .bash_profile; Linux reads .bashrc.
      if [ "$(uname -s)" = "Darwin" ] && [ -f "$HOME/.bash_profile" ]; then
        profile="$HOME/.bash_profile"
      else
        profile="$HOME/.bashrc"
      fi
      line="export PATH=\"\$PATH:$KLAUS_BIN\""
      ;;
    fish)
      profile="$HOME/.config/fish/config.fish"
      line="fish_add_path $KLAUS_BIN"
      ;;
    *)
      manual_path_note
      return 0
      ;;
  esac

  if [ -f "$profile" ] && grep -qF "$PATH_MARKER" "$profile"; then
    grn "  $profile already wired"
    PROFILE_TOUCHED="$profile"
    return 0
  fi

  mkdir -p "$(dirname "$profile")"
  printf '\n%s\n%s\n' "$PATH_MARKER" "$line" >> "$profile"
  grn "  added $KLAUS_BIN to PATH in $profile"
  PROFILE_TOUCHED="$profile"
}

PROFILE_TOUCHED=""
bld "PATH"
wire_path

bld "Installed"
echo "  klaus --help      what you can do"
echo "  klaus doctor      verify it took"
echo "  cd <repo> && klaus init"

if [ -n "$PROFILE_TOUCHED" ]; then
  echo ""
  echo "  A script cannot change the PATH of the shell that launched it, so"
  echo "  either open a new terminal or run:"
  echo ""
  echo "    source $PROFILE_TOUCHED"
fi
