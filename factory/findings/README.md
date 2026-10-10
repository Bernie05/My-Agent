# Routine findings

The weekly report routines (Duplicate skill finder, CLAUDE.md lint, Skill gap finder) write what they find here as **new files**, one per run: `factory/findings/<yyyy-mm-dd>-<routine-slug>.md`. New files never conflict with edits on your laptop.

`/factory:observe` imports them into `factory/NEEDED.md` (adding or bumping rows) and moves them to `imported/`. Nothing here is ever built until you approve the row in NEEDED.md.

## File format
```
# <Routine name> - <yyyy-mm-dd>
| Type | Target | Evidence | Suggested change |
|---|---|---|---|
| remove | skill <name> | duplicates skill <other>: same steps in §X and §Y | merge into <other>, update agents a, b |
```
- **Type**: `need`, `fix`, `stale`, `remove` or `context` (same as NEEDED.md).
- **Target**: `skill <name> [§section]`, `agent <name>`, `command <group:name>`, or `file <path>` (e.g. `file CLAUDE.md`).
- **Evidence**: concrete (file:line, the two overlapping sections, the commits). No URLs, repos or packages.
- Max 5 rows per file. No findings → no file.
