---
description: "Flow: switch a feature's Dev team between split (frontend-dev + backend-dev) and fullstack (one fullstack-dev) - works for /flow and /quick features"
argument-hint: "<split|fullstack> [feature]"
---

Arguments: $ARGUMENTS

Bookkeeping: don't call an agent.

1. Resolve the feature folder in `docs/features/` (the named one, or the only/newest one with `PROJECT_CONTEXT.md` or `PLAN.md`); ask if several fit. Missing or invalid value → show the current setting and the two options:
   - **split**: frontend-dev + backend-dev, in parallel. Best for large features with clearly separate UI and API work.
   - **fullstack**: one fullstack-dev (higher model) builds both sides in one context. Fewer handoffs; best for small and medium features.
2. Set `Dev team: <value>` in Flow State (`PROJECT_CONTEXT.md`) or in the `PLAN.md` header, and append to `activity.log` (or PLAN.md's Log): `<timestamp> | orchestrator | dev team → <value>`.
3. Confirm in one line. Tasks keep their F#/B# IDs and the API contract is unchanged, so switching mid-feature is safe: the next build round just goes to the new team. Tasks already 🔄 In Progress stay with whoever started them; note any in your reply.
