---
name: design-handoff
description: Write DESIGN.md - the design handoff that links Figma frames and node IDs to screens, tokens, components, states, interactions and requirements, for the architect and frontend-dev. Use when finishing a design (/design:handoff, /design:approve) or when the design changes.
---

# Design Handoff (DESIGN.md)

DESIGN.md sits in `docs/features/<slug>/`. The architect derives requirements and scenarios from it; the frontend-dev builds from it (and pulls exact specs per frame with `get_design_context`). It must match the Figma file exactly — regenerate it after every revision.

## Template

```markdown
# <Feature> — Design
Status: Draft | Awaiting approval | Approved (<date>)
Figma file: <url>
Flow diagram: <url>

## Summary
<what the design covers, key design decisions in 3-6 bullets>

## Screens
| ID | Screen | States | Mobile frame | Desktop frame |
|----|--------|--------|--------------|---------------|
| S1 | <name> | default, loading, empty, error | <url?node-id=...> | <url?node-id=...> |

### S1: <Screen name>
Purpose: <user goal>
Content & data shown: <fields, lists, with source if known>
Actions: <button/link → result, navigation target>
Validation & messages: <field rules and exact error/empty/success copy>
Responsive notes: <what changes between breakpoints>
Accessibility notes: <focus order, labels, announcements>

## User Flows
<journey: S1 → S2 → S3 (decision: ... → S4)>

## Design Tokens
<collections and key variables: color semantics, spacing scale, radius, typography styles — names as in Figma>

## Components
| Component | Variants / properties | States | Figma link | Notes (new / reused from library) |

## Interactions & Motion
<transitions, hover/press, toasts, modals, loading behavior>

## Assumptions & Open Questions
## Out of Scope (design)
## Revision History
| Date | Change | Frames affected |
```

## Code-first variant (no Figma, written by frontend-dev)
Same template, with these changes:
- Under `Status:` write `Source: code (frontend-dev)` instead of `Figma file:`/`Flow diagram:`, plus `Theme file: <path>` and `Preview route: <path>`.
- Screens table: replace the frame columns with `Preview` (route + state, e.g. `/design-preview#s1-empty`) and `Screenshots` (paths under `design/`).
- Design Tokens: the names as they appear in the theme file. Components: the file path instead of a Figma link.

A Figma design uses `Source: figma`.

## Rules
- Link every screen and component with a node-specific URL (Figma), or a preview route and file path (code-first).
- Copy text (errors, empty states, button labels) is written out exactly — it becomes requirements.
- Anything the design implies about data, permissions or behavior that isn't obvious goes in Assumptions for the architect to confirm.
- On approval, set `Status: Approved (<date>)` — the architect treats an approved DESIGN.md as input to SPEC.md.
