---
name: neon-postgres
description: Work with Neon serverless Postgres - pooled vs direct connection strings, the right driver for serverless/edge vs long-lived servers, ORM setup (Prisma, Drizzle), branches for dev and previews, scale-to-zero, roles and SSL, and the Neon MCP for schema, SQL and safe migrations. Use ONLY when the stack uses Neon (SPEC.md Tech Stack, `@neondatabase/*` packages, a `*.neon.tech` URL, or the user names Neon). For generic schema and migration design use database-design; for Supabase use supabase-connect / supabase-mcp.
---

# Neon Postgres

Neon is plain Postgres with serverless compute and copy-on-write branches. Schema design, constraints, indexes and query tuning follow `database-design`; this skill covers only what is Neon-specific.
Never print, log or commit a connection string (it holds the password). Ask the user before anything that writes to the production branch, deletes or resets a branch, or changes a paid plan.

## 0. Detect
- Reuse what's there: `DATABASE_URL` names in `.env.example`, an existing db/client module, the ORM and migration tool in `package.json`.
- First connection to a new project or environment → follow `connect.md` (load it only then).
- Record in your report: `Neon: <project/branch>, <driver>, <ORM or raw SQL>`.

## 1. Connection strings: two, for two jobs
| Variable | Host | Use for |
|---|---|---|
| `DATABASE_URL` | `...-pooler...neon.tech` (pooled, PgBouncer transaction mode) | the app at runtime, especially serverless |
| `DATABASE_URL_UNPOOLED` (or the name the repo already uses) | same host **without** `-pooler` (direct) | migrations, `pg_dump`, session features |

- The pooled URL doesn't keep session state: no `SET` that must persist, no session advisory locks, no `LISTEN/NOTIFY`, and named prepared statements can break on older drivers. Need those → direct URL.
- Keep `sslmode=require` (and `channel_binding=require` when Neon's string has it). Never disable TLS to "fix" a connection.
- **Prisma:** `url` = pooled, `directUrl` = direct (or the datasource config your Prisma version uses; check its docs). **Drizzle:** `drizzle.config.*` points drizzle-kit at the direct URL; the app uses the pooled one.

## 2. Driver: pick by runtime
| Runtime | Driver |
|---|---|
| Edge / serverless functions, one query per request | `@neondatabase/serverless` `neon()` (SQL over HTTP, no connection setup) |
| Serverless needing transactions or sessions | `@neondatabase/serverless` `Pool`/`Client` (WebSocket); create and close it inside the request |
| Long-lived Node server, scripts, migrations | the driver the repo already has (`pg`, `postgres`), standard pooling |

- **Reuse first (Ponytail):** keep the installed driver/ORM. Add `@neondatabase/serverless` only when the runtime is edge or serverless and there's no driver yet. Drizzle adapters: `drizzle-orm/neon-http`, `drizzle-orm/neon-serverless`.
- Node older than 22 has no global `WebSocket`: `Pool`/`Client` need `neonConfig.webSocketConstructor = ws`.
- Always parameterize: tagged template `` sql`... ${value}` `` or `$1` placeholders. Never build SQL from string concatenation.

## 3. Branches
- A branch is an instant copy-on-write copy of its parent (schema + data), with its own compute and connection string.
- **Default (Ponytail):** `main` for production plus one `dev` branch. Add per-preview branches (the Neon Vercel integration, or CI) only when the project deploys previews that write data.
- Test a risky migration on a fresh child branch first, then apply the same migration file to the parent. Don't hand-edit prod schema.
- A branch of prod carries prod data. If it holds PII, don't hand the branch URL to anyone or anything that shouldn't see prod data; seed a branch from a schema-only parent instead.
- Reset a dev branch from its parent rather than writing cleanup scripts. Resetting, deleting or restoring a branch needs the user's yes.

## 4. Compute and limits
- Compute scales to zero after idle time; the first query after that pays a cold start (usually well under a second). Don't add keep-alive pings unless the spec has a latency requirement, and say what they cost.
- Free-plan limits (storage, compute hours, branches, projects) change: check current numbers in Neon's docs before promising capacity. Never upgrade a plan unasked.
- Set connection and statement timeouts in the driver; a cold start plus a slow query must fail clearly, not hang.

## 5. Roles and access
- The default owner role is for migrations. For production, give the app a role with only the privileges it needs (`GRANT SELECT, INSERT, UPDATE, DELETE` on its tables), created in a migration. Load `backend-security` for auth and permission work.
- Neon IP allow lists are a paid feature; without one, the credential is the only guard. Rotate it if it leaked (`project-gitignore` covers untracking).

## 6. Neon MCP (when connected)
- Find the tools with ToolSearch `neon`. Use them to list projects and branches, read schemas, run read-only SQL and get connection strings, instead of guessing the live schema.
- Migrations via the MCP: use its prepare/complete migration flow (it runs on a temporary branch first), and keep the same SQL in the repo's migration files so history stays in git.
- Writes and DDL go to a non-production branch unless the user approved production for this task.
- MCP not connected → report: "Neon MCP not connected; add the official Neon MCP server, then rerun", and work from the repo's migrations and `psql`/ORM against the dev branch.

## 7. Verify (before you report done)
- [ ] The app connects on the pooled URL; migrations ran on the direct URL.
- [ ] One read/write round trip works on the dev branch.
- [ ] `git status` shows no env file with a real URL; `.env.example` has names only.
- [ ] Client bundle has no connection string: build, then grep the output for `neon.tech`. No hits (the DB is server-only).

## Gotchas
| Symptom | Cause / fix |
|---|---|
| `prepared statement "s1" already exists` / does not exist | Session feature on the pooled URL. Use the direct URL for that path, or a driver mode without named statements. |
| Migrations hang or fail with lock errors | Ran over the pooler. Point the migration tool at the direct URL. |
| First request slow, later fast | Scale-to-zero cold start. Expected; see section 4. |
| `too many connections` from serverless | Using the direct URL at runtime. Switch the app to the pooled URL. |
| Works locally, fails on edge runtime | `pg` uses TCP sockets; edge needs `@neondatabase/serverless`. |

Skipped by default (Ponytail): Neon Auth, the Data API, read replicas, logical replication and keep-alive pings. Add them when the spec asks.
