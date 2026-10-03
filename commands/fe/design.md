---
description: "Frontend: design a feature in code when there is no Figma design - tokens, theme, preview page and DESIGN.md, then stop for approval (Gate 0)"
argument-hint: "[feature] <brief / what the UI should do> [brand notes]"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise create it from the feature name (lowercase-kebab).

Use the **frontend-dev** agent, operation **design**, for: $ARGUMENTS

1. If the agent returns questions (stack, brand, content), ask the user (AskUserQuestion when there are clear options), then call it again with the answers.
2. **Hard stop, Gate 0 (design approval):** show the DESIGN.md link, the preview route (and how to open it, e.g. `npm run dev` → `/design-preview`), the screenshot paths and a short summary. Then ask with AskUserQuestion: **Approve** / **Send back** (with feedback) / **Reject**.
   - **Approve** → continue exactly as `/design:approve` does.
   - **Send back** → call frontend-dev **design** again with the feedback, then repeat this gate.
   - **Reject** → set Flow State phase to `stopped`, log it, and end.
