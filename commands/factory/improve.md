---
description: "Factory: improve an existing agent, skill or command (local or Anthropic) into a better, leaner, security-reviewed version"
argument-hint: "<local path | skill/agent/plugin name> [what to improve] [--probe]"
---

Use the **agent-factory** agent, operation **improve**, for: $ARGUMENTS

`--probe` (or the target is an agent, or a whole-skill restructure): add `PROBE` so the proposal includes an Alternative B. On approval, build and test both as `factory/evals/README.md` → Probing describes, show the user the scores side by side, and keep the winner (ask with AskUserQuestion if the scores tie and the approaches differ in a way the user should choose).

Handle its replies here, in the main session:
1. **`INTAKE: QUESTIONS`**: ask them all in **one** AskUserQuestion call, then call the agent again with the answers.
2. **`PROPOSAL`**: show it to the user as-is, then ask in **one** AskUserQuestion call: **Approve** / **Change** (the user says what) / **Cancel**. Approve: call the agent with operation **improve** and `APPROVED:` followed by the proposal. Change: call it again with the requested changes and repeat this step. Cancel: stop. Nothing is backed up or edited before an approval.
3. **`REJECT`** on the original: tell the user why in 1–3 lines and offer `/factory:skill`, `/factory:agent` or `/factory:command` to build a clean one instead.
4. **Done**: relay the diff summary (`kept | removed | added | fixed`), where the new or edited file is, and the backup path for local items. If the new item replaces a plugin item, say that both now exist and offer to disable the plugin (`claude plugin disable <plugin>`). Run that only after the user approves.

**Test plan:** if the build added or changed a script or hook, run the proposal's Test plan yourself (temp copies only, never the real `settings.json`) and report each step pass/fail. A failed step means the build isn't done: send the failures back to the agent as a build fix.

Relay the agent's final report briefly.

**Flow log:** load the `flow-log` skill and keep this run's `FLOW.md` current: create it when the run starts, then update it at every step, gate, pause and finish. Show its path in your first message.
