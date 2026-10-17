# Catalog: Agents, Commands, Skills

A one-line reference for everything in `~/.claude`. For the full design → spec → build → QA workflow, see [docs/AGENT-SYSTEM.md](docs/AGENT-SYSTEM.md).

- **Agent**: a specialist Claude that a command calls, or that you can ask for by name ("use the judge agent…").
- **Command**: type `/group:name` in the prompt.
- **Skill**: know-how that agents load when they need it. You rarely call these directly.

---

## Agents (`agents/`)

| Agent | Folder | What it does |
|---|---|---|
| `figma-designer` | design | Designs features/apps in Figma (tokens, components, screens, flows) and writes DESIGN.md |
| `architect` | architecture | Writes the spec (SPEC.md, scenarios), splits it into FE/BE/QA tasks, triages QA issues. No code |
| `frontend-dev` | developer | Builds frontend tasks (F#), and debugs, tests, refactors and fixes accessibility of UI code. Writes minimal code (Ponytail). Picks shadcn/ui or Material UI from the spec |
| `backend-dev` | developer | Builds backend tasks (B#): APIs, logic, database, migrations. Debugs, tests, secures. Writes minimal code (Ponytail) |
| `fullstack-dev` | developer | Builds both frontend (F#) and backend (B#) tasks in one context when Dev team is `fullstack` (default for `/quick`). Runs on Opus |
| `qa-agent` | qa | Plans and runs tests, reports issues with evidence, gives the release go/no-go |
| `code-reviewer` | review | Reviews a diff, PR or files for bugs, security and risky logic, plus over-engineering. Also audits the whole repo for bloat |
| `trial-agent` | court | Court clerk: asks you questions about an idea, writes the Case File, launches the trial tabs |
| `lawyer-attacker` | court | Attacks any work and finds every real hole (never fixes) |
| `lawyer-defender` | court | Defends the work: rebuts, fixes holes, returns a stronger version |
| `judge` | court | Neutral final verdict: rules on each hole, gives the best final version |
| `vercel-deployer` | deploy | Deploys to Vercel (preview, or production after you confirm); status, logs, env, domains, rollback. The deploy stage of `/flow:start` and `/quick:start` |
| `agent-factory` | factory | Finds, security-reviews, builds, improves and organizes agents, skills and commands. Proposal first; builds only after you approve |
| `observer` | factory | Watches how the agents actually worked (run stats, routine findings) and proposes improvements for NEEDED.md. Read-only |
| `resume-manager` | personal | Keeps your MyResume portfolio site up to date: GitHub projects, experience, skills, about |
| `system-documenter` | docs | Documents a whole system into `Notes/`: config, system flow, data flow, DB schema, with Mermaid diagrams and plain-language summaries |
| `digest` | utility | Reads a big log, CI output, doc or diff in its own context and returns the ~20 lines you need (exact quotes, file:line), saving main-conversation tokens |

---

## Commands (`commands/`)

### `/design:*`: Figma design
| Command | What it does |
|---|---|
| `/design:start` | Full Figma design for a feature, then stops for your approval (Gate 0) |
| `/design:system` | Build or extend the design system (tokens, styles, components) |
| `/design:screen` | Design or update specific screens/flows |
| `/design:revise` | Apply feedback to the design |
| `/design:review` | Review a design, or compare the built app against Figma |
| `/design:handoff` | Regenerate DESIGN.md from the Figma file |
| `/design:approve` | Approve the design and hand it to the architect |

### `/arch:*`: Architect
| Command | What it does |
|---|---|
| `/arch:analyze` | Full spec, scenarios, user journeys, architecture (SPEC.md) — then stops for approval (Gate 1) |
| `/arch:review` | Read a spec and review its completeness, architecture, edge cases, risks |
| `/arch:breakdown` | Split a spec into F# / B# / QA tasks with dependencies (Gate 2) |
| `/arch:finalize` | Merge task fixes into a final spec (Gate 3) |
| `/arch:analyze-issue` | Triage a QA issue: bug or new requirement, impact, recommendation |
| `/arch:suggest-refactor` | Refactor opportunities in the codebase (read-only) |

### `/fe:*`: Frontend
| Command | What it does |
|---|---|
| `/fe:code` | Build an F# task (one component or feature) |
| `/fe:debug` | Reproduce a UI bug, root cause, push a fix |
| `/fe:test` | Test a frontend feature end-to-end in a real browser |
| `/fe:refactor` | Rewrite a section for clarity, consistency or performance |
| `/fe:a11y` | Audit a UI for accessibility and fix issues |
| `/fe:optimize` | Measure render/bundle size, fix the slowest part, re-measure |

### `/be:*`: Backend
| Command | What it does |
|---|---|
| `/be:code` | Build a B# task (API, logic, DB migration) |
| `/be:debug` | Root-cause a runtime or test failure, push a fix |
| `/be:test` | Test a backend feature (unit, integration, API) |
| `/be:security` | Security audit of the backend code |
| `/be:refactor` | Rewrite for clarity, consistency or performance |
| `/be:optimize` | Measure query/API latency, fix the slowest, re-measure |

### `/fs:*`: Fullstack (frontend + backend in one context)
| Command | What it does |
|---|---|
| `/fs:code` | Build an F# + B# task pair (fullstack feature) |
| `/fs:debug` | Fullstack debugging (frontend + backend root cause) |
| `/fs:test` | Test the whole feature end to end (browser + API) |
| `/fs:optimize` | Measure + fix slowest cost across both tiers |

### `/qa:*`: QA
| Command | What it does |
|---|---|
| `/qa:start-testing` | Plan a full test of a feature, execute it, report issues |
| `/qa:test-scenario` | Execute one scenario from scenarios.md step by step |
| `/qa:test-checklist` | Run the 9-category test checklist |
| `/qa:report-issue` | Write a bug with repro, evidence, severity, blocking status |
| `/qa:triage-issue` | Classify an issue as Valid Bug / New Requirement / Ambiguous |
| `/qa:approve-feature` | Final sign-off: all tests pass, no blockers. Triggers release |

### `/flow:*`: Orchestration & control
| Command | What it does |
|---|---|
| `/flow:start` | Run the full pipeline: design → spec → tasks → build → QA → deploy |
| `/flow:status` | Where are we now? Show the feature FLOW.md |
| `/flow:team` | Switch Dev team between `split` (FE + BE parallel) and `fullstack` |
| `/flow:mode` | Confirm or change execution mode (verbose, terse, silent, debugging) |
| `/flow:pause` | Pause the pipeline; come back when ready |
| `/flow:resume` | Continue from where you paused |

### `/quick:*`: Fast path (plan → build → check → deploy)
| Command | What it does |
|---|---|
| `/quick:start` | Build a small feature in one pass: plan (PLAN.md) → build → QA → optional deploy |
| `/quick:resume` | Pick up where you left off in a quick:start run |

### `/court:*`: Live code review trial
| Command | What it does |
|---|---|
| `/court:trial` | Start a live courtroom trial: Clerk (you) → Attacker (finds holes) → Defender (rebuts) → Judge (verdict) |

### `/factory:*`: Agent, skill and command factory
| Command | What it does |
|---|---|
| `/factory:needed` | Build approved rows from factory/NEEDED.md (a routine task for Sunday) |
| `/factory:observe` | Analyze agent run logs and propose improvements to NEEDED.md |
| `/factory:learn` | Learn from the past week of agent runs: efficiency, patterns, fixes |

---

## Skills (`skills/`)

| Area | Skill | What it's for |
|---|---|---|
| **General** | `token-efficiency` | Rules for keeping token use low, plus the `FEEDBACK:` block agents use to report missing or stale skills, commands and context; preloaded in every agent |
| **General** | `flow-log` | FLOW.md format: the live flow of a /flow, /quick, /court or /factory run (step diagram, timeline, gate decisions, what's next) |
| **Ponytail** | `ponytail` | Write the least code that works: YAGNI → reuse → stdlib → native → one line. Preloaded in every coding agent |
| | `ponytail-review` | Over-engineering findings, one line each, with `net: -N lines` |
| | `ponytail-audit` | The same review across the whole repo, plus unneeded dependencies |
| | `ponytail-debt` | Ledger of the `ponytail:` shortcut comments |
| | `decision-making` | Compare options and record a decision |
| | `code-patterns` | Design patterns, SOLID, reuse, layering and folder structure for any stack; GoF + architecture catalog |
| | `performance-optimization` | Measure → fix biggest cost → re-measure across DB, API, caching, rendering and bundle; shared rules of the optimize operation |
| | `code-quality` | Robustness (validate at boundaries, no swallowed errors, timeouts, safe retries, transactions) and maintainability (names, size, dead code, consistency) lenses |
| | `input-source` | How plan-driven agents pick their input (architect files vs. the prompt) and handle gaps; preloaded |
| | `project-gitignore` | Create or fix a `.gitignore` so secrets, config, deps and build output never get committed |
| | `scripting` | Write and review Bash and Python scripts and Claude Code hooks: strict mode, stdlib-only, exit codes, the hook contract, and a required test plan |
| **Design** | `figma-design-workflow` | Step-by-step Figma build process |
| | `figma-integration` | Figma libraries, tokens, handoff |
| | `design-handoff` | Writing DESIGN.md |
| | `design-systems` | Tokens, theming, design language |
| | `component-design` | Component structure, variants, states |
| | `design-patterns` | Forms, navigation, tables, empty/error/loading states |
| | `accessibility-design` | WCAG 2.1 AA, contrast, focus, keyboard |
| | `frontend-design` | Distinctive visual direction when there's no Figma design |
| | `design-taste` | Anti-slop taste for marketing pages: three dials, avoid the AI-default look, pre-flight check |
| | `impeccable` | Design-quality playbooks for any UI: critique, audit, polish, harden, refine |
| | `motion-design` | UI animation feel: when to animate, easing, duration, springs, reduced motion |
| **Architecture** | `architecture-analysis` | Journeys, data flow, risks → SPEC.md |
| | `scenario-validation` | Writing scenarios.md |
| | `task-breakdown` | Spec → F# / B# / QA tasks |
| | `issue-triage` | Bug vs new requirement vs ambiguous |
| **Frontend** | `frontend-component-development` | Building UI components in any stack |
| | `frontend-api-integration` | Calling APIs from the frontend |
| | `frontend-testing` | Unit, component and E2E tests |
| | `react-best-practices` | React hooks, structure, performance (React only) |
| | `component-composition-patterns` | React composition patterns (React only) |
| | `react-data-fetching` | TanStack Query / SWR (React only) |
| | `react-testing-patterns` | Jest/Vitest + RTL (React only) |
| | `typescript-for-frontend` | Type-safe React + TS |
| | `shadcn-ui` | shadcn/ui: CLI add, CSS-variable theming, forms, data tables, dark mode, shadcn MCP |
| | `material-ui` | Material UI (MUI v5–v7): theme, `sx`, Grid v2, slotProps, MUI X, Next.js setup, MUI MCP |
| **Backend** | `api-design` | REST endpoints, status codes, validation, errors |
| | `database-design` | Schemas, migrations, indexes, queries |
| | `backend-security` | Auth, injection, rate limits, secrets |
| | `mongodb` | MongoDB on Atlas, Docker or self-hosted: connection, document modeling, indexes, transactions, migrations |
| | `neon-postgres` | Neon serverless Postgres: pooled/direct connections, ORM setup, branches, scale-to-zero |
| | `supabase-connect` | Connect an app to Supabase end-to-end: choose auth mode, create project, env setup, migrations |
| | `supabase-mcp` | Working with Supabase through its MCP |
| **QA** | `test-checklist` | The 9-category checklist |
| | `test-scenario-execution` | Running a scenario step by step |
| | `issue-reporting` | Writing an issue into issues.md |
| | `browser-testing` | Playwright testing in a real browser |
| **Court** | `court-terminal` | Runs the trial in Windows Terminal tabs (Clerk, Attacker, Defender, Judge) |
| **Deploy** | `vercel-deploy` | Deploy and operate on Vercel |
| **Factory** | `agent-factory` | Build agents, skills, commands with tests and security review |
| **Docs** | `system-docs` | Notes/ structure, TL;DR writing, Mermaid rules |
| **Personal** | `resume-portfolio` | Keep MyResume up to date with your projects and experience |

---

## Also available (plugins and built-in)

- **Figma MCP** — design system integration, code connect, components, variables, assets, motion
- **GitHub MCP** — PRs, issues, workflows, code search
- **Supabase MCP** — schema, migrations, SQL, RLS, branches, edge functions, types
- **Vercel MCP** — deployments, builds, env, domains, analytics
- **Claude Code** — `/quick:start`, `/flow:start`, `/design:start`, `/arch:analyze`, `/court:trial`, `/factory:needed`
- **Cowork mode** — plugins, connectors (Google Drive, Gmail, Slack, Jira, Asana, etc.)
