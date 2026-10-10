# Needed: toolkit improvement queue

Rows come from three sources: agents' own `FEEDBACK:` blocks (queued by the main session), the `observer` (`/factory:observe`, from run stats), and the weekly report routines (imported from `factory/findings/`). **You review it**, and the weekly routine (`/factory:needed`) builds only the rows you mark `approved`, then opens a pull request for you to merge.

## How to review
1. Read each `new` row. Edit the Evidence or add **Your notes** (what you want, constraints, "merge into X", …). You can also add your own rows: Type, Target and Evidence are enough.
2. Set **Status** to `approved` or `rejected`.
3. Commit and push `~/.claude` before the weekly run (`git add factory/NEEDED.md && git commit -m "needed: review" && git push`).

## Columns
- **Type**: `need` (missing skill/command) · `fix` (wrong instruction) · `stale` (outdated) · `remove` (unused or duplicate) · `context` (info an agent keeps rediscovering)
- **Target**: `skill <name> [§section]`, `agent <name>`, or `command <group:name>`
- **Seen**: how many runs reported it; repeats are the strongest signal
- **Status**: `new` → you set `approved` / `rejected` → the routine sets `done`, `failed: <reason>` or `needs-laptop: <why>` (e.g. a plugin install) **inside its pull request**. Merging makes it final; closing the PR unmerged leaves the rows `approved` for the next run. While a routine PR is open, the next run waits.

The routine never touches `new` or `rejected` rows, and never deletes without an `approved` `remove` row.

## Queue
| ID | Date | Type | Target | Evidence | From | Seen | Status | Your notes |
|---|---|---|---|---|---|---|---|---|
