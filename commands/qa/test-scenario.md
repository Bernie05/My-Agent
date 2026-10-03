---
description: "QA: execute a single test scenario with evidence"
argument-hint: "[feature] <SEC-#, SC-# or scenario description>"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Use the **qa-agent**, operation **test-scenario**, for: $ARGUMENTS (a SEC-# means: all scenarios of that section, plus a smoke check of sections already done)

If it fails, the agent logs an issue; offer /arch:analyze-issue for it.
