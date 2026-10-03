---
description: "Quick: move a quick-team project to the big team (/flow:start) without losing the plan or the finished work"
argument-hint: "[feature]"
---

Arguments: $ARGUMENTS

Resolve the folder in `docs/features/` that has a `PLAN.md`; ask if more than one fits.

1. Confirm with the user in one line: the big team adds a full spec, QA and more gates.
2. Use the **architect** agent, operation **analyze**, saying that `PLAN.md` is the primary input: its requirements, API contract, data model and scenarios carry over, and tasks marked ✅ are already built. Then continue exactly as `/flow:start` from Gate 1, with `Design` taken from PLAN.md. In breakdown, the architect marks work that already exists as ✅.
3. When SPEC.md is approved, add `Status: Superseded by SPEC.md (<date>)` to the top of PLAN.md; the devs then follow SPEC.md. Log it in activity.log.

**Flow log:** if the run folder has a `FLOW.md`, update it for what this command changed (`flow-log` skill).
