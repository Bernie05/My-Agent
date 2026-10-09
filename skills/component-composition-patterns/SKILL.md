---
name: component-composition-patterns
description: React composition patterns - compound components, render props, avoiding prop drilling. Use ONLY when the stack is React and a component is getting complex.
---

# Component Composition Patterns

> Long sections live in `reference/`. Read only the ones the current task needs (Read tool, path relative to this skill's folder).

## Core Principle

**Composition > Inheritance**: Build complex UIs by combining small, focused components rather than creating deep inheritance hierarchies.

---

## 1. Compound Components Pattern
→ `reference/02-1-compound-components-pattern.md`: Multiple components work together as a single unit. The parent doesn't need to know about all child internals.

## 2. Controlled vs. Uncontrolled Components
→ `reference/03-2-controlled-vs-uncontrolled-components.md`: Good for: Simple form inputs, fire-and-forget components

## 3. Render Props Pattern
→ `reference/04-3-render-props-pattern.md`: Pass a function as a prop that returns JSX. Component uses it to render content.

## 4. Props Drilling Solution
→ `reference/05-4-props-drilling-solution.md`: Problem: Passing props through many layers just to reach a deep component.

## 5. Higher-Order Component (HOC) Pattern
→ `reference/06-5-higher-order-component-hoc-pattern.md`: Wraps a component to add behavior (less common now, but still useful).

## 6. Slot Pattern (Children as Composable Parts)
→ `reference/07-6-slot-pattern-children-as-composable-pa.md`: Pass multiple chunks of JSX as "slots" to be positioned by a layout component.

## Quick Decision Tree

| Problem                               | Solution                                 |
| ------------------------------------- | ---------------------------------------- |
| Multiple siblings need to share state | Compound components + Context            |
| Props traveling through many layers   | Context API or composition               |
| Simple form input state               | Uncontrolled                             |
| Complex validation/interdependencies  | Controlled                               |
| Need to wrap/enhance components       | Custom hooks (preferred) or HOC          |
| Layout with flexible content          | Slot pattern (children + optional props) |

---

## Best Practices

✅ Compose small, focused components  
✅ Use context for genuinely global state  
✅ Prefer custom hooks over HOCs  
✅ Keep controlled/uncontrolled choice consistent  
✅ Use compound components for related UI units  
✅ Document APIs clearly when nesting is complex  
✅ Avoid prop drilling by moving logic closer to usage
