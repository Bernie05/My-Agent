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
