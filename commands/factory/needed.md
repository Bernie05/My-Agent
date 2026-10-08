---
description: "Factory: build the approved rows of factory/NEEDED.md (agent feedback you reviewed) - create, fix, update or remove skills, agents and commands, security-reviewed"
argument-hint: "[--pr] [--root <path>] [N-ids]"
---

Process the review queue. Arguments: $ARGUMENTS

## Setup
- **Root** = `--root <path>` if given (the weekly routine passes its clone of My-Agent), else `~/.claude`. Every path below is under Root.
- **Mode**: `--pr` (weekly routine) works on a branch and opens a pull request; otherwise edit in place, show the diff, and ask before committing or pushing.
- `--pr` only: if an open pull request whose branch starts with `factory/needed-` already exists, stop and report its number. Its rows are still waiting for the user's merge.
- Read `factory/NEEDED.md`. Take rows with Status `approved` (only the listed N-ids, if given), oldest first, **at most 5** per run; the rest stay `approved` for next time. None → report "nothing approved" and stop (no branch, no PR).
- `--pr`: create branch `factory/needed-<yyyy-mm-dd>` from the default branch.

## The factory
Use the **agent-factory** agent. If that agent type isn't available (a cloud routine on a clone), spawn a general-purpose agent whose prompt starts: "Act as the agent defined in `<Root>/agents/factory/agent-factory.md`; read it first, then its preloaded skills from `<Root>/skills/<name>/SKILL.md`. The toolkit root is `<Root>`, not `~/.claude`; Anthropic catalogs under `plugins/` are not available. Use only Read, Grep, Glob, Write, Edit, WebSearch and WebFetch; never run shell commands."

## Per row
1. Map the row to an operation, passing the row's Evidence and **Your notes** as the need:
   - `need` → **create-skill** or **create-command**; `fix`, `stale`, `context` → **improve** on the Target; `remove` → **review** the Target, and have it list every file that preloads, loads or mentions it.
2. The factory returns a `PROPOSAL`. The user approved the row, not this exact plan, so build it only if all hold:
   - it stays within the row's Target (plus wiring lines in agents that use it), and
   - its security verdict is `SAFE` or `SAFE WITH CHANGES` with the fixes in the proposal, and
   - it installs nothing, clones nothing, and doesn't touch `settings.json`, hooks or `.mcp.json`.

   Then call the factory with operation **build** and `APPROVED: pre-approved via NEEDED.md <ID>. <notes>` plus the proposal. Otherwise don't build: set Status `failed: needs your review - <reason>` (or `needs-laptop: <install/clone needed>`) and put the proposal in the report.
3. `remove`: after the review, back up the target to `factory/backups/` (in place mode), delete it with `git rm`, and remove the lines that referenced it.
4. **Check:** every agent's `skills:` entries exist under `skills/`, every file the change names exists, and no `.env`, key or credential file is staged. Fix or mark the row `failed`.
5. Set the row's Status to `done` (or `failed: …` / `needs-laptop: …`). The factory adds the `factory/REGISTRY.md` row.

## Finish
- `--pr`: commit on the branch (`factory: build NEEDED <IDs>`), push it, and open a pull request to the default branch. Body: one line per row (ID · type · target · result · files changed · security verdict), then the `failed` / `needs-laptop` rows with their proposals. Never merge it yourself.
- In place: show the diff summary and ask before committing or pushing.

Report (10 lines max): rows done / failed / waiting, the PR link, and anything that needs the user.
