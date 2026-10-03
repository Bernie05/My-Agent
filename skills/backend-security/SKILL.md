---
name: backend-security
description: Security checklist and fixes for backend code in any stack - authentication, authorization, injection, validation, rate limiting, CSRF, headers, secrets, error leakage. Use when building sensitive endpoints or running a security audit (/be:security).
---

# Backend Security

## Audit checklist
**Authentication**
- [ ] Passwords hashed with a slow algorithm (bcrypt/argon2/scrypt); never logged or returned
- [ ] Sessions/tokens expire; logout invalidates; tokens verified on every request
- [ ] Login and password-reset endpoints rate limited; no user enumeration in messages

**Authorization**
- [ ] Every endpoint checks the role AND ownership (`record.owner_id == current_user.id`) per SPEC.md → Permissions
- [ ] IDs from the client are never trusted — resource looked up with the user's scope (no IDOR)
- [ ] Admin actions restricted server-side, not only hidden in the UI

**Input & injection**
- [ ] Parameterized queries / ORM only; no string-built SQL
- [ ] Input validated with a schema; unknown fields stripped (no mass assignment of `role`, `owner_id`, `is_admin`...)
- [ ] File uploads: type and size checked, stored outside web root or in object storage, random names
- [ ] No shell/eval with user input

**Web protections**
- [ ] CSRF protection for cookie-based auth
- [ ] CORS limited to known origins
- [ ] Security headers (HSTS, X-Content-Type-Options, frame protection, CSP where applicable)
- [ ] HTTPS only in production; secure/httpOnly/SameSite cookies
- [ ] Rate limiting on public and expensive endpoints

**Data & errors**
- [ ] Generic error messages to clients; details only in server logs
- [ ] Secrets in environment/secret manager, never in code, URLs or logs
- [ ] Personal data minimized in logs and responses
- [ ] Dependencies scanned for known vulnerabilities (`npm audit`, `pip-audit`, `composer audit`, etc.)

## Reporting findings
For each finding: severity (CRITICAL/HIGH/MEDIUM/LOW), file:line, concrete exploit scenario, and the fix. Fix CRITICAL/HIGH immediately if in scope; list the rest for the architect.
