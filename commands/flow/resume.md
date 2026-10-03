---
description: "Flow: resume a stopped or interrupted feature workflow from its saved state"
argument-hint: "[feature]"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Arguments: $ARGUMENTS

1. Read PROJECT_CONTEXT.md (Flow State, Resume notes, Blockers), the task files, issues.md and the tail of activity.log.
2. Give the user a 3-line recap: where it stopped, what's next, and anything that needs their input.
3. Restore the phase (drop "stopped"), log `<timestamp> | orchestrator | resumed`, and continue the pipeline from that phase exactly as described in `/flow:start` (same mode, same scope, same gates; in per-section scope, restart at `Current section`). Re-run any task that was 🔄 when it stopped, starting with a check of what was already done.
