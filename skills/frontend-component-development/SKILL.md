---
name: frontend-component-development
description: Framework-agnostic rules for building UI components and screens - props/inputs, all UI states, validation, error handling, accessibility, performance. Use when implementing frontend tasks (F#) in any stack; pair with the stack-specific skill (e.g. react-best-practices) if one exists.
---

# Frontend Component Development

## Before coding
1. Read the task in `frontend-task.md`, the related requirements in `SPEC.md`, and the API contract in `backend-task.md`.
2. Confirm the stack from SPEC.md → Tech Stack (or the repo). Open 2–3 existing components and copy their conventions: folder layout, naming, styling approach, state library, form library, test style.
3. Reuse existing components/utilities before creating new ones.

## Every component defines
- **Inputs**: props/parameters with types (use the stack's type system: TypeScript, PropTypes, typed templates, etc.).
- **Outputs**: events/callbacks emitted.
- **All states**: initial, loading, empty, success, error, disabled. Missing states are the most common UI bug.
- **Validation**: the exact rules from SPEC.md, mirrored on the client; the server stays the authority.
- **Error handling**: user-readable message, keep the user's input, offer retry where it makes sense. Never show raw stack traces.

## Structure
- One responsibility per component; split when a file mixes data fetching, business logic and layout.
- Keep data fetching in a service/API layer or hooks/composables, not scattered in markup.
- Derive values instead of duplicating state.
- Clean up on unmount/destroy: subscriptions, timers, in-flight requests.

## Forms
- Controlled/bound inputs with visible labels.
- Disable submit while submitting (prevents double-submit).
- Show field-level errors next to the field and linked to it (`aria-describedby`).
- On success: clear or navigate as the spec says, and confirm to the user.

## Accessibility (WCAG 2.1 AA minimum)
- Semantic elements (`button`, `label`, `nav`, `main`, headings in order).
- Everything reachable and operable by keyboard; visible focus; logical tab order.
- Text contrast ≥ 4.5:1; color is never the only indicator.
- Images have alt text; icons-only buttons have accessible names.
- Move focus sensibly on dialogs and route changes.

## Performance
- Avoid unnecessary re-renders/re-computation (memoize only where measured).
- Paginate or virtualize long lists.
- Lazy-load heavy routes, images and components.
- Targets unless SPEC.md says otherwise: first render < 1s, interaction response < 100ms.

## Done when
- [ ] All acceptance criteria in the task pass
- [ ] All UI states implemented
- [ ] Validation and errors match SPEC.md
- [ ] Keyboard + screen-reader basics work
- [ ] Tests written (see `frontend-testing`) and passing
- [ ] Task status updated in `frontend-task.md` and `PROJECT_CONTEXT.md`
