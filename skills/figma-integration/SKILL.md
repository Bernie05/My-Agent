---
name: figma-integration
description: Figma workflows - libraries, components, tokens, design-to-code handoff via the Figma MCP. Use when a task involves Figma files or handoff.
---

# Figma Integration & Workflow

## Figma Setup for Design Systems

### Project Organization

```
Workspace (Organization)
├── Brand System (Design System project)
│   ├── Foundations (library file)
│   │   ├── Colors
│   │   ├── Typography
│   │   ├── Spacing
│   │   └── Icons
│   ├── Components (library file)
│   │   ├── Buttons
│   │   ├── Forms
│   │   ├── Cards
│   │   └── Modals
│   └── Documentation (design file)
│       ├── Component guide
│       ├── Usage examples
│       └── Changelog
├── Product A (project)
│   ├── Design (working file)
│   │   └── Uses components from Brand System
│   └── Specs (documentation)
└── Product B (project)
    ├── Design (working file)
    └── Specs (documentation)
```

---

## Design Libraries in Figma

### Main Library File

The central "source of truth" file containing:

- Color styles
- Typography styles
- Component library
- Design tokens (if using Figma Variables)

### Published Components

```
In Library File:
- Create component (right-click → Create component)
- Mark "Publish this file as a library"
- Team members can insert components from this library
```

### Using Library Components

```
In Working File:
- Main menu → Assets → Search library
- Drag component into design
- Updates publish in library → Auto-update in files using it
```

---

## Component Organization in Figma

### Naming Convention

Use forward slashes to organize:

```
Good:
Button/Primary/Small
Button/Primary/Medium
Button/Primary/Large
Button/Secondary/Small
Button/Danger/Small

Bad:
ButtonPrimarySmall
Button_Primary_Small
Primary Button Small
```

### Variant System

```
Set up component variants:
- Type: primary, secondary, danger
- Size: small, medium, large
- State: default, hover, active, disabled

Result: 18 component variants from one "Button" component
```

### Main Component vs. Instances

**Main Component** (source of truth)

```
Button (blue, primary)
├── All instances update when this changes
```

**Instances** (copies that update)

```
[Instance] Use in designs
[Instance] Use in designs
[Instance] Auto-updates when main changes
```

---

## Design Tokens in Figma

### Option 1: Figma Variables (Modern)

```
Variables > Create variable
- color-primary: #3B82F6
- color-secondary: #6B7280
- spacing-xs: 4px
- spacing-sm: 8px
- spacing-md: 12px

Apply to components:
- Button background: color-primary (variable)
- Button padding: spacing-sm (variable)
→ Change variable, all components update
```

### Option 2: Figma Styles (Classic)

```
Assets > Create style
- Type: Color, Typography, Effect

Name with structure:
- Color/Primary
- Color/Gray/100
- Typography/Heading/H1
- Spacing/Small
```

### Option 3: Design Tokens Plugin

Plugins like:

- Token Studio for Figma (exports to JSON)
- Design Tokens (export to CSS)
- Supernova (design to code sync)

---

## Collaboration & Handoff

### Commenting & Feedback

```
Handoff Process:
1. Design team creates components
2. Frontend team reviews (comment mode)
3. Design team responds to feedback
4. Components approved
5. Specs generated
6. Frontend implements
```

### Inspect Mode for Frontend

```
Right-click component → Inspect
Frontend sees:
- Dimensions (width, height)
- Padding/spacing
- Colors (with hex codes)
- Typography (size, weight, line height)
- Effects (shadows, borders)
- Measurement guide to nearest element
```

### Export Specifications

```
File > Export > Generate specs
Or use plugins:
- Figma to Code (generates HTML/CSS)
- Handoff (design documentation)
- Spec (design specifications)
```

---

## Figma to Code Handoff

### What Frontend Needs

```
1. Component Specifications
   - Visual dimensions
   - Color values (or token names)
   - Typography details
   - States/variants

2. Design Assets
   - Icon SVG exports
   - Image assets (optimized)
   - Favicon files

3. Documentation
   - Component usage guide
   - Props/variants available
   - Accessibility requirements
   - Figma component link

4. Design Tokens
   - As CSS variables
   - As JSON
   - As Figma variables
```

### Handoff Document Template

Create a Figma file with documentation:

```markdown
# Component Name

## What is it?

Short description and use cases

## Specs

- Dimensions: [specs]
- Colors: [tokens used]
- Typography: [size, weight, line]
- Spacing: [padding, gaps]

## Variants

- Variant A (primary button)
- Variant B (secondary button)
- Variant C (danger button)

## States

- Default
- Hover
- Focus
- Active
- Disabled
- Loading

## Accessibility

- Semantic HTML: <button>
- ARIA labels: Required
- Keyboard: Enter/Space
- Focus indicator: Required

## Responsive

- Mobile: [changes]
- Tablet: [changes]
- Desktop: [changes]

## Figma Link

[Link to component in library]

## Implementation Notes

- [Specific implementation details]
- [Tradeoffs/constraints]
```

---

## Design System Maintenance

### Version Control in Figma

```
Library File Versions:
- Version history (automatic in Figma)
- Archive old versions
- Document changelog

Changelog example:
v2.0.0 (Jan 2024)
- Added Button danger variant
- Updated color palette
- Improved spacing scale

v1.9.0 (Dec 2023)
- Fixed modal focus management
- Added dark mode support
```

### Deprecating Components

```
When replacing an old component:
1. Create new component
2. Mark old as "DEPRECATED" in name
   Example: "Button/Primary [DEPRECATED]"
3. Document migration path
4. Give teams time to migrate
5. Remove after period
```

### Library Health

```
Regular audits:
- Unused components? Remove
- Inconsistent naming? Fix
- Outdated documentation? Update
- Missing variants? Add
- Design-code mismatch? Sync
```

---

## Design-to-Code Sync with MCP

### Figma MCP tools (real names)

| Tool | Use | Load this skill first |
|---|---|---|
| `create_new_file` | New Figma Design / FigJam file | `figma:figma-create-new-file` |
| `use_figma` | Create/edit nodes, variables, components, auto-layout | `figma:figma-use` (+ `figma:figma-generate-library` for systems, `figma:figma-generate-design` for screens) |
| `search_design_system` / `get_libraries` | Find existing library components/variables to reuse | — |
| `get_metadata` / `get_variable_defs` | Inspect structure and tokens | — |
| `get_screenshot` | Visually verify what was built | — |
| `generate_diagram` | User flows / sitemaps in FigJam | `figma:figma-generate-diagram` |
| `get_design_context` | Design → code (frontend-dev) | `figma:figma-design-to-code` |

The tools may be deferred: load them with ToolSearch (`figma`) before the first call.

### Workflow (this setup)

```
/design:start <feature>      figma-designer builds foundations, components, screens  → Gate 0
/design:approve              DESIGN.md handoff → architect /arch:analyze (Gate 1)
/fe:code F#                  frontend-dev reads DESIGN.md + get_design_context per frame
/design:review <url>         figma-designer compares implementation vs design
```

---

## Best Practices

### Design File Management

✅ **Clear naming** (Button/Primary/Small, not ButtonPrimSmall)
✅ **Organized hierarchy** (Components > Buttons > Variants)
✅ **Library files** (separate library from working files)
✅ **Design tokens** (CSS variables or Figma Variables)
✅ **Version history** (documented changes)

### Collaboration

✅ **Shared libraries** (team access to components)
✅ **Component reviews** (before publishing)
✅ **Changelog** (document all updates)
✅ **Documentation** (handoff specs ready)
✅ **Feedback loops** (design → code → design)

### Handoff

✅ **Inspect mode ready** (specs visible to frontend)
✅ **Design tokens** (CSS values provided)
✅ **Asset exports** (SVG, PNG optimized)
✅ **Documentation link** (accessible to team)
✅ **Migration guide** (if replacing component)

### Maintenance

✅ **Audit quarterly** (unused components?)
✅ **Update changelog** (version tracking)
✅ **Deprecate old** (clear migration path)
✅ **Design consistency** (regular audits)
✅ **Code alignment** (design matches code)

---

## Common Figma Workflows

### Workflow 1: Creating New Component

```
1. Design component (in working file)
2. Get feedback (comments, reviews)
3. Move to library file
4. Create main component with variants
5. Publish library
6. Document specs
7. Notify frontend team
8. Frontend implements
```

### Workflow 2: Design System Update

```
1. Identify change (new color, spacing, etc.)
2. Update in library file
3. Publishing updates all using files
4. Document changelog
5. Notify all teams
6. Frontend updates code
7. Audit for consistency
```

### Workflow 3: Design → Code Handoff

```
1. Design finalized in Figma
2. Generate specs (Inspect mode or plugin)
3. Export assets (SVG, PNG)
4. Create handoff document
5. Share Figma link with frontend
6. Frontend reviews & asks questions
7. Frontend implements
8. Code review by design
```

---

## Integration with MCP

### Automated Design to Code

```
Design Agent uses Figma MCP:
1. /figma-design Create component
   ↓ Updates Figma automatically

2. /figma-specs Extract specifications
   ↓ Gets real data from Figma

3. Frontend Dev implements from specs
   ↓ Code matches design

4. /figma-sync Verify consistency
   ↓ Ensures no drift
```

### Real-Time Sync

```
Figma file updates
  ↓
MCP detects change
  ↓
/figma-sync notifies team
  ↓
Frontend updates code
  ↓
Design ↔ Code stays in sync
```

---

## Tools & Plugins

### Recommended Figma Plugins

- **Figma to Code** - Export as HTML/CSS/React
- **Inspect** - Detailed specs for frontend
- **Handoff** - Auto-generate documentation
- **Token Studio** - Design token management
- **Color Contrast Analyzer** - A11y testing
- **Figma Variables** - Dynamic tokens
- **Responsively** - Responsive testing

---

## Resources

- **Figma Learning:** https://www.figma.com/resources/
- **Design Systems:** https://www.designsystems.com/
- **Component Driven:** https://www.componentdriven.org/
- **Figma MCP Integration:** [Your MCP server setup guide]
