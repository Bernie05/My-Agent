---
name: react-best-practices
description: React fundamentals - hooks, component structure, rendering performance. Use ONLY when the project's stack is React (per SPEC.md Tech Stack or package.json).
---

# React Best Practices

## Core Principles

> Long sections live in `reference/`. Read only the ones the current task needs (Read tool, path relative to this skill's folder).

### 1. Functional Components as Default
→ `reference/01-1-functional-components-as-default.md`: Always use functional components + hooks (class components are legacy)

### 2. Custom Hooks for Logic Reuse
→ `reference/02-2-custom-hooks-for-logic-reuse.md`: Extract complex logic into custom hooks instead of higher-order components or render props.

### 3. Performance Optimization
→ `reference/03-3-performance-optimization.md`: Use when passing callbacks to optimized child components (to prevent unnecessary re-renders).

### 4. Key Prop Strategy
→ `reference/04-4-key-prop-strategy.md`: The key prop tells React which items have changed, been added, or removed.

### 5. Dependency Arrays
→ `reference/05-5-dependency-arrays.md`: Always think carefully about dependencies in hooks.

### 6. Separation of Concerns: Smart vs. Presentational
→ `reference/06-6-separation-of-concerns-smart-vs-presen.md`: Smart (Container): Handles state, side effects, business logic

### 7. Error Boundaries
→ `reference/07-7-error-boundaries.md`: Catch errors in component trees and display fallback UI.
