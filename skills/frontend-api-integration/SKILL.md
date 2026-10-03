---
name: frontend-api-integration
description: Connect a frontend to backend APIs in any stack - service layer, typed request/response, loading/error states, caching and invalidation, auth, retries. Use when a frontend task calls an API; for React also see react-data-fetching.
---

# Frontend API Integration

## Contract first
- Use the request/response shapes defined in `backend-task.md` / SPEC.md → API. If the backend isn't ready, build against a mock that matches the contract exactly.
- Type the responses (TS types, schemas, DTOs) — one definition, reused everywhere.

## Service layer
All HTTP calls live in one place (e.g. `services/`, `api/`, `lib/api`), never inline in components.

```
service.listItems(params)  -> GET  /api/v1/items?page=&limit=
service.getItem(id)        -> GET  /api/v1/items/:id
service.createItem(data)   -> POST /api/v1/items
service.updateItem(id, d)  -> PATCH /api/v1/items/:id
service.deleteItem(id)     -> DELETE /api/v1/items/:id
```

Each function: builds the request, sends credentials/auth header, checks the status, parses the body, and throws a typed error with the server's message on failure.

## Configuration
- Base URL from environment config, never hard-coded.
- Never put secrets/API keys in frontend code — they are public.

## States & errors
| Situation | Behavior |
|---|---|
| Loading | Show indicator; disable duplicate actions |
| 400 validation | Map field errors to the form fields |
| 401 | Redirect to login / refresh session |
| 403 | "You don't have permission" message |
| 404 | Not-found state |
| 409 conflict | Explain and offer to reload |
| 5xx / network | Generic friendly message + retry |

- Retry only safe/idempotent requests (GET), with backoff, a few times max.
- Use timeouts; cancel requests when the view is left.

## Caching & freshness
- Use the stack's data-fetching/cache tool if the project has one (TanStack Query, SWR, Apollo, RTK Query, Nuxt/Next data APIs...).
- After a create/update/delete, invalidate or update the affected lists/details so the UI isn't stale.
- Optimistic updates only when the spec allows; always roll back on error.

## Checklist
- [ ] Calls go through the service layer
- [ ] Request/response types match the contract
- [ ] Every status code above is handled
- [ ] Cache invalidated after mutations
- [ ] No secrets in client code; base URL from env
