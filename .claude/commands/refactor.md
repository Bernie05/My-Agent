---
description: Refactor code toward clean architecture without changing behavior
argument-hint: <file, folder, or component>
---

Refactor: $ARGUMENTS

Rule zero: **behavior must not change.** Refactoring and feature work never go in the same commit.

1. **Safety net.** Find the tests covering the target. If coverage is thin, use the `test-automator` agent to add characterization tests first and confirm they pass on the current code.
2. **Diagnose.** List the concrete smells you see, each tied to a principle, e.g.:
   - Business logic inside UI components or route handlers (separation of concerns)
   - A module doing several jobs (single responsibility)
   - Direct DB / SDK calls scattered through the app (missing data-access layer / dependency inversion)
   - Duplicated logic, long functions, deep nesting, boolean-prop explosion (see the `vercel-composition-patterns` skill), unclear names, `any` types
3. **Plan — checkpoint.** Propose small, ordered steps, each independently safe. Show me before editing.
4. **Execute** step by step, running tests after each one.
5. **Report** a before/after summary and the principle or pattern behind each change, so I can learn to spot it myself.
