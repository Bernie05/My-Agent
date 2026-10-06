# Multi-Agent System: Reference

**13 agents · 72 commands · 47 skills · 3 modes · 6 hard stops**

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

For simple projects, `/quick:start` runs a smaller pipeline: one plan (PLAN.md) → parallel build → final check → optional deploy.

## How it works
- **Agents** are subagents. Only the main chat session can call them; they cannot call each other.
- **Commands** are what you type, e.g. `/design:start`. Each command tells the main session which agent to call, and handles the hard stops.
- **Skills** are preloaded into agents through their `skills:` field. Claude can also load them automatically when a task matches.
- **Agents can ask for what they lack.** An agent first loads any existing skill that fits. If nothing fits, it ends its report with a `NEEDS:` block (skill or command, why, blocking or not). The main session checks whether it already exists, otherwise asks you and gets it through the agent factory (proposal → approval → security review → build), then resumes the agent where it stopped. Agents never create skills or commands themselves. Rules: `token-efficiency` (agent side) and `CLAUDE.md` (main session).
- You can also call an agent in plain language: *"use the figma-designer agent to add a dark mode to the design"*.

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
  design/        figma-designer.md
  architecture/  architect.md
  developer/     frontend-dev.md, backend-dev.md
  qa/            qa-agent.md
  review/        code-reviewer.md
  court/         trial-agent.md, lawyer-attacker.md, lawyer-defender.md, judge.md
  deploy/        vercel-deployer.md
  factory/       agent-factory.md
  personal/      resume-manager.md
commands/
  design/  (7)   /design:*
  arch/    (11)  /arch:*
  fe/      (8)   /fe:*
  be/      (8)   /be:*
  qa/      (6)   /qa:*
  flow/    (10)  /flow:*
  court/   (1)   /court:trial
  deploy/  (5)   /deploy:*
  ponytail/ (3)  /ponytail:*
  quick/   (3)   /quick:*
  factory/ (7)   /factory:*
  resume/  (1)   /resume:update
  summarize.md   /summarize
skills/<name>/SKILL.md     (must stay flat; Claude Code only finds skills one level deep)
docs/AGENT-SYSTEM.md       (this file)
factory/REGISTRY.md        (every item built, improved or reviewed, with its security verdict)
backups/agent-system-2026-09-25/   (previous version)
```

---

## Agents

| Agent | Folder | Model | Role | Preloaded | Loaded on demand |
|---|---|---|---|---|---|
| `figma-designer` | design | sonnet | Designs in Figma through the MCP (foundations, components, screens, flows); writes DESIGN.md | token-efficiency, figma-design-workflow | design-handoff, design-systems, component-design, design-patterns, accessibility-design, figma-integration, frontend-design |
| `architect` | architecture | inherit | Spec (built from DESIGN.md when there is one), scenarios, tasks and sections, issue triage. Never writes app code. Keeps specs lean (extras go to Out of Scope) | token-efficiency, ponytail | architecture-analysis, scenario-validation, task-breakdown, issue-triage, decision-making |
| `frontend-dev` | development | sonnet | UI tasks F#. Builds from Figma frames using `get_design_context` | token-efficiency, frontend-component-development, ponytail | frontend-api-integration, frontend-testing, browser-testing, frontend-design, react-*, shadcn-ui, material-ui, ponytail-review |
| `backend-dev` | development | sonnet | API, logic and data tasks B# | token-efficiency, api-design, ponytail | database-design, backend-security, supabase-mcp, ponytail-review |
| `qa-agent` | qa | sonnet | Test plan, scenarios, 9-category checklist, issues, go/no-go | token-efficiency, ponytail, test-scenario-execution | test-checklist, issue-reporting, issue-triage, browser-testing |
| `code-reviewer` | review | sonnet | General code review plus an over-engineering section; whole-repo bloat audit | token-efficiency, ponytail, ponytail-review | ponytail-audit |
| `trial-agent` | court | sonnet | Intake questions → Case File → launches the live trial tabs | token-efficiency, court-terminal | — |
| `lawyer-attacker` | court | sonnet | Finds every real hole in any work, including over-engineering | token-efficiency | — |
| `lawyer-defender` | court | sonnet | Rebuts or fixes each hole with the smallest real fix; returns an enhanced version | token-efficiency | — |
| `judge` | court | opus | Rules on each hole; final verdict and final version | token-efficiency | — |
| `vercel-deployer` | deploy | sonnet | Vercel deploys (preview; prod after you confirm), status, logs, env, domains, rollback. Runs Phase 5 of `/flow:start` and step 4 of `/quick:start` | token-efficiency, ponytail, vercel-deploy | — |
| `agent-factory` | factory | opus | Finds, security-reviews, builds, improves and organizes agents, skills and commands. Proposal first, builds only after you approve; no shell | token-efficiency, ponytail, agent-factory | quality-rubric.md, security-checklist.md (files in its skill) |
| `resume-manager` | personal | sonnet | Keeps your MyResume site current: adds GitHub projects, edits experience/skills/about, previews | token-efficiency, resume-portfolio | — |

**Token saving:** each agent preloads only its core skills and loads the rest with the Skill tool when an operation needs them. Routine work runs on Sonnet, while the architect inherits your main model because spec quality drives everything after it. Bookkeeping commands (`/arch:checklist`, `/arch:update`, `/arch:summary`, `/flow:status`, `/deploy:status`, `/ponytail:debt`) run directly without spawning an agent. The full rules are in the `token-efficiency` skill.

**Ponytail (less code):** every coding agent (frontend-dev, backend-dev, architect, qa-agent, code-reviewer, vercel-deployer, agent-factory) preloads the `ponytail` skill; court, resume and Figma agents don't, since they never touch code. It is adapted from [dietrichgebert/ponytail](https://github.com/dietrichgebert/ponytail) (MIT). Before writing code they climb a ladder: YAGNI → reuse → stdlib → native → installed dependency → one line → minimum code. They end each report with `Skipped (ponytail): …`. The spec, DESIGN.md states, validation, security and accessibility are never cut; Ponytail only decides how little code delivers them. The default level is `full`; add `ponytail: lite|ultra|off` to a `/fe:*` or `/be:*` command to change it for that call. Deliberate shortcuts are marked with `ponytail:` comments and listed by `/ponytail:debt`.

The old `design-system` agent was replaced by `figma-designer`. Its skills carry over, and it is kept in the backup.

**Figma MCP:** figma-designer and frontend-dev use the Figma connector's tools. Before calling them, they load the required Figma plugin skills (`figma:figma-use`, `figma:figma-create-new-file`, `figma:figma-generate-library`, `figma:figma-generate-design`, `figma:figma-generate-diagram`, `figma:figma-design-to-code`). If the connector isn't authorized, the agent stops and tells you.

---

## Commands

### `/design:*`: Figma Designer (7)
| Command | What it does |
|---|---|
| `/design:start <feature> [Figma URL] [brand notes]` | Brief → design system → components → flow diagram → screens → DESIGN.md. **Gate 0** |
| `/design:approve` | Approves the design, then hands it to the architect (`analyze`, which ends at **Gate 1**) |
| `/design:system <what>` | Builds or extends variables, styles and components |
| `/design:screen <screens>` | Designs or updates specific screens and flows |
| `/design:revise <feedback>` | Applies feedback and logs it in the revision history |
| `/design:review <Figma or app URL>` | Reviews design quality, or compares the built app to the frames |
| `/design:handoff` | Regenerates DESIGN.md from the Figma file |

### `/arch:*`: Architect (11)
| Command | What it does |
|---|---|
| `/arch:analyze <feature>` | Writes SPEC.md, analysis.md and scenarios.md (from DESIGN.md when there is one). **Gate 1** |
| `/arch:breakdown` | Writes frontend-task.md, backend-task.md and qa-task.md. **Gate 2** |
| `/arch:finalize` | Writes PROJECT_CONTEXT.md (living checklist). **Gate 3** |
| `/arch:approve` | Marks the feature ready for development |
| `/arch:ask <q1; q2…>` | Answers spec questions and logs them in Q&A |
| `/arch:checklist` · `/arch:summary` | Progress % · full status report |
| `/arch:update <F1 done>` | Logs completed or blocked work |
| `/arch:update-specs <change>` | Changes the spec, adds a CHANGE HISTORY entry, flags affected tasks |
| `/arch:analyze-issue <ISSUE-###>` | Triages an issue. **Gate 4** |
| `/arch:issue-decision <ISSUE-###> Fix\|Defer\|Accept` | Records the decision and assigns it |

### `/fe:*` (8) and `/be:*` (8)
| Command | fe | be | What it does |
|---|---|---|---|
| `code` | ✅ | ✅ | Implements tasks (F#/B#), with tests |
| `debug` | ✅ | ✅ | Finds the root cause, fixes it, adds a regression test |
| `ask` | ✅ | ✅ | Question, advice or explanation |
| `review` | ✅ | ✅ | Review by severity, with file:line |
| `test` | ✅ | ✅ | Writes or improves tests and runs them |
| `refactor` | ✅ | ✅ | Restructures without changing behavior |
| `performance` | ✅ | ✅ | Measures, then optimizes, then measures again |
| `accessibility` | ✅ | | WCAG 2.1 AA audit and fixes |
| `security` | | ✅ | Security audit and fixes |

### `/qa:*` (6)
`/qa:start-testing` · `/qa:test-scenario <SC-#>` · `/qa:report-issue` · `/qa:test-checklist` · `/qa:update-progress` · `/qa:approve-feature`

### `/flow:*` (10): orchestration
| Command | What it does |
|---|---|
| `/flow:mode <mode>` | Sets or switches hybrid / sequential / parallel |
| `/flow:start <feature> [--scope all\|per-section] [--design\|--no-design]` | Runs the full gated pipeline. Before building, asks **Implement all** or **Implement per section** |
| `/flow:section <SEC-# \| name \| next>` | Builds and tests one section, then stops at a checkpoint |
| `/flow:status [all]` | Gates, design link, progress, blockers, recent activity |
| `/flow:distribute` | Plans tasks into parallel batches |
| `/flow:coordinate` | Resolves blockers between agents |
| `/flow:handoff <architecture\|development\|qa\|release>` | Checks readiness and moves to the next phase |
| `/flow:report` | Writes REPORT.md |
| `/flow:stop` · `/flow:resume` | Pauses and saves state · continues from it |

### `/quick:*` (3): small team for simple projects
| Command | What it does |
|---|---|
| `/quick:start <project> [--design none\|frontend] [--frontend-only\|--backend-only]` | architect writes one PLAN.md (1 gate) → frontend-dev ║ backend-dev → main session runs build, lint, tests and scenarios → optional deploy |
| `/quick:status [feature\|all]` | Phase, tasks and deploy URL from PLAN.md (no agent) |
| `/quick:upgrade [feature]` | Moves the project to the big team (`/flow:start`) without losing work |

### `/factory:*` (7): agents, skills and commands
| Command | What it does |
|---|---|
| `/factory:find <need>` | Search local, then Anthropic, then GitHub. Review only, installs nothing |
| `/factory:agent` · `/factory:skill` · `/factory:command <need>` | Reuse a safe existing item or build one. Always a proposal first; builds after you approve |
| `/factory:review <path\|plugin\|GitHub URL>` | Security review (GitHub code is cloned into quarantine, never run) |
| `/factory:improve <item>` | A better, leaner, security-reviewed version (backup first) |
| `/factory:organize` | Duplicates, broken links, grouping and token waste: writes a catalog and a fix plan |

New coding agents always preload `ponytail`; coding skills point to its ladder and coding commands pass `ponytail: lite|ultra|off` (rules in the `agent-factory` skill). Every result gets a row in `factory/REGISTRY.md`.

### `/resume:*` (1)
| Command | What it does |
|---|---|
| `/resume:update` | Update the MyResume site: add GitHub projects, edit experience/skills/about, sync or remove projects, preview (resume-manager) |

### `/court:*` (1): stress-test an idea
| Command | What it does |
|---|---|
| `/court:trial <work> [--rounds N] [--no-intake] [--no-tabs]` | trial-agent asks you questions and writes a Case File. The attacker and defender then argue for N rounds in live Windows Terminal tabs, and the judge gives the verdict. The record is saved in `docs/court/<slug>-<date>/` |

### `/deploy:*` (5): Vercel
| Command | What it does |
|---|---|
| `/deploy:vercel [preview\|prod]` | Deploys a preview by default; production after you confirm |
| `/deploy:status` | Last 5 deployments and domains (no agent) |
| `/deploy:logs [url]` | Build or runtime errors, with the likely cause |
| `/deploy:env [check\|add …]` | Missing env vars per target, or adds one |
| `/deploy:rollback [url]` · `promote <url>` | Switches which deployment is live, after you confirm |

### `/ponytail:*` (3): less code
| Command | What it does |
|---|---|
| `/ponytail:review [target]` | Over-engineering-only review: what to delete or replace (code-reviewer) |
| `/ponytail:audit [folder]` | Whole-repo audit for bloat and unneeded dependencies (code-reviewer) |
| `/ponytail:debt [save]` | Ledger of the `ponytail:` shortcut comments (no agent) |

`/fe:review` and `/be:review` also end with an Over-engineering section. `/fe:refactor` and `/be:refactor` make the Ponytail cuts first.

---

## Implementation scope
During breakdown, the architect groups tasks into **sections**: vertical slices such as SEC-1 Auth or SEC-2 Tenants, each with its own frontend tasks, backend tasks and scenarios. Before building, `/flow:start` asks:

| Scope | How it runs | Use when |
|---|---|---|
| **Implement all** | Build every task, then test the whole feature once | Small features |
| **Implement per section** | For each section: build → test that section (plus a smoke check of earlier sections) → checkpoint (Next / Fix first / Stop). A full test checklist runs once at the end | Larger features. Uses fewer tokens per round and catches problems earlier |

The scope and current section are saved in Flow State, so `/flow:resume` restarts at the right section.

## Modes
| Mode | Development phase | Use when |
|---|---|---|
| **hybrid** (default) | Gates → frontend and backend in parallel → QA with triage | Most features |
| **sequential** | One agent at a time, with a check-in after each | You want full control |
| **parallel** | Gates → frontend, backend and QA planning all at once | Tasks are clearly separated and you want speed |

## Hard stops
0. After `/design:start`: **design approval**. Approving hands off to the architect.
1. After `/arch:analyze`: spec review
2. After `/arch:breakdown`: task review
3. After `/arch:finalize`: final approval
4. During QA, `/arch:analyze-issue`: Fix / Defer / Accept
5. After release (optional): **deploy**. Preview first; production only if you pick **Promote to production**

Each stop asks you **Approve / Send back / Reject**.

---

## Files per feature (in your project)
```
docs/features/<feature-slug>/
  design-brief.md      design goals, screens, brand inputs (figma-designer)
  DESIGN.md            Figma handoff: frame links, screens, tokens, components, copy (figma-designer)
  SPEC.md              master spec (architect)
  analysis.md          architecture reasoning, risks
  scenarios.md         SC-# user scenarios
  frontend-task.md     F# tasks
  backend-task.md      B# tasks + API contract
  qa-task.md           test plan + results
  PROJECT_CONTEXT.md   living checklist + Flow State (mode, phase, gates G0–G4, blockers)
  issues.md            ISSUE-### log with triage and decisions
  activity.log         timestamp | agent | action
  REPORT.md            written by /flow:report
```

## Skills (47)
- **Design / Figma:** figma-design-workflow, design-handoff, figma-integration, design-systems, component-design, design-patterns, accessibility-design
- **Design quality:** design-taste (marketing UI), impeccable (app UI critique and audit), motion-design (animation)
- **Architect:** architecture-analysis, scenario-validation, task-breakdown, decision-making, issue-triage
- **Code structure:** code-patterns (design patterns, SOLID, layering; rung 7 of the ponytail ladder)
- **Frontend:** frontend-component-development, frontend-api-integration, frontend-testing, frontend-design (official Anthropic)
- **React-only:** react-best-practices, typescript-for-frontend, component-composition-patterns, react-data-fetching, react-testing-patterns
- **UI libraries:** shadcn-ui, material-ui. frontend-dev loads the one the project uses. For a new React project it chooses from the spec: shadcn/ui for a custom design, Tailwind or Next.js; MUI for data-heavy admin tools or a standard Material look. It records the choice for SPEC.md → Tech Stack, and never adds a second library.
- **Backend:** api-design, database-design, backend-security, supabase-mcp (loaded when the stack uses Supabase)
- **QA:** test-scenario-execution, test-checklist, issue-reporting, browser-testing (Node Playwright, based on Anthropic's webapp-testing)
- **Cross-cutting:** token-efficiency (preloaded in every agent), input-source (reference vs prompt mode for plan-driven agents), project-gitignore (security baseline before the first commit)
- **Ponytail (less code, MIT):** ponytail, ponytail-review, ponytail-audit, ponytail-debt
- **Court:** court-terminal
- **Deploy:** vercel-deploy
- **Factory:** agent-factory (house rules, quality rubric, security checklist)
- **Personal:** resume-portfolio
- **Other:** hello-world
