---
description: "Frontend: implement tasks (F#) or a described change"
argument-hint: "[feature] <F# task ids or description> [ponytail: lite|ultra|off]"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user. (Skip this if the request isn't tied to a feature.)

Use the **frontend-dev** agent, operation **code**, for: $ARGUMENTS

Pass any `ponytail: <level>` from the arguments through to the agent (default full).

Relay the agent's report, including its "Skipped (ponytail)" line. If it lists blockers or spec questions, offer to take them to the architect (/arch:ask).
