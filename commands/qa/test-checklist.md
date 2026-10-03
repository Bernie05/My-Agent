---
description: "QA: run the full 9-category test checklist"
argument-hint: "[feature] [SEC-# to limit to a section] [categories]"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Use the **qa-agent**, operation **test-checklist**. $ARGUMENTS

Show the category summary table and the list of new issues.
