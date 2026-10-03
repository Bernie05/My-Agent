---
description: "Design: apply feedback to the Figma design and log it in DESIGN.md revision history"
argument-hint: "[feature] <feedback, optionally with frame links>"
---

Use the **figma-designer** agent, operation **revise**, with this feedback: $ARGUMENTS

Show what changed with frame links. Then ask the user with AskUserQuestion: **Approve now** (run `/design:approve`) / **More changes** / **Later**. If development had already started, remind them to run `/arch:update-specs` so the spec and tasks follow the design change.
