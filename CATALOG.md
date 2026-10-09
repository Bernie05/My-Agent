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
| `/arch:analyze` | Analyze a feature → SPEC.md, analysis.md, scenarios.md (Gate 1) |
| `/arch:breakdown` | Split the spec into FE / BE / QA tasks (Gate 2) |
| `/arch:finalize` | Finalize the specs and create the PROJECT_CONTEXT.md checklist (Gate 3) |
| `/arch:approve` | Mark the feature approved for development |
| `/arch:ask` | Ask questions about the spec |
| `/arch:update-specs` | Change the spec and flag the affected tasks |
| `/arch:update` | Log a task as done or blocked |
| `/arch:checklist` | Task progress percentages |
| `/arch:summary` | Full status report for a feature |
| `/arch:analyze-issue` | Triage a QA issue: bug, new requirement, or ambiguous (Gate 4) |
| `/arch:issue-decision` | Record Fix / Defer / Accept for an issue |

### `/fe:*`, `/be:*` and `/fs:*`: Frontend, backend and full-stack developers
The same commands exist in all three groups. `/be:security` is backend only; `/fe:accessibility` and `/fe:design` are frontend only. `/fs:*` (fullstack-dev) has all of them, including `design`, `accessibility` and `security`, and always uses fullstack-dev whatever the feature's Dev team is.

| Command | What it does |
|---|---|
| `code` | Implement tasks (F# / B#) or a described change. Add `ponytail: lite\|ultra\|off` to change how minimal the code is (default full) |
| `debug` | Find and fix the root cause of a bug |
| `test` | Write or improve tests and run them |
| `review` | Review code for bugs, security, performance, test gaps, plus an over-engineering section |
| `refactor` | Improve structure without changing behavior. Makes the Ponytail cuts first |
| `performance` | Measure and optimize |
| `ask` | Quick question or explanation |
| `/fe:accessibility` | Audit and fix WCAG 2.1 AA issues |
| `/be:security` | Security audit and fixes |

### `/qa:*`: QA
| Command | What it does |
|---|---|
| `/qa:start-testing` | Create the test plan (9 categories) |
| `/qa:test-checklist` | Run the full 9-category checklist |
| `/qa:test-scenario` | Run one scenario with evidence |
| `/qa:report-issue` | Log an issue with repro steps and severity |
| `/qa:update-progress` | Update testing progress and blockers |
| `/qa:approve-feature` | Release go / no-go |

### `/flow:*`: Run the whole pipeline
| Command | What it does |
|---|---|
| `/flow:start` | Run design → spec → build → QA → deploy with gates (choose mode and scope; design and deploy optional) |
| `/flow:section` | Build and test one section, then stop at a checkpoint |
| `/flow:status` | Progress, blockers, recent activity |
| `/flow:distribute` | Plan which agent does which task, and in what order |
| `/flow:coordinate` | Unblock dependencies between agents |
| `/flow:handoff` | Move a feature to its next phase, with readiness checks |
| `/flow:mode` | Switch mode: hybrid / sequential / parallel |
| `/flow:team` | Switch a feature's Dev team: split (frontend-dev + backend-dev) or fullstack (one fullstack-dev) |
| `/flow:stop` / `/flow:resume` | Pause and resume a feature workflow |
| `/flow:report` | Full project report |

### `/quick:*`: Small team for simple projects
| Command | What it does |
|---|---|
| `/quick:start` | Architect + fullstack-dev (or frontend-dev + backend-dev with `--team split`): one plan, one gate, build, final check, optional deploy |
| `/quick:status` | Status and deploy URL of a quick-team project from its PLAN.md |
| `/quick:upgrade` | Move a quick-team project to the big team (`/flow:start`) without losing work |

### `/court:*`: Stress-test an idea
| Command | What it does |
|---|---|
| `/court:trial` | Intake questions → attacker vs defender rounds in live terminal tabs → judge's verdict. Flags: `--rounds N`, `--no-intake`, `--no-tabs` |

### `/deploy:*`: Vercel
| Command | What it does |
|---|---|
| `/deploy:vercel` | Deploy: preview by default; `prod` asks for confirmation first |
| `/deploy:status` | Last 5 deployments and production domains |
| `/deploy:logs` | Error lines from a failed build or runtime errors, with the likely cause |
| `/deploy:env` | Which env vars are missing per environment, or add one |
| `/deploy:rollback` | Roll production back, or `promote <url>` a preview (asks first) |

### `/ponytail:*`: Less code
| Command | What it does |
|---|---|
| `/ponytail:review` | Over-engineering review of a diff or files: what to delete, or replace with stdlib/native |
| `/ponytail:audit` | Whole-repo audit: ranked list of code and dependencies to cut |
| `/ponytail:debt` | List every `ponytail:` shortcut comment with its limit and when to upgrade (`save` writes a file) |

### `/factory:*`: Agents, skills and commands
| Command | What it does |
|---|---|
| `/factory:find` | Search for an existing agent, skill, command or plugin (local, Anthropic, GitHub). Installs nothing |
| `/factory:agent` | Get a new agent: reuse a safe existing one or build it, security-reviewed |
| `/factory:skill` | Get a new skill: reuse a safe existing one or build it, security-reviewed |
| `/factory:command` | Get a new command: reuse a safe existing one or build it, security-reviewed |
| `/factory:improve` | Turn an existing agent, skill or command into a leaner, security-reviewed version |
| `/factory:review` | Security review of an agent, skill, command or plugin (path, plugin name or GitHub URL) |
| `/factory:organize` | Find duplicates, broken links, bad grouping and token waste; write a catalog and fix plan |
| `/factory:needed` | Build the rows you approved in `factory/NEEDED.md` (agent feedback). Runs weekly as a routine that opens a PR |
| `/factory:observe` | Analyze recent agent runs and routine findings, queue evidence-backed improvements in NEEDED.md |

### `/resume:*`: Portfolio site
| Command | What it does |
|---|---|
| `/resume:update` | Update MyResume: add GitHub projects, edit experience/skills/about, sync or remove projects, preview |

### Other
| Command | What it does |
|---|---|
| `/summarize` | Summarize text, a file, or the conversation in a few bullets |

---

## Skills (`skills/`)

| Area | Skill | What it's for |
|---|---|---|
| **General** | `token-efficiency` | Rules for keeping token use low, plus the `FEEDBACK:` block agents use to report missing or stale skills, commands and context; preloaded in every agent |
| **Ponytail** | `ponytail` | Write the least code that works: YAGNI → reuse → stdlib → native → one line. Preloaded in every coding agent |
| | `ponytail-review` | Over-engineering findings, one line each, with `net: -N lines` |
| | `ponytail-audit` | The same review across the whole repo, plus unneeded dependencies |
| | `ponytail-debt` | Ledger of the `ponytail:` shortcut comments |
| | `decision-making` | Compare options and record a decision |
| | `code-patterns` | Design patterns, SOLID, reuse, layering and folder structure for any stack; GoF + architecture catalog |
| | `input-source` | How plan-driven agents pick their input (architect files vs. the prompt) and handle gaps; preloaded |
| | `project-gitignore` | Create or fix a `.gitignore` so secrets, config, deps and build output never get committed |
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
| | `supabase-mcp` | Working with Supabase through its MCP |
| **QA** | `test-checklist` | The 9-category checklist |
| | `test-scenario-execution` | Running a scenario step by step |
| | `issue-reporting` | Writing an issue into issues.md |
| | `browser-testing` | Playwright testing in a real browser |
| **Court** | `court-terminal` | Runs the trial in Windows Terminal tabs (Clerk, Attacker, Defender, Judge) |
| **Deploy** | `vercel-deploy` | Vercel preflight, deploy, verify, logs, env, domains, rollback |
| **Factory** | `agent-factory` | House rules for building agents, skills and commands, plus the quality rubric, security checklist and registry format |
| **Personal** | `resume-portfolio` | Turning GitHub repos into honest portfolio entries and verifying the MyResume build |

### Also available (plugins and built-in, not in this folder)
- **Figma plugin** (`figma:*`): use, generate-design, generate-library, generate-diagram, code-connect, create-new-file
- **Adobe** (`adobe-for-creativity:*`): PDF tools, photo edits, resizing, design from templates
- **Documents** (`anthropic-skills:*`): docx, xlsx, pptx, pdf, docs, deep-research, skill-creator
- **MCP dev** (`mcp-server-dev:*`): build an MCP server, MCP app, or MCPB bundle
- **Built-in:** `/code-review`, `/simplify`, `/security-review`, `/init`, `/loop`, `/schedule`, `/run`

---
*Ponytail skills are adapted from [dietrichgebert/ponytail](https://github.com/dietrichgebert/ponytail) (MIT, license in `skills/ponytail/LICENSE`).*
*When you add an agent, command or skill, add one line here.*
