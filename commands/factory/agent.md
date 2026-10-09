---
description: "Factory: get a new agent - reuse a safe existing one (local, Anthropic, GitHub) or build it, security-reviewed"
argument-hint: "<what the agent should do>"
---

Use the **agent-factory** agent, operation **create-agent**, for: $ARGUMENTS

Before calling it, run `claude plugin marketplace update` once (any shell) so the Anthropic catalogs are current. If it fails, continue with the local copies.

**Approval gate:** the agent never builds on the first call. When it returns `PROPOSAL`, show it to the user as-is (what gets reused or built, where, wiring, token cost), then ask in **one** AskUserQuestion call: **Approve** / **Change** (the user says what) / **Cancel**, together with any `Open questions`.
- Approve: call the agent with operation **build** and `APPROVED:` followed by the proposal and the answers.
- Change: call it again with the original operation, the proposal and the requested changes, then repeat the gate.
- Cancel: stop. Nothing has been written.

Nothing is created, edited or installed before an approval.

Handle its other replies here, in the main session. The agent has no shell, so these steps are yours:
1. **`INTAKE: QUESTIONS`**: ask them all in **one** AskUserQuestion call, then call the agent again with the answers.
2. **GitHub candidate**: clone it into quarantine, then call the agent again with operation **review** and the quarantine path:
   ```
   git clone --depth 1 https://github.com/<owner>/<repo> "$HOME/.claude/factory/quarantine/<repo>"
   git -C "$HOME/.claude/factory/quarantine/<repo>" rev-parse HEAD
   ```
   Pass the SHA along. Never run anything inside quarantine.
3. **`SAFE`** or **`SAFE WITH CHANGES`** (with the fixes applied): it comes back as a `PROPOSAL` first. After the user approves it, run the install it names:
   - Anthropic marketplace: `claude plugin install <plugin>@<marketplace>`
   - GitHub repo that is a plugin: `claude plugin marketplace add <owner>/<repo>`, then `claude plugin install <plugin>@<marketplace>`
   - Loose GitHub files: copy the reviewed files from quarantine into `~/.claude`

   Afterwards, tell the user a restart may be needed for the plugin to load.
4. **`REJECT`**: tell the user why in 1–3 lines, and offer to have the agent build a new one instead.
5. When done, delete the quarantine folder for this item. The review record stays in `factory/REGISTRY.md`.

Relay the agent's final report briefly.
