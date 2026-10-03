---
description: "Architect: answer one or more questions about a feature's spec (logged in the Q&A log)"
argument-hint: "[feature] <question(s)>"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Use the **architect** agent, operation **ask**, with these question(s): $ARGUMENTS

Relay each answer with its spec reference. For any answer marked "needs user confirmation", ask the user and have the architect log the confirmed answer.
