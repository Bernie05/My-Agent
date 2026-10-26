---
description: "Security: independent audit of the app, an area or a diff (auth, sessions, IDOR, injection, XSS/CSP, CSRF, headers, secrets, dependencies) into a ranked SEC-# report, then hand the chosen fixes to the developers"
argument-hint: "[area | files | diff | recheck SEC-#…] [ponytail: lite|ultra|off]"
---

Use the **security-auditor** agent, operation **audit** (or **recheck** if the arguments start with `recheck`), on: $ARGUMENTS
(No target given → audit the whole app. `diff` → only the current branch's changes against main.)

If the report ends with a fenced block and `Save to: <path>`, write that block to the path in the project.

Present the findings by severity in a short summary with the report path (`docs/security/AUDIT-<date>.md`). Then ask the user in **one** AskUserQuestion which to fix: **All CRITICAL+HIGH** (Recommended) / **Pick SEC-#** / **None for now**.

Fixes: follow the Dev team rule in CLAUDE.md. `fullstack` → **fullstack-dev**, operation **code**, one call for all chosen SEC-#. `split` → **backend-dev** for owner `backend`, **frontend-dev** for `frontend`; `both` goes to backend-dev first, then frontend-dev. Pass: "fix <SEC-#…> per <report path>; follow each finding's Fix and Verify lines", and any `ponytail: <level>` from the arguments (default full). Items marked `decision` go to the architect (/arch:ask) instead.

After the fixes, offer `/sec:audit recheck <SEC-#…>`.
