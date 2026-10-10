---
name: accessibility-design
description: Accessibility-first design (WCAG 2.1 AA, contrast, keyboard navigation, screen readers, focus). Use when designing or auditing UI for accessibility.
---

# Accessibility Design (A11y)

> Long sections live in `reference/`. Read only the ones the current task needs (Read tool, path relative to this skill's folder).

## What is Accessibility?

**A11y = Accessible to everyone, regardless of ability**

- Visual impairment (blind, low vision)
- Hearing impairment (deaf, hard of hearing)
- Motor impairment (can't use mouse, use keyboard/switch)
- Cognitive impairment (dyslexia, ADHD, learning disabilities)
- Temporary impairment (broken arm, eye surgery recovery)
- Situational impairment (bright sunlight, noisy environment)

---

## WCAG Standards
→ `reference/02-wcag-standards.md`: WCAG AA (Standard, Recommended)

## Color Contrast
→ `reference/03-color-contrast.md`: Low contrast = hard to read for people with:

## Keyboard Navigation
→ `reference/04-keyboard-navigation.md`: Motor impairment (can't use mouse)

## Screen Reader Support
→ `reference/05-screen-reader-support.md`: Software that reads page content aloud:

## Motion & Animation
→ `reference/06-motion-animation.md`: Transitions (fade, slide) - Smooth, informative

## Interactive Element Sizing
→ `reference/07-interactive-element-sizing.md`: covers: Minimum Touch Target Size, Spacing Between Interactive Elements

## Form Accessibility
→ `reference/08-form-accessibility.md`: covers: Label Association, Error Messages, Required Field Indicator

## Text & Typography
→ `reference/09-text-typography.md`: Minimum: 14px for body text

## Color Blindness
→ `reference/10-color-blindness.md`: Protanopia (Red-blind): 1% of men

## Content & Language
→ `reference/11-content-language.md`: Use short sentences (< 20 words)

## Testing Checklist
→ `reference/12-testing-checklist.md`: ✅ Chrome DevTools (Accessibility tab)

## Accessibility Audit Template
→ `reference/13-accessibility-audit-template.md`

## Best Practices

✅ **Accessibility from day 1** (not an afterthought)
✅ **Color contrast >= 4.5:1** (minimum AA)
✅ **Keyboard navigation** (all features keyboard accessible)
✅ **Semantic HTML** (structure means something)
✅ **Focus indicators** (visible and clear)
✅ **Alt text for images** (describe purpose)
✅ **Form labels** (associated with inputs)
✅ **Touch targets >= 44x44px** (on mobile)
✅ **Respect prefers-reduced-motion** (animations optional)
✅ **Test with screen readers** (not just automated tools)

---

## Resources

- **WCAG 2.1:** https://www.w3.org/WAI/WCAG21/quickref/
- **WebAIM:** https://webaim.org/
- **Deque:** https://www.deque.com/
- **A11y Project:** https://www.a11yproject.com/
