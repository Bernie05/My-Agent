---
name: supabase-connect
description: Connect an app to Supabase end to end - choose browser-direct + RLS or a server-only API from the spec, create or reuse a project (free-plan limits) or run a local Docker stack, lay out env files, write the one client module, first migration, idempotent seed, verify, README and .gitignore. Use ONLY when a project is adding Supabase or wiring a new environment (first connection, new local stack, new deploy target). For schema changes, RLS, advisors and types on an already-connected project, use supabase-mcp instead.
---

# Supabase connect

Steps 0-7 run in order. Write each file from `templates.md`; policies come from `rls-baseline.md`. Load each sibling file only at the step that names it.
Never print, log or commit a secret key. Ask the user before anything that costs money, pauses a project or writes to production (see `supabase-mcp` section 4).

## 0. Detect the stack and pick the mode
1. **Stack:** Vite (`VITE_` prefix, `import.meta.env`), Next.js (`NEXT_PUBLIC_`), or a Node server (Express, `api/` functions on Vercel). Check `package.json` for `@supabase/supabase-js` and look for a `supabase/` folder. Reuse what's already there.
2. **Mode: decide per project from the spec** (SPEC.md or PLAN.md → Tech Stack and Architecture, otherwise the repo):

| Signal | Mode |
|---|---|
| No server: an SPA or static host, and the spec has no backend tasks (B#) or API routes | **browser-direct + RLS** (the TodoPro pattern) |
| There is a server (`api/`, Express, Next route handlers) or the spec calls for one, or it needs secrets, admin actions or third-party calls | **server-only API** with the service key (the MyCatBlog pattern) |
| Both or unclear | Ask one question (`INTAKE: QUESTIONS` or report it to the architect). Don't guess. |

   - **browser-direct:** the browser holds the URL plus the publishable/anon key. RLS is the only guard, so every table gets owner policies. Auth defaults to **anonymous sign-in**, and you can upgrade to email later (`rls-baseline.md` → Upgrade).
   - **server-only:** only the server imports Supabase, with the service key. The browser calls `/api/*`. RLS is on with no policies (deny by default), and the API enforces permissions itself, so load `backend-security`.
3. Record it in your report as `Supabase: <mode>, <local | project ref>, <reason>`.

## 1. Project
- **Default: one project per app.** On Pro, a dev+prod pair is an option. Suggest it only when the user is on Pro or asks.
- **Free-plan limit:** 2 **active** projects per user, counted across all orgs. Paused projects don't count. Before `create_project`, run `list_projects` and count the active ones. At the limit, offer: **pause one** (the user picks it), **upgrade to Pro**, or **local Docker**. Never pause anything unasked.
- Creating a project goes through the cost confirmation (`get_cost` → `confirm_cost` → `create_project`) after the user says yes. Never act on a project the user didn't name.
- **Local dev (Docker):** Docker Desktop must be running.
  1. `npx supabase init` creates `supabase/config.toml`.
  2. Browser-direct only: set `[auth] enable_anonymous_sign_ins = true` in `config.toml` (`templates.md` → config.toml).
  3. `npx supabase start`. The API is at `http://127.0.0.1:54321` and Studio at `http://127.0.0.1:54323`.
  4. Take the local URL and keys from `npx supabase status`, and put them only in `.env.local`.
- **Hosted, browser-direct:** the user turns on anonymous sign-ins in the dashboard (Authentication → Sign In / Providers). Recommend CAPTCHA, or at least the default rate limit, before production.

## 2. Env layout
| Where | Committed | Holds |
|---|---|---|
| `.env.example` | yes | variable names and safe placeholders only |
| `.env.local` | **no** | local/dev URL and keys, `SUPABASE_SERVICE_ROLE_KEY` (server mode or seed), `SEED_USER_ID` |
| Deploy host env vars (e.g. Vercel) | n/a | production values, set by the user or via `vercel-deploy` |

- Match the variable names the repo already uses (`..._ANON_KEY` or `..._PUBLISHABLE_KEY`). Templates: `templates.md` → .env.example.
- **The service/secret key never gets a `VITE_` or `NEXT_PUBLIC_` prefix.** Those prefixes are bundled into the client.
- **Vercel CLI deploys:** add `.vercelignore` (`templates.md`). On MyCatBlog, env files leaked into CLI uploads without it.

## 3. Client module
- **Reuse first (Ponytail):** if a client already exists (`src/lib/supabase.ts`, `api/_lib/...`), extend it. There is **one** module per side, and no repository or wrapper layer around the client.
- **browser-direct:** use `templates.md` → Browser client: `createClient<Database>`, fail fast on missing env, and `ensureSession()` for anonymous sign-in. Next.js with server-side auth needs `@supabase/ssr` (check `search_docs`).
- **server-only:** use `templates.md` → Server client. It lives outside `src/` and is never imported by browser code. Set `persistSession: false`.
- Native first: let RLS, constraints and column defaults (`owner_id default auth.uid()`) do the checks before you write app code for them.

## 4. Migrations and types: follow `supabase-mcp`
- Load `supabase-mcp` and follow its section 2 (workflow) and section 3 (repo history). Write the file first: `npx supabase migration new <name>`.
- Policies: `rls-baseline.md`, for the mode you picked.
- **Local:** `npx supabase db reset` applies the migrations plus `seed.sql`.
- **Hosted:** `npx supabase link --project-ref <ref>`, then `npx supabase db push`. Prefer this over MCP `apply_migration`, which records a different version than the file timestamp. If you did use MCP, fix `schema_migrations` per `supabase-mcp` section 3.
- **Types:** `npx supabase gen types typescript --local > src/types/database.ts` (hosted: `--project-id <ref>` or MCP `generate_typescript_types`).

## 5. Seed
- `supabase/seed.sql` holds a no-op placeholder. User-owned rows need a real auth user, so they don't go there.
- `scripts/seed.mjs` (`templates.md` → Seed) is idempotent: it upserts fixed ids with the service key and `SEED_USER_ID` from `.env.local`, and refuses non-local URLs unless `--remote` is passed. Run it with `node --env-file=.env.local scripts/seed.mjs` (Node 20.6+).
- To get `SEED_USER_ID`, open the app once (the anonymous sign-in creates the user), then copy the id from Studio → Authentication.
- Never seed a hosted or production project without asking.

## 6. Verify (all must pass before you report done)
- [ ] The app starts, a session exists (anonymous in browser-direct mode), and one create/read/update/delete round trip works.
- [ ] **RLS:** a second user (private window) can't see the first user's rows. Every `public` table has `rowsecurity = true` (`rls-baseline.md` → Check).
- [ ] **No secrets in the client:** build, then grep `dist/` (or `.next/`) for `service_role`, `sb_secret_` and the service key's variable name. There must be no hits.
- [ ] `git status` shows no `.env.local` and no `supabase/.temp`.
- [ ] Hosted: `get_advisors` security is clean. Local: `npx supabase db lint`.
- [ ] Server mode: call each `/api` route with and without auth and get the expected status. **Git Bash:** prefix with `MSYS_NO_PATHCONV=1`, or `/api/...` arguments get rewritten into Windows paths.

## 7. README and .gitignore
- Load `project-gitignore` and merge its baseline. Make sure `.env.local`, `.env*.local`, `supabase/.temp` and `supabase/.branches` are ignored and `!.env.example` is kept.
- Add the `templates.md` → README section: prerequisites, local start, env names (never values), seed, and deploy env vars.

## Gotchas (learned the hard way)
| Symptom | Cause / fix |
|---|---|
| `create_project` fails or is blocked | Free-plan 2-active-project limit. Pause one, go Pro, or use local Docker. |
| `db push` re-runs migrations or says "versions not found" | MCP recorded its own version. Repair `schema_migrations` (`supabase-mcp` section 3). |
| Env file in a Vercel deployment | No `.vercelignore` on a CLI deploy. |
| Service key in the bundle | It had a `VITE_`/`NEXT_PUBLIC_` prefix. Rename it, rotate the key, rebuild. |
| `curl /api/x` hits `C:/Program Files/Git/api/x` | Git Bash path conversion. Use `MSYS_NO_PATHCONV=1`. |
| Anonymous sign-in returns 422 "disabled" | Turn it on in `config.toml` (then `supabase stop` / `start`) or in the dashboard. |
| Empty results or 401/403 | RLS. See `supabase-mcp` → Debugging. |

Skipped by default (Ponytail): dev+prod project pair, email auth UI, Edge Functions and a repository layer. Add them when the spec asks.
