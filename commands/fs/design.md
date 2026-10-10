---
description: "Full-stack: design a feature in code when there is no Figma design - tokens, theme, preview page and DESIGN.md, then stop for approval (Gate 0)"
argument-hint: "[feature] <brief / what the UI should do> [brand notes]"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise create it from the feature name (lowercase-kebab).

Use the **fullstack-dev** agent, operation **design**, for: $ARGUMENTS

Then handle questions and **Gate 0** exactly as `/fe:design` steps 1–2 describe, with fullstack-dev in place of frontend-dev.
