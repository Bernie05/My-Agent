## Figma to Code Handoff

### What Frontend Needs

```
1. Component Specifications
   - Visual dimensions
   - Color values (or token names)
   - Typography details
   - States/variants

2. Design Assets
   - Icon SVG exports
   - Image assets (optimized)
   - Favicon files

3. Documentation
   - Component usage guide
   - Props/variants available
   - Accessibility requirements
   - Figma component link

4. Design Tokens
   - As CSS variables
   - As JSON
   - As Figma variables
```

### Handoff Document Template

Create a Figma file with documentation:

```markdown
# Component Name

## What is it?

Short description and use cases

## Specs

- Dimensions: [specs]
- Colors: [tokens used]
- Typography: [size, weight, line]
- Spacing: [padding, gaps]

## Variants

- Variant A (primary button)
- Variant B (secondary button)
- Variant C (danger button)

## States

- Default
- Hover
- Focus
- Active
- Disabled
- Loading

## Accessibility

- Semantic HTML: <button>
- ARIA labels: Required
- Keyboard: Enter/Space
- Focus indicator: Required

## Responsive

- Mobile: [changes]
- Tablet: [changes]
- Desktop: [changes]

## Figma Link

[Link to component in library]

## Implementation Notes

- [Specific implementation details]
- [Tradeoffs/constraints]
```

---
