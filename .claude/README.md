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
| `web-design-guidelines` | UI / accessibility audit — fetches its rules live from vercel-labs/web-interface-guidelines | vercel-labs/agent-skills (MIT) |

Unmodified copies.

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

## Upstream versions

| Repo | Commit |
|---|---|
| github.com/wshobson/agents | `156b7a5` |
| github.com/anthropics/skills | `8a1541c` |
| github.com/supabase/agent-skills | `544bfc5` |
| github.com/vercel-labs/agent-skills | `063bee9` |

To update, re-copy from upstream and review the diff before committing — these files are instructions Claude follows.
