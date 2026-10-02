#!/usr/bin/env bash
# Sync this repo's Claude Code agents, skills, and commands into ~/.claude/
# so they are available in every project on this device.
#
# The repo is the source of truth. Run after cloning, and again after pulls:
#   ./scripts/sync-claude.sh            # git pull, audit, then symlink (default)
#   ./scripts/sync-claude.sh --copy     # copy instead of symlink (Windows / no symlinks)
#   ./scripts/sync-claude.sh --dry-run  # show what would change, change nothing
#   ./scripts/sync-claude.sh --no-pull  # skip `git pull`
#   ./scripts/sync-claude.sh --uninstall
#
# Only items this script installed are ever modified or removed (tracked in a
# manifest). Your own agents/skills/commands in ~/.claude/ are left alone;
# a name clash with an unmanaged item is backed up before being replaced.
# Project-only files (.claude/settings.json, CLAUDE.md) are never installed.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/.claude"
DEST="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
MANIFEST="$DEST/.my-agent-sync-manifest"
KINDS=(agents skills commands)

mode="link"
dry_run=false
do_pull=true
uninstall=false

usage() { sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//'; }

for arg in "$@"; do
  case "$arg" in
    --copy) mode="copy" ;;
    --link) mode="link" ;;
    --dry-run) dry_run=true ;;
    --no-pull) do_pull=false ;;
    --uninstall) uninstall=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; usage >&2; exit 2 ;;
  esac
done

# Symlinks on Git Bash / MSYS silently become copies or fail without
# Developer Mode, so default to copy mode there.
case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*)
    if [[ "$mode" == "link" ]]; then mode="copy"; fi ;;
esac

log()  { printf '%s\n' "$*"; }
warn() { printf 'warning: %s\n' "$*" >&2; }

# Run a mutating command, or just print it in --dry-run mode.
run() {
  if $dry_run; then
    printf '[dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

# Items to install, as "kind/name" (agents and commands are *.md files,
# skills are directories).
list_sources() {
  local kind path
  for kind in "${KINDS[@]}"; do
    [[ -d "$SRC/$kind" ]] || continue
    if [[ "$kind" == "skills" ]]; then
      for path in "$SRC/$kind"/*/; do
        if [[ -f "$path/SKILL.md" ]]; then
          printf '%s/%s\n' "$kind" "$(basename "$path")"
        fi
      done
    else
      for path in "$SRC/$kind"/*.md; do
        if [[ -f "$path" ]]; then
          printf '%s/%s\n' "$kind" "$(basename "$path")"
        fi
      done
    fi
  done
}

# True if $1 was installed by this script (listed in the manifest).
is_managed() {
  [[ -f "$MANIFEST" ]] && grep -Fxq "$1" "$MANIFEST"
}

remove_item() {
  local item="$1" target="$DEST/$1"
  if [[ -L "$target" || -e "$target" ]]; then
    run rm -rf -- "$target"
    log "  removed  $item"
  fi
}

install_item() {
  local item="$1" src="$SRC/$1" target="$DEST/$1"

  # Already a symlink to the right place: nothing to do.
  if [[ "$mode" == "link" && -L "$target" && "$(readlink "$target")" == "$src" ]]; then
    log "  ok       $item"
    return
  fi

  if [[ -L "$target" || -e "$target" ]]; then
    if is_managed "$item"; then
      run rm -rf -- "$target"
    else
      local backup
      backup="$target.bak-$(date +%Y%m%d%H%M%S)"
      warn "$item exists and is not managed by this script; backing up to $(basename "$backup")"
      run mv -- "$target" "$backup"
    fi
  fi

  if [[ "$mode" == "link" ]]; then
    run ln -s -- "$src" "$target"
    log "  linked   $item"
  else
    run cp -R -- "$src" "$target"
    log "  copied   $item"
  fi
}

uninstall_all() {
  if [[ ! -f "$MANIFEST" ]]; then
    log "Nothing to uninstall (no manifest at $MANIFEST)."
    return
  fi
  log "Removing items installed from $REPO_ROOT:"
  local item
  while IFS= read -r item; do
    if [[ -n "$item" ]]; then remove_item "$item"; fi
  done < "$MANIFEST"
  run rm -f -- "$MANIFEST"
}

main() {
  if $uninstall; then
    uninstall_all
    return
  fi

  if $do_pull; then
    log "Pulling latest changes..."
    if ! git -C "$REPO_ROOT" pull --ff-only; then
      warn "git pull failed (local changes or diverged branch); syncing the current checkout"
    fi
  fi

  # Security gate: never install toolkit files with unreviewed audit findings.
  if [[ -f "$SRC/scripts/audit.py" ]]; then
    log "Auditing toolkit for prompt-injection red flags..."
    if command -v python3 >/dev/null 2>&1; then
      if ! python3 "$SRC/scripts/audit.py"; then
        echo "error: audit found unreviewed findings; nothing was installed. Review them first (see .claude/README.md)." >&2
        exit 1
      fi
    else
      warn "python3 not found; skipping the security audit"
    fi
  fi

  local items=()
  mapfile -t items < <(list_sources)
  if [[ ${#items[@]} -eq 0 ]]; then
    echo "error: nothing to install under $SRC" >&2
    exit 1
  fi

  log "Syncing ${#items[@]} items to $DEST (mode: $mode)"
  local kind
  for kind in "${KINDS[@]}"; do
    run mkdir -p -- "$DEST/$kind"
  done

  local item
  for item in "${items[@]}"; do
    install_item "$item"
  done

  # Prune items removed from the repo since the last sync.
  if [[ -f "$MANIFEST" ]]; then
    while IFS= read -r item; do
      [[ -z "$item" ]] && continue
      if ! printf '%s\n' "${items[@]}" | grep -Fxq "$item"; then
        remove_item "$item"
      fi
    done < "$MANIFEST"
  fi

  if $dry_run; then
    log "[dry-run] would write manifest $MANIFEST"
  else
    printf '%s\n' "${items[@]}" > "$MANIFEST"
  fi

  log "Done. Restart Claude Code (or open /agents) to load the changes."
}

main
