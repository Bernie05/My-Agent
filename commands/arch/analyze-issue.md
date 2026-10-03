---
description: "Architect: triage a QA issue against the spec - valid bug, new requirement or ambiguous (Gate 4)"
argument-hint: "[feature] <ISSUE-### or description>"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Use the **architect** agent, operation **analyze-issue**, for: $ARGUMENTS
(If a description is given instead of an ISSUE-###, first have the **qa-agent** log it with operation report-issue.)

**Hard stop (Gate 4):** show the triage and recommendation, then ask the user with AskUserQuestion: **Fix** / **Defer** / **Accept** (and get their answer to any product question for a new or ambiguous requirement). Then record the choice exactly as /arch:issue-decision does.
