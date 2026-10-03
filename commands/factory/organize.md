---
description: "Factory: organize all agents, skills and commands - find duplicates, broken links, bad grouping and token waste, write a catalog and a fix plan"
argument-hint: "[focus, e.g. 'skills only' or 'duplicates']"
---

Use the **agent-factory** agent, operation **organize**, for: $ARGUMENTS

Then, in the main session:
1. Show the user the top findings from the plan file (`factory/organize/PLAN-<date>.md`) and the path to `factory/CATALOG.md`.
2. Ask in **one** AskUserQuestion call which actions to apply (multiSelect; group them if there are more than 4).
3. For approved actions, call the agent again with operation **organize-apply**, the plan path and the chosen action numbers.
4. Run the move, rename and delete commands it returns yourself, only for approved actions. Back up each target to `factory/backups/` before deleting it.
5. Tell the user a restart may be needed for renamed or moved agents to load.

Relay the agent's final report briefly.

**Flow log:** load the `flow-log` skill and keep this run's `FLOW.md` current: create it when the run starts, then update it at every step, gate, pause and finish. Show its path in your first message.
