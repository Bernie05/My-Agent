---
name: task-breakdown
description: Break an approved spec into implementable frontend (F#), backend (B#) and QA tasks with dependencies and acceptance criteria. Use when running /arch:breakdown or splitting work between developers.
---

# Task Breakdown

Input: approved `SPEC.md` + `scenarios.md`. Output: `frontend-task.md`, `backend-task.md`, `qa-task.md` in the feature folder.

## Task template

```markdown
### B1: <Short name>
Owner: backend-dev          (the layer; with `Dev team: fullstack`, fullstack-dev builds both F# and B#)
Section: SEC-1
Status: ⏳ Todo | 🔄 In Progress | ✅ Done | ⛔ Blocked
Depends on: <task IDs or "none">
Covers: R1, R2 | Scenarios: SC-1, SC-4

What: <what to build, one paragraph>
Inputs: <request fields / props / data>
Outputs: <response / rendered result / side effects>
States: <loading, empty, error, success ... (UI) or entity states (backend)>
Validation: <rules, referencing SPEC.md>
Error handling: <each failure and its behavior>

Acceptance criteria:
- [ ] <specific, verifiable>
- [ ] Tests written and passing

Testing:
- Unit: <what>
- Integration: <what>
- E2E: <what, if any>
```

## Ordering
1. Data layer first (schema/migrations), then backend endpoints, so the frontend has a contract.
2. Define the API contract (request/response shapes) in `backend-task.md` early so frontend can build against it in parallel (with mocks).
3. Mark which tasks can run in parallel.

## Sections (for "implement per section")
Group tasks into **sections**: vertical slices that each deliver something a user can see working end to end, e.g. SEC-1 Auth & roles, SEC-2 Tenant records, SEC-3 Billing.
- Each section contains its backend tasks, frontend tasks and scenarios (SC-#), so it can be built **and tested** on its own.
- Order sections by dependency. Foundations (schema, auth, layout shell) go in SEC-1.
- Aim for 3–8 tasks per section. A feature with only 2–4 tasks total can be a single section.
- Write the table into `PROJECT_CONTEXT.md` → Sections: ID, name, tasks, scenarios, depends on, status.

## Granularity
- Good: half a day to 2 days of work.
- Too big (> 2 days): split by screen, endpoint or entity.
- Too small (< ~4 hours): merge with a related task.
- Number of tasks follows the feature, not a template — use as many F#/B# as needed.

## qa-task.md
Map each scenario to the 9 test categories (see `test-checklist`), list test data needed, and which tasks must be done before each block of testing can start.

## Checklist
- [ ] Every requirement maps to at least one task
- [ ] Every task has owner, dependencies, acceptance criteria and testing notes
- [ ] API contract written before frontend integration tasks
- [ ] Parallelizable tasks marked
- [ ] Every task belongs to exactly one section; sections are ordered and independently testable
- [ ] No task larger than ~2 days
