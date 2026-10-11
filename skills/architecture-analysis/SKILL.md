---
name: architecture-analysis
description: Analyze a feature's architecture - user journeys, components, data flow, edge cases, risks, feasibility - and write SPEC.md + analysis.md. Use when starting a new feature (/arch:analyze) or reviewing an existing design.
---

# Architecture Analysis

Output goes to `docs/features/<feature-slug>/`: `SPEC.md` (source of truth) and `analysis.md` (reasoning behind it).

## Process

1. **Understand the feature**
   - Who is the user? What are they trying to accomplish? What does "done" look like?
   - List what is in scope and explicitly out of scope.
   - Anything unclear → write it under "Open Questions" in SPEC.md. Do not invent requirements.

2. **Pin down the tech stack**
   - Use the stack the user specified. If none: detect it from the repo (`package.json`, `composer.json`, `pyproject.toml`, `requirements.txt`, `go.mod`, `pom.xml`, `*.csproj`, existing folders).
   - Greenfield with no stack given → list it as an Open Question; don't pick silently.
   - Record it in SPEC.md → Tech Stack (frontend, backend, database, auth, testing tools, hosting).

3. **Identify components**
   - Frontend: screens/views, components, client state, forms.
   - Backend: endpoints/handlers, business rules, background jobs.
   - Data: entities, fields, relationships, constraints.
   - Integrations: third-party services, files, email/SMS, payments.

4. **Trace data flow** for each main action:
   user action → UI → request → validation → business logic → database → response → UI update.

5. **Find edge cases**
   - Invalid / empty / oversized input; duplicates; double-submit.
   - Network failure, timeouts, partial failure mid-operation.
   - Concurrent edits of the same record.
   - Permissions: who can read / create / edit / delete what.
   - Boundary values: zero, negative, max, dates across months/timezones.

6. **Check patterns & consistency**: reuse existing conventions in the codebase; prefer the simplest design that meets the requirements.

7. **Assess feasibility & risk**: unknowns, dependencies, anything needing a decision (use the `decision-making` skill and log it).

8. **Team check**: list each area of work (frontend, backend, database, each integration, infra/deploy, testing) and map it to an existing agent and its skill(s). Check cheaply: Grep the `description:` lines of `~/.claude/agents/**/*.md` and `~/.claude/skills/*/SKILL.md`, never whole files. Mark a gap only when guessing would risk wrong or unsafe output (a new service, library or file format with real rules). Prefer a **skill** for missing know-how. Ask for an **agent** only when a whole role is missing (e.g. mobile, data/ML). Max 3 gaps.

## SPEC.md template

```markdown
# <Feature Name>
Status: Draft | Approved | In Development | In QA | Done

## Summary
## Users & Roles
## Tech Stack
## Requirements
### Functional (numbered: R1, R2, ...)
### Non-functional (performance, security, accessibility)
## Data Model
## API / Interfaces
## Permissions
## Validation Rules
## Edge Cases & Expected Behavior
## Out of Scope
## Open Questions
## Q&A Log
## Decisions
## CHANGE HISTORY
```

## analysis.md contents
User journeys, component list, data-flow traces, risks (with likelihood/impact), dependencies, a rough size estimate (S/M/L per area), and a **Team & skills** table (`Area | Agent | Skills | Gap?`) from step 8.

## Checklist
- [ ] Goal, users and scope clear; out-of-scope listed
- [ ] Tech stack recorded (or flagged as open question)
- [ ] Every requirement numbered and testable
- [ ] Data model and permissions defined
- [ ] Edge cases listed with expected behavior
- [ ] Risks and open questions listed
- [ ] Team check done: every area has an agent and skills, or a gap is requested
