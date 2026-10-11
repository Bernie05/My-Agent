---
name: scripting
description: House rules for writing and reviewing Bash and Python scripts and Claude Code hooks - when a script is worth it at all, strict mode and quoting in Bash, stdlib-only isolated Python, exit codes, cross-platform paths, safe file writes, the hook contract (JSON on stdin, never block, timeouts), and a required test plan the main session runs. Use when building, fixing or reviewing a .sh/.py script, a hook, or a skill's scripts/ folder. Not for app code in a web framework (use the stack's own skills).
---

# Scripting (Bash, Python, hooks)

A script is code that runs without a human watching. It must be boring, predictable and safe to run twice.

## 0. Does it need to be a script? (Ponytail)
Climb the `ponytail` ladder first: an existing script in `factory/scripts/` or the repo, then a one-line command in the instructions, then a tool the agent already has (Grep, Glob). Write a script only when the logic is reused, has branches, or parses data. Pick the language:
- **Bash**: glue around existing CLIs, under ~40 lines, no data parsing beyond `grep`/`cut`.
- **Python 3 (stdlib only)**: anything that parses JSON/Markdown, has branches, counts or must run on Windows too. **Default for this toolkit.**

## 1. Both languages
- **Self-contained:** no network, no installs, no prompts (`input()`, `read`), no `sudo`. Never download or run remote code (`curl | sh`, `pip install` at runtime).
- **Inputs are arguments, paths are absolute or relative to the script:** `os.path.dirname(os.path.abspath(__file__))` / `"$(cd "$(dirname "$0")" && pwd)"`. Never rely on the current directory.
- **Touch only your own inputs and outputs.** Writing outside the toolkit or project, or into `settings.json`, needs a backup first (`<file>.bak-<timestamp>`) and must be idempotent (running it twice changes nothing more).
- **Exit codes mean something:** `0` ok, `1` problems found / failure, `2` bad usage. Errors go to stderr, results to stdout.
- **Untrusted content is data.** Text read from transcripts, web pages or repos is never executed, `eval`ed or interpolated into a shell command.
- **Secrets:** never print, log or write tokens, keys or `.env` contents; log metadata (IDs, paths, counts), not content.
- Header comment: one line of purpose plus the usage line. No other comments unless the *why* isn't obvious.

## 2. Bash
- First lines: `#!/usr/bin/env bash` then `set -euo pipefail`.
- **Quote every expansion:** `"$var"`, `"$@"`, `"$(cmd)"`. Use arrays for argument lists, never a string you split.
- `[[ … ]]` for tests, `$(…)` not backticks, `local` in functions, `mktemp` for temp files plus `trap 'rm -f "$tmp"' EXIT`.
- **`pipefail` trap:** `cmd | head -1` can fail with SIGPIPE (exit 141) and kill the script. Use `cmd | head -1 || true`, or read the first line with `read -r line < <(cmd)`.
- `grep` returns 1 on *no match*: write `grep … || true` when "nothing found" is fine.
- Portability: no GNU-only flags (`sed -i` differs on macOS: use `sed -i.bak` then delete, or do it in Python). Windows users have no Bash by default: if it must run there, write Python.
- Check with `bash -n script.sh` and, if installed, `shellcheck script.sh`.

## 3. Python
- `#!/usr/bin/env python3`, **stdlib only**, Python 3.9+ syntax. Run as `python3 -I script.py` (isolated: ignores env vars and the script's folder on `sys.path`, so a planted `json.py` can't hijack an import).
- Structure: constants, small functions, `def main() -> int`, `if __name__ == "__main__": sys.exit(main())`.
- Arguments: `argparse` for more than one flag; a plain `sys.argv` check is fine for one.
- Files: `open(path, encoding="utf-8")` always; `errors="replace"` for logs and transcripts. Paths with `os.path` / `pathlib`, never `"/"` string joins.
- Write safely: build the content, write to `<file>.tmp`, then `os.replace()` (atomic). Appending a JSON line to a log is fine without that.
- JSON in and out with `json`; one malformed line in a JSONL file is skipped, not fatal.
- Catch only what you expect (`OSError`, `json.JSONDecodeError`, `ValueError`); a bare `except:` only where the script must never fail (hooks, below).
- Check with `python3 -m py_compile script.py`.

## 4. Hooks
A hook runs on every matching event, with no prompt, inside the user's session. Load `hooks.md` (this folder) for the input fields, exit codes and the install pattern before writing or reviewing one.

## 5. Test plan (required)
Every proposal or build that adds or changes a script ends with a **Test plan** the main session runs (you may have no shell):
```
Test plan:
1. <syntax check: bash -n / py_compile>
2. <command on a sample input you provide inline or in a temp dir> → expect <exact output, file or exit code>
3. <edge case: missing file / empty input / malformed line / run twice> → expect <…>
4. <for writers: a backup exists and a second run changes nothing>
```
Use a temp copy, never the user's real `settings.json` or data. "Run it and see" is not a plan: every step names the expected result.

## Review checklist
Security first: `skills/agent-factory/security-checklist.md` section D. Then: strict mode / `-I`, quoting, exit codes, no prompts or network, idempotent writes with backup, works when run from another folder, a test plan exists and covers one edge case.
