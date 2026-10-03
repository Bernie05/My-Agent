---
name: issue-reporting
description: Report a QA issue with reproduction steps, expected vs actual, severity, impact, blocking status and evidence into issues.md. Use when a test fails or unexpected behavior is found (/qa:report-issue).
---

# Issue Reporting

Append to `docs/features/<slug>/issues.md`. IDs are sequential: ISSUE-001, ISSUE-002, ...

## Format

```markdown
## ISSUE-###: <short title>
Status: Open | Triaged | In Fix | Ready for Retest | Closed | Deferred | Accepted
Reported: <YYYY-MM-DD> by qa-agent
Category: Functional | Error Handling | Edge Case | Permission | Integration | Performance | Security | Accessibility | Mobile
Severity: CRITICAL | HIGH | MEDIUM | LOW
Scenario: SC-# (step #) | Requirement: R#

Reproduction:
1. <step>
2. <step>
Result: <what happens>

Expected: <per SPEC.md / scenario>
Actual: <observed>
Evidence: <test output, HTTP response, log, screenshot path>
Environment: <browser/OS/device, build/commit, test data>

Impact: <who/what is affected, how often>
Blocking testing: YES (what is blocked) | NO
Workaround: <how> | none
Suggested owner: frontend-dev | backend-dev
```

(Triage fields are added later by the architect — see `issue-triage`.)

## Severity
- **CRITICAL** — data loss/corruption, security breach, feature unusable for everyone, no workaround.
- **HIGH** — core function broken or wrong results; many users affected.
- **MEDIUM** — partially broken, workaround exists.
- **LOW** — cosmetic or minor; no functional impact.

## Rules
- One issue per problem; reproducible steps from a clean state.
- Facts only — describe behavior, not guessed causes (a suspected cause can go in a "Notes" line).
- Search `issues.md` first to avoid duplicates.
