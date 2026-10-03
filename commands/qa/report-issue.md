---
description: "QA: log an issue with reproduction, severity, impact and evidence"
argument-hint: "[feature] <what went wrong>"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Use the **qa-agent**, operation **report-issue**, for: $ARGUMENTS

Then offer to triage it with /arch:analyze-issue.
