---
description: "Flow: pause the feature workflow and save state so it can be resumed later"
argument-hint: "[feature] [reason]"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Arguments: $ARGUMENTS

1. If any subagents are running in the background for this feature, stop them (TaskStop) or let them finish, whichever the user prefers.
2. Make sure every task file reflects reality: mark tasks in progress as 🔄 with a note about where they stopped.
3. In PROJECT_CONTEXT.md → Flow State, set `Phase: stopped (was <previous phase>)`, and write a "Resume notes" section: what was in flight, the next action, and open questions.
4. Log to activity.log: `<timestamp> | orchestrator | stopped: <reason>`.
5. Tell the user it's paused and that `/flow:resume` continues from here.
