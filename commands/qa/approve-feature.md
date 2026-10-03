---
description: "QA: give the release go/no-go recommendation"
argument-hint: "[feature]"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Use the **qa-agent**, operation **approve-feature**. $ARGUMENTS

If the recommendation is GO, ask the user to confirm the release; on confirmation set Flow State phase to `done` and SPEC.md Status to Done. If NO-GO, list what blocks it and the commands to fix it.
