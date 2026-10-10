## Form Accessibility

### Label Association

```
❌ Bad (no association):
<label>Email</label>
<input type="email" />

✅ Good (with for/id):
<label for="email">Email</label>
<input id="email" type="email" />

✅ Also good (implicit):
<label>
  Email
  <input type="email" />
</label>
```

### Error Messages

```
❌ Bad (just red border, no text):
┌─────────────────┐
│ [user@]         │ ← Red border only
└─────────────────┘

✅ Good (text + icon + border):
┌─────────────────┐
│ [user@]         │ ← Red border
└─────────────────┘
⚠ Invalid email format

✅ Best (with aria-describedby):
<input
  id="email"
  aria-invalid="true"
  aria-describedby="email-error"
/>
<p id="email-error">⚠ Invalid email format</p>
```

### Required Field Indicator

```
❌ Bad (only red star, no text):
Email *

✅ Good (text label):
Email (required)

✅ Better (asterisk + text):
Email * (required)

✅ Best (with aria-required):
<input
  id="email"
  required
  aria-required="true"
/>
<label for="email">Email (required)</label>
```

---
