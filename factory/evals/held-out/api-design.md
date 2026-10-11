# api-design (held-out)

Grader-only cases: the factory never reads this folder, so a skill can't be tuned to pass them.

### C3: Endpoint test list
Prompt: List the tests you would write for `PATCH /api/v1/projects/:id` (rename), which only the project owner may call.
Checks:
- Includes success → 200
- Includes missing/invalid field → 400
- Includes no auth → 401 and another user → 403
- Includes not found → 404
