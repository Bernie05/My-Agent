---
description: Write or run tests for the current changes or a given target
argument-hint: "[file, folder, or feature — defaults to uncommitted changes]"
---

Target: $ARGUMENTS (if empty, use the files changed in `git diff HEAD` plus untracked files).

1. Detect the test setup from `package.json` (Vitest, Jest, Playwright, etc.) and follow the existing test file location and naming conventions. If no test framework exists, propose one (Vitest for unit/integration, Playwright for E2E) and ask before installing.
2. Delegate to the `test-automator` agent to write missing tests for the target:
   - Unit tests for pure logic and utilities.
   - Integration tests for route handlers, server actions, and data access.
   - E2E tests only for critical user journeys (use the `webapp-testing` skill to explore the running app).
3. Each test name should describe the behavior being verified, not the implementation.
4. Run the tests. If any fail, determine whether the test or the code is wrong — use the `debugger` agent for non-obvious failures. Never weaken an assertion just to make it pass.
5. Report: tests added, pass/fail result, and any risky paths still untested.
