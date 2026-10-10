---
name: system-docs
description: Structure, writing style and Mermaid diagram rules for system docs - the Notes/ set (overview, configuration, system flow, data flow, database schema, glossary), single topic pages, and folder maps showing how parts call each other - each page opening with a plain-language TL;DR. Preloaded by the system-documenter agent; use when generating or updating project Notes. Not for feature specs (architecture-analysis) or design handoff (design-handoff).
---

# System docs (Notes/)

## 1. Folder layout (always this order)
| File | Answers | Main diagram |
|---|---|---|
| `README.md` | What is this, in one page? Where do I start? | Big-picture `flowchart LR` (users → app parts → storage → external services) |
| `01-overview.md` | Purpose, users, stack, main parts and how they connect | `flowchart` of components / deployables |
| `02-configuration.md` | Config files, env var names, ports, scripts, how to run locally, deploy targets | none or a small `flowchart` of config sources |
| `03-system-flow.md` | The 3-6 most important user journeys, step by step | one `sequenceDiagram` per journey |
| `04-data-flow.md` | Where data enters, is validated or transformed, stored, cached, sent out | `flowchart LR` with data stores as cylinders |
| `05-database-schema.md` | Entities, columns, keys, relations, indexes | `erDiagram` |
| `06-glossary.md` | Domain and technical terms in plain words | none |

Page skeletons are in `templates.md` (this folder). Read it once at the start of **generate**.

## 2. Writing style: easy to understand
- **TL;DR first**: 3-5 lines that a newcomer understands without reading code. Then the diagram, then the details.
- Short sentences, active voice, one idea per bullet. Tables for anything with 3+ attributes (env vars, tables, routes).
- Name real things: actual file paths as links (`[src/db.ts](../src/db.ts)`), route paths, table names.
- Explain *why* when the code shows it (comments, commit-style names, config). Otherwise only *what*.
- Size target: README ≤ 80 lines, other pages ≤ 200 lines. Split by journey or module if longer (`03-system-flow/checkout.md`).
- Mark guesses _(inferred)_. Put unknowns in README "Open questions".

## 3. Mermaid rules (render in GitHub and VS Code)
- Fence with ```` ```mermaid ````. One diagram, one purpose. ≤ 15 nodes; split if bigger.
- Node IDs are simple words (`api`, `db`). Put labels in quotes when they contain spaces or symbols: `api["API server (Express)"]`.
- Shapes: `[(Database)]` cylinder for stores, `((User))` for actors, `{{Queue}}` for queues/jobs, `[/External API/]` for third parties.
- `sequenceDiagram`: `participant` aliases, `->>` for calls, `-->>` for responses, `alt/else` for error paths. Show only the main error path.
- `erDiagram`: `TABLE ||--o{ OTHER : "has"`. Column lines as `type name PK|FK|UK`. No spaces in type names (`varchar`, not `varchar(255)`).
- No `click`, no HTML, no styling except `classDef` for at most 2 highlight classes.
- Under each diagram add one line: "Read it as: …" for non-technical readers.

## 4. Sources footer (needed for update)
End every page with:
```
---
Sources: path/a.ts, path/b/, prisma/schema.prisma
Last updated: YYYY-MM-DD (commit <short sha or "unknown">)
```
**update** maps changed files to pages through these lines. A changed file that matches no page goes to the page whose topic fits, then into its Sources.

## 5. Where to find things (check in this order)
- **Config**: `.env.example`, `.env.sample`, `config/`, `*.config.{js,ts}`, `settings.py`, `appsettings*.json`, `docker-compose*.yml`, `vercel.json`, CI files, then `process.env.` / `os.environ` / `getenv` usages (Grep).
- **Flow**: entry point (`main`, `index`, `app`, `server`), router and route files, controllers or handlers, middleware, queue or cron workers, frontend pages that call APIs.
- **Schema**: migrations, `schema.prisma`, `drizzle/`, ORM models or entities, `*.sql`, `supabase/migrations/`. Prefer migrations (they are the truth) over models when they disagree, and note the difference.
- **Data flow**: request validation, services, repositories, caches (Redis), file storage, outbound HTTP clients, webhooks, analytics.

## 6. Secrets
Names and purpose only. Values become `<redacted>`. Never read real `.env`, key or credential files (see agent rules).

## 7. Topic pages and folder docs (operation topic)
A topic page uses the matching template section from `templates.md` when one fits (schema → 05, config → 02). Otherwise use: TL;DR → main diagram + "Read it as" → **Parts** table → **How it works** (numbered steps) → details → Open questions → Sources footer.

**Documenting a folder that isn't an app** (an agent setup, a docs tree, a scripts folder):
1. **Inventory**: Glob the folder and group files by kind (e.g. `commands/`, `agents/`, `skills/`). Read only the frontmatter or first ~15 lines of each file for its name, purpose and links.
2. **Relationships**: Grep for references between files: names in backticks, paths, `Use the **X** agent`, `skills:` lists, "load on demand" table rows, links, imports, `calls`/`hands back` wording. Each hit is an edge: `A --calls--> B`, `A --preloads--> B`, `A --loads on demand--> B`.
3. **Diagrams**:
   - a **map** (`flowchart LR`) with one `subgraph` per group and labeled edges for each relationship type. If it has more than 15 nodes, draw one overview map of groups and one map per group.
   - a **run** (`sequenceDiagram`) for each main path, e.g. user → command → main session → agent → skill, including stops and gates (`Note over`) and hand-backs.
4. **Tables**: `Item | Kind | Purpose | Uses | Used by`. Mark items nothing references as _(unused?)_.
5. Example for `~/.claude`: commands call agents through the main session, agents preload or load skills, agents request new ones with `NEEDS:` and agent-factory builds them after approval. Draw it, don't just list it.
