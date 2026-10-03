# Code patterns: frontend

Framework-neutral names first; the React / Vue / Svelte / Angular idiom follows in brackets. Use the idiom the repo already uses.

## Smell → pattern
| Smell | Pattern | Not when |
|---|---|---|
| The same fetch/loading/error or subscribe/unsubscribe logic in 3+ components | **Extract stateful logic** (React custom hook, Vue composable, Svelte store/action, Angular service) | 2 components, or the logic is one line |
| A component both fetches data and renders a complex view, and is hard to test | **Container / presentational split**: one part gets the data, one only renders props | Small components; hooks already keep it readable |
| A component takes 8+ props, or boolean props like `isCompact`, `hasIcon`, `showHeader` keep growing | **Composition**: children/slots, or compound components (`<Tabs><Tabs.Tab/>`) | The props are genuinely independent settings |
| The same prop passed through 3+ layers that don't use it | **Context / provide-inject**, or move the state closer to where it's used | 1–2 layers |
| Several related pieces of state updated together, with rules between them | **Reducer** (`useReducer`, a store module) or a **state machine** for flows (wizard, checkout, upload) | Independent values: plain state is fine |
| Server data copied into local state, then kept in sync by hand | **Server-state cache** (the repo's data library: TanStack Query, SWR, RTK Query, Apollo) as the single source | There's no server data |
| Components call `fetch` with URLs and headers inline | **API client module** (one place for the base URL, auth header, errors; see `frontend-api-integration`) | Single call in a prototype |
| Rendering differs by `type` or `variant` in a big conditional | **Component map** (`{ [type]: Component }`) | 2–3 variants that read clearly inline |
| Form logic (values, validation, submit, errors) repeated per form | The repo's form library, with **one schema** for validation (reused on the backend when possible) | One tiny form |
| Magic numbers and colors scattered in styles | **Design tokens / theme** (already set by DESIGN.md or the UI library) | Never "not when": always use tokens |

## Architecture patterns
The names follow patterns.dev (https://www.patterns.dev, CC BY-NC 4.0). The summaries are original, and the links lead to the full article. For the classic GoF patterns, grep `catalog.md`.

| Pattern | Use when (smell) | Not when | Link |
|---|---|---|---|
| Hooks / composables | Stateful logic repeated in 3+ components | One user | patterns.dev/react/hooks-pattern |
| Container / presentational | Data loading and complex rendering are tangled together, and the view needs isolated tests or stories | A hook already keeps it readable | patterns.dev/react/presentational-container-pattern |
| Compound components | One component grows a boolean or config prop for every layout variation | The props are independent settings | patterns.dev/react/compound-pattern |
| Provider | A value prop-drilled through 3+ layers that don't use it | 1–2 layers, or state only one screen uses | patterns.dev/vanilla/provider-pattern |
| Render props | The caller must control rendering while you own the behavior | Hooks can do it (prefer hooks) | patterns.dev/react/render-props-pattern |
| Higher-order component | Legacy code wrapping many components with the same cross-cutting behavior | New code: use a hook | patterns.dev/react/hoc-pattern |
| Rendering choice (CSR / SSR / static / streaming / server components) | A measured SEO, first-load or data-freshness need | The framework default already meets the need | patterns.dev/react (rendering section) |

Performance patterns (bundle splitting, dynamic import, list virtualization) are in patterns.dev/vanilla. Use them only after measuring.

## Structure
- `features/<name>/` holds that feature's components, hooks, API calls and types. `components/ui/` (or the repo's equivalent) holds only generic, feature-free building blocks.
- A component file exports one main component. Helpers used only by it stay in the same file until a second user appears.
- Data flows down (props), events flow up (callbacks/emits). Two-way sync between siblings means the state belongs in their parent or a store.

## Anti-patterns
- `useEffect` / watchers that copy one piece of state into another (derive it while rendering instead)
- A global store for state only one screen uses
- A "shared" component with a flag for each screen that uses it
- Wrapping every library component in your own component "in case we switch libraries"
