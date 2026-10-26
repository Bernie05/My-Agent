# Create a new Vercel project

Load for the **setup** operation when no Vercel project exists yet (`list_projects` finds nothing by name or repo). Every outward step needs `confirmed: create` in the prompt; without it, return `NEEDS CONFIRMATION` with the plan below filled in. `vc` = `npx --yes vercel@latest`. Verified against Vercel CLI 65.

## 0. Plan (no changes yet)
- Run §1 Preflight and §2 auth from SKILL.md. Get the team with MCP `list_teams` (one team → use it; several → ask).
- **Shape:** one app → a normal project. Two or more apps (e.g. `client/` + `server/`) → one project in services mode; load `services.md` and finish its step 4 questions before step 1 here.
- **Name:** the repo name, lowercase-kebab, unless the user gave one.
- **Needs:** read the env names in `.env.example` (names only) and group them:
  - database (`DATABASE_URL`…)
  - storage (`BLOB_*`)
  - auth or third-party keys
  - secrets the project generates itself (`*_SECRET`)
  - plain config
- Return the plan as `INTAKE: QUESTIONS` if anything is a guess: name, team, shape, which integrations, Node version, production domain.

## 1. Create, link, connect Git
```
vc project create <name> --scope <team> 2>&1 | tail -n 5
vc link --yes --project <name> --team <team> 2>&1 | tail -n 5     # at the repo root; writes .vercel/
vc git connect <git remote url> 2>&1 | tail -n 5                  # pushes to branches → previews, main → production
```
- `.gitignore` must have `.vercel` and `.env*` before anything else (load `project-gitignore` if missing).
- **After `vc link`, check the `.gitignore` diff.** The CLI appends `.vercel` and `.env*` at the end of the file, and that `.env*` overrides an earlier `!.env.example`, because the last matching line wins. Drop the appended lines if the file already covers them, and check with `git check-ignore .env.example`, which should match nothing.
- `vc link` and `blob create-store` write `VERCEL_OIDC_TOKEN` and `BLOB_*` into the root `.env.local`. That's expected; it is gitignored.
- **Settings** (MCP `update_project`; check its schema):
  - Node version = `engines.node`.
  - Root directory: `.` for services mode, otherwise the app folder.
  - Framework / build / output only when auto-detect is wrong.
  - If MCP `update_project` returns 404 (it can be scoped to a different account than the CLI), use `vc api /v9/projects/<id> -X PATCH` with the same fields.
- **Check two defaults and report them:**
  - Pushes to a connected repo deploy automatically by default. They're only off if `vercel.json` has `git.deploymentEnabled: false`. Don't read `gitProviderOptions.createDeployments: disabled` as "auto-deploy off": there's no dashboard switch for it, so don't send the user looking for one.
  - Deployment Protection is usually on for previews, so an unauthenticated `curl` gets 401.

## 2. Storage and integrations
| Need | How |
|---|---|
| **New** Neon database | `vc integration add neon -e production -e preview -e development --yes 2>&1 \| tail -n 10`. This creates a new Neon project billed through Vercel and pulls `DATABASE_URL`/`DATABASE_URL_UNPOOLED`. `vc integration add neon --help` lists metadata keys (region). |
| **Existing** Neon project | Not possible from the CLI. The user links it in the dashboard (Marketplace → Neon → link existing project, preview branches on), or sets the env vars by hand from `neon connection-string`. Never create a second database "to make it work". |
| Other Marketplace product | `vc integration discover <query>`, then `vc integration add <name>`. Only `neon` accepts `--yes`; others need the user in a browser, so report the command. |
| Blob store | `vc blob create-store <name> --access public\|private --yes -e production -e preview -e development` (needs `@vercel/blob` 2.3 or later for private). **Since 2026, connecting a store adds `BLOB_STORE_ID`, `VERCEL_OIDC_TOKEN` and `BLOB_WEBHOOK_PUBLIC_KEY`, not a read-write token.** The SDK uses OIDC with `storeId`, and an explicitly passed `token` always wins. **Two stores in one project:** both connections claim `BLOB_STORE_ID`. Don't fight the dashboard prefix; have the code pass `storeId` per store from its own env var (e.g. `BLOB_PRIVATE_STORE_ID`, set with `vc env add`; get the id from `vc api /v1/storage/stores`). Keep a read-write token only for local/outside-Vercel use. Docs: vercel.com/docs/vercel-blob/using-blob-sdk#authentication |

- Pick the region nearest the database and users. Paid plans or add-ons: stop and ask; never accept billing.

## 3. Env vars
- **Generated secrets** (never printed, never written to a file):
  `node -e "process.stdout.write(require('crypto').randomBytes(32).toString('hex'))" | vc env add <NAME> --environment production,preview --sensitive 2>&1 | tail -n 2`
- **Values from the user:** `printf '%s' "$VALUE" | vc env add <NAME> --environment <targets>`. Ask for the value; don't echo it.
- **Finish with the `env` operation:** compare against `.env.example` per target and report what's still missing.

## 4. First deploy and hand-off
- **The project's first deployment becomes production, even without `--prod`.** Before the first `vc deploy`, check that production env vars are complete; otherwise a broken production alias goes live. Then preview-deploy and verify (SKILL.md §4–5). Production only with `confirmed: production`.
- **Neon-managed integration with preview branches:** a Git-pushed preview gets its own Neon branch and `DATABASE_URL`. A CLI deploy from the working tree gets **no** Preview DB vars. Either push the branch, or set Preview `DATABASE_URL*` to a dev branch by hand.
- Report:
  - the project URL
  - the Git connection
  - integrations and stores, with the env names they added
  - env vars still missing
  - manual dashboard steps left (existing-Neon link, domain DNS)
  - for services mode, the confirmed `vercel.json`
