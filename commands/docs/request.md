---
description: "Docs: document a topic or folder (flows, architecture, how parts call each other) with Mermaid diagrams, saved to the folder you choose"
argument-hint: "<what to document, e.g. this folder and how the agents call each other> [to <output folder>]"
---

Use the **system-documenter** agent for: $ARGUMENTS

1. **Split the request.** "What" is the text before a trailing `to <folder>`, and that folder is the Output. Source is a folder named in the "what" (e.g. "this folder" = current working directory, or a path), otherwise the current working directory. If the "what" is "whole system" or "everything", use operation **generate**. Otherwise use operation **topic**.
2. **Hard stop if Output is missing.** Ask with AskUserQuestion: **`<source>/Notes/` (default)** / **Other path** (the user types it) / **Cancel**. Resolve a relative path against the source.
3. **Existing page.** If Output already has a page for this topic (same kebab name), ask **Update it** / **Overwrite** / **New file** and pass the answer on.
4. Pass Source, Output, the topic text and `git -C <source> rev-parse --short HEAD` (or "unknown") to the agent. If it returns `INTAKE: QUESTIONS`, ask them with AskUserQuestion, then call it again with the answers.

Relay the report briefly with links to the written pages. If it lists committed secrets, tell the user to untrack and rotate them. Don't commit unless the user asks.
