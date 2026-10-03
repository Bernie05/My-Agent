---
name: figma-design-workflow
description: Step-by-step process for designing a feature or app in Figma via the Figma MCP - brief, file setup, foundations (variables/styles), components, user-flow diagram, screens, visual verification. Use when the figma-designer builds or extends a design (/design:start, /design:system, /design:screen).
---

# Figma Design Workflow

## 0. Brief (design-brief.md)
Capture: product goal, target users, the screens/flows needed, key content and data shown, platform(s) and breakpoints, brand inputs (colors, fonts, logo, existing library), accessibility needs, constraints. Unknowns go in "Open Questions" — ask rather than invent brand decisions.

## 1. File setup
- Existing file/library given → use it; inspect with `get_metadata`, `get_libraries`, `search_design_system`, `get_variable_defs`.
- Otherwise → create one with `create_new_file` (load `figma:figma-create-new-file` first). Name: `<Project> — <Feature>`.
- Pages: `📐 Foundations`, `🧩 Components`, `🔀 Flows`, `📱 Screens`, `🗒 Handoff Notes`.

## 2. Foundations (load `figma:figma-use` + `figma:figma-generate-library`)
Create variable collections (with Light/Dark modes if needed):
- **Color**: primitives (brand scales, neutrals, success/warning/error/info) → semantic aliases (`bg/default`, `text/primary`, `border/subtle`, `action/primary`...). Check text/background pairs for ≥ 4.5:1 contrast.
- **Spacing**: 4-based scale (4, 8, 12, 16, 24, 32, 48, 64).
- **Radius**, **border width**, **elevation** (effect styles).
- **Typography**: text styles for display, headings (H1–H4), body (L/M/S), label, caption — font, size, line height, weight.
Document them on the Foundations page.

## 3. Components
Build only what the screens need, starting from atoms: Button, Input/TextField, Select, Checkbox/Radio/Switch, Badge/Tag, Avatar, Card, Table/List row, Modal/Dialog, Toast/Alert, Navigation (top bar / sidebar / tabs), Empty state.
- Component sets with variant properties (`Type`, `Size`, `State`), boolean/text/instance-swap properties where useful.
- States: default, hover, focus, disabled, loading, error (and selected/checked where relevant).
- Auto-layout everywhere, bound to spacing/color variables.

## 4. Flows (load `figma:figma-generate-diagram`)
Use `generate_diagram` to create a user-flow diagram (screens and decision points) for the main journeys. Link it in DESIGN.md.

## 5. Screens (load `figma:figma-generate-design`)
For each screen in the brief:
- Frames for mobile (390w) and desktop (1440w) unless the brief says otherwise.
- Built only from component instances + variables.
- Include the non-happy states as separate frames: loading, empty, error, success/confirmation, permission denied where relevant.
- Realistic sample content (no lorem ipsum in key places) — it exposes layout problems.
- Name frames `Screen/<Area>/<Name>/<State>/<Breakpoint>`.

## 6. Verify
For each screen and component set: `get_screenshot` → check alignment, spacing, overflow/truncation, contrast, consistency with foundations. Fix, re-screenshot. Note anything intentionally left open.

## 7. Handoff
Write DESIGN.md (see `design-handoff`) with links to every page/frame, then report back for Gate 0.

## Checklist before Gate 0
- [ ] Every screen in the brief exists at each breakpoint, with its non-happy states
- [ ] No hard-coded values; all variables/styles bound
- [ ] All interactive components have every state
- [ ] Contrast and touch target sizes checked
- [ ] Flow diagram covers main journeys
- [ ] Screenshots reviewed
- [ ] DESIGN.md complete, open questions listed
