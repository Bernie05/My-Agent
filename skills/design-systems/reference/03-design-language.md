## Design Language

### Design Principles

Define **WHY** your system exists:

```
Example Design Principles:

1. Clarity First
   Every design decision should make products clearer.
   Reduce cognitive load. Make it obvious.

2. Accessibility Built-In
   Inclusive by default. Accessible for everyone.
   WCAG AA minimum, strive for AAA.

3. Consistency
   Predictable patterns. Familiar interactions.
   Users can anticipate behavior.

4. Simplicity
   Remove unnecessary elements. Minimal = better.
   Don't over-engineer solutions.

5. Performance
   Fast and responsive. Respect user's time.
   Optimize before shipping.
```

### Design Tokens

**Semantic naming** (not color values)

```
❌ Bad (color values):
color-blue-500: #3B82F6
color-red-600: #DC2626

✅ Good (semantic):
color-primary: #3B82F6
color-danger: #DC2626
color-success: #10B981

✅ Better (with hierarchy):
color-interactive-primary: #3B82F6
color-interactive-danger: #DC2626
color-status-success: #10B981
color-status-warning: #F59E0B
color-text-primary: #111827
color-text-secondary: #6B7280
color-surface-background: #FFFFFF
color-surface-overlay: #F3F4F6
```

---
