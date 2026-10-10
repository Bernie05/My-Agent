---
description: "Docs: refresh only the Notes sections whose source files changed since they were last documented"
argument-hint: "[project path, default current folder] [to <notes folder>]"
---

Use the **system-documenter** agent, operation **update**, for: $ARGUMENTS

Source is the project path in the arguments, or the current working directory. Output is the folder after `to`, or `<source>/Notes/`. If Output has no Notes, run `/docs:generate` instead (with the same `to`).

Before calling, find what changed:
1. Read the commit from the "Last updated" line in `<output>/README.md`.
2. If it's a real sha, run `git -C <source> diff --name-only <sha> HEAD` plus `git -C <source> status --porcelain`. Otherwise pass "unknown".
3. Pass Source, Output, the changed file list (excluding the Output folder) and `git rev-parse --short HEAD` to the agent. If nothing changed, tell the user the Notes are current and stop.

Relay the report briefly. Don't commit unless the user asks.
