# frontend-component-development (held-out)

Grader-only cases: the factory never reads this folder, so a skill can't be tuned to pass them.

### C2: Form
Prompt: Write a React + TypeScript form to create a project with a required `name` (max 80 chars).
Checks:
- Input has a visible `<label>` associated with it
- Submit is disabled while submitting
- Field error is shown next to the field and linked with `aria-describedby`
- Validates required and max length on the client
- Keeps the user's input when the server returns an error
