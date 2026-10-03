---
description: "Flow: set or switch the workflow mode (hybrid, sequential, parallel) for a feature"
argument-hint: "[feature] <hybrid|sequential|parallel>"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Arguments: $ARGUMENTS

If no mode is given, show the current mode and this table, then ask which to use (AskUserQuestion):

| Mode | How development runs | Best for |
|---|---|---|
| **hybrid** (default) | Specs gated → frontend + backend in parallel → QA with architect triage | Most features |
| **sequential** | One agent at a time, check-in with you after each | Maximum control, learning, risky changes |
| **parallel** | Specs gated → frontend, backend and QA test-planning all at once | Clear, well-separated tasks; speed |

Set `Mode:` in `PROJECT_CONTEXT.md` → Flow State (create the Flow State block if missing; if there is no feature yet, just confirm the mode to use for the next /flow:start). Work already done is kept; the new mode applies from the next phase. Log to `activity.log`: `<timestamp> | orchestrator | mode → <mode>`.
