---
description: "Architect: analyze a feature and write SPEC.md, analysis.md, scenarios.md (Gate 1)"
argument-hint: "<feature name or description, incl. tech stack if known>"
---

Use the **architect** agent, operation **analyze**, for: $ARGUMENTS

Create the slug from the feature name. Pass along everything the user said about requirements and tech stack. If the architect returns open questions, ask the user (AskUserQuestion when there are clear options) and send the answers back to the architect before the gate.

**Hard stop:** show the user a short summary of what the agent produced (with file links). If the report has `NEEDS:` blocks, add a **Team gaps** list (type, name, Summary, needed by). Then ask with AskUserQuestion: **Approve** / **Approve + hire** (only when there are gaps: approve the spec, then run the team-check hires per `token-efficiency` → "`NEEDS:` in a report") / **Send back** (with feedback) / **Reject**. On Approve, tick the gate in `PROJECT_CONTEXT.md` → Flow State (create the Flow State block if the file does not exist yet) and suggest the next command. On Send back, call the architect again with the feedback and repeat this stop. On Reject, set Flow State phase to `stopped` and log it. Do not continue to the next phase on your own. (Gate 1: Spec review)
