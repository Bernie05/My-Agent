# task-breakdown (held-out)

Grader-only cases: the factory never reads this folder, so a skill can't be tuned to pass them.

### C2: Granularity
Prompt: A teammate wrote one task: "B1: Build the whole billing system (Stripe, invoices, emails, admin page)". Fix it.
Checks:
- Splits it into several tasks by entity, endpoint or screen
- Each resulting task is described as roughly half a day to 2 days
- Keeps dependencies between the new tasks explicit
