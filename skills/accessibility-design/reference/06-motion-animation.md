## Motion & Animation

### Respects Prefers Reduced Motion

```css
/* Check user's motion preference */
@media (prefers-reduced-motion: reduce) {
  /* Remove animations */
  * {
    animation: none !important;
    transition: none !important;
  }
}
```

### When to Use Animation

✅ **Good use:**

- Transitions (fade, slide) - Smooth, informative
- Loading indicators - Shows work in progress
- Hover feedback - Clear interaction

❌ **Bad use:**

- Autoplaying videos with sound
- Flashing content (causes seizures)
- Excessive motion (causes nausea)
- Animations that distract from content

---
