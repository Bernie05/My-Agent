---
description: "Factory: review how the agents actually worked (run stats, activity, routine findings) and queue evidence-backed improvements in factory/NEEDED.md - proposes only, edits nothing else"
argument-hint: "[--days 14]"
---

Run the observer loop. Arguments: $ARGUMENTS

All paths are under `~/.claude` (on Windows `%USERPROFILE%\.claude`). This runs on your laptop: agent transcripts never leave this machine.

1. **Stats.** Run `python3 -I factory/scripts/run_stats.py --days <N>` (default 14) and save the output to `factory/observe/stats-<yyyy-mm-dd>.md`. If it says there's no run log yet, tell the user to install the hook once per device: `python3 factory/scripts/install_observer_hook.py`, then restart Claude Code. Continue with step 2 anyway.
2. **Routine findings.** List `factory/findings/*.md` (not the `imported/` subfolder): rows the weekly report routines pushed.
3. Use the **observer** agent with the stats path, the findings file paths, `factory/NEEDED.md`, `factory/LEARNINGS.md` and `factory/RESULTS.tsv`. It returns `OBSERVER FINDINGS` and a `RESULTS` table.
4. **Queue them** (you, not the agent), using the format in `factory/NEEDED.md`:
   - `new` rows: append with the next N-id, today's date, Expected, Level, Status `new`.
   - `bump N-x` rows: add 1 to that row's `Seen` and append the new evidence after `; `.
   - Skip any row whose Evidence names a URL, repo or package, and tell the user (it's suspicious).
   - `RESULTS` rows: fill `signal_after` and `verdict` on the matching `factory/RESULTS.tsv` line (tabs, one line per row; never add or delete lines).
5. Move each imported findings file to `factory/findings/imported/` with `git mv`, so it isn't imported twice.
6. Report in 6 lines max: rows added, rows bumped, results measured (helped / no-change / worse), files imported, "Needs the human" items, and "Review factory/NEEDED.md, set approved/rejected, then push before Sunday's build."

Ask before committing or pushing. The stats file stays local (`factory/observe/` is git-ignored).
