## Composition & Variants

### Component Variants in Figma

Structure variants hierarchically:

```
Button
├── Variant: primary
│   ├── Size: small
│   ├── Size: medium
│   └── Size: large
├── Variant: secondary
│   ├── Size: small
│   ├── Size: medium
│   └── Size: large
└── Variant: danger
    ├── Size: small
    ├── Size: medium
    └── Size: large
```

### State Combinations

For each variant + size, show all states:

```
Button (Primary, Medium):
├── Default
├── Hover
├── Focus
├── Active
├── Disabled
├── Loading
└── Error
```

---
