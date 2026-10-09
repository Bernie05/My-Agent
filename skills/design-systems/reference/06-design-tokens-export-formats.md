## Design Tokens Export Formats

### CSS Variables

```css
:root {
  --color-primary: #3b82f6;
  --color-secondary: #6b7280;
  --spacing-xs: 4px;
  --spacing-sm: 8px;
  --font-size-base: 16px;
}

/* Usage in components */
.button {
  background-color: var(--color-primary);
  padding: var(--spacing-md);
  font-size: var(--font-size-base);
}
```

### JavaScript/JSON

```json
{
  "color": {
    "primary": "#3B82F6",
    "secondary": "#6B7280"
  },
  "spacing": {
    "xs": "4px",
    "sm": "8px"
  },
  "typography": {
    "fontSize": {
      "base": "16px",
      "lg": "18px"
    }
  }
}
```

### Figma Variables

```
Variables panel → Create variable
- Name: color/primary
- Type: Color
- Value: #3B82F6

Apply to components:
Button background: color/primary
→ All instances update when variable changes
```

---
