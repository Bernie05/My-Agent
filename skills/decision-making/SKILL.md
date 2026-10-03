---
name: decision-making
description: Make and record architectural/product decisions by comparing options, tradeoffs and risks. Use when a design choice has more than one reasonable answer (e.g. soft vs hard delete, sync vs async, library choice).
---

# Decision Making

## Process
1. **Define the problem** — what must be decided, why now, what it affects.
2. **List options** — at least two real ones (including "do nothing" when relevant).
3. **Analyze each** — pros, cons, risks, effort, reversibility.
4. **Weigh tradeoffs** — complexity vs capability, time vs quality, scope vs deadline, risk vs simplicity. Prefer reversible, simpler options when close.
5. **Decide or escalate** — decide technical questions; escalate product/business questions to the user with a recommendation.

## Record (append to SPEC.md → Decisions)

```markdown
### D-<n>: <Title>  (<YYYY-MM-DD>)
Problem: <what needed deciding>
Options: A) ... B) ... C) ...
Chosen: <option>
Reasoning: <why>
Tradeoffs: <what we give up>
Risks: <what could go wrong + mitigation>
Impact: <tasks affected, schedule impact>
Decided by: <architect | user>
```

If the decision changes requirements, also add a CHANGE HISTORY entry and update the affected tasks.
