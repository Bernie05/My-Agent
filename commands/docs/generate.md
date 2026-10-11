---
description: "Docs: document the whole system into Notes/ (or a folder you choose) - configuration, system flow, data flow, database schema, with Mermaid diagrams and plain-language summaries"
argument-hint: "[project path, default current folder] [to <output folder>] [overwrite]"
---

Use the **system-documenter** agent, operation **generate**, for: $ARGUMENTS

Source is the project path in the arguments, or the current working directory. Output is the folder after `to`, or `<source>/Notes/`. If Output already has Notes (a `README.md` with a "Last updated" line) and the arguments don't say `overwrite`, ask the user: overwrite, or run update instead (`/docs:update`).

Before calling, get the current commit for the "Last updated" lines with `git -C <source> rev-parse --short HEAD` (use "unknown" if it isn't a git repo). Pass Source, Output and the commit to the agent.

If the agent returns `INTAKE: QUESTIONS`, ask them with AskUserQuestion (header and options as given), then call it again with the answers.

Relay the report briefly. If it lists committed secrets, tell the user to untrack them and rotate the secret. Don't commit the Notes unless the user asks.
