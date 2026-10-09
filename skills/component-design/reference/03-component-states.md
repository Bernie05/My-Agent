## Component States

### Every Component Has Multiple States

1. **Default** - Normal, uninteracted
2. **Hover** - Mouse over (desktop)
3. **Focus** - Keyboard focus (tab key)
4. **Active** - Currently selected/pressed
5. **Disabled** - Cannot interact
6. **Loading** - Async operation in progress
7. **Error** - Invalid state
8. **Success** - Positive confirmation

### Example: Text Input States

```
Default:
┌─────────────────────┐
│ Enter your name...  │
└─────────────────────┘

Focus (outline visible):
┌─────────────────────┐ ← Blue outline
│ Enter your name...  │
└─────────────────────┘

Disabled (low opacity, cursor not-allowed):
┌─────────────────────┐
│ Enter your name...  │ (50% opacity)
└─────────────────────┘

Error (red border, error message):
┌─────────────────────┐ ← Red border
│ Enter your name...  │
└─────────────────────┘
⚠ This field is required

Loading (spinner):
┌─────────────────────┐
│ [⟳] Saving...      │
└─────────────────────┘

Success (green checkmark):
✓ Name saved successfully
```

---
