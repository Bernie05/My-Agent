---
name: accessibility-design
description: Accessibility-first design (WCAG 2.1 AA, contrast, keyboard navigation, screen readers, focus). Use when designing or auditing UI for accessibility.
---

# Accessibility Design (A11y)

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

### Levels of Compliance

**WCAG AA** (Standard, Recommended)

- 4.5:1 color contrast for normal text
- 3:1 color contrast for large text (18pt+)
- Focus indicators visible
- Keyboard navigation functional

**WCAG AAA** (Enhanced, High standard)

- 7:1 color contrast for all text
- Enhanced keyboard support
- Sign language support
- Extended audio description

**Target: Minimum WCAG AA, strive for AAA**

---

## Color Contrast

### Why Color Contrast Matters

Low contrast = hard to read for people with:

- Color blindness (8% of men, 0.5% of women)
- Low vision
- Using bright displays (outdoor screens)
- Aging eyes

### Contrast Ratios

```
1:1 = No contrast (impossible to read)
3:1 = Large text minimum
4.5:1 = Normal text minimum (WCAG AA) ✅
7:1 = Enhanced (WCAG AAA)
```

### Color Contrast Examples

```
✅ Good (Black #000 on White #FFF = 21:1)
Text: Easily readable

⚠️  Questionable (Gray #777 on White #FFF = 4.48:1)
Text: Barely meets AA, fails AAA

❌ Bad (Gray #888 on White #FFF = 4.14:1)
Text: Hard to read, fails AA

❌ Terrible (Gray #999 on White #FFF = 3.78:1)
Text: Fails accessibility
```

### Testing Color Contrast

**Tools:**

- Chrome DevTools (Inspect element → Color picker)
- WebAIM Contrast Checker
- Deque axe DevTools
- Figma plugins (Able, Color Contrast Analyzer)

### Color Combinations to Avoid

❌ **Don't rely on color alone**

- Red/Green (color blindness: 8% can't distinguish)
- Red/Blue (low vision)
- Light colors on light (no contrast)

✅ **Do combine with:**

- Text labels
- Icons with text
- Patterns or textures
- Symbols

---

## Keyboard Navigation

### Why Keyboard Matters

- Motor impairment (can't use mouse)
- Screen reader users (keyboard only)
- Power users (faster with keyboard)
- Accessibility feature (voice control)

### Keyboard Interaction Standards

| Key        | Action                                  |
| ---------- | --------------------------------------- |
| Tab        | Move forward through focusable elements |
| Shift+Tab  | Move backward                           |
| Enter      | Activate button/link/submit form        |
| Space      | Toggle checkbox/radio/button            |
| Escape     | Close modal/dropdown/popover            |
| Arrow Keys | Navigate menu items, sliders, spinners  |

### Tab Order

```
Correct tab order (left-to-right, top-to-bottom):
1. Header Logo → 2. Nav Menu → 3. Search → 4. Main Content → 5. Sidebar → 6. Footer

Wrong tab order:
1. Footer → 2. Sidebar → 3. Header (confusing, skip around)
```

**Test:** Press Tab repeatedly. Does order make logical sense?

### Focus Management

```
Before Modal Opens:
[Nav] → [Main Content] → [Sidebar]

Modal Opens:
Focus → Modal's first focusable element
Tab within modal only (focus trap)

Modal Closes:
Focus returns to button that opened modal
User can continue navigation
```

### Focus Indicator Visibility

✅ **Visible focus indicator (WCAG AA requirement)**

```
Good focus:
┌────────────────┐
│ [Button Text]  │ ← 2px solid outline, 2px offset
└────────────────┘

Terrible focus (don't do this):
┌────────────────┐
│ [Button Text]  │ ← No outline, invisible focus
└────────────────┘
```

**Minimum:** 2px outline, 2px offset, solid border

---

## Screen Reader Support

### What's a Screen Reader?

Software that reads page content aloud:

- NVDA (Windows, free)
- JAWS (Windows, paid)
- VoiceOver (Mac/iOS, built-in)
- TalkBack (Android, built-in)

### Semantic HTML

**Screen readers read structure, not just text**

```
❌ Bad (no semantic meaning):
<div onclick="navigate()">Click here</div>

✅ Good (semantic, screen reader knows it's a link):
<a href="/page">Navigate</a>

❌ Bad (button unclear):
<div class="button">Submit</div>

✅ Good (semantic button):
<button type="submit">Submit</button>
```

### ARIA Labels

**When semantic HTML isn't enough, use ARIA**

```
Icon-only button:
<button aria-label="Close menu">
  <Icon name="close" />
</button>

Image without context:
<img src="logo.svg" alt="Company logo" />

Complex widget:
<div role="tablist">
  <div role="tab" aria-selected="true">
    Tab 1
  </div>
</div>
```

### Common ARIA Attributes

| Attribute          | Purpose                  | Example                        |
| ------------------ | ------------------------ | ------------------------------ |
| `aria-label`       | Text label for element   | `aria-label="Close"`           |
| `aria-labelledby`  | Link to label element    | `aria-labelledby="heading-id"` |
| `aria-describedby` | Link to description      | `aria-describedby="error-id"`  |
| `aria-required`    | Mark required fields     | `aria-required="true"`         |
| `aria-invalid`     | Mark invalid fields      | `aria-invalid="true"`          |
| `aria-live`        | Announce dynamic changes | `aria-live="polite"`           |
| `aria-hidden`      | Hide from screen readers | `aria-hidden="true"`           |
| `role`             | Define element role      | `role="tab"`                   |

---

## Motion & Animation

### Respects Prefers Reduced Motion

```css
/* Check user's motion preference */
@media (prefers-reduced-motion: reduce) {
  /* Remove animations */
  * {
    animation: none !important;
    transition: none !important;
  }
}
```

### When to Use Animation

✅ **Good use:**

- Transitions (fade, slide) - Smooth, informative
- Loading indicators - Shows work in progress
- Hover feedback - Clear interaction

❌ **Bad use:**

- Autoplaying videos with sound
- Flashing content (causes seizures)
- Excessive motion (causes nausea)
- Animations that distract from content

---

## Interactive Element Sizing

### Minimum Touch Target Size

```
Mobile: 44x44px minimum
  ↓ (sufficient for finger touch)

Desktop: 32x32px acceptable
  ↓ (mouse is more precise)

Large buttons: 48x48px+
  ↓ (easier for users with tremors, elderly)
```

### Spacing Between Interactive Elements

```
Minimum 8px gap between buttons
  ↓ (prevents accidental clicks)

Better: 12px gap
  ↓ (more comfortable for touching)

Ideal: 16px gap
  ↓ (clear separation)
```

---

## Form Accessibility

### Label Association

```
❌ Bad (no association):
<label>Email</label>
<input type="email" />

✅ Good (with for/id):
<label for="email">Email</label>
<input id="email" type="email" />

✅ Also good (implicit):
<label>
  Email
  <input type="email" />
</label>
```

### Error Messages

```
❌ Bad (just red border, no text):
┌─────────────────┐
│ [user@]         │ ← Red border only
└─────────────────┘

✅ Good (text + icon + border):
┌─────────────────┐
│ [user@]         │ ← Red border
└─────────────────┘
⚠ Invalid email format

✅ Best (with aria-describedby):
<input
  id="email"
  aria-invalid="true"
  aria-describedby="email-error"
/>
<p id="email-error">⚠ Invalid email format</p>
```

### Required Field Indicator

```
❌ Bad (only red star, no text):
Email *

✅ Good (text label):
Email (required)

✅ Better (asterisk + text):
Email * (required)

✅ Best (with aria-required):
<input
  id="email"
  required
  aria-required="true"
/>
<label for="email">Email (required)</label>
```

---

## Text & Typography

### Font Size

- Minimum: 14px for body text
- Heading: 18px+
- Mobile: Increase by 10-20%

### Line Height (Line Spacing)

- Minimum: 1.5x font size
- Better: 1.6x
- Headings: 1.2-1.3x

```
Body text 16px with 1.5 line height = 24px line height ✅

Cramped text 16px with 1.0 line height = 16px (hard to read) ❌
```

### Text Justification

```
❌ Justified text (uneven gaps):
The quick brown fox jumps     over
the lazy dog in the beautiful morning.

✅ Left-aligned (consistent gaps):
The quick brown fox jumps over the
lazy dog in the beautiful morning.
```

### Dyslexia-Friendly Fonts

- **Good:** Open Sans, Verdana, Arial, Helvetica, Tahoma
- **Avoid:** Serif fonts (Times New Roman), decorative fonts
- **Spacing:** Increase letter-spacing 0.1-0.15em

---

## Color Blindness

### Types & Percentages

- Protanopia (Red-blind): 1% of men
- Deuteranopia (Green-blind): 1% of men
- Tritanopia (Blue-yellow-blind): 0.001% (rare)
- Monochromacy (Colorblind): 0.001% (extremely rare)

### Design for Color Blindness

```
❌ Red/Green only:
[Red button] [Green button]
(Can't distinguish)

✅ Add text labels:
[✗ Delete] [✓ Save]

✅ Add icons/patterns:
[Red icon + label] [Green icon + label]
```

### Testing

- Chrome DevTools → Rendering → Emulate vision deficiencies
- Use colorblind simulator tools

---

## Content & Language

### Readability

- Use short sentences (< 20 words)
- Use common words (avoid jargon)
- Use active voice
- Break content into sections
- Use lists and subheadings

### Links

```
❌ Bad (unclear):
Click here to learn more

✅ Good (descriptive):
Read accessibility guidelines

❌ Bad (repetitive):
Learn about WCAG | Learn about ARIA | Learn about semantics

✅ Good (varied):
WCAG standards | ARIA attributes | Semantic HTML
```

### Abbreviations & Acronyms

```
❌ Bad (unexplained):
Use WCAG AA for a11y

✅ Good (explained):
Use WCAG (Web Content Accessibility Guidelines) AA level
```

---

## Testing Checklist

### Automated Testing (Browser Tools)

- ✅ Chrome DevTools (Accessibility tab)
- ✅ axe DevTools
- ✅ WAVE
- ✅ Lighthouse

### Manual Testing (Screen Reader)

- ✅ Page structure logical
- ✅ Links have descriptive text
- ✅ Images have alt text
- ✅ Buttons have labels
- ✅ Form fields labeled

### Keyboard Testing

- ✅ Tab through page (logical order?)
- ✅ Focus indicator visible?
- ✅ Can activate buttons (Enter/Space)?
- ✅ Can close modals (Escape)?

### Visual Testing

- ✅ Color contrast >= 4.5:1
- ✅ Touch targets >= 44x44px
- ✅ Text readable at zoom 200%
- ✅ Responsive at all breakpoints

### Mobile Testing

- ✅ Touch targets adequate (44x44px)
- ✅ Gestures have alternatives (swipe + buttons)
- ✅ Zoom works properly
- ✅ Buttons don't overlap

---

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
