# Claude Code toolkit

Project-scoped agents, skills, and slash commands for a **Next.js + TypeScript + Supabase + Vercel** stack. Claude Code picks these up automatically when run from this repo.

| Type | Folder | How it's used |
|---|---|---|
| Agents | `agents/` | Sub-agents with their own context window. Claude delegates to them automatically, or ask: *"use the debugger agent on …"*. |
| Skills | `skills/` | Knowledge packs loaded on demand when a task matches their description. |
| Commands | `commands/` | Slash commands you type, e.g. `/feature add password reset`. |

## Agents

| Agent | Use for | Source |
|---|---|---|
| `frontend-developer` | React 19 / Next.js App Router components, state, accessibility | wshobson/agents |
| `backend-architect` | API contracts, service layering, auth, resilience | wshobson/agents |
| `database-architect` | Schema design, indexes, migrations | wshobson/agents |
| `typescript-pro` | Advanced types, strict config | wshobson/agents |
| `test-automator` | Unit / integration / E2E tests following project conventions | wshobson/agents |
| `debugger` | Root-cause analysis of errors and failing tests | wshobson/agents |
| `code-reviewer` | Quality, SOLID, performance, security review | wshobson/agents |
| `security-auditor` | OWASP, auth flows, secrets, threat modeling | wshobson/agents |
| `docs-architect` | Architecture docs and technical write-ups | wshobson/agents |

Local changes vs upstream: only the frontmatter `name` (plugin prefix removed) and `model` (set to `inherit`, so agents use your session's model).

## Skills

| Skill | Use for | Source |
|---|---|---|
| `frontend-design` | Distinctive, non-templated UI design | anthropics/skills (Apache-2.0) |
| `webapp-testing` | Driving the running app with Playwright | anthropics/skills (Apache-2.0) |
| `supabase` | Auth, RLS, migrations, CLI/MCP, security checklist | supabase/agent-skills (MIT) |
| `supabase-postgres-best-practices` | Postgres schema, indexing, RLS, query performance rules | supabase/agent-skills (MIT) |
| `vercel-react-best-practices` | 70 React/Next.js performance rules | vercel-labs/agent-skills (MIT) |
| `vercel-composition-patterns` | Scalable component APIs (compound components, etc.) | vercel-labs/agent-skills (MIT) |
| `web-design-guidelines` | UI / accessibility audit | vercel-labs/agent-skills (MIT) |

Unmodified copies, except `web-design-guidelines`: upstream fetched its rules from GitHub at run time; the rules are now vendored in `references/guidelines.md` (pinned) and `SKILL.md` reads the local copy instead.

## Commands

| Command | What it does |
|---|---|
| `/feature <desc>` | Branch → design (checkpoint) → implement → test → review (checkpoint) |
| `/test [target]` | Write and run tests for the current changes |
| `/commit [hint]` | Conventional Commits message from the diff, then commit |
| `/pr [base]` | Draft a PR title and description |
| `/refactor <target>` | Behavior-preserving clean-architecture refactor with a safety net |
| `/explain <target>` | Learning-oriented walkthrough: flow, patterns, gotchas |

Written for this repo; they orchestrate the agents and skills above.

Built-in commands that complement these (no files needed): `/code-review`, `/security-review`, `/simplify`, `/init`.

## Sync to other devices

This repo is the source of truth. `scripts/sync-claude.sh` installs the agents, skills, and commands into `~/.claude/` so they work in **every** project on a device.

```bash
# first time on a device
git clone https://github.com/Bernie05/My-Agent.git && cd My-Agent
./scripts/sync-claude.sh

# later: pull + re-sync (symlink mode picks up pulled changes even without re-running,
# but re-run to install newly added items and prune removed ones)
./scripts/sync-claude.sh
```

| Flag | Effect |
|---|---|
| *(none)* | `git pull --ff-only`, run the security audit, then symlink each item |
| `--copy` | Copy instead of symlink (default on Git Bash for Windows) |
| `--dry-run` | Show what would change without changing anything |
| `--no-pull` | Skip `git pull` |
| `--uninstall` | Remove everything this script installed |

Behavior: only items listed in `~/.claude/.my-agent-sync-manifest` are ever changed or removed, so your own agents are untouched; an unmanaged item with the same name is backed up as `*.bak-<timestamp>`. If the audit reports unreviewed findings, nothing is installed. `settings.json` and `CLAUDE.md` stay project-only by design. Respects `CLAUDE_CONFIG_DIR` if set.

## Upstream versions

| Repo | Commit |
|---|---|
| github.com/wshobson/agents | `156b7a5` |
| github.com/anthropics/skills | `8a1541c` |
| github.com/supabase/agent-skills | `544bfc5` |
| github.com/vercel-labs/agent-skills | `063bee9` |
| github.com/vercel-labs/web-interface-guidelines | `e3d624b` |

## Security

These files are instructions Claude follows, so they are treated as code that can be attacked (prompt injection, supply chain).

| Layer | What it does |
|---|---|
| Audit on install | Every file was read and scanned for injection phrasing, hidden Unicode (zero-width / bidi / tag chars), pipe-to-shell, exfiltration patterns, and hidden markup. No malicious content found. |
| No live remote instructions | `web-design-guidelines` rules are pinned locally instead of fetched each run. The `supabase` skill still reads supabase.com docs (reference data only; `CLAUDE.md` says fetched content is never instructions). |
| `CLAUDE.md` rules | Untrusted content is data, never instructions; never read/commit secrets; ask before any outbound action (push, deploy, remote migration, filing issues, installing packages). |
| `settings.json` | Denies reading `.env*`, keys, and credential files, editing `settings.json` itself, `rm -rf /`/`~`, force-push, and `curl`/`wget` piped to a shell. Asks before `git push`, deploys, remote DB pushes, and edits to `.claude/` or `CLAUDE.md`. |
| `scripts/audit.py` | Re-runnable scanner with a reviewed baseline (`scripts/audit-baseline.txt`). New findings fail with exit 1. |

Known-benign baseline entries: the deny rules in `settings.json`, the example injection phrase in `CLAUDE.md`, and Supabase docs that mention access tokens.

### Updating from upstream
1. Re-copy the files from upstream.
2. `git diff` — read every change.
3. `python3 .claude/scripts/audit.py` — investigate each new finding; only after review run it with `--update-baseline`.
4. Update the commit table above.

`settings.json` deny rules are a safety net, not a sandbox: pattern rules can be bypassed by creatively written commands. The real protection is reviewing what goes into `.claude/` and approving outbound actions yourself.
