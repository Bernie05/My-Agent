### C1: Design endpoints
Prompt: Design the REST endpoints for "projects" that users can list, create, view, rename and archive. Give method, path and success status for each.
Checks:
- Paths use the plural noun `projects` under a version prefix like `/api/v1/`
- No verbs in paths for CRUD (no `/getProjects`, `/createProject`)
- Create returns 201; delete (if included) returns 204
- Archive is `POST /api/v1/projects/:id/archive` (non-CRUD action), not a PATCH of an arbitrary field without saying so
- List mentions pagination parameters with a capped limit

### C2: Error response
Prompt: The client sent `POST /api/v1/projects` without the required `name` field. Show the exact response (status and JSON body).
Checks:
- Status is 400 (or 422 with a stated project convention)
- Body has an `error` object with a machine-readable `code` and a human `message`
- Field-level detail names `name`
- Leaks no internals (no stack trace, SQL or file paths)

### C3: Endpoint test list
Prompt: List the tests you would write for `PATCH /api/v1/projects/:id` (rename), which only the project owner may call.
Checks:
- Includes success → 200
- Includes missing/invalid field → 400
- Includes no auth → 401 and another user → 403
- Includes not found → 404
