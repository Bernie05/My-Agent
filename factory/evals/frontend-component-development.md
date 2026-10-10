### C1: Data list component
Prompt: Write a React + TypeScript component `ProjectList` that fetches `/api/v1/projects` and renders their names.
Checks:
- Handles loading, empty, error and success states explicitly
- Props or returned data are typed (no `any` for the project shape)
- Error state shows a user-readable message and a retry option, not a raw error object
- Cleans up or cancels the in-flight request on unmount (AbortController or the data library's equivalent)

### C2: Form
Prompt: Write a React + TypeScript form to create a project with a required `name` (max 80 chars).
Checks:
- Input has a visible `<label>` associated with it
- Submit is disabled while submitting
- Field error is shown next to the field and linked with `aria-describedby`
- Validates required and max length on the client
- Keeps the user's input when the server returns an error
