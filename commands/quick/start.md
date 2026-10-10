---
description: "Quick: build a simple project with the small team (architect, frontend-dev, backend-dev) - one plan, one gate, parallel build, final check"
argument-hint: "<project/feature description + specs> [--design none|frontend] [--frontend-only | --backend-only]"
---

You are the orchestrator for a **simple** project. You run in the main session and delegate to **architect**, **frontend-dev** and **backend-dev** only: no QA agent, no figma-designer. Follow the `token-efficiency` skill. Arguments: $ARGUMENTS

## Setup
1. Slug = lowercase-kebab of the name; the folder is `docs/features/<slug>/`. If `PLAN.md` already exists there, don't restart: continue from its `Phase`. If `SPEC.md` exists, this feature belongs to the big team: stop and suggest `/flow:resume`.
2. **Size check.** If the request clearly isn't simple (several user roles, payments, complex auth or permissions, integrations with outside systems, many screens), say so in 1–2 lines and ask (AskUserQuestion): **Use the big team (/flow:start)** / **Keep it quick**.
3. Design = `--design` if given, else `none` (frontend-dev styles as it builds). `frontend` → run `/fe:design` first and its Gate 0, then continue.
4. No `.gitignore` in the repo → the dev that scaffolds loads `project-gitignore` first (their rules already say so; remind them in the prompt).

## 1. Plan (1 hard stop)
architect **plan-lite**. If it returns open questions, ask the user in **one** AskUserQuestion call, then call it again with the answers.
**Plan gate:** show the PLAN.md link and a 3-line summary (requirements count, tasks F#/B#, stack). Ask **Approve** / **Send back** (→ architect **plan-lite** again with the feedback, then repeat) / **Reject** (Phase `stopped`, end). If the architect recommended the big team, include that option: **Upgrade** → `/quick:upgrade`. If its report has `NEEDS:` blocks (team check), show a **Team gaps** list and add **Approve + hire**: approve, then run the hires per `token-efficiency` → "`NEEDS:` in a report" before the build.
On Approve, set `Status: Approved` and `Phase: build` in PLAN.md yourself.

## 2. Build
backend-dev **code** (all B#) and frontend-dev **code** (all F#, against the API contract; mock anything not ready) **in parallel**, as two Agent calls in one message. Pass the slug and task IDs, not file contents. `--frontend-only` / `--backend-only` → call only that dev. Run a second round for anything blocked by a dependency. Each dev writes and runs their own tests.
Spec questions go to architect **ask**. Update task statuses in PLAN.md yourself, not through the architect.

## 3. Final check (you, no agent)
Set `Phase: check`.
1. Run the project's build, lint and tests (the commands the devs reported).
2. Walk each SC-# in PLAN.md once: run the app (`run` skill) or call the API, and check the expected result. For UI flows, use the `browser-testing` skill only if a quick look can't confirm it.
3. Failures → send them to the owning dev's **debug** operation, several in one call, both devs in parallel if both are involved. Then re-check only what failed. Stop after 2 rounds and ask the user.

## 4. Done
Set `Phase: done` and add a Log line. Final report (10 lines max): what was built, how to run it, tests (pass/fail), scenarios (x/y passed), known gaps, and whether `/deploy:vercel` makes sense next.

## Throughout
Keep messages short. The user can interrupt; to pause, set `Phase: stopped` in PLAN.md and a one-line resume note in its Log. Running `/quick:start` again resumes it.

**Flow log:** load the `flow-log` skill and keep this run's `FLOW.md` current: create it when the run starts, then update it at every step, gate, pause and finish. Show its path in your first message.
