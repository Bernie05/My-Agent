---
name: scenario-validation
description: Write and validate user scenarios (happy path, error, edge, security) in the standard step format, producing scenarios.md. Use when defining how a feature should behave end-to-end or checking that scenarios cover the spec.
---

# Scenario Validation

Scenarios turn SPEC.md requirements into concrete, testable flows. QA executes them later, so every step needs an observable expected result.

## Scenario format (shared by architect and QA)

```
### SC-<n>: <Name>
Type: Happy Path | Error | Edge Case | Security
Covers: R1, R3
Preconditions: <data/users that must exist>

STEP 1: <user action>
  → Frontend: <what the UI shows/changes>
  → Backend: <what is called / what logic runs>
  → Database: <what is read/written>
  └─ Expected: <observable result>

STEP 2: ...

✅ SUCCESS: <final expected outcome>
```

## Scenario types (write at least one of each per main action)
- **Happy Path** — valid input, correct permissions, everything works.
- **Error** — invalid/missing input, server error, network failure; system shows a clear message and the user can recover.
- **Edge Case** — unusual but valid: boundaries, empty lists, very long text, rapid double-clicks, concurrent edits.
- **Security** — unauthorized or wrong-role user, tampered IDs, expired session.

## Validation checklist
- [ ] Every functional requirement (R#) is covered by at least one scenario
- [ ] Every scenario lists the requirements it covers
- [ ] Every step has an observable expected result (no "works correctly")
- [ ] Error scenarios specify the exact message/behavior
- [ ] Permission rules from SPEC.md each have a security scenario
- [ ] Preconditions are reproducible

Gaps found → add them to SPEC.md "Open Questions" instead of guessing.
