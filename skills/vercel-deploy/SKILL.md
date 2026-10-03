---
name: vercel-deploy
description: Deploy and operate a project on Vercel with low token use - preflight checks, linking, preview/production deploys via the Vercel CLI (npx) or a Git-connected project through the Vercel MCP, build-failure diagnosis, env vars, domains, rollback and promote. Use when the vercel-deployer agent or a /deploy command deploys or inspects a project on Vercel.
---

# Vercel deploy

## Tools
- **CLI:** `npx --yes vercel@latest <cmd>`. No global install is needed. Run it in **Bash** (Git Bash) so `2>&1 | tail` works. Below, `vc` is short for `npx --yes vercel@latest`.
- **Vercel MCP** (`mcp__claude_ai_Vercel__*`): for reads and for Git-based deploys. Load only the tools you need with `ToolSearch("select:<name>,<name>")`. Never keyword-search the whole list; it has 200+ tools.
  - Look up the team/project: `list_teams`, `list_projects`, `get_project`
  - Check deployments: `list_deployments`, `get_deployment`
  - Read logs: `list_deployment_events` (build), `get_runtime_errors`, `get_runtime_logs`
  - Change state: `request_promote`, `request_rollback`
  - Env vars: `filter_project_envs`, `create_project_env`, `edit_project_env`
  - Domains: `list_project_domains`, `add_project_domain`
  - Git deploys: `create_deployment`

## 1. Preflight: cheap checks only
Run these in one batch:
- **Project root:** `package.json` (or another manifest). Read only `scripts`, `engines`, and the framework dependency.
- **Link state:** `.vercel/project.json` gives `projectId` and `orgId`. `vercel.json` may exist too.
- **Git:** `git status --porcelain | head`, `git rev-parse --abbrev-ref HEAD`, `git log -1 --oneline`, `git remote -v | head -2`.
- **Env names:** the keys in `.env.example`, `.env.local.example` or `.env.sample`. **Read names only, never values.** Never read `.env`, `.env.local` or `.env.production`.
- **.gitignore** must contain `.vercel` and `.env*`. If either is missing, report it; add `.vercel` only when you are allowed to change files.

## 2. Auth and linking
- **Auth check:** `vc whoami 2>&1 | tail -n 2`.
  - If it fails and `VERCEL_TOKEN` is set, add `--token "$VERCEL_TOKEN"` to every command.
  - If there is no token, stop and report: *"Vercel CLI isn't logged in — run `! npx vercel login` in the prompt (or set VERCEL_TOKEN), then retry."*
  - Never paste or print a token.
- **Not linked:**
  - Find the project first with the MCP `list_projects`, matched by name or repo.
  - Then run `vc link --yes --project <name> [--scope <team>] 2>&1 | tail -n 5`.
  - Create a new project only when the prompt says so.

## 3. Pick a deploy method
| Situation | Method |
|---|---|
| CLI is authenticated | **CLI**. It uploads the working tree, including uncommitted changes. |
| Project is Git-connected, the commit is pushed, and the CLI can't authenticate | **MCP `create_deployment`** with the git source of the current branch and commit (check the tool's schema) |
| Commits aren't pushed | Don't push. Report it and let the user decide. |

Uncommitted changes plus a **production** deploy: warn about this in the report, because what is live won't match git.

## 4. Deploy
- **Preview (default):**
  ```
  vc deploy --yes 2>&1 | tail -n 15
  ```
- **Production:** run it only when the prompt says `confirmed: production`.
  ```
  vc deploy --prod --yes 2>&1 | tail -n 15
  ```
- `vc deploy` waits until the deployment is Ready or Error. The deployment URL is the `https://…vercel.app` line.
- **MCP path:** check `get_deployment` for its state. While it is `BUILDING` or `QUEUED`, run `sleep 45` as a **background** Bash command, then check again. Stop after 10 checks.

## 5. Verify
- Check the URL with `curl -s -o /dev/null -w "%{http_code}\n" <url>`.
  - `200` is OK. So is `401` when the preview has Vercel Authentication on; say that in the report.
  - For production, also check each assigned domain.
- **Build failed:** read only the errors.
  ```
  vc inspect <url> --logs 2>&1 | grep -iE "error|failed|cannot|not found|missing" | tail -n 30
  ```
  If that shows nothing, fall back to `tail -n 40`, or to MCP `list_deployment_events` (last events only).
- **Runtime 500s:** use MCP `get_runtime_errors` or `get_runtime_logs`, filtered to that deployment and the last 15 minutes.
- **Common causes:**
  - A missing env var
  - The wrong build command or output directory
  - A Node version mismatch (`engines.node` vs the project setting)
  - A case-sensitive import path: it works on Windows and fails on Linux
  - A lockfile out of sync
  - A package-manager mismatch

## 6. Other operations
- **Status:** MCP `list_deployments`, limit 5, fields state, target, url, createdAt, commit. Also `get_project` for domains.
- **Env:**
  - List: `vc env ls 2>&1 | tail -n 40` or MCP `filter_project_envs`. **Names and targets only.**
  - Compare against the names in `.env.example` and report the missing keys per target (production, preview, development).
  - Add: `printf '%s' "$VALUE" | vc env add NAME production`, with the value taken from the user. Never log it and never write it to a file.
- **Domains:** `vc domains add <domain>` or MCP `add_project_domain`. Then report the DNS records the user must set (A, CNAME, TXT) exactly as Vercel returns them.
- **Rollback:** `vc rollback <previous-url> --yes`, or MCP `request_rollback`. Find the target with `list_deployments` (last READY production deploy before the current one).
- **Promote:** `vc promote <preview-url> --yes`, or MCP `request_promote`.

## Safety
- Production deploys, rollbacks, promotes, production env changes, domain changes and project deletion are **outward-facing**. Do them only when the prompt carries `confirmed: <action>`.
- Never `git push`, commit, or change git config, unless the prompt says so.
- Never print, log or commit secrets. Mask anything that looks like a key if it shows up in output.
- Don't create Vercel projects, teams, or paid add-ons unless told to.

## Token rules
- Always pipe CLI output through `tail` or `grep`. Never dump full build logs.
- Load MCP tools with `select:`. One `get_*` per object; don't re-fetch what you already have.
- Skip local builds (`npm run build`), since Vercel builds remotely. Build locally only to reproduce a failure, and then `| tail -n 30`.
