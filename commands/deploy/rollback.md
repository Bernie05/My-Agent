---
description: "Deploy: roll Vercel production back to the previous good deployment, or promote a preview to production"
argument-hint: "[rollback [deployment url] | promote <preview url>]"
---

Use the **vercel-deployer** agent for: $ARGUMENTS

1. **Operation:**
   - `promote <url>` → operation **promote**.
   - Anything else → operation **rollback**. Its target is the given URL, or else the previous READY production deployment.
2. **Confirm** with AskUserQuestion. State which deployment goes live and which one it replaces: **Proceed** / **Cancel**.
3. On Proceed, call the agent with `confirmed: rollback` or `confirmed: promote`.
4. Relay the report: what is live now, and the HTTP check result.
