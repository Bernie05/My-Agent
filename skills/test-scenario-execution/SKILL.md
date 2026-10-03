---
name: test-scenario-execution
description: Execute a test scenario step by step, recording expected vs actual and pass/fail with evidence. Use when QA runs a scenario from scenarios.md (/qa:test-scenario) or verifies a fix.
---

# Test Scenario Execution

Scenarios come from `scenarios.md` (format defined in `scenario-validation`). Execute against the real running app or the automated test suite — never mark PASS without evidence.

## How to execute
1. Set up preconditions (seed data, user role, logged-in state). Record them.
2. Perform each step exactly as written.
3. Record the **actual** result with evidence: test output, HTTP status + body, DB query result, log line, or screenshot path.
4. Compare with expected. Any difference = FAIL for that step.
5. On FAIL: stop the scenario unless later steps are independent; report the issue (`issue-reporting`).
6. Prefer turning a scenario into an automated test so it can be re-run after fixes.

## Result format (append to `qa-task.md` → Results)

```
### SC-<n>: <Name>   Category: <one of the 9>   Run: <YYYY-MM-DD HH:MM>
Preconditions: ...

STEP 1: <action>
  Expected: <...>
  Actual:   <...>
  Evidence: <command/output/screenshot>
  Status:   ✅ PASS | ❌ FAIL

Result: ✅ PASS | ❌ FAIL  (issues: ISSUE-###)
Notes: <observations, flakiness, environment>
```

## Checklist
- [ ] Preconditions recorded
- [ ] Every step has expected, actual and evidence
- [ ] Failures linked to an ISSUE-### in `issues.md`
- [ ] Re-test after fix recorded as a new run (don't overwrite history)
