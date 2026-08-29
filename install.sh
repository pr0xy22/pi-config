#!/usr/bin/env bash
#
# pi-config installer — the AI learning system for pi
#
#   Local:   ./install.sh [/path/to/learning-project]   (default: cwd)
#   Remote:  curl -fsSL <RAW_GITHUB_URL>/install.sh | bash -s -- [/path/to/project]
#
set -euo pipefail

# ── set this after creating the GitHub repo, e.g.
# ── REPO="https://github.com/YOURUSER/pi-config"
REPO="${PI_CONFIG_REPO:-https://github.com/pr0xy22/pi-config}"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

# ── locate the payload: beside this script, or download the repo ────────────
SRC="$(cd "$(dirname "${BASH_SOURCE[0]:-/dev/null}")" 2>/dev/null && pwd || true)"
if [[ -z "${SRC}" || ! -d "${SRC}/project" ]]; then
  [[ -n "${REPO}" ]] || die "remote install needs REPO set — edit install.sh or use git clone"
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  info "Downloading ${REPO}"
  curl -fsSL "${REPO}/archive/refs/heads/main.tar.gz" | tar -xz -C "$TMP" --strip-components=1
  SRC="$TMP"
fi

TARGET="${1:-$PWD}"
[[ -d "$TARGET" ]] || die "target project '$TARGET' does not exist — create it first"

command -v pi >/dev/null 2>&1 || die "pi is not installed — see https://github.com/earendil-works/pi"

# ── project config → <target>/.pi ───────────────────────────────────────────
info "Installing project config into $TARGET/.pi"
mkdir -p "$TARGET/.pi"
cp -R "$SRC/project/"* "$TARGET/.pi/"

# ── global extensions/skills → ~/.pi/agent ──────────────────────────────────
info "Installing global extensions into ~/.pi/agent/extensions"
mkdir -p "$HOME/.pi/agent/extensions"
cp -R "$SRC/global/extensions/"* "$HOME/.pi/agent/extensions/"

info "Installing global skills into ~/.pi/agent/skills"
mkdir -p "$HOME/.pi/agent/skills"
cp -R "$SRC/global/skills/"* "$HOME/.pi/agent/skills/"

# ── shared skills → ~/.agents/skills ────────────────────────────────────────
info "Installing shared skills into ~/.agents/skills"
mkdir -p "$HOME/.agents/skills"
cp -R "$SRC/shared-skills/"* "$HOME/.agents/skills/"

# ── extension dependencies ──────────────────────────────────────────────────
if [[ -f "$TARGET/.pi/extensions/visual-tools/package.json" ]]; then
  info "Installing visual-tools dependencies"
  (cd "$TARGET/.pi/extensions/visual-tools" && npm install)
fi

# ── agent settings (never clobber an existing setup) ────────────────────────
if [[ ! -f "$HOME/.pi/agent/settings.json" ]]; then
  info "Installing example agent settings (no existing settings.json found)"
  cp "$SRC/agent/settings.example.json" "$HOME/.pi/agent/settings.json"
  cp "$SRC/agent/models.example.json" "$HOME/.pi/agent/models.json"
else
  info "Keeping your existing ~/.pi/agent/settings.json"
  info "  → merge the \"packages\" list from agent/settings.example.json if you want the same extensions"
fi

cat <<EOF

Done. Open pi in $TARGET and everything loads:
  quiz + ask-user-question tools, md-log session mirroring (/md-log <file>),
  teach/visualize skills, researcher & visual subagents.
EOF
