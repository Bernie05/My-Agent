# Quality rubric (improve and organize)

Load this only for the **improve** and **organize** operations. Score each item against every row. A row that fails becomes a finding in the form `file:line - issue - fix`.

## 1. Per-item checks (agents, skills, commands)
| # | Check | Fails when |
|---|---|---|
| Q1 | Description picks the item | It doesn't say **what** and **when**, or a stack-specific skill has no "Use ONLY when…" |
| Q2 | Least privilege | An agent has no `tools:` line, has `*`, or lists a tool its body never uses |
| Q3 | Right model | `opus` for routine work, or `sonnet`/`haiku` for security or final verdicts |
| Q4 | Lean preload | `skills:` has more than `token-efficiency` (+ `ponytail` for coding agents) + 2, or preloads something only some runs need |
| Q5 | Progressive disclosure | SKILL.md is over ~150 lines, or holds long checklists/templates that belong in sibling files |
| Q6 | Structure | An agent body is missing its role line, operations, rules or a **Report back** block of 15 lines or fewer |
| Q7 | Thin command | A command holds logic that belongs in its agent, or uses `allowed-tools`/`!` lines without a justifying comment |
| Q8 | Clear instructions | The steps are vague ("handle appropriately"), contradict each other, or have no stop condition |
| Q9 | Security | Anything from `security-checklist.md` section A or B |
| Q10 | Pointers, not pastes | It pastes large content that a path or ID would replace |
| Q11 | Ponytail wiring | A coding agent doesn't preload `ponytail`; a code-guiding skill never points to the ladder at its build decisions; a command that runs a coding agent doesn't accept and pass `ponytail: lite\|ultra\|off` |

## 2. Improve: what "better" means
An improved version must:
- keep the original's purpose and every capability the user relies on (list them first, then check each one survives)
- fix every failed row above
- cost the same or fewer always-on tokens (description plus preloaded skills), unless a fix needs more; say why when it does
- match the house style (`SKILL.md` in this folder)

Write a short diff summary: `kept | removed | added | fixed`, one line each.

## 3. Organize: whole-setup checks
Inventory `agents/**/*.md`, `skills/*/SKILL.md` and `commands/**/*.md` by Grep on `name:`/`description:`, never by reading every file whole.

| # | Check | Finding |
|---|---|---|
| O1 | Duplicates / overlap | Two items whose descriptions cover the same job → merge one into the other or split their "when" lines apart |
| O2 | Broken links | A command names an agent or operation that doesn't exist; an agent preloads a missing skill; a file path in a body doesn't exist |
| O3 | Orphans | An agent no command or other agent uses (flag, don't delete: the user may call it directly); a skill nothing preloads or mentions |
| O4 | Grouping | An agent outside `agents/<group>/`, a command outside `commands/<group>/`, or a group holding unrelated items |
| O5 | Naming | Not lowercase-kebab, or a name that doesn't match the file/folder name |
| O6 | Always-on cost | The descriptions that are longest: list the top 5 with a shorter rewrite |
| O7 | Per-item quality | Run section 1 on each item, but only read the files that the Grep pass flags (missing `tools:`, long files, and so on) |

## 4. Organize: outputs
1. `factory/CATALOG.md`: one table per type (`Name | Group | What / when (short) | Used by`), rewritten each run.
2. `factory/organize/PLAN-<yyyyMMdd>.md`: findings ranked most useful first, each with a concrete action:
   - **edit**: the exact change (you may apply these only in the **organize-apply** operation)
   - **move / rename / delete**: the source and target paths, for the main session to run after the user approves (you have no shell)
