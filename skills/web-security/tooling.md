# Audit tooling (read-only)

Run these from the project root. No installs, no project scripts, no writes. If a tool is missing, note it under "Not checked" and move on. Never print secret values: report file:line and `[REDACTED]`.

## Dependencies
| Stack | Command | Notes |
|---|---|---|
| Bun (lockfile `bun.lock`/`bun.lockb`) | `bun audit` | Bun 1.2.15+; check with `bun --version`. Add `--json` for counts. |
| npm | `npm audit --omit=dev` then `npm audit` | Prod advisories rank higher. |
| pnpm / yarn | `pnpm audit` / `yarn npm audit` | |
| Python / PHP | `pip-audit` / `composer audit` | Only if already installed. |
For each HIGH/CRITICAL: is the vulnerable function reachable from app code? Unreachable → lower one level.

## Secrets and leaks
- Tracked sensitive files: `git ls-files | grep -iE '(^|/)\.env($|\.)|\.pem$|\.key$|\.p12$|\.sqlite3?$|\.db$|id_rsa|credentials'` (`.env.example` is fine).
- Ignore coverage: `git check-ignore -v .env .env.local <db file>`; a file that is not ignored → finding.
- History: `git log --all --oneline -S "<pattern>"` for `BEGIN PRIVATE KEY`, `sk_live`, `AKIA`, `password=`, `SECRET`; then `git log --all --diff-filter=D --name-only` for deleted env/db files.
- Working tree: Grep the code (not `node_modules`) for `(api[_-]?key|secret|token|password)\s*[:=]\s*['"][^'"]{8,}`.
- Client bundle: Grep client code for `process.env`/`import.meta.env`/`Bun.env` reads; only public, non-secret values may reach the browser.

## Stack-specific sinks to trace (Grep, then follow the flow)
| Stack | Grep for | Check |
|---|---|---|
| Drizzle | `sql\.raw\|sql\`` with `${`, `.execute(`, `.run(` | Interpolated input outside the `sql` tag params, raw identifiers |
| Drizzle | `.update(`, `.delete(`, `.select(` on per-user tables | `where` includes the user id from the session |
| bun:sqlite | `.query(`, `.prepare(`, `.exec(` with template strings | Bound params (`$x`, `?`) vs string building |
| Bun server | `Bun.serve`, `routes:`, `fetch(req` | Auth middleware per route, headers on every response, `error()` handler output |
| Cookies | `Set-Cookie`, `cookies.set`, `new Bun.Cookie`, `serialize(` | HttpOnly, Secure, SameSite, Path, expiry |
| React | `dangerouslySetInnerHTML`, `innerHTML`, `href={` | Sanitized? URL scheme restricted? |
| Storage | `localStorage`, `sessionStorage` | No tokens or personal financial data |
| Express/Hono/Elysia | `cors(`, `helmet(`, `rateLimit`, `app.use(` | Origin list, headers, limiter placement before routes |
| Errors | `catch`, `console.error`, `logger.` near `res`/`Response` | Stack or error message sent to the client; secrets logged |

## Headers (static check first)
Find where responses are built and list the headers set. A live check (`curl -sI`) is allowed only against a server the user already has running on `localhost`, and only when the main session says so.
