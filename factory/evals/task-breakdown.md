### C1: Break down a small feature
Prompt: Spec: users can create projects (name required, unique per user) and see a list of their projects. Stack: Next.js + Postgres. Write the frontend and backend tasks using the task template.
Checks:
- Backend tasks come first and include the data layer (table/migration) before the endpoints
- Every task has Owner, Depends on, Acceptance criteria and Testing
- The API contract (request/response shapes) is defined in a backend task
- The duplicate-name rule appears as validation or an acceptance criterion with a 409/duplicate case
- Tasks are grouped into at least one section (SEC-1)

### C2: Granularity
Prompt: A teammate wrote one task: "B1: Build the whole billing system (Stripe, invoices, emails, admin page)". Fix it.
Checks:
- Splits it into several tasks by entity, endpoint or screen
- Each resulting task is described as roughly half a day to 2 days
- Keeps dependencies between the new tasks explicit
