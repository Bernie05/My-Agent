---
name: issue-triage
description: Classify a reported issue against SPEC.md as Valid Bug, New Requirement or Ambiguous, assess impact, and recommend Fix/Defer/Accept. Use when QA reports an issue (/arch:analyze-issue) or when validating whether behavior is a bug.
---

# Issue Triage

## Process
1. **Understand the issue** — what was done, what was expected, what happened. Reproduction steps must be clear; if not, ask QA.
2. **Check the spec** — search SPEC.md (requirements, validation rules, permissions, edge cases, decisions, Q&A log) and scenarios.md. Quote the relevant line.
3. **Categorize**

| Category | Meaning | Action |
|---|---|---|
| ✅ VALID BUG | Behavior is specified; code doesn't match | Fix. Assign to frontend-dev or backend-dev with a precise fix direction |
| 🆕 NEW REQUIREMENT | Behavior isn't in the spec | Ask the user: implement now or defer. If implement → update SPEC.md + CHANGE HISTORY, add a task |
| ❓ AMBIGUOUS | Spec mentions it but is unclear/contradictory | Ask the user to clarify, record the answer in the Q&A log, then re-triage |

4. **Assess impact**
   - Severity (CRITICAL / HIGH / MEDIUM / LOW — see `issue-reporting`)
   - Scenarios/requirements affected
   - Does it block further testing? Is there a workaround?

5. **Recommend** Fix / Defer / Accept (known issue), with owner and rationale.

## Output (update the entry in `issues.md`)

```markdown
Triage: VALID BUG | NEW REQUIREMENT | AMBIGUOUS
Spec reference: SPEC.md > <section> — "<quote>" (or "not specified")
Blocks testing: yes/no
Recommendation: Fix | Defer | Accept
Assign to: frontend-dev | backend-dev | user decision
Fix direction: <what needs to change, where>
```

Never mark something a bug just because it seems wrong — the spec is the reference. Never silently expand scope.
