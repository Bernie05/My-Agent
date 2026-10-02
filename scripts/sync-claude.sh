#!/usr/bin/env bash
# Sync this repo's Claude Code agents, skills, and commands to a target:
#   user mode    -> ~/.claude/            (every project on this device)
#   project mode -> <project>/.claude/    (one project, committed with it)
#
# Usage (run from anywhere; the toolkit repo is found from the script path):
#   sync-claude.sh                     # user mode: pull, audit, symlink everything
#   sync-claude.sh --project [DIR]     # project mode (DIR defaults to $PWD):
#                                      #   pick items on first run, then re-sync
#   sync-claude.sh --project --select  # re-open the picker to change the selection
#   sync-claude.sh --project --all     # select everything, no picker
#
# Options:
#   --copy | --link   install mode (user default: link; project default: copy)
#   --dry-run         show what would change, change nothing
#   --no-pull         skip `git pull` of the toolkit repo
#   --uninstall       remove everything this script installed in the target
#
# Selection: if <target>/sync.list exists, only the items listed there are
# synced (one "kind/name" per line, # comments allowed). Unlisted items that
# were synced before are removed. Commit sync.list in a project so every
# device and teammate gets the same set.
#
# Safety: the prompt-injection audit must pass before anything is installed.
# Only items recorded in the target's manifest are ever changed or removed;
# an unmanaged item with the same name, or a synced copy that was edited
# locally, is backed up as *.bak-<timestamp> before being replaced.
# settings.json and CLAUDE.md are never synced.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/.claude"
KINDS=(agents skills commands)

target="user"
project_dir=""
mode=""
dry_run=false
do_pull=true
uninstall=false
select_items=false
select_all=false

usage() { sed -n '2,28p' "$0" | sed 's/^# \{0,1\}//'; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      target="project"
      if [[ $# -gt 1 && "$2" != --* ]]; then
        project_dir="$2"
        shift
      fi
      ;;
    --select) select_items=true ;;
    --all) select_all=true ;;
    --copy) mode="copy" ;;
    --link) mode="link" ;;
    --dry-run) dry_run=true ;;
    --no-pull) do_pull=false ;;
    --uninstall) uninstall=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

log()  { printf '%s\n' "$*"; }
warn() { printf 'warning: %s\n' "$*" >&2; }
die()  { printf 'error: %s\n' "$*" >&2; exit 1; }

# Run a mutating command, or just print it in --dry-run mode.
run() {
  if $dry_run; then
    printf '[dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

# --- Resolve target directory and install mode -------------------------------

if [[ "$target" == "project" ]]; then
  project_dir="${project_dir:-$PWD}"
  [[ -d "$project_dir" ]] || die "project directory not found: $project_dir"
  project_dir="$(cd "$project_dir" && pwd)"
  # Syncing into the toolkit repo itself would overwrite the source of truth.
  [[ "$project_dir" != "$REPO_ROOT" ]] || die "target is the toolkit repo itself; run this from your project's root"
  DEST="$project_dir/.claude"
  # Project files are committed to the project, so default to real copies:
  # a symlink would point at this repo's path on this machine only.
  mode="${mode:-copy}"
  if [[ "$mode" == "link" ]]; then
    warn "--link in a project: symlinks only resolve on this machine; teammates and other devices will get broken links"
  fi
else
  DEST="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
  mode="${mode:-link}"
fi

# Symlinks on Git Bash / MSYS silently become copies or fail without
# Developer Mode, so always copy there.
case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*)
    if [[ "$mode" == "link" ]]; then mode="copy"; fi ;;
esac

MANIFEST="$DEST/.my-agent-sync-manifest"
SELECTION="$DEST/sync.list"

# --- Helpers ----------------------------------------------------------------

# All installable items as "kind/name" (agents and commands are *.md files,
# skills are directories containing SKILL.md).
list_available() {
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

# Items listed in the selection file (comments and blank lines stripped).
read_selection() {
  sed -e 's/#.*//' -e 's/[[:space:]]*$//' -e '/^$/d' "$SELECTION"
}

# One short description per item for the picker, from its frontmatter.
describe() {
  local file="$SRC/$1"
  [[ -d "$file" ]] && file="$file/SKILL.md"
  # Handles both `description: text` and a YAML block on the following lines.
  awk '/^description:/ { sub(/^description:[[:space:]]*/, ""); if ($0 != "") { print; exit } next_line = 1; next }
       next_line { sub(/^[[:space:]]+/, ""); print; exit }' "$file" | tr -d "\"'" | cut -c1-60
}

# Content hash of an installed file or directory, used to detect local edits.
hash_item() {
  local path="$1"
  if [[ -d "$path" ]]; then
    (cd "$path" && find . -type f -print0 | LC_ALL=C sort -z | xargs -0 sha256sum) | sha256sum | cut -d' ' -f1
  else
    sha256sum "$path" | cut -d' ' -f1
  fi
}

# Manifest lines are "kind/name<TAB>hash" (hash is "-" for symlinks).
manifest_items() {
  if [[ -f "$MANIFEST" ]]; then cut -f1 "$MANIFEST"; fi
}

manifest_hash() {
  if [[ -f "$MANIFEST" ]]; then
    awk -F'\t' -v item="$1" '$1 == item { print $2 }' "$MANIFEST"
  fi
}

is_managed() {
  [[ -f "$MANIFEST" ]] && awk -F'\t' -v item="$1" '$1 == item { found = 1 } END { exit !found }' "$MANIFEST"
}

# True if $1 is one of the remaining arguments. (A loop, not `printf | grep -q`:
# under pipefail, grep exiting early can SIGPIPE the writer and report false.)
contains() {
  local needle="$1" x
  shift
  for x in "$@"; do [[ "$x" == "$needle" ]] && return 0; done
  return 1
}

backup() {
  local path="$1" backup_path
  backup_path="$path.bak-$(date +%Y%m%d%H%M%S)"
  run mv -- "$path" "$backup_path"
  printf '%s' "$(basename "$backup_path")"
}

# --- Picker -----------------------------------------------------------------

# Interactive checklist. Reads from the terminal when there is one (so it works
# even when stdin is redirected), otherwise from stdin.
pick_items() {
  local -a available=("$@") chosen=()
  local i item input tok
  local -A on=()

  if [[ -f "$SELECTION" ]]; then
    while IFS= read -r item; do on["$item"]=1; done < <(read_selection)
  else
    for item in "${available[@]}"; do on["$item"]=1; done
  fi

  local in_fd=0
  if { exec 3</dev/tty; } 2>/dev/null; then in_fd=3; fi

  while true; do
    printf '\nSelect what to sync into %s\n' "$DEST" >&2
    for i in "${!available[@]}"; do
      item="${available[$i]}"
      printf '  %2d) [%s] %-42s %s\n' "$((i + 1))" "$([[ -n "${on[$item]:-}" ]] && echo x || echo ' ')" \
        "$item" "$(describe "$item")" >&2
    done
    printf '\nToggle numbers (e.g. "1 3 5-8"), a = all, n = none, d = done, q = quit: ' >&2
    if ! IFS= read -r -u "$in_fd" input; then
      die "no input for the picker (no terminal?); re-run in a terminal, or use --all / edit $SELECTION"
    fi

    case "$input" in
      d|D|"") break ;;
      q|Q) die "cancelled; nothing changed" ;;
      a|A) for item in "${available[@]}"; do on["$item"]=1; done ;;
      n|N) on=() ;;
      *)
        for tok in $input; do
          local lo hi n
          if [[ "$tok" =~ ^([0-9]+)-([0-9]+)$ ]]; then
            lo="${BASH_REMATCH[1]}"; hi="${BASH_REMATCH[2]}"
          elif [[ "$tok" =~ ^[0-9]+$ ]]; then
            lo="$tok"; hi="$tok"
          else
            warn "ignoring '$tok'"; continue
          fi
          for ((n = lo; n <= hi; n++)); do
            if (( n < 1 || n > ${#available[@]} )); then warn "no item $n"; continue; fi
            item="${available[$((n - 1))]}"
            if [[ -n "${on[$item]:-}" ]]; then unset 'on[$item]'; else on["$item"]=1; fi
          done
        done
        ;;
    esac
  done

  for item in "${available[@]}"; do
    if [[ -n "${on[$item]:-}" ]]; then chosen+=("$item"); fi
  done
  SELECTED=("${chosen[@]}")
  write_selection "${chosen[@]}"
}

write_selection() {
  if $dry_run; then
    log "[dry-run] would write selection ($# items) to $SELECTION"
    return
  fi
  mkdir -p "$DEST"
  {
    echo "# Items synced from the My-Agent toolkit by scripts/sync-claude.sh."
    echo "# Edit by hand or re-run with --select. Remove a line to stop syncing it."
    printf '%s\n' "$@"
  } > "$SELECTION"
  log "Saved selection ($# items) to $SELECTION"
}

# --- Install / remove -------------------------------------------------------

remove_item() {
  local item="$1" path="$DEST/$1" recorded
  [[ -L "$path" || -e "$path" ]] || return 0
  recorded="$(manifest_hash "$item")"
  if [[ ! -L "$path" && -n "$recorded" && "$recorded" != "-" && "$(hash_item "$path")" != "$recorded" ]]; then
    log "  kept     $item (edited locally; backed up as $(backup "$path"))"
  else
    run rm -rf -- "$path"
    log "  removed  $item"
  fi
}

# Installs one item and prints its manifest line on fd 4.
install_item() {
  local item="$1" src="$SRC/$1" path="$DEST/$1" recorded

  if [[ "$mode" == "link" && -L "$path" && "$(readlink "$path")" == "$src" ]]; then
    log "  ok       $item"
    printf '%s\t-\n' "$item" >&4
    return
  fi
  if [[ "$mode" == "copy" && -e "$path" && ! -L "$path" ]] && is_managed "$item" \
     && [[ "$(hash_item "$path")" == "$(hash_item "$src")" ]]; then
    log "  ok       $item"
    printf '%s\t%s\n' "$item" "$(hash_item "$src")" >&4
    return
  fi

  if [[ -L "$path" || -e "$path" ]]; then
    recorded="$(manifest_hash "$item")"
    if ! is_managed "$item"; then
      warn "$item exists and is not managed by this script; backed up as $(backup "$path")"
    elif [[ ! -L "$path" && -n "$recorded" && "$recorded" != "-" && "$(hash_item "$path")" != "$recorded" ]]; then
      warn "$item was edited locally; backed up as $(backup "$path") before updating"
    else
      run rm -rf -- "$path"
    fi
  fi

  if [[ "$mode" == "link" ]]; then
    run ln -s -- "$src" "$path"
    log "  linked   $item"
    printf '%s\t-\n' "$item" >&4
  else
    run cp -R -- "$src" "$path"
    log "  copied   $item"
    printf '%s\t%s\n' "$item" "$(hash_item "$src")" >&4
  fi
}

uninstall_all() {
  [[ -f "$MANIFEST" ]] || { log "Nothing to uninstall (no manifest at $MANIFEST)."; return; }
  log "Removing items installed from $REPO_ROOT:"
  local item
  while IFS= read -r item; do
    if [[ -n "$item" ]]; then remove_item "$item"; fi
  done < <(manifest_items)
  run rm -f -- "$MANIFEST"
  if [[ -f "$SELECTION" ]]; then log "Kept $SELECTION (delete it if you no longer want it)."; fi
}

# --- Main -------------------------------------------------------------------

main() {
  if $uninstall; then
    uninstall_all
    return
  fi

  if $do_pull; then
    log "Pulling latest toolkit changes..."
    if ! git -C "$REPO_ROOT" pull --ff-only; then
      warn "git pull failed (local changes or diverged branch); syncing the current checkout"
    fi
  fi

  # Security gate: never install toolkit files with unreviewed audit findings.
  if [[ -f "$SRC/scripts/audit.py" ]]; then
    log "Auditing toolkit for prompt-injection red flags..."
    if command -v python3 >/dev/null 2>&1; then
      python3 "$SRC/scripts/audit.py" || die "audit found unreviewed findings; nothing was installed. Review them first (see .claude/README.md)."
    else
      warn "python3 not found; skipping the security audit"
    fi
  fi

  local -a available=()
  mapfile -t available < <(list_available)
  [[ ${#available[@]} -gt 0 ]] || die "nothing to install under $SRC"

  # Decide the selection: picker, everything, saved list, or (user mode) all.
  SELECTED=()
  if $select_all; then
    SELECTED=("${available[@]}")
    write_selection "${available[@]}"
  elif $select_items || [[ "$target" == "project" && ! -f "$SELECTION" ]]; then
    if [[ ! -t 0 && ! -r /dev/tty ]] && ! $select_items; then
      die "no $SELECTION yet and no terminal for the picker; re-run with --all or --select"
    fi
    pick_items "${available[@]}"
  elif [[ -f "$SELECTION" ]]; then
    mapfile -t SELECTED < <(read_selection)
  else
    SELECTED=("${available[@]}")   # user mode without a list: sync everything
  fi

  # Drop entries that no longer exist in the toolkit.
  local -a items=()
  local item
  for item in "${SELECTED[@]}"; do
    if contains "$item" "${available[@]}"; then
      items+=("$item")
    else
      warn "$item is in the selection but not in the toolkit; skipping"
    fi
  done

  log "Syncing ${#items[@]} of ${#available[@]} items to $DEST (mode: $mode)"
  local kind
  for kind in "${KINDS[@]}"; do run mkdir -p -- "$DEST/$kind"; done

  # Collect new manifest lines on fd 4 while installing.
  local new_manifest
  new_manifest="$(mktemp)"
  exec 4>"$new_manifest"
  for item in "${items[@]}"; do install_item "$item"; done
  exec 4>&-

  # Remove previously synced items that are deselected or gone from the toolkit.
  while IFS= read -r item; do
    [[ -z "$item" ]] && continue
    if ! contains "$item" "${items[@]}"; then
      remove_item "$item"
    fi
  done < <(manifest_items)

  if $dry_run; then
    log "[dry-run] would write manifest $MANIFEST"
    rm -f "$new_manifest"
  else
    mv "$new_manifest" "$MANIFEST"
  fi

  if [[ "$target" == "project" ]]; then
    log "Done. Commit .claude/ (including sync.list) in $project_dir to share this setup."
  else
    log "Done. Restart Claude Code (or open /agents) to load the changes."
  fi
}

main
