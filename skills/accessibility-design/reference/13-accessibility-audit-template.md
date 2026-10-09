## Accessibility Audit Template

```markdown
# Accessibility Audit Report

## Summary

- WCAG Level Achieved: AA / AAA
- Critical Issues: [count]
- Major Issues: [count]
- Minor Issues: [count]

## Color Contrast

- [ ] Body text >= 4.5:1 (AA)
- [ ] Large text >= 3:1 (AA)
- [ ] Enhanced text >= 7:1 (AAA)
- Failures: [list]

## Keyboard Navigation

- [ ] All interactive elements keyboard accessible
- [ ] Logical tab order
- [ ] Focus indicators visible
- [ ] Escape closes modals
- Issues: [list]

## Semantic HTML

- [ ] Proper heading hierarchy (h1 → h2 → h3)
- [ ] Navigation landmarks (<nav>)
- [ ] Main content landmark (<main>)
- [ ] Form labels (<label for="">)
- [ ] Button elements (not <div> roles)

## Screen Reader

- [ ] Page structure logical
- [ ] Images have alt text
- [ ] Links descriptive
- [ ] Form fields labeled
- [ ] Dynamic content announced

## Content

- [ ] Text is readable (14px minimum)
- [ ] Line height adequate (1.5x minimum)
- [ ] Text not justified
- [ ] Links underlined or styled
- [ ] Motion respects prefers-reduced-motion

## Mobile

- [ ] Touch targets 44x44px minimum
- [ ] Zoom works to 200%
- [ ] No horizontal scroll
- [ ] Text remains readable at zoom

## Recommendations

1. [Priority 1 - Critical]
2. [Priority 2 - Major]
3. [Priority 3 - Minor]
```

---
