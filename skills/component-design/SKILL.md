---
name: component-design
description: Designing reusable UI components - structure, variants, states, specs for handoff. Use when specifying a new component or its variants before it is built.
---

# Component Design

## Component Structure

### Anatomy of a Component

Every component has these layers:

```
Component (Button)
├── Container (outer wrapper)
├── Content (text, icon, slots)
├── State (default, hover, active, disabled)
├── Variant (primary, secondary, danger)
├── Size (small, medium, large)
├── Responsive (mobile, tablet, desktop)
└── Accessibility (ARIA, semantic HTML, keyboard)
```

---

## Component Variants

### What Are Variants?

**Variants = Different versions of the same component that serve different purposes**

Example: Button component

```
Primary Variant → Main call-to-action (high contrast)
Secondary Variant → Alternative action (lower contrast)
Danger Variant → Destructive action (red warning)
```

### How to Define Variants

1. **Identify the purpose** - What is this variant for?
2. **Visual difference** - How does it look different?
3. **Behavior difference** - Does it interact differently?
4. **Use case** - When would you use this?

### Button Example

| Variant   | Purpose           | Color        | When to Use       |
| --------- | ----------------- | ------------ | ----------------- |
| Primary   | Main action       | Blue         | Primary CTA       |
| Secondary | Alternative       | Gray outline | Secondary action  |
| Tertiary  | Additional option | Text only    | Extra options     |
| Danger    | Destructive       | Red          | Delete, remove    |
| Success   | Completed action  | Green        | Confirmation      |
| Ghost     | Minimal style     | Transparent  | Space-constrained |

---

## Component States

### Every Component Has Multiple States

1. **Default** - Normal, uninteracted
2. **Hover** - Mouse over (desktop)
3. **Focus** - Keyboard focus (tab key)
4. **Active** - Currently selected/pressed
5. **Disabled** - Cannot interact
6. **Loading** - Async operation in progress
7. **Error** - Invalid state
8. **Success** - Positive confirmation

### Example: Text Input States

```
Default:
┌─────────────────────┐
│ Enter your name...  │
└─────────────────────┘

Focus (outline visible):
┌─────────────────────┐ ← Blue outline
│ Enter your name...  │
└─────────────────────┘

Disabled (low opacity, cursor not-allowed):
┌─────────────────────┐
│ Enter your name...  │ (50% opacity)
└─────────────────────┘

Error (red border, error message):
┌─────────────────────┐ ← Red border
│ Enter your name...  │
└─────────────────────┘
⚠ This field is required

Loading (spinner):
┌─────────────────────┐
│ [⟳] Saving...      │
└─────────────────────┘

Success (green checkmark):
✓ Name saved successfully
```

---

## Component Sizing

### Size Strategy

Create a scale, not arbitrary sizes:

**Button Heights:**

- Small: 32px (tight spaces, inline)
- Medium: 40px (default, most common)
- Large: 48px (hero actions, mobile)

**Reasoning:**

- Consistent scaling factor (1.25x)
- Touch target minimum: 44x44px
- Hierarchy through size

### Responsive Sizing

```
Mobile (< 768px):
- Use larger sizes (Medium/Large)
- Touch-friendly spacing

Tablet (768px - 1024px):
- Mixed sizes based on layout

Desktop (> 1024px):
- Can use smaller sizes
- More compact layouts
```

---

## Component Specifications

### What to Specify

1. **Visual Design**
   - Dimensions (width, height, padding)
   - Colors (with tokens)
   - Typography (size, weight, line height)
   - Border radius, shadows, effects

2. **Behavior**
   - States (hover, focus, active, disabled)
   - Animations (fade, slide, none)
   - Interactions (click, drag, keyboard)

3. **Responsive**
   - Mobile layout
   - Tablet layout
   - Desktop layout

4. **Accessibility**
   - ARIA labels needed
   - Keyboard support
   - Focus indicators
   - Color contrast

5. **Content**
   - Max/min dimensions
   - Text overflow handling
   - Icon specifications
   - Slot requirements

### Example Button Specification

```
BUTTON COMPONENT

Visual Design:
- Height: 40px (medium)
- Padding: 12px 24px
- Border radius: 6px
- Font: 14px, weight 600
- Icon size: 18px (if included)

Colors (via tokens):
- Primary variant: --color-primary (blue)
- Secondary variant: --color-gray-200 (light gray)
- Text color: --color-white / --color-gray-900
- Hover: 10% darker
- Active: 15% darker
- Disabled: 50% opacity

States:
- Default: Solid color, no shadow
- Hover: 10% darker + shadow elevation 2
- Focus: 2px outline with 2px offset
- Active: 15% darker
- Disabled: 50% opacity, cursor not-allowed
- Loading: Icon spinner, text hidden

Responsive:
- Mobile (< 768px): Full width or Min width 44px
- Desktop: Inline with padding

Accessibility:
- Semantic: <button> element
- Label: aria-label if icon-only
- Focus: Visible focus indicator
- Keyboard: Enter/Space to activate
- Disabled: aria-disabled="true"

Content:
- Min width: 80px (text) / 44px (icon only)
- Max width: 100% container
- Icon + text: Icon left, 8px gap
- Icon only: Square (44x44px min)
```

---

## Composition & Variants

### Component Variants in Figma

Structure variants hierarchically:

```
Button
├── Variant: primary
│   ├── Size: small
│   ├── Size: medium
│   └── Size: large
├── Variant: secondary
│   ├── Size: small
│   ├── Size: medium
│   └── Size: large
└── Variant: danger
    ├── Size: small
    ├── Size: medium
    └── Size: large
```

### State Combinations

For each variant + size, show all states:

```
Button (Primary, Medium):
├── Default
├── Hover
├── Focus
├── Active
├── Disabled
├── Loading
└── Error
```

---

## Component Library Organization

### Folder Structure

```
Components
├── Primitives (Atomic)
│   ├── Button
│   ├── Input
│   ├── Label
│   └── Icon
├── Layouts
│   ├── Card
│   ├── Container
│   ├── Grid
│   └── Stack
├── Forms
│   ├── TextField
│   ├── Select
│   ├── Checkbox
│   └── FormGroup
├── Navigation
│   ├── NavBar
│   ├── Sidebar
│   ├── Tabs
│   └── Breadcrumb
├── Feedback
│   ├── Alert
│   ├── Modal
│   ├── Toast
│   └── Tooltip
└── Data Display
    ├── Table
    ├── List
    ├── Badge
    └── Avatar
```

---

## Design System Integration

### Using Design Tokens in Components

```
Color Tokens:
- color-primary: #3B82F6
- color-secondary: #6B7280
- color-danger: #EF4444
- color-success: #10B981
- color-text-primary: #111827
- color-text-secondary: #6B7280

Button using tokens:
- Background: color-primary
- Text: color-white
- Hover: 10% darker
- Disabled: 50% opacity
```

### Documentation Template

```markdown
# Component Name

## Purpose

What is this component for? When should you use it?

## Variants

- Variant A: When to use
- Variant B: When to use

## States

- Default
- Hover
- Focus
- Active
- Disabled
- Loading

## Accessibility

- Semantic HTML: <element>
- ARIA labels: Required?
- Keyboard: Tab, Enter, Escape?
- Screen reader: Works?

## Responsive

- Mobile behavior
- Tablet behavior
- Desktop behavior

## Content Guidelines

- Text length
- Icon usage
- Overflow handling

## Usage Examples

[Figma link]
[Implementation examples]

## Related Components

- Similar components
- Composition patterns
```

---

## Component Checklist

Before finalizing a component design:

### Visual

- ✅ All states visible (default, hover, focus, active, disabled)
- ✅ Responsive (mobile, tablet, desktop)
- ✅ Variants clear (purpose of each)
- ✅ Color contrast >= 4.5:1
- ✅ Touch targets >= 44x44px
- ✅ Consistent with design system

### Interaction

- ✅ Clear hover state
- ✅ Clear focus state
- ✅ Clear active state
- ✅ Disabled state obvious
- ✅ Loading state shows feedback
- ✅ Error state communicates issue

### Accessibility

- ✅ Keyboard navigable
- ✅ Screen reader compatible
- ✅ ARIA labels present
- ✅ Focus indicators visible
- ✅ Color not only indicator
- ✅ WCAG AA compliant minimum

### Documentation

- ✅ Purpose documented
- ✅ States documented
- ✅ Variants explained
- ✅ Usage examples shown
- ✅ Figma link available
- ✅ Accessibility notes clear

---

## Common Component Mistakes

❌ **No disabled state** - How do you show "can't interact"?
❌ **Missing focus indicator** - Keyboard users can't navigate
❌ **Poor color contrast** - Text unreadable
❌ **No hover state** - No feedback to interaction
❌ **Inconsistent sizing** - Components don't align
❌ **No documentation** - Frontend can't implement
❌ **No responsive design** - Breaks on mobile
❌ **Icon without label** - Unclear purpose
❌ **Too many variants** - Maintenance nightmare
❌ **Design-code mismatch** - Frontend rebuilds component

---

## Component Evolution

### Version 1: Basic Component

```
✓ Default state
✓ Hover state
✓ Disabled state
✓ Basic documentation
→ Ready for implementation
```

### Version 2: Enhanced Component

```
✓ All states (hover, focus, active, disabled, loading)
✓ Multiple variants
✓ Responsive design
✓ Accessibility checklist
✓ Figma component library
→ Ready for production
```

### Version 3: Mature Component

```
✓ Advanced states (error, success, loading with progress)
✓ Complex variants + combinations
✓ Comprehensive responsive design
✓ Full accessibility audit (WCAG AAA)
✓ Themed versions (light/dark mode)
✓ Animation specifications
✓ Performance notes
✓ Migration guide (if updated)
→ Enterprise-ready
```

---

## Best Practices

✅ **Start with primitive components** (Button, Input, Label)
✅ **Build up to complex components** (Form, Modal, Table)
✅ **Every component has states** (default, hover, focus, active, disabled)
✅ **Variants serve clear purposes** (not arbitrary variations)
✅ **Responsive by default** (mobile first, then enhance)
✅ **Accessibility built-in** (not added later)
✅ **Document thoroughly** (frontend needs clarity)
✅ **Use design tokens** (not hardcoded values)
✅ **Maintain consistency** (across all components)
✅ **Version and deprecate** (manage evolution gracefully)
