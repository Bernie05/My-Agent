# Neon: first connection

Load this from `SKILL.md` section 0 only for a first connection or a new environment.

1. **Project.** Reuse the user's Neon project if the spec or repo names one. Creating one: via the Neon MCP (ToolSearch `neon`) or the Neon console, after the user says yes. Pick the region closest to the app's host.
2. **Branches.** `main` = production. Create one `dev` branch for local work (MCP or `npx neonctl branches create --name dev`). Pin `neonctl` in `devDependencies` if a script uses it.
3. **Env files** (load `project-gitignore` and merge its baseline first):

   | File | Committed | Holds |
   |---|---|---|
   | `.env.example` | yes | `DATABASE_URL=postgresql://USER:PASSWORD@HOST-pooler.REGION.aws.neon.tech/DB?sslmode=require` and the `_UNPOOLED` twin, placeholders only |
   | `.env.local` / `.env` (ignored) | **no** | the `dev` branch's pooled and direct URLs |
   | Deploy host env vars | n/a | the `main` branch URLs, set by the user or `vercel-deploy` |

   Database URLs never get a `VITE_` or `NEXT_PUBLIC_` prefix.
4. **Client module.** One module (e.g. `src/db.ts` or `lib/db.ts`) that reads the env var, fails fast if it's missing, and exports the client or ORM instance. Driver per `SKILL.md` section 2. No wrapper layer around it.
5. **Schema.** Write migrations with the repo's tool (`database-design` for the design). Run them on the direct URL of `dev`, then on `main` at deploy time with the user's approval.
6. **Seed.** Idempotent (`INSERT ... ON CONFLICT DO NOTHING`), and refuses to run against the `main` branch host unless an explicit flag is passed.
7. **Verify** with `SKILL.md` section 7, then add a README section: prerequisites, env names (never values), migrate, seed.
