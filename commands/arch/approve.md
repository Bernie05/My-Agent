---
description: "Architect: mark a finalized feature approved and ready for development"
argument-hint: "[feature]"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Use the **architect** agent, operation **approve**. Then tell the user development can start and suggest `/flow:start` (continues the pipeline) or `/fe:code` / `/be:code` for individual tasks. $ARGUMENTS
