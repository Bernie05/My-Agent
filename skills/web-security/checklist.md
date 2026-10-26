# Web security checklist

Tags: OWASP Top 10 2021 (`A01`…`A10`) and ASVS 4.0 chapter (`V2` auth, `V3` session, `V4` access control, `V5` validation/encoding, `V7` errors/logging, `V8` data protection, `V12` files, `V14` config). Each line says what counts as evidence.

## 1. Authentication (A07, V2)
- [ ] Passwords hashed with argon2id/bcrypt/scrypt (e.g. `Bun.password.hash`), never a fast hash or plaintext; never logged or returned. Evidence: the hash call and every place the password field flows.
- [ ] Login, register and reset return the same message and similar timing for unknown users (no enumeration).
- [ ] Login, register, reset and verify are rate limited per IP **and** per account; lockout or backoff after repeated failures.
- [ ] Password policy: min length 8+ (ASVS: 12 recommended), max length allowed ≥ 64, no silent truncation (bcrypt's 72-byte limit).
- [ ] Reset tokens: random (≥128 bits), single use, short expiry, stored hashed; reset invalidates other sessions.
- [ ] Changing email or password requires the current password.

## 2. Sessions (A07, V3)
- [ ] Session id from a CSPRNG (≥128 bits); stored server-side (or hashed); never in URLs or logs.
- [ ] Cookie: `HttpOnly`, `Secure` (in production), `SameSite=Lax` or `Strict`, `Path=/`; prefer the `__Host-` prefix.
- [ ] A new session id at login (no fixation); logout deletes it server-side, not only the cookie.
- [ ] Idle and absolute expiry are enforced server-side; expired rows are rejected even if the cookie remains.
- [ ] Every protected route resolves the user from the session on the server; nothing trusts a client-sent `userId`.

## 3. Authorization and IDOR (A01, V4)
- [ ] Every query on per-user data is scoped by the session's user id (`where userId = session.userId` **and** the record id), on read, update, delete **and** list/export/aggregate routes.
- [ ] Ids in the path, query or body are never trusted alone; a row from another user returns 404 (not 403, to avoid revealing existence).
- [ ] Foreign keys sent by the client (category, account, card id) are checked to belong to the same user before insert/update.
- [ ] Mass assignment: the update schema whitelists fields; `userId`, `role`, `id`, timestamps cannot be set by the client.
- [ ] Dashboards and totals aggregate only the caller's rows.
- [ ] Deny by default: new routes are protected unless explicitly public; the public list is short and reviewed.

## 4. Injection (A03, V5)
- [ ] ORM query builder or tagged/parameterized SQL only; any raw SQL with interpolated input is a finding.
- [ ] Dynamic `ORDER BY`, column or table names come from a whitelist.
- [ ] No `eval`, `new Function`, shell execution or template compilation with user input.
- [ ] Input validated with a schema at the trust boundary (types, ranges, lengths; money as integer cents or decimal, not float).

## 5. XSS and CSP (A03, V5, V14)
- [ ] No raw HTML sinks with user data (`dangerouslySetInnerHTML`, `innerHTML`, `insertAdjacentHTML`, `document.write`); if needed, sanitize with a maintained sanitizer.
- [ ] User-controlled URLs in `href`/`src` are restricted to `http(s):` (no `javascript:`).
- [ ] CSV/Excel export escapes cells that start with `= + - @` (formula injection).
- [ ] CSP set: `default-src 'self'; script-src 'self'` (no `'unsafe-inline'`/`'unsafe-eval'` for scripts), `object-src 'none'`, `base-uri 'self'`, `frame-ancestors 'none'`, `form-action 'self'`.
- [ ] No session token or secret readable by JS (`localStorage`, non-HttpOnly cookies).

## 6. CSRF and CORS (A01, V4, V13)
- [ ] Cookie-authenticated state-changing routes (POST/PUT/PATCH/DELETE) are protected: SameSite cookie **plus** an Origin/`Sec-Fetch-Site` check or a CSRF token. GET never changes state.
- [ ] CORS: no `*` with credentials, no reflected Origin; allow only the app's own origin(s).
- [ ] JSON routes require `Content-Type: application/json` (blocks simple-form CSRF).

## 7. Security headers and transport (A05, V14)
- [ ] `Strict-Transport-Security` (prod), `X-Content-Type-Options: nosniff`, `Referrer-Policy: strict-origin-when-cross-origin`, frame protection (CSP `frame-ancestors` or `X-Frame-Options: DENY`), `Permissions-Policy`.
- [ ] Headers apply to API **and** static/HTML responses, including errors.
- [ ] No `X-Powered-By` or version banners; dev servers and debug routes are not exposed in production.

## 8. Rate limiting and abuse (A04, V11)
- [ ] Auth routes limited (section 1); expensive routes (exports, search, uploads) limited per user.
- [ ] Body size limits on JSON and uploads; pagination with a max page size.
- [ ] An in-memory limiter is noted as single-instance only.

## 9. File upload (A04, V12)
- [ ] Size limit, allow-listed type checked by content (magic bytes), not only extension or `Content-Type`.
- [ ] Stored outside the web root or in object storage with random names; served with `Content-Disposition: attachment` and `nosniff`.
- [ ] No path built from the client filename (path traversal); CSV/OFX/image parsers bounded.

## 10. Secrets and config (A05, V14, V8)
- [ ] No secrets in tracked files or git history; `.env*` (except `.env.example`), DB files (`*.sqlite`, `*.db`), keys and local cloud config are in `.gitignore`.
- [ ] No server secret in the client bundle (env vars exposed by the bundler prefix, e.g. `VITE_`, `PUBLIC_`, `BUN_PUBLIC_`).
- [ ] The SQLite file is not reachable over HTTP (static file serving roots).

## 11. Errors and logging (A09, V7)
- [ ] Clients get generic errors; stack traces, SQL and paths only in server logs.
- [ ] Logs never hold passwords, session ids, reset tokens, full card numbers or full request bodies of auth routes.
- [ ] Auth events (login success/failure, logout, password change) are logged with user id and IP, without secrets.

## 12. Dependencies and supply chain (A06, V14)
- [ ] Dependency audit run (see `tooling.md`); each HIGH/CRITICAL advisory is checked for reachability.
- [ ] Lockfile committed; no packages from git URLs or unpinned tarballs; no install scripts from unknown packages.

## 13. Sensitive financial data (A02, V8)
- [ ] Card data limited to what is needed (last 4 digits, brand); never full PAN or CVV.
- [ ] Responses return only the fields the UI uses (no password hash, other users' data or internal ids beyond need).
- [ ] Caches: `Cache-Control: no-store` on authenticated API responses.
