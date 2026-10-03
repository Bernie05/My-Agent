---
description: "Design: build or extend the design system in Figma (variables/tokens, styles, components with variants and states)"
argument-hint: "[feature] <what to build, e.g. 'foundations + form components'> [Figma file URL]"
---

Use the **figma-designer** agent, operation **system**, for: $ARGUMENTS

If this belongs to a feature, it works in `docs/features/<slug>/` and updates DESIGN.md → Design Tokens / Components. Show the user the Figma links and counts (variables, styles, components: new vs reused). If the design was already approved (G0 ticked), point out that changes need re-approval with `/design:approve`, and that the architect should run `/arch:update-specs` if requirements change.
