---
description: "Deploy: check which Vercel env vars are missing per environment, or add one"
argument-hint: "[check | add NAME production|preview|development]"
---

Use the **vercel-deployer** agent, operation **env**, for: $ARGUMENTS

- **check** (default): the agent compares the names in `.env.example` against Vercel for each target. Relay the missing names only.
- **add:**
  - Ask the user for the value in a normal message. Don't use AskUserQuestion options for secrets.
  - For production, also confirm with AskUserQuestion: **Add to production** / **Cancel**.
  - Pass the name, value and target to the agent, plus `confirmed: env` for production.
  - Never repeat the value back in your reply.
