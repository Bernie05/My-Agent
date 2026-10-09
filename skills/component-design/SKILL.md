---
name: component-design
description: Designing reusable UI components - structure, variants, states, specs for handoff. Use when specifying a new component or its variants before it is built.
---

# Component Design

> Long sections live in `reference/`. Read only the ones the current task needs (Read tool, path relative to this skill's folder).

## Component Structure
→ `reference/01-component-structure.md`: Every component has these layers:

## Component Variants
→ `reference/02-component-variants.md`: Variants = Different versions of the same component that serve different purposes

## Component States
→ `reference/03-component-states.md`: Default - Normal, uninteracted

## Component Sizing
→ `reference/04-component-sizing.md`: Create a scale, not arbitrary sizes:

## Component Specifications
→ `reference/05-component-specifications.md`: Dimensions (width, height, padding)

## Composition & Variants
→ `reference/06-composition-variants.md`: Structure variants hierarchically:

## Component Library Organization
→ `reference/07-component-library-organization.md`: covers: Folder Structure

## Design System Integration
→ `reference/08-design-system-integration.md`: covers: Using Design Tokens in Components, Documentation Template

## Component Checklist
→ `reference/09-component-checklist.md`: Before finalizing a component design:

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
→ `reference/11-component-evolution.md`: covers: Version 1: Basic Component, Version 2: Enhanced Component, Version 3: Mature Component

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
