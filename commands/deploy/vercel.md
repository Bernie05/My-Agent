---
description: "Deploy: deploy the current project to Vercel - preview by default, production after confirmation"
argument-hint: "[preview|prod] [project dir] [notes]"
---

Use the **vercel-deployer** agent, operation **deploy**, for: $ARGUMENTS

1. **Target:** `prod` or `production` means production. Anything else means preview.
2. **Production:** before calling the agent, ask with AskUserQuestion: **Deploy to production** / **Deploy a preview first** / **Cancel**.
   - Pass `confirmed: production` only if the user picks the first option.
3. Pass the agent the project directory (default: the current working directory), the target, and any notes. Nothing else.
4. **If the agent returns:**
   - `NEEDS CONFIRMATION`: ask the user, then call the agent again with `confirmed: <action>`.
   - A login instruction: tell the user to run `! npx vercel login` in the prompt, then retry.
   - Missing env vars: list them, and offer `/deploy:env`.
   - A build error caused by code: offer to hand it to frontend-dev or backend-dev with the error lines.
5. Relay the report briefly: URL, state, issues, next step.
   - After a good preview, suggest `/deploy:vercel prod` or `/deploy:promote <url>`.
