# PLAN.md template (quick team: plan-lite)

One file replaces SPEC.md, analysis.md, scenarios.md, the three task files and PROJECT_CONTEXT.md. Keep it under ~120 lines. If it won't fit, the project isn't simple: say so in the report and recommend `/quick:upgrade`.

```markdown
# <Project> — Plan
Status: Draft | Approved (<date>)   Team: quick   Design: none | frontend
Phase: plan | build | check | deploy | done | stopped      Last updated: <timestamp>
Deploy: — | preview <url> | production <url> | skipped | n/a

## Goal
<1-3 lines: who uses it and what they can do>

## Requirements
- R1 <one line, testable>
## Out of scope / later

## Tech stack
<frontend, backend, database, UI library, test runner, from the request or the repo; unknowns → Open questions>

## Data model
<entity: fields (type, required, unique)>, only what the requirements need

## API contract
| Method | Path | Request | Response | Errors |
|---|---|---|---|---|

## Tasks
| ID | Task | Owner | Reqs | Depends on | Status |
|---|---|---|---|---|---|
| B1 | <one line> | backend | R1 | — | ⏳ / 🔄 / ✅ / ⛔ |
| F1 | <one line> | frontend | R1 | B1 (mock until ready) | ⏳ |

## Key scenarios (3-6, used for the final check)
SC-1 <name>: <step> → <step> → expected: <result>

## Open questions
## Log
<YYYY-MM-DD HH:MM | who | action>
```

## Rules
- Every requirement maps to at least one task and one scenario.
- Small tasks, 1–8 in total. More than 8 tasks, several user roles, payments or complex auth: recommend `/quick:upgrade` in the report.
- The API contract is the handshake between the devs, so write it exactly.
- Ponytail: spec only what was asked. Anything else goes under Out of scope.
