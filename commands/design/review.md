---
description: "Design: review a design for quality/accessibility, or compare a built implementation against the Figma frames"
argument-hint: "[feature] <Figma URL | app URL | screenshot | code path>"
---

Use the **figma-designer** agent, operation **review**, on: $ARGUMENTS

- Given a Figma URL only → design-quality review: consistency with tokens/components, missing states, contrast, touch targets, naming.
- Given an implementation (running app URL, screenshots or code) → compare it to the matching frames in DESIGN.md.

Present findings by severity with frame links. For implementation mismatches, offer to send them to **frontend-dev** (`/fe:debug`) or log them via `/qa:report-issue`.
