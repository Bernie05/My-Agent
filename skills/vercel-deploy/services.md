# Multi-service projects (`services` in vercel.json)

Load when a repo has two or more deployable apps (e.g. `client/` + `server/`, `web/` + `api/`) that should ship as **one** Vercel project with one domain. Docs: https://vercel.com/docs/services

## How it works
- Each app is a service under the top-level `services` key, built independently. `root` is relative to the folder holding `vercel.json` (normally the repo root).
- Per service: `root`, `framework`, `runtime`, `entrypoint`, `buildCommand`, `bindings`.
- A service is **internal by default**. It gets public traffic only when a top-level rewrite targets it in object form: `{ "source": "/api/(.*)", "destination": { "service": "server" } }`.
- Rewrites run top to bottom: most specific path first, the catch-all `/(.*)` last.
- In services mode these keys are **invalid at the top level** and move into their service: `functions`, `installCommand`, `buildCommand`, `devCommand`, `ignoreCommand`, `outputDirectory`, `framework`. Public routing keys (`rewrites`, `redirects`, `headers`) stay at the top. For anything else already at the top (e.g. `crons`), check the docs before moving it.
- `vc dev` runs every service together and injects the binding variables. It is the local test.

## 1. Detect and draft
- List candidate folders: each `package.json` (or other manifest) with its framework dependency and `scripts`. Skip `packages/`/`libs/` that only hold shared code.
- Draft `vercel.json` at the repo root. Keep every existing top-level key that is still valid there.
```json
{
  "$schema": "https://openapi.vercel.sh/vercel.json",
  "services": {
    "client": { "root": "client", "framework": "vite" },
    "server": { "root": "server", "framework": "express" }
  },
  "rewrites": [
    { "source": "/api/(.*)", "destination": { "service": "server" } },
    { "source": "/(.*)", "destination": { "service": "client" } }
  ]
}
```
- The detected names, public paths and frameworks are **guesses** until the user confirms them (step 4).
- **Express services:** set `"entrypoint"` to the file whose **default export** is the app (e.g. `src/index.js`). Auto-detect can pick `src/app.js` and fail with "The default export must be a function or server". The entry must `export default app` and skip `app.listen` when `process.env.VERCEL` is set.

## 2. Bindings (service → service calls)
- A binding injects the **target's internal URL** into the **calling** service. It does not make the target public. Declare it on the caller:
```json
"bindings": [{ "type": "service", "service": "inventory", "format": "url", "env": "INVENTORY_URL" }]
```
- All four fields are required. `type` is always `"service"` and `format` is always `"url"`. Never set the `env` variable yourself; Vercel injects it.
- Bindings resolve **at runtime in functions only**: not during builds, and not in middleware. **Browser code can't use them.** A frontend calls the backend through its public rewrite path (same origin, e.g. `/api/...`).
- Add a binding only for a real server-to-server call found in step 3. **Ponytail:** no binding "just in case".

## 3. Reconcile the code
- Find cross-service calls and base URLs:
  `grep -rnE "localhost:[0-9]+|127\.0\.0\.1|https?://[a-z0-9-]+:[0-9]+|_URL\b|baseURL|BASE_URL" --include=*.{js,ts,jsx,tsx,mjs,py} <service roots>`
  Also check docker-compose hostnames, service-discovery config, and dev proxies (`vite.config` `server.proxy`).
- **Server → server:** read the bound variable, e.g. `fetch(new URL('items/123', process.env.INVENTORY_URL))`.
- **Browser → server:** use a relative public path (`/api/...`), or keep the existing env base URL and set it to empty or same-origin for Vercel. Keep the dev proxy for local work.
- **Path prefixes:** make sure the backend's mounted routes match the public rewrite. Confirm with `vc dev` plus `curl` whether the service receives `/api/x` or `/x`. Don't assume either.
- CORS between services on one domain is usually no longer needed. Leave the allowed origins in place unless the user says to drop them.
- The **vercel-deployer agent doesn't edit app code.** It lists each needed change (file:line, old → new) for frontend-dev or backend-dev.

## 4. Confirm before finishing (required)
Show the final `vercel.json` and ask the user to confirm (the agent returns these as `INTAKE: QUESTIONS`):
1. The **name** of each service.
2. Which services are **public** and on which path, and which stay **internal**.
3. Each **binding**: which service calls which, and the env variable name.
4. Anything else that was guessed: framework, entrypoint, build command, keys moved from the top level.

Write `vercel.json` only after the answers. Then the user (or a confirmed run) verifies with `vc dev` and a preview deploy.
