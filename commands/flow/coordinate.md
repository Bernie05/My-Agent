---
description: "Flow: resolve blockers and dependencies between agents and get work moving again"
argument-hint: "[feature] [specific blocker]"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Arguments: $ARGUMENTS

1. Collect blockers from PROJECT_CONTEXT.md → Blockers, tasks marked ⛔, open issues that block testing, and the latest agent reports.
2. For each one, decide who unblocks it:
   - Spec question or conflict → **architect** (ask / update-specs)
   - API contract mismatch → **backend-dev** (keep the contract) or **frontend-dev** (adapt), per the architect's contract
   - Failing fix or retest → the owning dev, then **qa-agent**
   - Product/business decision → the user (AskUserQuestion with a recommendation)
3. Dispatch independent unblock actions in parallel.
4. Update Blockers in PROJECT_CONTEXT.md and log to activity.log. Report what was unblocked, what's still waiting, and the next step.

**Flow log:** if the run folder has a `FLOW.md`, update it for what this command changed (`flow-log` skill).
