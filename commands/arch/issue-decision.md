---
description: "Architect: record Fix/Defer/Accept for an issue and assign it"
argument-hint: "[feature] <ISSUE-###> <Fix|Defer|Accept> [owner/notes]"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Use the **architect** agent, operation **issue-decision**, with: $ARGUMENTS

If the decision is Fix, offer to run the fix now with /fe:debug or /be:debug (whichever owns it), then have the **qa-agent** re-test.
