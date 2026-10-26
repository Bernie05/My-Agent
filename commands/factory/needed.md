---
description: "Factory: build the approved rows of factory/NEEDED.md (agent feedback you reviewed) - create, fix, update or remove skills, agents and commands, security-reviewed, file-guarded and eval-gated"
argument-hint: "[--pr] [--root <path>] [N-ids]"
---

Process the review queue. Arguments: $ARGUMENTS

The gate, learnings log and results file follow the loop from [auto-harness](https://github.com/neosigmaai/auto-harness) (MIT): one hypothesis per change, never skip the gate, record every attempt.

## Setup
- **Root** = `--root <path>` if given (the weekly routine passes its clone of My-Agent), else `~/.claude`. Every path below is under Root.
- **Mode**: `--pr` (weekly routine) works on a branch and opens a pull request; otherwise edit in place, show the diff, and ask before committing or pushing.
- `--pr` only: if an open pull request whose branch starts with `factory/needed-` already exists, stop and report its number. Its rows are still waiting for the user's merge.
- Read `factory/NEEDED.md` and its **Autonomy** line. Take rows with Status `approved`, plus (only in `bounded` mode) `new` rows that meet every `bounded` condition in that file. Only the listed N-ids, if given. Oldest first, **at most 5** per run; the rest wait. None → report "nothing to build" and stop (no branch, no PR).
- Skip any row whose Type + Target has 3 `failed ✗` entries in `factory/LEARNINGS.md`: set it to `parked` instead (3 strikes).
- `--pr`: create branch `factory/needed-<yyyy-mm-dd>` from the default branch.

## The factory
Use the **agent-factory** agent. If that agent type isn't available (a cloud routine on a clone), spawn a general-purpose agent whose prompt starts: "Act as the agent defined in `<Root>/agents/factory/agent-factory.md`; read it first, then its preloaded skills from `<Root>/skills/<name>/SKILL.md`. The toolkit root is `<Root>`, not `~/.claude`; Anthropic catalogs under `plugins/` are not available. Use only Read, Grep, Glob, Write, Edit, WebSearch and WebFetch; never run shell commands; never read `factory/evals/held-out/`."

## Per row (one row = one hypothesis; finish it before the next)
1. Map the row to an operation, passing the row's Evidence, **Expected** and **Your notes** as the need. If the row needs **probing** (`factory/evals/README.md` → Probing: Level L2+, an earlier `failed ✗` in LEARNINGS, or `probe` in Your notes), add `PROBE` to the call so the proposal includes an Alternative B:
   - `need` → **create-skill** or **create-command**; `fix`, `stale`, `context` → **improve** on the Target; `remove` → **review** the Target, and have it list every file that preloads, loads or mentions it.
2. The factory returns a `PROPOSAL`. The user approved the row, not this exact plan, so build it only if all hold:
   - it stays within the row's Target (plus wiring lines in agents that use it), and
   - its security verdict is `SAFE` or `SAFE WITH CHANGES` with the fixes in the proposal, and
   - it installs nothing, clones nothing, and doesn't touch `settings.json`, hooks or `.mcp.json`.

   Then call the factory with operation **build** and `APPROVED: pre-approved via NEEDED.md <ID>. <notes>` plus the proposal. **Probed row:** build `CANDIDATE: A` and `CANDIDATE: B` one after the other as that README describes, test both, keep the winner, then continue with step 3 on the winner only. Otherwise don't build: set Status `failed: needs your review - <reason>` (or `needs-laptop: <install/clone needed>`) and put the proposal in the report.
3. `remove`: after the review, back up the target to `factory/backups/` (in place mode), delete it with `git rm`, and remove the lines that referenced it.
4. **File guard:** list what this row changed. Before step 1 take a snapshot: `git stash create` (a commit of the working tree; prints nothing when it's clean, then use `HEAD`) and `git ls-files --others --exclude-standard`. Now: `git diff --name-only <snapshot>` plus untracked files not in the old list. Allowed: the files of the proposal's Items and Wiring, plus `factory/REGISTRY.md`, `factory/backups/`, `CATALOG.md`, `README.md` and `docs/AGENT-SYSTEM.md`. Any other path → revert this row's changes (`git checkout -- <paths>`, delete new files) and set Status `failed: file guard - <paths>`.
5. **Skill tests:** if the row changed a skill with `factory/evals/<skill>.md` or `factory/evals/held-out/<skill>.md`, run both sets as `factory/evals/README.md` describes (old vs new, blind grader). Lower score on either set, or any lost check → revert that skill's change and set Status `failed: regression - <lost checks>`. Put `seen x/y · held-out x/y` (old → new) in the report.
   **Script tests:** if the row added or changed a script or hook, run the proposal's Test plan (temp copies only). Any failed step → revert that change and set Status `failed: test plan - <step>`.
6. **Check:** run `python3 -I <Root>/factory/scripts/check.py <Root>` (counts, docs, tools lines, preloaded skills, skill sizes, links) and confirm no `.env`, key or credential file is staged. Fix what it reports, or mark the row `failed`.
7. **Promote:** if a `fix`, `stale` or `context` row on a skill passed, try to add one eval case from its Evidence (`factory/evals/README.md` → Growing the suite).
8. Set the row's Status to `done` (or `failed: …` / `needs-laptop: …` / `parked`). The factory adds the `factory/REGISTRY.md` row.
9. **Record, pass or fail:**
   - Append a `factory/LEARNINGS.md` entry (format in that file), with the `**Probe:**` line for probed rows.
   - `done` only: append a line to `factory/RESULTS.tsv` with `signal` = the row's Expected, `signal_before` = the evidence count it was raised on (e.g. "re-read in 5/7 runs"), `signal_after` empty, verdict `pending`. The commit is filled in after committing (`--pr`: the branch commit).

## Finish
- `--pr`: commit on the branch (`factory: build NEEDED <IDs>`), push it, and open a pull request to the default branch. Body: one line per row (ID · type · level · target · result · files changed · security verdict · eval score old → new, and for probed rows A vs B and which won), then the `failed` / `needs-laptop` / `parked` rows with their proposals, and which rows came in through `bounded` autonomy. Never merge it yourself.
- In place: show the diff summary and ask before committing or pushing.

Report (10 lines max): rows done / failed / parked / waiting, the PR link, and anything that needs the user.
