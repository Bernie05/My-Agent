## Screen Reader Support

### What's a Screen Reader?

Software that reads page content aloud:

- NVDA (Windows, free)
- JAWS (Windows, paid)
- VoiceOver (Mac/iOS, built-in)
- TalkBack (Android, built-in)

### Semantic HTML

**Screen readers read structure, not just text**

```
❌ Bad (no semantic meaning):
<div onclick="navigate()">Click here</div>

✅ Good (semantic, screen reader knows it's a link):
<a href="/page">Navigate</a>

❌ Bad (button unclear):
<div class="button">Submit</div>

✅ Good (semantic button):
<button type="submit">Submit</button>
```

### ARIA Labels

**When semantic HTML isn't enough, use ARIA**

```
Icon-only button:
<button aria-label="Close menu">
  <Icon name="close" />
</button>

Image without context:
<img src="logo.svg" alt="Company logo" />

Complex widget:
<div role="tablist">
  <div role="tab" aria-selected="true">
    Tab 1
  </div>
</div>
```

### Common ARIA Attributes

| Attribute          | Purpose                  | Example                        |
| ------------------ | ------------------------ | ------------------------------ |
| `aria-label`       | Text label for element   | `aria-label="Close"`           |
| `aria-labelledby`  | Link to label element    | `aria-labelledby="heading-id"` |
| `aria-describedby` | Link to description      | `aria-describedby="error-id"`  |
| `aria-required`    | Mark required fields     | `aria-required="true"`         |
| `aria-invalid`     | Mark invalid fields      | `aria-invalid="true"`          |
| `aria-live`        | Announce dynamic changes | `aria-live="polite"`           |
| `aria-hidden`      | Hide from screen readers | `aria-hidden="true"`           |
| `role`             | Define element role      | `role="tab"`                   |

---
