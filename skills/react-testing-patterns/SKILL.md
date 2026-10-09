---
name: react-testing-patterns
description: Jest/Vitest + React Testing Library patterns, mocking, avoiding implementation-detail tests. Use ONLY when testing a React frontend.
---

# Testing Patterns

> Long sections live in `reference/`. Read only the ones the current task needs (Read tool, path relative to this skill's folder).

## Core Principle

**Test behavior, not implementation. Users don't care how your component works internally—they care what it does.**

---

## 1. Jest & React Testing Library Setup
→ `reference/02-1-jest-react-testing-library-setup.md`: covers: Basic Installation, Jest Config (jest.config.js), Setup File (setupTests.ts)

## 2. Unit Testing: Testing Components in Isolation
→ `reference/03-2-unit-testing-testing-components-in-iso.md`: covers: ❌ Anti-pattern: Testing Implementation, ✅ Behavior-Driven Testing, Query Priority (Use in this order)

## 3. Testing Props & State Changes
→ `reference/04-3-testing-props-state-changes.md`: covers: Input Component Test

## 4. Integration Testing: Testing Behavior Across Components
→ `reference/05-4-integration-testing-testing-behavior-a.md`: covers: Form Integration Test

## 5. Mocking Strategies
→ `reference/06-5-mocking-strategies.md`: covers: Mocking Child Components, Mocking API Calls, Mocking Modules

## 6. Testing Hooks
→ `reference/07-6-testing-hooks.md`: covers: Custom Hook Test, Hook with Dependencies

## 7. Async Testing
→ `reference/08-7-async-testing.md`: covers: Using waitFor, Using findBy Queries, Avoiding waitFor Mistakes

## 8. Common Patterns
→ `reference/09-8-common-patterns.md`: covers: Test User Interactions, Test Conditional Rendering, Test Error Handling

## Best Practices
→ `reference/10-best-practices.md`: ✅ Test user behavior, not implementation

## Coverage Goals

| Type       | Recommendation |
| ---------- | -------------- |
| Statements | 80%+           |
| Branches   | 75%+           |
| Functions  | 80%+           |
| Lines      | 80%+           |

(100% coverage is overkill and wastes time on low-value tests)
