---
name: design-systems
description: Building and governing a design system - tokens, design language, theming, documentation. Use when creating or extending a design system.
---

# Design Systems

## What is a Design System?

A design system is a **collection of reusable components and patterns, guided by clear standards, that can be assembled together to build any number of applications.**

Components:

- ✅ Buttons, inputs, cards
- ✅ Navigation, layouts
- ✅ Modals, alerts, tooltips

Standards:

- ✅ Color palette
- ✅ Typography scale
- ✅ Spacing guidelines
- ✅ Accessibility rules
- ✅ Motion principles
- ✅ Voice & tone

---

## Design System Layers

### Layer 1: Foundations (Design Tokens)

**The building blocks**

```
Colors:
- Primary: #3B82F6
- Secondary: #6B7280
- Success: #10B981
- Error: #EF4444

Typography:
- Heading 1: 32px, weight 700, line-height 1.2
- Heading 2: 24px, weight 600, line-height 1.3
- Body: 16px, weight 400, line-height 1.5
- Small: 14px, weight 400, line-height 1.4

Spacing:
- xs: 4px
- sm: 8px
- md: 12px
- lg: 16px
- xl: 24px
- 2xl: 32px

Shadows:
- Elevation 1: 0 1px 3px rgba(0,0,0,0.1)
- Elevation 2: 0 4px 6px rgba(0,0,0,0.1)
- Elevation 3: 0 10px 15px rgba(0,0,0,0.1)

Radius:
- sm: 4px
- md: 8px
- lg: 12px
- full: 9999px
```

### Layer 2: Components (Primitive)

**Basic, single-purpose components**

- Button
- Input
- Label
- Icon
- Checkbox
- Radio
- Select

### Layer 3: Patterns (Composite)

**Combinations of primitives that solve common problems**

- Form (Input + Label + Error)
- Card (Container + Image + Title + Description)
- Modal (Card + Overlay + Close button)
- Navigation (Button + Icon + Label)

### Layer 4: Layouts (Template)

**Full-page layouts using components**

- Landing page layout
- Product page layout
- Dashboard layout
- Admin panel layout

### Layer 5: Documentation

**Guides, examples, governance**

- Component usage guide
- Code examples
- Accessibility checklist
- Design principles
- Changelog

---

## Design Language

### Design Principles

Define **WHY** your system exists:

```
Example Design Principles:

1. Clarity First
   Every design decision should make products clearer.
   Reduce cognitive load. Make it obvious.

2. Accessibility Built-In
   Inclusive by default. Accessible for everyone.
   WCAG AA minimum, strive for AAA.

3. Consistency
   Predictable patterns. Familiar interactions.
   Users can anticipate behavior.

4. Simplicity
   Remove unnecessary elements. Minimal = better.
   Don't over-engineer solutions.

5. Performance
   Fast and responsive. Respect user's time.
   Optimize before shipping.
```

### Design Tokens

**Semantic naming** (not color values)

```
❌ Bad (color values):
color-blue-500: #3B82F6
color-red-600: #DC2626

✅ Good (semantic):
color-primary: #3B82F6
color-danger: #DC2626
color-success: #10B981

✅ Better (with hierarchy):
color-interactive-primary: #3B82F6
color-interactive-danger: #DC2626
color-status-success: #10B981
color-status-warning: #F59E0B
color-text-primary: #111827
color-text-secondary: #6B7280
color-surface-background: #FFFFFF
color-surface-overlay: #F3F4F6
```

---

## Design System Architecture

### Simple System (Early Stage)

```
Colors + Typography + Spacing
    ↓
5-10 Core Components (Button, Input, Card, etc.)
    ↓
Basic Documentation
    ↓
Ready for small teams
```

### Mature System (Established)

```
Design Tokens (Colors, Typography, Spacing, Shadows)
    ↓
Components (Primitives: Button, Input, Label)
    ↓
Patterns (Composites: Form, Card, Modal)
    ↓
Layouts (Templates: Page layouts)
    ↓
Documentation (Guide, Figma, Code examples)
    ↓
Governance (Review process, versioning)
    ↓
Ready for large teams / multiple products
```

### Enterprise System (Advanced)

```
Base Design System
    ├─ Brand-agnostic tokens
    ├─ Accessible components
    └─ Flexible patterns

Theme Layers
    ├─ Brand A theme (colors, logo, tone)
    ├─ Brand B theme (different colors, tone)
    └─ Dark mode (all components)

Platform Variations
    ├─ Web version (desktop-optimized)
    ├─ Mobile version (touch-optimized)
    └─ Responsive (adapts to all sizes)

Multi-package Structure
    ├─ @company/design-tokens (CSS, JSON)
    ├─ @company/react-components (React library)
    ├─ @company/icons (SVG icon library)
    └─ @company/design-documentation (docs site)

Ready for enterprise / multiple teams / multiple brands
```

---

## Component Library Standards

### Component Checklist

✅ **Visual**

- All variants designed
- All states (default, hover, focus, active, disabled)
- Responsive design
- Dark mode support
- Accessible colors

✅ **Documentation**

- Purpose documented
- Usage examples
- Do's and don'ts
- Figma link
- Code examples

✅ **Accessibility**

- WCAG AA compliant
- Keyboard navigable
- Screen reader friendly
- Focus indicators visible
- Color contrast >= 4.5:1

✅ **Code**

- TypeScript types
- Props documented
- Accessible HTML
- Responsive CSS
- Performance optimized

✅ **Testing**

- Unit tests
- Integration tests
- Accessibility tests
- Visual regression tests

---

## Design Tokens Export Formats

### CSS Variables

```css
:root {
  --color-primary: #3b82f6;
  --color-secondary: #6b7280;
  --spacing-xs: 4px;
  --spacing-sm: 8px;
  --font-size-base: 16px;
}

/* Usage in components */
.button {
  background-color: var(--color-primary);
  padding: var(--spacing-md);
  font-size: var(--font-size-base);
}
```

### JavaScript/JSON

```json
{
  "color": {
    "primary": "#3B82F6",
    "secondary": "#6B7280"
  },
  "spacing": {
    "xs": "4px",
    "sm": "8px"
  },
  "typography": {
    "fontSize": {
      "base": "16px",
      "lg": "18px"
    }
  }
}
```

### Figma Variables

```
Variables panel → Create variable
- Name: color/primary
- Type: Color
- Value: #3B82F6

Apply to components:
Button background: color/primary
→ All instances update when variable changes
```

---

## Documentation Standards

### Component Documentation Template

````markdown
# Button

## Overview

The Button component is used for triggering actions.
Use for primary actions, secondary options, or destructive actions.

## Variants

- **Primary:** Main call-to-action (high contrast)
- **Secondary:** Alternative action (lower contrast)
- **Danger:** Destructive action (red, warning)
- **Ghost:** Minimal style (transparent, text only)

## Sizes

- **Small:** 32px height (compact spaces)
- **Medium:** 40px height (default)
- **Large:** 48px height (hero actions)

## States

- **Default:** Normal appearance
- **Hover:** Darker color, elevated shadow
- **Focus:** 2px outline, 2px offset
- **Active:** Darker color (pressed appearance)
- **Disabled:** 50% opacity, cursor not-allowed
- **Loading:** Spinner icon, text hidden

## Accessibility

- **Semantic HTML:** `<button>` element
- **Label:** Text label (avoid icon-only if possible)
- **Keyboard:** Enter/Space to activate
- **Focus:** Visible outline required
- **Screen reader:** Label announced

## Responsive

- **Mobile:** Full width or 44px minimum
- **Tablet:** Inline with others (44px minimum touch target)
- **Desktop:** Inline with others

## Usage Examples

### Do's ✅

- Use button for actions (submit, save, delete)
- Use short, action-oriented labels
- Provide visual feedback on hover/focus
- Ensure adequate touch targets (44x44px)

### Don'ts ❌

- Don't use buttons for navigation (use links)
- Don't disable submit button (show loading instead)
- Don't use button styles for links
- Don't rely on color alone for meaning

## Code Example

React:

```jsx
import Button from '@company/button';

<Button variant="primary" size="medium" onClick={handleClick}>
  Save Changes
</Button>

<Button variant="danger" disabled>
  Delete
</Button>
```
````

## Figma Component

[Link to Figma library]

## Related Components

- Link (for navigation)
- IconButton (icon-only button)

```

---

## Design System Governance

### Review Process

```

New Component Proposal
↓
Design Review (meets system standards?)
↓
Accessibility Review (WCAG AA compliant?)
↓
Frontend Review (implementable? performant?)
↓
Documentation Review (complete? clear?)
↓
Approval & Publishing
↓
Version released in library

```

### Versioning

```

MAJOR.MINOR.PATCH

v1.0.0
├─ MAJOR: Breaking changes (components removed)
├─ MINOR: New features (new components, new variants)
└─ PATCH: Bug fixes (fixes, documentation)

Examples:
v1.0.0 → Initial release
v1.1.0 → Added new Button variants (MINOR)
v1.1.1 → Fixed Button focus state (PATCH)
v2.0.0 → Removed old components (MAJOR)

```

### Deprecation Policy

```

Timeline for component deprecation:

Announcement (v1.5.0)
"Component X is deprecated. Migrate to component Y."

Grace Period (3 months)
Continues to work, but marked as deprecated
Documentation shows migration path

Removal (v2.0.0)
Component removed entirely
Teams must have migrated by now

```

---

## Multi-Brand Design Systems

### Brand Theming Layer

```

Base System (Neutral)
├─ Semantic tokens (color-primary, not color-blue)
├─ Accessible components
└─ Flexible patterns

Brand A Theme
├─ color-primary: #0066CC (Brand A blue)
├─ Font: Brand A custom font
├─ Logo: Brand A logo
└─ Tone: Formal, professional

Brand B Theme
├─ color-primary: #FF6B00 (Brand B orange)
├─ Font: Brand B custom font
├─ Logo: Brand B logo
└─ Tone: Casual, friendly

Result:
Same components, different brands
Different colors, same structure
Reusable patterns, customizable appearance

```

---

## Design System Tools

### Documentation Sites
- **Storybook** (component showcase with stories)
- **Zeroheight** (auto-generated from Figma)
- **Supernova** (design system platform)
- **Notion** (simple, collaborative)

### Design Token Management
- **Token Studio** (Figma plugin)
- **Style Dictionary** (open-source token processor)
- **Supernova** (integrated platform)
- **Figma Variables** (native Figma solution)

### Component Libraries
- **Storybook** (React, Vue, Angular)
- **GitHub Pages** (free hosting)
- **npm** (publish as package)
- **Turborepo** (monorepo management)

---

## Measuring Design System Success

### Metrics

```

Adoption

- % of product using system components
- # of teams using system
- Growth rate month-over-month

Quality

- Bug reports per component
- Accessibility violations found
- Design-code consistency score

Efficiency

- Time to build new features (should decrease)
- Time to redesign (should decrease)
- Number of duplicate components (should decrease)

Maintenance

- Time to update entire system (should decrease)
- # of breaking changes (should decrease)
- Team satisfaction with system (should increase)

```

---

## Best Practices

✅ **Start small** (5-10 core components)
✅ **Build on success** (add components gradually)
✅ **Document thoroughly** (guide, examples, gotchas)
✅ **Review strictly** (maintain quality)
✅ **Version wisely** (clear versioning strategy)
✅ **Support users** (help teams adopt)
✅ **Iterate constantly** (systems evolve)
✅ **Measure impact** (show value)
✅ **Governance light** (rules, not bureaucracy)
✅ **Accessibility first** (built-in, not added)

---

## Anti-Patterns

❌ **Too rigid** (no flexibility for teams)
❌ **Too loose** (no consistency, chaos)
❌ **Over-engineered** (components do too much)
❌ **Poor documentation** (hard to use)
❌ **No deprecation policy** (confusion, tech debt)
❌ **One-size-fits-all** (doesn't fit different brands/platforms)
❌ **No maintenance plan** (system rots over time)
❌ **Forced adoption** (teams build workarounds)
❌ **Design-code mismatch** (confusion, frustration)
❌ **No governance** (chaos in library)

---

## Getting Started with Design Systems

### Phase 1: Foundation (Month 1-2)
```

✓ Define design principles
✓ Create color palette
✓ Set typography scale
✓ Create spacing scale
✓ Design 5 core components (Button, Input, Card, etc.)
→ Ready for internal use

```

### Phase 2: Growth (Month 3-6)
```

✓ Add 10+ more components
✓ Create pattern library
✓ Document usage examples
✓ Get team feedback
✓ Build Figma library
→ Ready for team adoption

```

### Phase 3: Maturity (Month 6-12)
```

✓ 25+ components
✓ Comprehensive documentation
✓ Figma + Code aligned
✓ Design tokens exported
✓ Regular updates and maintenance
→ Production-ready design system

```

### Phase 4: Scale (Year 2+)
```

✓ 50+ components
✓ Multi-brand theming
✓ Advanced tokens
✓ Automated testing
✓ Governance established
✓ Team dedicated to maintenance
→ Enterprise-grade system

```

---

## Resources

- **Design System Handbook:** https://www.designsystems.com/
- **Storybook:** https://storybook.js.org/
- **Zeroheight:** https://www.zeroheight.com/
- **Supernova:** https://www.supernova.io/
- **A11y Project:** https://www.a11yproject.com/
```
