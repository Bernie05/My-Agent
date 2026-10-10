## Design Tokens in Figma

### Option 1: Figma Variables (Modern)

```
Variables > Create variable
- color-primary: #3B82F6
- color-secondary: #6B7280
- spacing-xs: 4px
- spacing-sm: 8px
- spacing-md: 12px

Apply to components:
- Button background: color-primary (variable)
- Button padding: spacing-sm (variable)
→ Change variable, all components update
```

### Option 2: Figma Styles (Classic)

```
Assets > Create style
- Type: Color, Typography, Effect

Name with structure:
- Color/Primary
- Color/Gray/100
- Typography/Heading/H1
- Spacing/Small
```

### Option 3: Design Tokens Plugin

Plugins like:

- Token Studio for Figma (exports to JSON)
- Design Tokens (export to CSS)
- Supernova (design to code sync)

---
