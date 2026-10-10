## Documentation Standards

### Component Documentation Template

````markdown
# Button

## Overview

The Button component is used for triggering actions.
Use for primary actions, secondary options, or destructive actions.

## Variants

- **Primary:** Main call-to-action (high contrast)
- **Secondary:** Alternative action (lower contrast)
- **Danger:** Destructive action (red, warning)
- **Ghost:** Minimal style (transparent, text only)

## Sizes

- **Small:** 32px height (compact spaces)
- **Medium:** 40px height (default)
- **Large:** 48px height (hero actions)

## States

- **Default:** Normal appearance
- **Hover:** Darker color, elevated shadow
- **Focus:** 2px outline, 2px offset
- **Active:** Darker color (pressed appearance)
- **Disabled:** 50% opacity, cursor not-allowed
- **Loading:** Spinner icon, text hidden

## Accessibility

- **Semantic HTML:** `<button>` element
- **Label:** Text label (avoid icon-only if possible)
- **Keyboard:** Enter/Space to activate
- **Focus:** Visible outline required
- **Screen reader:** Label announced

## Responsive

- **Mobile:** Full width or 44px minimum
- **Tablet:** Inline with others (44px minimum touch target)
- **Desktop:** Inline with others

## Usage Examples

### Do's ✅

- Use button for actions (submit, save, delete)
- Use short, action-oriented labels
- Provide visual feedback on hover/focus
- Ensure adequate touch targets (44x44px)

### Don'ts ❌

- Don't use buttons for navigation (use links)
- Don't disable submit button (show loading instead)
- Don't use button styles for links
- Don't rely on color alone for meaning

## Code Example

React:

```jsx
import Button from '@company/button';

<Button variant="primary" size="medium" onClick={handleClick}>
  Save Changes
</Button>

<Button variant="danger" disabled>
  Delete
</Button>
```
````
