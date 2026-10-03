---
description: "Design: regenerate DESIGN.md from the current Figma file (links, node IDs, screens, tokens, components, copy)"
argument-hint: "[feature] [Figma file URL]"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Use the **figma-designer** agent, operation **handoff**. $ARGUMENTS

Show the user a link to DESIGN.md plus the list of screens it covers, and anything in Assumptions / Open Questions. Suggest `/design:approve` if it hasn't been approved yet.
