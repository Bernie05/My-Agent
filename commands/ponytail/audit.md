---
description: "Ponytail: audit the whole repo for over-engineering - ranked list of code and dependencies to delete or replace"
argument-hint: "[folder to limit the audit]"
---

Use the **code-reviewer** agent, mode **audit**, on: $ARGUMENTS (default: the whole current project).

Relay the top findings (at most 15, biggest cut first) and the `net:` line. Offer to hand the chosen cuts to **frontend-dev** or **backend-dev**, operation **refactor**. This command applies nothing itself.
