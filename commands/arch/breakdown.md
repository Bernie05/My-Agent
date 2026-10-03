---
description: "Architect: break the approved spec into frontend, backend and QA tasks (Gate 2)"
argument-hint: "[feature]"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Check Gate 1 is passed (ticked in PROJECT_CONTEXT.md, or SPEC.md Status is Approved); if not, tell the user to run /arch:analyze first. Then use the **architect** agent, operation **breakdown**. Extra instructions: $ARGUMENTS

**Hard stop:** show the user a short summary of what the agent produced (with file links), then ask with AskUserQuestion: **Approve** / **Send back** (with feedback) / **Reject**. On Approve, tick the gate in `PROJECT_CONTEXT.md` → Flow State (create the Flow State block if the file does not exist yet) and suggest the next command. On Send back, call the architect again with the feedback and repeat this stop. On Reject, set Flow State phase to `stopped` and log it. Do not continue to the next phase on your own. (Gate 2: Task review)
