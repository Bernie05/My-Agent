# Claude Code hooks: the contract

Load this when writing, installing or reviewing a hook. Check the current Claude Code hooks docs when a detail matters; field names can change between versions.

## How a hook runs
- Configured in `settings.json` under `"hooks"`: `{ "<Event>": [ { "matcher": "<tool pattern, for tool events>", "hooks": [ { "type": "command", "command": "...", "timeout": 5 } ] } ] }`.
- The event's data arrives as **one JSON object on stdin**. Common fields: `session_id`, `transcript_path`, `cwd`, `hook_event_name`; tool events add `tool_name` and `tool_input`; subagent events add `agent_id` and `agent_type`. Read only the fields you need, with `.get()`: a missing field is normal, not an error.
- **Exit codes:** `0` = fine (stdout may be shown or used, depending on the event). `2` = **block**: stderr is fed back to Claude, and on `PreToolUse` the tool call is stopped. Any other code = non-blocking error shown to the user.
- `PreToolUse` can also allow, deny or ask by printing a JSON decision on stdout; use that only when the hook's job is to gate tools.

## Rules for this toolkit
- **Observers never block.** A logging or stats hook wraps everything in `try/except`, prints nothing, and always exits `0`. Mark it `"async": true` so it never slows the session. (House example: `factory/scripts/log_run.py`.)
- **Gates block on purpose only.** A hook that stops an action exits `2` with a one-line reason on stderr that tells Claude what to do instead.
- **Fast:** set an explicit small `timeout` (seconds). No network, no heavy imports, no scanning whole folders on every event.
- **Local and minimal data:** write under the toolkit (`factory/observe/`, git-ignored) and log metadata only (IDs, paths, names), never prompt or file content.
- **Point to the script with an absolute path** and the interpreter that will exist (`sys.executable` when an installer writes the entry). Never `cd` in the command.
- **Install with a script, never by hand-editing:** back up `settings.json`, merge (keep every other setting and hook), skip if already present, and offer `--uninstall` that removes only its own entry. (House example: `factory/scripts/install_observer_hook.py`.) Agents never install hooks: the main session runs the installer after the user approves.

## Test plan for a hook
1. Pipe a sample event into it: `echo '{"hook_event_name":"Stop","session_id":"t1","cwd":"/tmp"}' | python3 -I hook.py; echo "exit=$?"` → expected exit code and output file line.
2. Malformed input: `echo 'not json' | python3 -I hook.py` → still exit `0` for observers, nothing printed.
3. Installer on a **temp** config dir (`CLAUDE_CONFIG_DIR=$(mktemp -d)`): install twice → one entry, one backup per run, other keys untouched; `--uninstall` → only its entry removed.
