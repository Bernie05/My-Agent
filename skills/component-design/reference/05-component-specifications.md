## Component Specifications

### What to Specify

1. **Visual Design**
   - Dimensions (width, height, padding)
   - Colors (with tokens)
   - Typography (size, weight, line height)
   - Border radius, shadows, effects

2. **Behavior**
   - States (hover, focus, active, disabled)
   - Animations (fade, slide, none)
   - Interactions (click, drag, keyboard)

3. **Responsive**
   - Mobile layout
   - Tablet layout
   - Desktop layout

4. **Accessibility**
   - ARIA labels needed
   - Keyboard support
   - Focus indicators
   - Color contrast

5. **Content**
   - Max/min dimensions
   - Text overflow handling
   - Icon specifications
   - Slot requirements

### Example Button Specification

```
BUTTON COMPONENT

Visual Design:
- Height: 40px (medium)
- Padding: 12px 24px
- Border radius: 6px
- Font: 14px, weight 600
- Icon size: 18px (if included)

Colors (via tokens):
- Primary variant: --color-primary (blue)
- Secondary variant: --color-gray-200 (light gray)
- Text color: --color-white / --color-gray-900
- Hover: 10% darker
- Active: 15% darker
- Disabled: 50% opacity

States:
- Default: Solid color, no shadow
- Hover: 10% darker + shadow elevation 2
- Focus: 2px outline with 2px offset
- Active: 15% darker
- Disabled: 50% opacity, cursor not-allowed
- Loading: Icon spinner, text hidden

Responsive:
- Mobile (< 768px): Full width or Min width 44px
- Desktop: Inline with padding

Accessibility:
- Semantic: <button> element
- Label: aria-label if icon-only
- Focus: Visible focus indicator
- Keyboard: Enter/Space to activate
- Disabled: aria-disabled="true"

Content:
- Min width: 80px (text) / 44px (icon only)
- Max width: 100% container
- Icon + text: Icon left, 8px gap
- Icon only: Square (44x44px min)
```

---
