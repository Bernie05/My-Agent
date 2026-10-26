# Threat model (STRIDE-lite)

Keep it to one page per feature. Read `SPEC.md` (or `PLAN.md`) → data model, permissions, API contract, then the code if it exists.

## Steps
1. **Assets**: what an attacker wants (credentials, sessions, financial records, card data, other users' data, availability).
2. **Actors**: anonymous visitor, signed-in user, another signed-in user, admin (if any), compromised dependency.
3. **Entry points and trust boundaries**: each route/form/upload, and where data crosses browser → server → DB → logs/third parties.
4. **STRIDE per entry point** (skip letters that don't apply):
   | Letter | Ask |
   |---|---|
   | S Spoofing | Can someone act as another user (weak login, session theft, fixation)? |
   | T Tampering | Can input change data it shouldn't (IDOR, mass assignment, CSRF)? |
   | R Repudiation | Are security events logged to tell who did what? |
   | I Information disclosure | Can data leak (other users' rows, errors, logs, bundle, cache)? |
   | D Denial of service | Can one user exhaust the app (no limits, huge uploads, unbounded queries)? |
   | E Elevation of privilege | Can a user reach admin or another user's scope? |
5. **Abuse cases**: write each threat as "As `<actor>`, I `<action>` to `<gain>`", with the control that stops it and whether the code has it.
6. **Controls to require**: turn missing controls into spec requirements (for the architect) or SEC-# findings (if the code exists and fails).

## THREAT_MODEL.md template
```
# Threat model: <feature>   Date: <yyyy-mm-dd>   Scope: <spec | code @ <commit>>
## Assets
- <asset>: <why it matters>
## Entry points and boundaries
| Entry point | Actor | Crosses | Auth required |
## Threats
| ID | STRIDE | Abuse case | Control | In code? (file:line / missing) | Severity |
| T-1 | T | As user B, I PATCH /api/transactions/<A's id> to edit A's data | owner-scoped where | missing | HIGH |
## Required controls
- <control> → <spec requirement or SEC-#>
## Findings (code fails an abuse case)
<SEC-# entries in the `templates.md` format>
```
