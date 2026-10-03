---
description: "Design: approve the Figma design (Gate 0) and hand it to the architect to continue the workflow"
argument-hint: "[feature] [notes]"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Arguments: $ARGUMENTS

1. Check `DESIGN.md` exists and lists its screens with links: the Figma file and frames, or, for `Source: code`, the preview route and screenshots. If it's missing or stale, call **figma-designer** operation **handoff** first (for `Source: code`, frontend-dev **design** instead).
2. In DESIGN.md set `Status: Approved (<today>)`. In `PROJECT_CONTEXT.md` → Flow State tick `G0 Design` and set `Phase: analysis` (create the file with a Flow State block if it doesn't exist yet — Mode from an earlier /flow:mode, else hybrid). Log to activity.log: `<timestamp> | user | design approved`.
3. **Hand off to architecture:** use the **architect** agent, operation **analyze**, telling it that the approved `DESIGN.md` is the primary input — screens, copy, states and flows become requirements (R#) and scenarios (SC-#), and the design's Assumptions become Open Questions. Include any notes from the arguments.
4. Continue exactly like `/arch:analyze`: resolve open questions with the user, then **Gate 1** (Approve / Send back / Reject). After Gate 1, if this feature is running under `/flow:start`, carry on with its Phase 1; otherwise suggest `/arch:breakdown`.

**Flow log:** if the run folder has a `FLOW.md`, update it for what this command changed (`flow-log` skill).
