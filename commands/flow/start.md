---
description: "Flow: run the full gated feature pipeline (optional design in Figma or by frontend-dev → architect → implement all or per section → QA) in the chosen mode"
argument-hint: "<feature name/description + specs> [--mode hybrid|sequential|parallel] [--scope all|per-section] [--design figma|frontend|none] [Figma URL]"
---

You are the orchestrator for this feature. You run in the main session and delegate to the subagents **figma-designer**, **architect**, **frontend-dev**, **backend-dev** and **qa-agent** (subagents can't call each other; only you can). Follow the `token-efficiency` skill throughout. Arguments: $ARGUMENTS

## Setup
1. Mode = `--mode` value if given, else the Mode in an existing `PROJECT_CONTEXT.md`, else **hybrid**.
2. If `docs/features/<slug>/PROJECT_CONTEXT.md` already exists for this feature, don't restart: continue from its Flow State phase (same as /flow:resume).
3. **Design source** (the toggle): `--design figma|frontend|none`. The old flags still work: `--design` alone = `figma`, `--no-design` = `none`. A Figma URL in the arguments means `figma`. If none of these is given, the feature has a UI, and there is no approved DESIGN.md yet, ask the user (AskUserQuestion):
   - **Design in Figma**: figma-designer builds it in Figma. Needs the Figma connector.
   - **Frontend designs it (no Figma)**: frontend-dev designs it in code (tokens, theme and a preview page of the screens), for approval before the spec.
   - **Skip design**: no design stage; frontend-dev styles each task as it builds.

   Save `Design: figma | frontend | none` in Flow State (none → G0 = n/a).
4. Append to `activity.log`: `<timestamp> | orchestrator | flow started (mode: <mode>, design: <source>)`.

## Phase 0 — Design (optional, 1 hard stop)
**Design: figma.** Run exactly as `/design:start` does: figma-designer **start** → **Gate 0**. If figma-designer reports that the Figma MCP isn't connected, or the user says the Figma design isn't ready, ask: **Switch to frontend design** / **Wait (stop here)** / **Skip design**. On switch, set `Design: frontend` in Flow State and continue below.

**Design: frontend.** Run exactly as `/fe:design` does: frontend-dev **design** → **Gate 0**.

**Gate 0** (both sources): show the DESIGN.md link and the screens (Figma frame links, or the preview route and screenshot paths), then ask **Approve** / **Send back** (→ the same agent revises with the feedback: figma-designer **revise**, or frontend-dev **design** again; then repeat) / **Reject**. On Approve, do what `/design:approve` does: mark DESIGN.md Approved, tick G0, and go into Phase 1, where the architect uses DESIGN.md as its primary input.

## Phase 1 — Specification (3 hard stops)
For each gate: call the **architect**, show the user a short summary with file links, then ask with AskUserQuestion **Approve / Send back / Reject**. Send back → call the architect again with the feedback. Reject → set phase `stopped` and end. Tick each gate in Flow State as it passes.
1. architect **analyze** (pointing it at the approved DESIGN.md if there is one; answer its open questions with the user first) → **Gate 1**
2. architect **breakdown** (tasks grouped into sections SEC-#) → **Gate 2**
3. architect **finalize** (writes PROJECT_CONTEXT.md with Mode and the Sections table) → **Gate 3** → architect **approve**

## Implementation scope (choose before Phase 2)
Use `--scope` if given, else the Scope in Flow State. Otherwise show the Sections table (ID, name, number of tasks) and ask with AskUserQuestion:
- **Implement all**: build every task, then test the whole feature once. Fastest when the feature is small.
- **Implement per section (recommended for larger features)**: build and test one section at a time, with a checkpoint after each. Uses less context per round, and problems surface earlier.

Save `Scope:` (and `Current section:`) in Flow State.

## Phase 2 + 3 — Build and test
### Scope: all
1. **Build.** Dispatch by Mode:
   - **hybrid:** backend-dev (all B tasks) and frontend-dev (all F tasks, against the API contract; mock if the backend isn't ready) **in parallel**, as two Agent calls in one message. Run a second round for anything blocked by dependencies.
   - **sequential:** backend-dev → frontend-dev, with a short check-in after each report.
   - **parallel:** backend-dev, frontend-dev and qa-agent (**start-testing**: plan and automated tests) in one message.
2. **Test** (Phase 3 below) on the whole feature.

### Scope: per section
For each section in order (skip ✅ Done, respect `Depends on`):
1. Set `Current section: SEC-n` and mark it 🔄 Building.
2. **Build** only that section's tasks, dispatched by Mode as above. Pass the section ID and task IDs, not file contents.
3. Mark it 🧪 Testing, then **test the section**: qa-agent **test-scenario** for its SC-# plus a quick smoke check of the sections already done. Triage any issues with Gate 4 (below) and fix them before moving on.
4. Mark it ✅ Done and log it. Then **section checkpoint**: show a 3-line summary (built, tests, open issues) and ask with AskUserQuestion: **Next section** / **Fix or change something first** / **Stop here** (stop = /flow:stop). If the user chose "no check-ins" earlier, continue automatically unless something failed.
5. After the last section, run the full **test-checklist** once over the whole feature (Phase 3, step 1) before release.

The user can also run a single section any time with `/flow:section <SEC-# | name | next>`.

If a DESIGN.md exists, tell frontend-dev to build from it: from its Figma frames (`Design: figma`), or from its tokens and preview components (`Design: frontend`). Optionally, once the UI is done, have figma-designer **review** the implementation against the design (ask the user; Figma designs only).

After each build round: summarize the reports briefly and resolve blockers (spec questions → architect **ask**; contract mismatches → the responsible dev). **Update task and section status yourself**, directly in the files: don't spawn the architect for bookkeeping. If a blocker needs the user, stop and ask.

## Phase 3 — QA
1. qa-agent **start-testing** (unless it was already done), then **test-checklist**. In per-section scope, the checklist runs once at the end; the sections were already tested one by one.
2. For each new issue: architect **analyze-issue** → **Gate 4** (AskUserQuestion: Fix / Defer / Accept) → record the decision.
3. Fixes: send them to the owning dev (**debug**, several issues in one call), in parallel where independent. Then qa-agent re-tests (**test-scenario**).
4. Repeat until there are no open CRITICAL or HIGH issues.

## Phase 4 — Release
qa-agent **approve-feature**. If it recommends GO, ask the user to confirm, then set phase `done`. Finish with a short final report (offer `/flow:report` for the full REPORT.md).

## Throughout
- Keep Flow State (phase, scope, current section, gates, blockers) in PROJECT_CONTEXT.md current, so /flow:status and /flow:resume work from any session.
- Keep your messages to the user short: phase or section, what just finished, what's next.
- The user can interrupt at any time; /flow:stop pauses cleanly.
