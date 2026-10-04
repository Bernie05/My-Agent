---
description: "Flow: hand a feature off to the next phase (design → spec → development → QA → release → deploy) with readiness checks"
argument-hint: "[feature] <architecture|development|qa|release|deploy>"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Arguments: $ARGUMENTS (if no target phase is given, use the next one after the current phase)

Check readiness before handing off:
- **→ architecture:** DESIGN.md exists, is Approved (G0 ticked), and links every screen. (Handing off here does exactly what `/design:approve` step 3 does.)
- **→ development:** Gates 1–3 passed, no open questions in SPEC.md, API contract defined.
- **→ qa:** all F/B tasks ✅, test suites passing (ask the devs for their latest test results if unknown), seed/test data and run instructions available.
- **→ release:** qa-agent approve-feature says GO; no open CRITICAL/HIGH issues; deferred/accepted issues documented.
- **→ deploy:** release confirmed (GO); the project can deploy to Vercel. Then run `/flow:start` Phase 5 (Gate 5, env check, preview, smoke test, optional promote).

If not ready, list exactly what's missing and the commands to fix it. If ready: update the phase in Flow State, write a short handoff note in PROJECT_CONTEXT.md (what's done, where things are, known issues, how to run), log it, and start the next owner's first operation (e.g. qa-agent start-testing).
