---
description: "Flow: plan which tasks go to which agent and in what order/parallel batches"
argument-hint: "[feature]"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Arguments: $ARGUMENTS

Read the task files' `Depends on` and `Section` fields plus the Mode and Scope. In per-section scope, plan batches **within** the current (or named) section only. Produce an execution plan:

```
Batch 1 (parallel): backend-dev → B1, B2 · frontend-dev → F1 (mocked API)
Batch 2 (parallel): backend-dev → B3 · frontend-dev → F2, F3
Batch 3: qa-agent → start-testing, test-checklist
Critical path: B1 → B3 → F3 → QA
```

Flag circular or missing dependencies and oversized tasks (send those back to the architect). Write the plan to PROJECT_CONTEXT.md under "Execution Plan", then ask the user whether to start Batch 1 now. If yes, dispatch each batch's agents in parallel (multiple Agent calls in one message).

**Flow log:** if the run folder has a `FLOW.md`, update it for what this command changed (`flow-log` skill).
