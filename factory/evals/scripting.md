# scripting

### C1: Bash backup script
Prompt: Write a Bash script that copies every `*.md` file from a folder given as the first argument into `<folder>/backup-<yyyymmdd>/`, and prints how many files it copied. Then give its test plan.
Checks:
- Starts with `#!/usr/bin/env bash` and `set -euo pipefail`
- Every variable expansion holding a path is double-quoted
- Exits with a non-zero code and a usage message on stderr when no argument is given
- Handles a folder with no `.md` files without failing (e.g. `nullglob` or a guarded loop)
- The test plan has at least one edge case with an expected result

### C2: Python observer hook
Prompt: Write a Python Claude Code hook for the `Stop` event that appends `{"ts", "session_id", "cwd"}` as one JSON line to `log/stops.jsonl` next to the script. Then give its test plan.
Checks:
- Reads the event as JSON from stdin
- Uses only the standard library
- Wraps the work so malformed input or a write error still exits 0 and prints nothing
- Builds the log path from the script's own location, not the current directory
- Logs no prompt or message content
- The test plan pipes a sample event and a malformed input, each with an expected result

### C3: When not to script
Prompt: An agent keeps needing the list of skill names in `skills/*/SKILL.md`. Should we add a script for it? Answer in 3 lines.
Checks:
- Recommends not writing a script (an existing tool such as Glob/Grep, or a one-line command, is enough)
- Gives the one-line alternative
