---
description: "Full-stack: implement tasks (F# and/or B#) or a described change end to end - DB, API and UI in one context"
argument-hint: "[feature] <F#/B# task ids or description> [ponytail: lite|ultra|off]"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` or `PLAN.md` is newest. If still ambiguous, ask the user. (Skip this if the request isn't tied to a feature.)

Use the **fullstack-dev** agent, operation **code**, for: $ARGUMENTS

This always uses fullstack-dev, whatever the feature's Dev team setting is (to make it the default for the feature, use `/flow:team fullstack`). Pass any `ponytail: <level>` from the arguments through to the agent (default full).

Relay the agent's report, including its "Skipped (ponytail)" and "API contract changes" lines. If it lists blockers or spec questions, offer to take them to the architect (/arch:ask).
