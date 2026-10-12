# Code-quality checklist (grep the heading you need)

Each line: what to look for → the smallest fix. Robustness checks go by boundary; inside a boundary, trust the data.

## HTTP input
- Body, query or params used without validation → one schema at the route (the repo's validator, else the framework's), with types from the parsed result
- Block-list checks (`if (!x.includes("<"))`) → allow-list: type, length, format, enum
- Unknown fields passed through to the DB (mass assignment) → pick or whitelist the fields
- Validation errors leak stack traces or internals → the `api-design` error format, with details only in logs
- IDs from the client trusted for ownership → check ownership server-side (`backend-security`)

## Database
- Multi-step write without a transaction → wrap it in one transaction. Keep outside calls out of it.
- An invariant enforced only in app code (unique email, non-negative stock) → a DB constraint, then map its error to a 409/422
- Read-modify-write races (counters, balances) → an atomic update (`SET x = x + 1`), a row lock, or a version check
- A "not found" result treated as success → handle `null`/empty explicitly (404 or a clear branch)

## Outside calls
- HTTP/SDK call with no timeout → set one (the client's option, `AbortSignal.timeout(ms)`, the driver's setting)
- Retry on a non-idempotent call (POST payment, send email) → remove the retry, or add an idempotency key first
- Retry with no cap or backoff → max 3 attempts, exponential backoff with jitter, only on transient errors (timeouts, 429, 5xx)
- Outside response used without a check → parse it at the edge like any input. Unexpected shape → a clear error.
- Secrets or tokens in error messages or logs → redact them

## Errors and logging
- Empty catch, or catch → log → continue as if fine → handle it or rethrow with context
- `catch (e)` around a large block → narrow it to the call that can fail. Rethrow what you didn't expect.
- `?.` / `?? default` covering a value that must exist → fail fast with a clear message
- The same error logged at several layers → log once, where it's handled
- Errors logged without context → add the operation name and the relevant IDs. No personal data.
- Background job failures with no record → log them and leave the job retryable or marked failed

## UI forms and fetch
- A request with no error state, or a generic "Something went wrong" for every failure → the error states per `frontend-component-development`, with a retry where it makes sense
- Client-only validation → keep it for user experience, but the server validates too
- Double submit on slow requests → disable while pending, or use an idempotency key
- Unhandled promise rejections or missing error boundaries → handle them at the route or component boundary (`react-best-practices` for React)
- A stale response overwriting a newer one → cancel (`AbortController`) or ignore stale results

## Types
- `any` / untyped data crossing a boundary → type it from the parsed schema
- Several booleans encoding one state (`isLoading && !isError && data`) → one status union
- Non-null assertions (`!`) on data that can be missing → handle the missing case

## Maintainability
- Names that don't say what a thing is (`data`, `tmp`, `handle2`, `obj`) → rename to its intent, using repo vocabulary
- Two words for one concept across files (`user`/`account`/`member` for the same thing) → pick the repo's word
- A deeply nested function (3+ levels) → guard clauses and early returns
- A long function mixing steps → extract only blocks with a clear name. Tests first if it's branch-heavy.
- A boolean parameter switching behavior → two functions (see `code-patterns` → anti-patterns)
- Magic numbers or strings repeated → one named constant near their use
- Commented-out code, unused exports, unreachable branches, always-on flags → delete them (grep first)
- Comments restating the code → delete. Missing "why" on a non-obvious constraint → add one line.
- A style that differs from the rest of the repo → match the repo. Don't reformat untouched code.
