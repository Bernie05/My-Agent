## Component Organization in Figma

### Naming Convention

Use forward slashes to organize:

```
Good:
Button/Primary/Small
Button/Primary/Medium
Button/Primary/Large
Button/Secondary/Small
Button/Danger/Small

Bad:
ButtonPrimarySmall
Button_Primary_Small
Primary Button Small
```

### Variant System

```
Set up component variants:
- Type: primary, secondary, danger
- Size: small, medium, large
- State: default, hover, active, disabled

Result: 18 component variants from one "Button" component
```

### Main Component vs. Instances

**Main Component** (source of truth)

```
Button (blue, primary)
├── All instances update when this changes
```

**Instances** (copies that update)

```
[Instance] Use in designs
[Instance] Use in designs
[Instance] Auto-updates when main changes
```

---
