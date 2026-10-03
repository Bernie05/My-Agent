---
description: "Deploy: show the latest Vercel deployments and production domains for this project"
argument-hint: "[project name]"
---

Show the Vercel status for: $ARGUMENTS (default: the project linked in `.vercel/project.json` in the current directory).

This is a quick read, so do it in the main session. Don't spawn an agent. Follow the `vercel-deploy` skill.

1. Get the project:
   - Read `.vercel/project.json` for `projectId` and `orgId`.
   - If it's missing, use `list_projects` and match by name.
2. Load `list_deployments` and `get_project` with `ToolSearch("select:…")`. Fetch the last 5 deployments.
3. Reply with a table of at most 5 rows: state, target, URL, commit, age. Then list the production domains.
   - Flag any ERROR deployment and offer `/deploy:logs <url>`.
