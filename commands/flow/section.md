---
description: "Flow: implement and test one section (SEC-#) of a feature, then stop at a checkpoint"
argument-hint: "[feature] <SEC-# | section name | next>"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Arguments: $ARGUMENTS. Follow the `token-efficiency` skill.

1. Read PROJECT_CONTEXT.md → Flow State and the Sections table. Check Gate 3 is passed; if not, point the user to `/flow:start` or `/arch:finalize`.
2. Pick the section: the given SEC-# or name, or `next` (or nothing) = the first section that isn't ✅ Done and whose dependencies are done. If a dependency isn't done, say so and offer to build that section first.
3. Set `Scope: per-section` and `Current section: SEC-n` in Flow State. Mark the section 🔄 Building and log it.
4. **Build**: dispatch only this section's tasks by Mode (hybrid: backend-dev and frontend-dev in parallel; sequential: one after the other; parallel: plus qa-agent writing this section's tests). Pass the section ID and task IDs.
5. **Test**: mark it 🧪 Testing; qa-agent **test-scenario** for the section's SC-# plus a smoke check of sections already done. For issues: architect **analyze-issue** → Gate 4 (Fix / Defer / Accept) → the owning dev fixes → qa-agent re-tests.
6. Mark it ✅ Done, update the task statuses yourself, and log it.
7. **Checkpoint**: show a 3-line summary and the remaining sections, then ask with AskUserQuestion: **Next section** (run this command again with `next`) / **Fix or change something** / **Stop**. When no sections are left, suggest the final `/qa:test-checklist`, then `/qa:approve-feature`.
