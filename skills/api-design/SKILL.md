---
name: api-design
description: Design and implement consistent HTTP/REST APIs in any backend stack - resource URLs, methods, status codes, validation, error format, pagination/filtering, layering. Use when building or reviewing backend endpoints (B#).
---

# API Design

Follow the project's existing API style if one exists; these are the defaults.

## Resources & methods
```
GET    /api/v1/items            list (paginated)
GET    /api/v1/items/:id        get one
POST   /api/v1/items            create          -> 201 + created resource
PATCH  /api/v1/items/:id        partial update  -> 200
PUT    /api/v1/items/:id        full replace    -> 200
DELETE /api/v1/items/:id        delete          -> 204
GET    /api/v1/items/:id/sub    nested resource
```
- Plural nouns, lowercase, kebab-case; no verbs in URLs (`/getItems` ✗).
- Actions that aren't CRUD: `POST /api/v1/items/:id/archive`.
- Version the API (`/api/v1`).

## Status codes
200 OK · 201 Created · 204 No Content · 400 Validation error · 401 Not authenticated · 403 Not allowed · 404 Not found · 409 Conflict/duplicate · 422 Semantic validation (if the project uses it) · 429 Rate limited · 500 Server error

## Response format (pick one per project and keep it)
```json
{ "data": { ... } }
{ "data": [ ... ], "meta": { "page": 1, "limit": 20, "total": 134 } }
{ "error": { "code": "VALIDATION_ERROR", "message": "Title is required", "fields": { "title": "Required" } } }
```
Error messages are helpful to the user but never leak internals (SQL, stack traces, file paths).

## Lists
Pagination `?page=&limit=` (cap `limit`), filtering `?status=active`, sorting `?sort=created_at&order=desc`, search `?q=`. Whitelist allowed sort/filter fields.

## Layering (names follow the stack's conventions)
```
route/controller  -> parse request, call validator, call service, shape response
validator/schema  -> validate + whitelist input (Zod/Joi/Pydantic/FormRequest/...)
service           -> business rules, transactions, permissions
repository/model  -> database access only
middleware        -> auth, rate limiting, logging, error handler
```
One global error handler converts thrown errors into the error format above.

## Every endpoint
- [ ] Authenticated (unless public by spec) and authorized per SPEC.md → Permissions
- [ ] Input validated and unknown fields rejected/stripped
- [ ] Parameterized queries / ORM only
- [ ] Multi-step writes in a transaction
- [ ] Correct status code and consistent body
- [ ] Idempotency / duplicate prevention where the spec needs it
- [ ] Logged (without secrets or personal data)
- [ ] Tests: valid → 2xx, missing/invalid fields → 400, no auth → 401, wrong user → 403, not found → 404, duplicates → 409
- [ ] Documented (OpenAPI or the project's API doc) and matches the contract in `backend-task.md`
