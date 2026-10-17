# Multi-Agent System: Reference

**17 agents · 92 commands · 54 skills · 3 modes · 6 hard stops**

For a one-line list of everything, see [CATALOG.md](../CATALOG.md).

The system is generic and stack-agnostic. Agents take the tech stack from the spec you give. If the spec doesn't name one, they detect it from the repo; if they still can't tell, they ask. Designs are made in Figma through the Figma MCP.

---

## Workflow

```
 /design:start ──► figma-designer ──► GATE 0 Design approval
                                          │ Approve (/design:approve)
                                          ▼
 /arch:analyze ──► architect ──► GATE 1 Spec ──► breakdown ──► GATE 2 Tasks ──► finalize ──► GATE 3 Final
                                                                                                 │
                        ┌────────────────────────────────────────────────────────────────────────┘
                        ▼
         frontend-dev ║ backend-dev   (in parallel in hybrid mode)
                        ▼
         qa-agent ──► issue ──► architect triage ──► GATE 4 Fix / Defer / Accept ──► dev fix ──► retest
                        ▼
         qa-agent approve-feature ──► release
                        ▼
         vercel-deployer ──► GATE 5 Deploy: env check ──► preview ──► smoke test ──► promote? (you confirm)
```

`/flow:start` runs the whole pipeline. The design stage is optional: use `--design` or `--no-design`, and if you pass neither, it asks you. The deploy stage is optional too: after release it offers a Vercel preview, smoke-tests it, and promotes to production only if you choose to.

For simple projects, `/quick:start` runs a smaller pipeline: one plan (PLAN.md) → build → final check → optional deploy.

**Dev team toggle.** Each feature records `Dev team: split | fullstack`. **split**: `frontend-dev` and `backend-dev` build F# and B# in parallel; best for large features. **fullstack**: one `fullstack-dev` (Opus) builds both sides in one context, so fewer handoffs and contract mismatches; best for small and medium features. `/quick` defaults to fullstack; `/flow:start` asks (or `--team`). Switch any time with `/flow:team`; task IDs and the API contract don't change, so it's safe mid-feature. The routing rule is in `CLAUDE.md`.

## How it works

- **Agents** are subagents. Only the main chat session can call them; they cannot call each other.
- **Commands** are what you type, e.g. `/design:start`. Each command tells the main session which agent to call, and handles the hard stops.
- **Skills** are preloaded into agents through their `skills:` field. Claude can also load them automatically when a task matches.
- **Agents report what's missing or wrong; you decide.** Each agent ends its report with an optional `FEEDBACK:` block: `need` (missing skill or command), `fix`, `stale`, `remove` or `context`, each with evidence. A **blocking** need is handled right away (check local → ask you → agent factory → resume the agent). Everything else is queued in `factory/NEEDED.md`, where you review it and mark rows `approved` or `rejected`. A **weekly routine** runs `/factory:needed`, which builds only approved rows through the agent factory and opens a pull request for you to merge. Agents never change the toolkit themselves. Rules: `token-efficiency` (agents), `CLAUDE.md` (main session), `commands/factory/needed.md` (builder).
- **An observer watches how agents actually work.** A `SubagentStop`/`Stop` hook logs one line per run (metadata only, local). `/factory:observe` turns those runs into stats (files re-read across runs, repeated errors and retries, user corrections, unused skills) and the read-only `observer` agent proposes evidence-backed rows for `factory/NEEDED.md`. It also imports the weekly report routines' findings (`factory/findings/`), so everything lands in one review queue. Install the hook once per device: `python3 factory/scripts/install_observer_hook.py`.

**Weekly loop:** use your agents → run `/factory:observe` → review `factory/NEEDED.md` (approve/reject) → push → Sunday's routine builds the approved rows and opens a PR → merge → `git pull`.

- You can also call an agent in plain language: _"use the figma-designer agent to add a dark mode to the design"_.

## Self-improvement loop

Agents never change themselves: they report, the observer finds patterns, **you** decide, the factory builds with tests.

```
 AGENT RUNS                      WEEKLY ROUTINES (cloud)
   │  FEEDBACK: need / fix /        │  duplicate skills · CLAUDE.md lint
   │  stale / remove / context      │  · skill gaps · catalog sync
   │                                ▼
   │  hook (SubagentStop/Stop)   factory/findings/<date>-<routine>.md
   ▼  → factory/observe/runs.jsonl  (local, git-ignored)
 main session ──queues──┐        │
                        │        ▼
                        │   /factory:observe ── run_stats.py ──► observer (read-only)
                        │        │  files re-read 3+ runs · repeated errors · corrections · unused skills
                        ▼        ▼
                  factory/NEEDED.md   Status: new
                        │
                        ▼  YOU review: approved / rejected  → push
                        │
                        ▼
          /factory:needed (Sunday routine, max 5 rows)
            agent-factory builds → file guard (only the row's files)
            → skill tests (seen + held-out) → script test plan → check.py
            → promote the fixed problem into a new eval case
            → LEARNINGS.md (pass or fail) · RESULTS.tsv (verdict: pending)
                        │
                        ▼
                 pull request ──► YOU merge ──► git pull on each device
                        │
                        ▼  14 days later
          /factory:observe measures it: helped / no-change / worse
          (3 failed builds → parked · 5 no-effect results → asks you)
```

Proposal and approval stay separate: the thing being changed never decides the change. `factory/NEEDED.md` → **Autonomy** can be raised from `proposal` to `bounded` (small L1 skill fixes seen 3+ times build without your approval, still as a PR you merge). The gate, learnings, results and eval-growth ideas are adapted from auto-harness and autoharness (MIT).

## Quick start

```
/flow:mode hybrid
/flow:start Tenant billing — monthly invoices per tenant, Next.js + Postgres --design
/flow:status
```

Or run it step by step: `/design:start …` → `/design:approve` → `/arch:breakdown` → `/arch:finalize` → `/fe:code` / `/be:code` → `/qa:test-checklist`

---

## Folder layout (`~/.claude`)

```
agents/
  ├── design/              figma-designer
  ├── architecture/        architect
  ├── developer/           frontend-dev, backend-dev, fullstack-dev
  ├── qa/                  qa-agent
  ├── review/              code-reviewer
  ├── court/               trial-agent, lawyer-attacker, lawyer-defender, judge
  ├── deploy/              vercel-deployer
  ├── factory/             agent-factory, observer
  ├── personal/            resume-manager
  ├── docs/                system-documenter
  └── utility/             digest

commands/
  ├── design/              `/design:start`, `/design:system`, `/design:screen`, `/design:revise`, `/design:review`, `/design:handoff`, `/design:approve`
  ├── architecture/        `/arch:analyze`, `/arch:review`, `/arch:breakdown`, `/arch:finalize`, `/arch:analyze-issue`, `/arch:suggest-refactor`
  ├── developer/           `/fe:*`, `/be:*`, `/fs:*` (code, debug, test, refactor, a11y/security, optimize)
  ├── qa/                  `/qa:*` (start-testing, test-scenario, test-checklist, report-issue, triage-issue, approve-feature)
  ├── flow/                `/flow:*` (start, status, team, mode, pause, resume)
  ├── quick/               `/quick:*` (start, resume)
  ├── court/               `/court:trial`
  └── factory/             `/factory:*` (needed, observe, learn)

skills/
  ├── agent-factory/       House rules for building agents, skills, commands, tools
  ├── api-design/          REST API design
  ├── architecture-analysis/
  ├── backend-security/
  ├── browser-testing/
  ├── code-patterns/
  ├── code-quality/
  ├── component-design/
  ├── component-composition-patterns/
  ├── court-terminal/
  ├── database-design/
  ├── decision-making/
  ├── design-handoff/
  ├── design-patterns/
  ├── design-systems/
  ├── design-taste/
  ├── figma-design-workflow/
  ├── figma-integration/
  ├── flow-log/
  ├── frontend-api-integration/
  ├── frontend-component-development/
  ├── frontend-design/
  ├── frontend-testing/
  ├── input-source/
  ├── issue-reporting/
  ├── issue-triage/
  ├── material-ui/
  ├── mongodb/
  ├── motion-design/
  ├── neon-postgres/
  ├── performance-optimization/
  ├── ponytail/
  ├── ponytail-audit/
  ├── ponytail-debt/
  ├── ponytail-review/
  ├── project-gitignore/
  ├── react-best-practices/
  ├── react-data-fetching/
  ├── react-testing-patterns/
  ├── resume-portfolio/
  ├── scenario-validation/
  ├── scripting/
  ├── shadcn-ui/
  ├── supabase-connect/
  ├── supabase-mcp/
  ├── system-docs/
  ├── task-breakdown/
  ├── test-checklist/
  ├── test-scenario-execution/
  ├── token-efficiency/
  ├── typescript-for-frontend/
  └── vercel-deploy/

factory/
  ├── scripts/
  │   ├── check.py         ← Runs on every push (docs sync, counts, links)
  │   ├── install_observer_hook.py
  │   └── run_stats.py
  ├── NEEDED.md            ← Queue for improvements (you review + approve / reject)
  ├── findings/            ← Weekly routine findings (skill gaps, duplicate skills, etc.)
  └── LEARNINGS.md         ← Record of what was built and if it worked
```

---

## Agents table (description, skills, tools)

| Agent | Role | Skills | Tools |
|---|---|---|---|
| figma-designer | Design in Figma (tokens, components, screens, flows) → DESIGN.md | figma-design-workflow, figma-integration, design-systems, component-design, design-patterns, accessibility-design, design-taste, impeccable, motion-design | Figma MCP |
| architect | Write spec (SPEC.md, scenarios) + break into F#/B#/QA tasks; triage QA issues | architecture-analysis, scenario-validation, task-breakdown, decision-making, issue-triage, code-patterns | none |
| frontend-dev | Build F# tasks, debug/test/refactor/fix-a11y UI; minimal code (Ponytail); pick shadcn or MUI from spec | ponytail, frontend-component-development, frontend-api-integration, frontend-testing, frontend-design, react-best-practices, component-composition-patterns, react-data-fetching, react-testing-patterns, typescript-for-frontend, shadcn-ui, material-ui, code-quality, browser-testing, input-source | Node (shadcn/MUI, Vitest/Jest, Playwright, TypeScript) |
| backend-dev | Build B# tasks (APIs, logic, DB, migrations); debug/test/secure; minimal code (Ponytail) | ponytail, api-design, database-design, backend-security, scripting, code-quality, input-source | Node + Python (Node.js frameworks, SQL tools, schema migration, secrets management) |
| fullstack-dev | Build F# + B# tasks in one context (Opus); runs when Dev team = fullstack or /quick:start | ponytail, frontend-component-development, frontend-api-integration, frontend-testing, api-design, database-design, backend-security, code-quality, input-source | Node + Python (full stack tooling) |
| qa-agent | Plan and run feature tests; report issues with evidence; final sign-off | test-checklist, test-scenario-execution, issue-reporting, scenario-validation, browser-testing | Playwright, GitHub (issues write) |
| code-reviewer | Review a diff/PR for bugs, security, risky logic, over-engineering; whole-repo bloat audit | ponytail-review, ponytail-audit, code-patterns, code-quality, backend-security, token-efficiency | GitHub (PR read/review), all languages |
| trial-agent | Court Clerk: asks you questions, writes the Case File, launches trial tabs (Figma for Figma sketches) | court-terminal, decision-making | Figma MCP |
| lawyer-attacker | Attacks the work, finds every real hole (never fixes) | code-patterns, code-quality, backend-security, api-design | none |
| lawyer-defender | Defends the work, rebuts attacker, returns a stronger version (may involve small fixes) | ponytail, code-patterns, code-quality, backend-security, api-design, database-design | relevant stack |
| judge | Neutral verdict: rules on each hole, gives the best final version | code-patterns, code-quality, decision-making, api-design | none |
| vercel-deployer | Deploy to Vercel (preview or production); monitor status, logs, env, domains; rollback, promote | vercel-deploy, input-source | Vercel CLI / Vercel MCP |
| agent-factory | Find, security-review, build, improve agents/skills/commands; proposal first | agent-factory, ponytail, code-quality, scripting | Node, Python, GitHub (PR create), file system |
| observer | Watch agent run logs (via hook); propose improvements to NEEDED.md | token-efficiency | factory/observe/runs.jsonl (read-only) |
| resume-manager | Keep MyResume portfolio site up to date (GitHub projects → experience, skills, about) | resume-portfolio, frontend-design | GitHub (repo read), file system |
| system-documenter | Document a whole system into Notes/ (overview, config, flow, data flow, DB schema, glossary) | system-docs | Mermaid, file system |
| digest | Read a big log/output/doc in its own context; return the ~20 lines you need | token-efficiency | none (context-only) |

---

## Skills (54)

- **Design / Figma:** figma-design-workflow, design-handoff, figma-integration, design-systems, component-design, design-patterns, accessibility-design
- **Design quality:** design-taste (marketing UI), impeccable (app UI critique and audit), motion-design (animation)
- **Architect:** architecture-analysis, scenario-validation, task-breakdown, decision-making, issue-triage
- **Code structure:** code-patterns (design patterns, SOLID, layering; rung 7 of the ponytail ladder), code-quality (robustness + maintainability lenses)
- **Performance:** performance-optimization (measure-first loop across DB, API, caching, UI and bundle; shared plan → apply rules for `/fe`, `/be`, `/fs:optimize`)
- **Frontend:** frontend-component-development, frontend-api-integration, frontend-testing, frontend-design (official Anthropic)
- **React-only:** react-best-practices, typescript-for-frontend, component-composition-patterns, react-data-fetching, react-testing-patterns
- **UI libraries:** shadcn-ui, material-ui. frontend-dev loads the one the project uses. For a new React project it chooses from the spec: shadcn/ui for a custom design, Tailwind or Next.js; MUI for data-heavy admin tools or a standard Material look. It records the choice for SPEC.md → Tech Stack, and never adds a second library.
- **Backend:** api-design, database-design, backend-security, mongodb, neon-postgres, supabase-connect, supabase-mcp
- **QA:** test-scenario-execution, test-checklist, issue-reporting, browser-testing (Node Playwright, based on Anthropic's webapp-testing)
- **Cross-cutting:** token-efficiency (preloaded in every agent), flow-log (live FLOW.md for every orchestrator run), input-source (reference vs prompt mode for plan-driven agents), project-gitignore (security baseline before the first commit), scripting (Bash, Python and hooks, with a required test plan; loaded by agent-factory, backend-dev and fullstack-dev)
- **Ponytail (less code, MIT):** ponytail, ponytail-review, ponytail-audit, ponytail-debt
- **Court:** court-terminal
- **Deploy:** vercel-deploy
- **Factory:** agent-factory (house rules, quality rubric, security checklist)
- **Docs:** system-docs (Notes/ layout, TL;DR-first writing, Mermaid rules)
- **Personal:** resume-portfolio
