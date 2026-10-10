## Design System Layers

### Layer 1: Foundations (Design Tokens)

**The building blocks**

```
Colors:
- Primary: #3B82F6
- Secondary: #6B7280
- Success: #10B981
- Error: #EF4444

Typography:
- Heading 1: 32px, weight 700, line-height 1.2
- Heading 2: 24px, weight 600, line-height 1.3
- Body: 16px, weight 400, line-height 1.5
- Small: 14px, weight 400, line-height 1.4

Spacing:
- xs: 4px
- sm: 8px
- md: 12px
- lg: 16px
- xl: 24px
- 2xl: 32px

Shadows:
- Elevation 1: 0 1px 3px rgba(0,0,0,0.1)
- Elevation 2: 0 4px 6px rgba(0,0,0,0.1)
- Elevation 3: 0 10px 15px rgba(0,0,0,0.1)

Radius:
- sm: 4px
- md: 8px
- lg: 12px
- full: 9999px
```

### Layer 2: Components (Primitive)

**Basic, single-purpose components**

- Button
- Input
- Label
- Icon
- Checkbox
- Radio
- Select

### Layer 3: Patterns (Composite)

**Combinations of primitives that solve common problems**

- Form (Input + Label + Error)
- Card (Container + Image + Title + Description)
- Modal (Card + Overlay + Close button)
- Navigation (Button + Icon + Label)

### Layer 4: Layouts (Template)

**Full-page layouts using components**

- Landing page layout
- Product page layout
- Dashboard layout
- Admin panel layout

### Layer 5: Documentation

**Guides, examples, governance**

- Component usage guide
- Code examples
- Accessibility checklist
- Design principles
- Changelog

---
