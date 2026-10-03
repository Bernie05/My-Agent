---
description: "Architect: finalize specs and create the PROJECT_CONTEXT.md living checklist (Gate 3)"
argument-hint: "[feature]"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Check Gates 1 and 2 are passed. Use the **architect** agent, operation **finalize**. Extra instructions: $ARGUMENTS

**Hard stop:** show the user a short summary of what the agent produced (with file links), then ask with AskUserQuestion: **Approve** / **Send back** (with feedback) / **Reject**. On Approve, tick the gate in `PROJECT_CONTEXT.md` → Flow State (create the Flow State block if the file does not exist yet) and suggest the next command. On Send back, call the architect again with the feedback and repeat this stop. On Reject, set Flow State phase to `stopped` and log it. Do not continue to the next phase on your own. (Gate 3: Final approval — on Approve, development can start)
