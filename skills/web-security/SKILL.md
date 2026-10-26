---
name: web-security
description: End-to-end web app security audit method for any stack - scope, workflow, OWASP Top 10 / ASVS L1-L2 checklist (auth and sessions, authorization/IDOR, injection, XSS/CSP, CSRF, headers, rate limits, uploads, secrets, dependencies, error and log leaks), STRIDE-lite threat modelling, severity rubric and the SEC-# report format with developer hand-off. Use for security audits, threat models and fix rechecks (security-auditor, /sec:audit, /sec:threat-model). For the build-time backend checklist use backend-security.
---

# Web Security audit

Files in this folder, loaded only when needed (Grep for the section, then read the slice):
| File | Holds |
|---|---|
| `checklist.md` | The audit checklist by area, with OWASP/ASVS tags and what counts as evidence |
| `tooling.md` | Read-only commands: dependency audit, secret and history checks, stack-specific sinks to grep |
| `threat-model.md` | STRIDE-lite steps and the THREAT_MODEL.md template |
| `templates.md` | The AUDIT-<date>.md layout, SEC-# format and hand-off table |

Backend items that `backend-security` already lists are not repeated here: read its checklist for server code and apply it alongside `checklist.md`.

## Workflow (audit)
1. **Map the attack surface.** List the entry points (routes, server actions, uploads, webhooks), the session/auth module, the data-access layer and the client trust boundary (what the browser can send). Note who may call each route.
2. **Trace, don't pattern-match.** For every entry point follow the input from source to sink: request → validation → auth check → owner scope → query/render/file/log. A grep hit is a lead, not a finding.
3. **Walk `checklist.md`** area by area for the scoped code. Skip an area only if it doesn't exist in the app (e.g. no uploads) and say so under "Not checked".
4. **Run the tooling** in `tooling.md`: dependency audit, tracked secrets, secrets in git history, `.gitignore` coverage.
5. **Prove each finding**: file:line, the attacker's request or action, and what they gain. Two-user tests for IDOR: "user B sends user A's id to `<route>` → gets A's row".
6. **Rank** with the rubric below, then **write the audit file** per `templates.md`.

## Severity rubric
| Severity | When | Examples |
|---|---|---|
| CRITICAL | Remote, no or low privilege, full data or account takeover | Auth bypass, SQL injection, committed live secret, IDOR on all financial records |
| HIGH | Exploitable by any signed-in user or via a victim's click; real data or account impact | Stored XSS, CSRF on state-changing routes, session not invalidated on logout, missing login rate limit |
| MEDIUM | Needs extra conditions, or limited impact | Missing CSP/headers with no current XSS sink, user enumeration, verbose errors, vulnerable dependency not reachable |
| LOW | Defense in depth, best practice | Cookie without `__Host-` prefix, missing `Permissions-Policy`, outdated but unaffected dependency |
Raise one level when money, credentials or other users' personal data is exposed; lower one level when it needs an already-compromised admin.

## Fix hand-off
- The auditor never edits code. Each SEC-# names its owner (`backend` | `frontend` | `both`) and the **minimal fix** (shortest diff in the right place: one guard in the shared function rather than one per caller; **reuse first (Ponytail)**: the framework's or ORM's built-in protection before a new library).
- The main session sends the chosen SEC-# to `fullstack-dev` (Dev team `fullstack`) or `backend-dev`/`frontend-dev` (`split`), pointing them at the report path. After the fix: `recheck SEC-#`.
- A fix that needs a product decision (e.g. session lifetime, lockout policy) is marked `decision` and goes to the architect.

## Workflow (recheck)
Read only the named SEC-# rows, verify the fix at file:line and that no sibling route still has the flaw, then update their Status in the same report.
