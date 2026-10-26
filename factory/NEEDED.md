# Needed: toolkit improvement queue

Rows come from three sources: agents' own `FEEDBACK:` blocks (queued by the main session), the `observer` (`/factory:observe`, from run stats), and the weekly report routines (imported from `factory/findings/`). **You review it**, and the weekly routine (`/factory:needed`) builds only the rows you mark `approved` (plus, in `bounded` mode, the narrow cases below), then opens a pull request for you to merge.

**Autonomy: proposal**
- `proposal` (default): only rows you mark `approved` are built.
- `bounded`: also builds `new` rows that are **all** of: Type `fix`, `stale` or `context` · Level `L1` · Target is one skill that has an eval file · Seen ≥ 3 · never `rejected` or `parked` before. Everything else stays proposal-only. The result is still a pull request you merge.

Levels adapted from [autoharness](https://github.com/kayba-ai/autoharness) (MIT). Change the line above to switch; nothing else reads a different place.

## How to review
1. Read each `new` row. Edit the Evidence or add **Your notes** (what you want, constraints, "merge into X", …). You can also add your own rows: Type, Target and Evidence are enough.
2. Set **Status** to `approved` or `rejected`.
3. Commit and push `~/.claude` before the weekly run (`git add factory/NEEDED.md && git commit -m "needed: review" && git push`).

## Columns
- **Type**: `need` (missing skill/command) · `fix` (wrong instruction) · `stale` (outdated) · `remove` (unused or duplicate) · `context` (info an agent keeps rediscovering)
- **Target**: `skill <name> [§section]`, `agent <name>`, or `command <group:name>`
- **Expected**: the hypothesis: which signal should change and how (e.g. "backend-dev stops re-reading db/migrations/README.md"; "api-design eval C3 passes"). One hypothesis per row.
- **Level**: `L1` wording or context inside one skill · `L2` a skill's structure or a new reference file · `L3` an agent's tools, model or wiring, or a new skill or command · `L4` a new agent, a removal, scripts or hooks
- **Seen**: how many runs reported it; repeats are the strongest signal
- **Status**: `new` → you set `approved` / `rejected` → the routine sets `done`, `failed: <reason>`, `needs-laptop: <why>` (e.g. a plugin install) or `parked` (failed 3 times, see `factory/LEARNINGS.md`) **inside its pull request**. Merging makes it final; closing the PR unmerged leaves the rows `approved` for the next run. While a routine PR is open, the next run waits.

The routine never touches `rejected` or `parked` rows, never builds `new` rows outside `bounded` mode, and never deletes without an `approved` `remove` row.

## Related files
- `factory/LEARNINGS.md`: one entry per row worked on, pass or fail (the factory's memory, 3-strike rule).
- `factory/RESULTS.tsv`: one line per built row, so you can see whether it **helped**. Columns: `date id type target level commit evals_before evals_after signal signal_before signal_after verdict`. `/factory:needed` fills everything up to `signal_before` and sets verdict `pending`; `/factory:observe` fills `signal_after` and the verdict (`helped`, `no-change`, `worse`) once the line is 14+ days old and the agent or skill has had 3+ runs since.

## Queue
| ID | Date | Type | Target | Evidence | Expected | Level | From | Seen | Status | Your notes |
|---|---|---|---|---|---|---|---|---|---|---|
| N-1 | 2026-10-16 | context | agent fullstack-dev | iRent: had to rediscover that `docs/` is git-ignored (no docs changes in `git status`); a note in PROJECT_CONTEXT.md or the agent prompt would save the check | fullstack-dev stops checking git status for docs changes | L1 | fullstack-dev (irent-app) | 1 | new | |
| N-2 | 2026-10-16 | fix | agent fullstack-dev | iRent (Windows): Bash heredocs with JSX template literals failed twice ("unexpected EOF while looking for matching quote"); a Node script written with Write worked. Suggest: use Write/Edit for multi-line code edits on Windows | fullstack-dev stops retrying failed heredoc appends | L1; again 2026-10-16 (rates follow-up: every multi-line edit routed via Node scripts) | fullstack-dev (irent-app) | 2 | new | |
| N-3 | 2026-10-19 | fix | skill neon-postgres | iRent (Supabase → Neon migration plan): the skill says Neon Auth is "skipped by default" and has no section on it, so server-side user creation, reset links and the JWT key (JWKS) endpoint had to go into task B50 as open questions | architect/backend-dev plan Neon Auth tasks from the skill without spike questions | L2 | architect (irent-app) | 1 | new | |
