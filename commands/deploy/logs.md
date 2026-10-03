---
description: "Deploy: diagnose a failed Vercel build or runtime errors (latest deployment by default)"
argument-hint: "[deployment url] [build|runtime]"
---

Use the **vercel-deployer** agent, operation **logs**, for: $ARGUMENTS

Pass the deployment URL (default: latest) and the kind (default: build if the deployment state is ERROR, otherwise runtime).

Relay the report briefly: the errors and their likely cause. If the fix is in the code, offer to hand it to frontend-dev or backend-dev together with the error lines and file paths.
