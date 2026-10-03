---
description: "Design: create the full Figma design for a feature (brief, design system, screens, flows) and stop for approval (Gate 0)"
argument-hint: "<feature/app description> [Figma file URL] [brand notes]"
---

Use the **figma-designer** agent, operation **start**, for: $ARGUMENTS

1. Create the slug from the feature name (lowercase-kebab); the agent works in `docs/features/<slug>/`.
2. If the agent returns open questions (brand, content, platforms), ask the user (AskUserQuestion when there are clear options), then call the agent again with the answers.
3. If the agent reports that Figma MCP isn't connected, stop and tell the user to authorize the Figma connector (claude.ai connector settings, or `/mcp`).

**Hard stop — Gate 0 (Design approval):** show the Figma file link, the list of screens with frame links, and a short summary. Then ask with AskUserQuestion: **Approve** / **Send back** (with feedback) / **Reject**.
- **Approve** → continue exactly as `/design:approve` does (DESIGN.md marked Approved, G0 ticked, then the architect starts `analyze` → Gate 1).
- **Send back** → call figma-designer **revise** with the feedback, then repeat this gate.
- **Reject** → set Flow State phase to `stopped`, log it, and end.
