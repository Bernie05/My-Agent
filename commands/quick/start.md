---
description: "Quick: build a simple project with the small team (architect, frontend-dev, backend-dev) - one plan, one gate, parallel build, final check, optional Vercel deploy"
argument-hint: "<project/feature description + specs> [--team fullstack|split] [--design none|frontend] [--frontend-only | --backend-only]"
---

You are the orchestrator for a **simple** project. You run in the main session and delegate to **architect** and **fullstack-dev** (or **frontend-dev** + **backend-dev** with `--team split`), plus **vercel-deployer** for the optional deploy: no QA agent, no figma-designer. Follow the `token-efficiency` skill. Arguments: $ARGUMENTS

## Setup
1. Slug = lowercase-kebab of the name; the folder is `docs/features/<slug>/`. If `PLAN.md` already exists there, don't restart: continue from its `Phase`. If `SPEC.md` exists, this feature belongs to the big team: stop and suggest `/flow:resume`.
2. **Size check.** If the request clearly isn't simple (several user roles, payments, complex auth or permissions, integrations with outside systems, many screens), say so in 1–2 lines and ask (AskUserQuestion): **Use the big team (/flow:start)** / **Keep it quick**.
3. Design = `--design` if given, else `none` (frontend-dev styles as it builds). `frontend` → run `/fe:design` first and its Gate 0, then continue.
4. Dev team = `--team` if given, else `fullstack`. Tell the architect, so `PLAN.md` records `Dev team:`.
5. No `.gitignore` in the repo → the dev that scaffolds loads `project-gitignore` first (their rules already say so; remind them in the prompt).

## 1. Plan (1 hard stop)
architect **plan-lite**. If it returns open questions, ask the user in **one** AskUserQuestion call, then call it again with the answers.
**Plan gate:** show the PLAN.md link and a 3-line summary (requirements count, tasks F#/B#, stack). Ask **Approve** / **Send back** (→ architect **plan-lite** again with the feedback, then repeat) / **Reject** (Phase `stopped`, end). If the architect recommended the big team, include that option: **Upgrade** → `/quick:upgrade`. If its report has team-check `FEEDBACK:` items, show a **Team gaps** list and add **Approve + hire**: approve, then run the hires per `token-efficiency` → "Team-check gaps" before the build.
On Approve, set `Status: Approved` and `Phase: build` in PLAN.md yourself.

## 2. Build
**Dev team `fullstack`:** one fullstack-dev **code** call with all B# and F# (backend first, then UI against the contract). **`split`:** backend-dev **code** (all B#) and frontend-dev **code** (all F#, against the API contract; mock anything not ready) **in parallel**, as two Agent calls in one message. Pass the slug and task IDs, not file contents. `--frontend-only` / `--backend-only` → only those tasks (to fullstack-dev, or to that dev when split). Run a second round for anything blocked by a dependency. Each dev writes and runs their own tests.
Spec questions go to architect **ask**. Update task statuses in PLAN.md yourself, not through the architect.

## 3. Final check (you, no agent)
Set `Phase: check`.
1. Run the project's build, lint and tests (the commands the devs reported).
2. Walk each SC-# in PLAN.md once: run the app (`run` skill) or call the API, and check the expected result. For UI flows, use the `browser-testing` skill only if a quick look can't confirm it.
3. Failures → send them to the owning dev's **debug** operation, several in one call, both devs in parallel if both are involved. Then re-check only what failed. Stop after 2 rounds and ask the user.

## 4. Deploy (optional, 1 hard stop)
Only when the final check passed and the project can deploy to Vercel (a web app, or a `vercel.json` / `.vercel/` link). Otherwise set `Deploy: n/a` and go to step 5.
1. Ask (AskUserQuestion): **Deploy a preview** / **Skip deploy** (→ `Deploy: skipped`, step 5).
2. Set `Phase: deploy`. vercel-deployer **env**: missing required variables → list them, offer `/deploy:env add …`, and wait.
3. vercel-deployer **deploy** (preview). Handle its replies as `/deploy:vercel` step 4 does; a build error caused by code goes to the owning dev's **debug**, then deploy once more. Stop and ask after a second failure.
4. Confirm `READY` and HTTP 2xx, then re-walk 1–3 key SC-# against the preview URL yourself. Read-only ones only: a preview can share production data, so skip anything that creates, changes or deletes data unless the user confirms it uses a test database.
5. Ask **Promote to production** / **Keep preview only**. Promote → vercel-deployer **promote** `<preview url>` with `confirmed: promote`. Never production without this explicit choice.
6. Record `Deploy: preview <url> | production <url>` in the PLAN.md header and add a Log line.

## 5. Done
Set `Phase: done` and add a Log line. Final report (10 lines max): what was built, how to run it, tests (pass/fail), scenarios (x/y passed), deploy URL (or skipped / n/a), known gaps.

## Throughout
Keep messages short. The user can interrupt; to pause, set `Phase: stopped` in PLAN.md and a one-line resume note in its Log. Running `/quick:start` again resumes it.

**Flow log:** load the `flow-log` skill and keep this run's `FLOW.md` current: create it when the run starts, then update it at every step, gate, pause and finish. Show its path in your first message.
