---
description: "Ponytail: over-engineering review of a diff or files - what to delete, replace with stdlib/native, or inline"
argument-hint: "[files, folder, or diff description]"
---

Use the **code-reviewer** agent, mode **over-engineering only**, on: $ARGUMENTS
(If no target is given, review the current uncommitted changes.)

Relay the findings list and the `net: -N lines possible` line. Ask before applying any cuts. If the user says yes, pass the cuts to **frontend-dev** or **backend-dev**, operation **refactor**.
