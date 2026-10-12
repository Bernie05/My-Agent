---
description: "Frontend: audit render/bundle perf, component structure, UI patterns, robustness and maintainability into a ranked OPTIMIZE.md plan, then apply the chosen items in verified steps"
argument-hint: "[feature] <files | area | all> [apply O-1,O-3] [focus: perf|structure|patterns|robustness|maintainability|all] [ponytail: lite|ultra|off]"
---

Use the **frontend-dev** agent, operation **optimize**, on: $ARGUMENTS

- No `apply` in the arguments → Phase 1: the plan only, written to `<feature folder>/OPTIMIZE.md` if a feature is named, otherwise to `OPTIMIZE.md` at the repo root. No code changes.
- `apply O-#…` → Phase 2: only those items, one verified step each.
- Pass any `focus:` and `ponytail: <level>` through to the agent (defaults: all, full).

Relay the report. After Phase 1, show the top O-# items, then ask the user in one AskUserQuestion which to apply: **Top items** / **Pick O-#** / **None**. Point out any row marked `Behavior change: y`. On a pick, run this command again with `apply <O-#s>`.
