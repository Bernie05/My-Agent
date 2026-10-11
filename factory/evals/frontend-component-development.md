### C1: Data list component
Prompt: Write a React + TypeScript component `ProjectList` that fetches `/api/v1/projects` and renders their names.
Checks:
- Handles loading, empty, error and success states explicitly
- Props or returned data are typed (no `any` for the project shape)
- Error state shows a user-readable message and a retry option, not a raw error object
- Cleans up or cancels the in-flight request on unmount (AbortController or the data library's equivalent)
