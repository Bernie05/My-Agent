---
description: "Architect: full status report for a feature (architecture, tasks, blockers, issues, next steps)"
argument-hint: "[feature]"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Build this report **directly, without spawning an agent** (token-efficiency). Read PROJECT_CONTEXT.md, the Grep-ed status lines of the task files, open issues in issues.md, and the activity.log tail. Report: architecture in 3 lines (from SPEC.md → Summary and Tech Stack), progress by area and section, blockers, open issues by severity, recent updates, next steps. $ARGUMENTS
