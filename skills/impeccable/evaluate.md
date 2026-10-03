# Evaluate: audit and critique

From Impeccable (Apache-2.0, Paul Bakaus), condensed. The bundled detector is not included: gather evidence by reading the code and, for rendered checks, with the `browser-testing` skill (desktop and mobile in one round).

## Audit (technical, measurable; document, don't fix)
Score each dimension 0-4.

| # | Dimension | Check for |
|---|---|---|
| 1 | **Accessibility** | contrast < 4.5:1; missing roles, labels or states; no focus indicator, bad tab order, keyboard traps; heading hierarchy, landmarks, divs as buttons; alt text; inputs without labels; reduced motion that kills useful feedback, or motion that blocks reading or tasks |
| 2 | **Performance** | layout thrashing; animating layout properties or unbounded blur/shadow; images not lazy-loaded or not sized; `will-change` left on at rest; unused dependencies, heavy imports; needless re-renders |
| 3 | **Responsive** | fixed widths; touch targets < 44×44px; horizontal scroll on narrow screens; layouts that break at larger text sizes; mouse-only drag/slider handlers, no `touch-action`, drag state not cleared on cancel |
| 4 | **Theming** | hard-coded colors instead of tokens; broken or low-contrast dark mode; mixed token types; values that don't update on theme change |
| 5 | **Integrity** | repeated shortcuts, design-system drift, decorative or misleading content, a structure interchangeable with any other product (the `craft-floor.md` Refuse list) |

Scores: 0 fails basics · 1 major gaps · 2 partial · 3 good, minor gaps · 4 excellent.
**Total /20:** 18-20 excellent · 14-17 good · 10-13 acceptable · 6-9 poor · 0-5 critical.

### Severity
- **P0 blocking:** prevents task completion. Fix now.
- **P1 major:** real difficulty or a WCAG AA failure. Fix before release.
- **P2 minor:** annoying, a workaround exists. Next pass.
- **P3 polish:** no real user impact. If time allows. Don't flood the report with P3s.

### Report
1. Score table (dimension · score · key finding) and total with band
2. Integrity verdict first: does this feel like a coherent, product-specific system?
3. Findings by severity: **[P?] name**, location (file:line), category, impact on users, standard violated (if any), fix, and the operation that fixes it (polish, harden, a refine lens, `motion-design`, …)
4. Systemic patterns ("hard-coded colors in 15+ components")
5. What works well and should be kept

## Critique (UX judgment)
Score Nielsen's 10 heuristics 0-4 (4 = genuinely excellent, not "fine"):
1. **Visibility of system status:** loading, confirmation, progress, current location, inline validation
2. **Match with the real world:** the user's language, logical order, recognizable icons
3. **User control and freedom:** undo, cancel, back, clear filters, escape from long flows
4. **Consistency and standards:** same words, same results, platform conventions
5. **Error prevention:** constraints, confirmation for destructive actions, good defaults
6. **Recognition over recall:** visible options, remembered context, examples
7. **Flexibility and efficiency:** shortcuts, bulk actions, sensible defaults for experts
8. **Aesthetic and minimalist design:** only what supports the task; clear hierarchy
9. **Help users recover from errors:** plain-language errors that name the problem and the fix, without losing input
10. **Help and documentation:** contextual hints and empty states that teach

Then:
- **Cognitive load:** count the decisions and the new concepts on the main path; flag walls of equal-weight options, hidden state, and memory demands between screens.
- **Persona walk-through:** walk the primary task as 2-3 realistic users (first-time, expert, one with an access need or on a phone). Note where each hesitates or fails.

Report: heuristic table (score + one-line reason), total /40, the top 3-5 priority issues (P0-P3) with fixes, and what to keep.
