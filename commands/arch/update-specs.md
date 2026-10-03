---
description: "Architect: change the spec, log it in CHANGE HISTORY, and flag affected tasks"
argument-hint: "[feature] <what changed and why>"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Use the **architect** agent, operation **update-specs**, with: $ARGUMENTS

Afterwards list the affected tasks and ask the user whether to send them to frontend-dev / backend-dev now.
