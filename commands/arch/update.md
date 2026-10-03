---
description: "Architect: log completed or blocked work and update progress"
argument-hint: "[feature] <task id + status, e.g. F1 done>"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Do this **directly, without spawning an agent** (token-efficiency), for: $ARGUMENTS

Edit the Status line of each named task in its task file; update the progress line, the Sections table (a section is ✅ when all its tasks are done and its scenarios have passed) and Blockers in PROJECT_CONTEXT.md; append `<timestamp> | <who> | <what>` to activity.log. Reply with the new progress in 2 lines.
