# Harden

From Impeccable (Apache-2.0, Paul Bakaus), condensed. Designs that only work with perfect data aren't production-ready.

## Inputs to throw at it
- **Text:** 100+ character names, a single character, empty, emoji, accents, RTL (Arabic, Hebrew), CJK
- **Numbers:** millions and billions, negatives, zero, long decimals; locale formats (1,000 vs 1.000), currency symbols, dates and time zones
- **Volume:** 0 items, 1 item, 1000+ items, 50+ options in a select
- **Translation:** German runs ~30% longer; nothing may clip or overlap

## Failure paths
- Network: offline, slow (throttled), timeout. Show progress, keep input, offer retry.
- API errors 400 / 401 / 403 / 404 / 409 / 429 / 500 each get a specific, human message and a way forward. Never lose what the user typed.
- Validation: inline, next to the field, after the user leaves it or submits; announce errors to screen readers.
- Permissions: hide or disable with an explanation, never a dead button.
- Concurrency: double-submit (disable during the request or make it idempotent), stale data after another tab edits, optimistic updates that roll back cleanly.

## Layout resilience
- Long text truncates with a tooltip or full view, or wraps; `min-width: 0` on flex children, `overflow-wrap: anywhere` for URLs and tokens.
- Images: fixed aspect ratio, fallback for broken sources, no layout shift.
- Layouts survive 200% zoom and larger system fonts; logical properties (`margin-inline-start`) so RTL works.

## Accessibility resilience
Focus is managed after route changes, modal open/close and item deletion; nothing is conveyed by color alone; errors and live updates reach screen readers (`aria-live`); every action works by keyboard.

## Performance resilience
Long lists virtualize or paginate; search and resize handlers debounce; heavy work leaves the main thread; skeletons match the final layout.

## Verify
Try each input above, force each error state (DevTools network throttling and request blocking, or mocked responses), click submit 10 times fast, interrupt gestures (second finger mid-drag, release outside, switch window), empty all data. Record what was tested and what wasn't.
