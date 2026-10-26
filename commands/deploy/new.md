---
description: "Deploy: create and set up a new Vercel project for this repo - Git, storage, secrets, multi-service vercel.json - then a first preview"
argument-hint: "[project name] [project dir] [notes, e.g. 'neon existing', 'two blob stores']"
---

Use the **vercel-deployer** agent, operation **setup** (new project), for: $ARGUMENTS

1. **First call:** pass only the project directory (default: the current working directory), the name if given, and the notes. Don't pass `confirmed: create`, so the agent returns its plan.
2. **If the agent returns `INTAKE: QUESTIONS`:** ask them in **one** AskUserQuestion. These include service names, public paths and bindings, team, integrations and the Node version. Pass the answers back.
3. **If the agent returns its plan as `NEEDS CONFIRMATION`:** show it and ask **Create it** / **Change something** / **Cancel**. On **Create it**, call the agent again with `confirmed: create` plus the answers.
4. **If the agent lists code changes** (services/bindings): offer to hand them to frontend-dev / backend-dev (fullstack-dev if the feature's Dev team is `fullstack`).
5. **Relay the report briefly:**
   - project URL, preview URL and state
   - integrations and stores added
   - missing env vars, with an offer of `/deploy:env`
   - dashboard steps left for the user
