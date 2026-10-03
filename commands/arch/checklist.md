---
description: "Architect: show task progress percentages for a feature"
argument-hint: "[feature]"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Do this **directly, without spawning an agent** (token-efficiency): count ✅ vs total tasks per area and per section from the task files (Grep the Status lines rather than reading everything). Show the result as a compact table (area, done/total, %) followed by the task list with ✅ 🔄 ⏳ ⛔. $ARGUMENTS
