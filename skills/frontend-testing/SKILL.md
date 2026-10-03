---
name: frontend-testing
description: Test frontend code in any stack - unit, component/integration and E2E tests that check user-visible behavior, with API mocking. Use when writing or improving frontend tests; for React also see react-testing-patterns.
---

# Frontend Testing

## Tooling
Use what the project already has (check the package manifest and existing tests). Only if nothing exists, propose a standard set for the stack in SPEC.md → Tech Stack and ask before adding it.

## What to test (by level)
- **Unit** — pure logic: formatters, validators, calculations, reducers/stores.
- **Component / integration** — render the component, interact like a user, assert what the user sees. Mock the network at the HTTP boundary (e.g. MSW or the framework's equivalent), not internal functions.
- **E2E** — the main happy path + the most important error path per feature, in a real browser (Playwright/Cypress or what the project uses).

## Per component, cover
- [ ] Renders with required inputs
- [ ] Each UI state: loading, empty, error, success, disabled
- [ ] Input and validation messages
- [ ] Submit sends the correct data; prevents double-submit
- [ ] API error shows the right message and keeps user input
- [ ] Keyboard interaction and accessible names (query by role/label, not CSS classes)

## Rules
- Test behavior, not implementation details (no asserting internal state or private methods).
- Query elements the way users find them: role, label, visible text.
- One behavior per test; descriptive names ("shows error when title is empty").
- No real network calls, no dependence on test order, no arbitrary sleeps — wait for UI conditions.
- Map tests to scenarios (SC-#) from `scenarios.md` where possible.

## Done when
- [ ] New code covered at the levels above
- [ ] Full test suite passes locally
- [ ] Test command and results reported back
