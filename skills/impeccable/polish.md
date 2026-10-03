# Polish

From Impeccable (Apache-2.0, Paul Bakaus), condensed. Polish is refinement, never concealed redesign. If the concept is wrong, say so and recommend a redesign or a refine lens instead.

## 1. Establish the system
Read DESIGN.md, the tokens, the shared components and neighboring flows. Classify each drift before fixing it:
- **missing token:** the system needs a reusable value
- **one-off implementation:** a shared component or pattern should replace it
- **conceptual mismatch:** the flow or hierarchy differs from comparable areas
- **local defect:** simply incomplete or inconsistent

Fix at the narrowest correct level. Ask when a system rule can't be inferred.

## 2. Gather evidence
Use the feature yourself at desktop and mobile (`browser-testing`). Establish whether the path works end to end, the quality bar, known deliberate gaps, and the real states, content lengths, roles and input methods users hit.

## 3. Triage, in this order
1. Broken or blocked tasks, data loss, misleading state, inaccessible paths
2. Missing loading, empty, error, success, disabled and permission states
3. Flow, hierarchy, responsive and design-system drift
4. Visual and motion inconsistencies
5. Code and asset cleanup

Don't perfect one corner while the rest stays below the bar.

## 4. Polish the whole path
- **Flow:** match neighbors' mental models, terms, save behavior and disclosure. Make the primary task and current state obvious. Arrival, empty and recovery paths connect.
- **Layout and type:** the project's grid and spacing scale, optical alignment too; same-role type identical; test wrapping, translation length, zoom and font loading at every viewport.
- **Color, images, icons:** semantic tokens with stable meanings across themes; contrast in every state; one icon family, consistent size and stroke; images with aspect ratios (no layout shift) and useful alt text.
- **Interaction:** every control has default, hover, focus, active, disabled, loading, error and success; visible focus, logical tab order, labels, touch targets; motion coherent and interruptible, never added just to look polished.
- **Content and code:** consistent terms, capitalization, punctuation; ask before changing claims. Remove debug output, dead code, unused imports and styles. Use shared components where the system owns the pattern; promote only genuinely reused values to tokens.

## 5. Verify and finish
Walk the path again with mouse, keyboard and touch: mobile, mid and wide layouts; loading, empty, error, success, disabled, long and missing content; zoom, focus, screen-reader names; console errors, layout shift, input latency. Then review your own diff and remove accidental churn. Ship only when the path is complete and finished to one consistent bar.
