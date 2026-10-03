---
name: project-gitignore
description: Create or fix a project's .gitignore so secrets, local config, dependencies and build output are never committed - a security baseline plus stack-specific entries. Use when creating or scaffolding a new project, running git init, or when a repo has no .gitignore or is missing security entries.
---

# Project .gitignore

Every new project gets a `.gitignore` **before the first commit**. Security entries are never cut.

## Steps
1. **Detect the stack** from the files present (`package.json`, `requirements.txt`/`pyproject.toml`, `go.mod`, `Cargo.toml`, `*.csproj`, `composer.json`, `pom.xml`/`build.gradle`, `supabase/`, `.vercel/`).
2. **If a scaffolder made one** (create-next-app, Vite, `dotnet new`, and so on), keep it and **merge in** the security baseline below. Don't replace it.
3. **Otherwise, create it** with the security baseline plus the matching stack blocks.
4. **Check for leaks** (only if the folder is already a git repo):
   ```
   git ls-files | Select-String -Pattern '\.env|\.pem$|\.key$|id_rsa|credentials|secrets?\.|\.pfx$|\.p12$'
   ```
   For each tracked secret file, run `git rm --cached <file>` (this keeps the local copy). Then **tell the user** the secret is still in git history and must be **rotated**. If it was pushed, it's compromised; `.gitignore` alone doesn't fix that.
5. **Keep examples committed.** Add `!.env.example` so a template with no real values stays in the repo. Create `.env.example` if the project reads env vars.
6. Report in one line: `.gitignore: created | merged (+N entries) | ok` and any leaked files found.

## Security baseline (always)
```gitignore
# --- Secrets & credentials ---
.env
.env.*
!.env.example
*.pem
*.key
*.p12
*.pfx
*.crt
id_rsa*
id_ed25519*
*.keystore
*.jks
credentials*.json
service-account*.json
secrets.*
*.secret
.npmrc
.pypirc
.netrc

# --- Local tool / cloud config (may hold tokens) ---
.vercel/
.netlify/
.firebase/
.supabase/
supabase/.temp/
.terraform/
*.tfstate
*.tfstate.*
.aws/
.claude/settings.local.json

# --- Logs, dumps & local data ---
*.log
logs/
*.sqlite
*.sqlite3
*.db
*.dump
*.sql.gz

# --- OS & editor ---
.DS_Store
Thumbs.db
desktop.ini
.idea/
.vscode/*
!.vscode/extensions.json
!.vscode/settings.json
*.swp
```

## Stack blocks (add only the ones that match)
| Stack | Add |
|---|---|
| Node / JS / TS | `node_modules/`, `dist/`, `build/`, `out/`, `.next/`, `.nuxt/`, `.svelte-kit/`, `.turbo/`, `.cache/`, `coverage/`, `*.tsbuildinfo`, `npm-debug.log*`, `yarn-error.log*`, `pnpm-debug.log*` |
| Python | `__pycache__/`, `*.py[cod]`, `.venv/`, `venv/`, `env/`, `.pytest_cache/`, `.mypy_cache/`, `.ruff_cache/`, `*.egg-info/`, `dist/`, `build/`, `.coverage`, `htmlcov/` |
| .NET | `bin/`, `obj/`, `*.user`, `.vs/`, `appsettings.*.local.json` |
| Java / Kotlin | `target/`, `build/`, `.gradle/`, `*.class`, `local.properties` |
| Go | `/bin/`, `*.exe`, `*.test`, `vendor/` (only if not vendoring on purpose) |
| Rust | `target/` |
| PHP | `vendor/`, `.phpunit.result.cache` |
| Mobile | `ios/Pods/`, `*.xcuserstate`, `android/.gradle/`, `android/app/release/`, `google-services.json`, `GoogleService-Info.plist` |
| Playwright / tests | `test-results/`, `playwright-report/`, `playwright/.cache/` |

## Don't ignore
- Lockfiles (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `poetry.lock`, `Cargo.lock` for apps). They pin dependencies, which is a security feature.
- `.env.example`, migrations, and `supabase/migrations/`.
