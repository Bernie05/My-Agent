## Color Contrast

### Why Color Contrast Matters

Low contrast = hard to read for people with:

- Color blindness (8% of men, 0.5% of women)
- Low vision
- Using bright displays (outdoor screens)
- Aging eyes

### Contrast Ratios

```
1:1 = No contrast (impossible to read)
3:1 = Large text minimum
4.5:1 = Normal text minimum (WCAG AA) ✅
7:1 = Enhanced (WCAG AAA)
```

### Color Contrast Examples

```
✅ Good (Black #000 on White #FFF = 21:1)
Text: Easily readable

⚠️  Questionable (Gray #777 on White #FFF = 4.48:1)
Text: Barely meets AA, fails AAA

❌ Bad (Gray #888 on White #FFF = 4.14:1)
Text: Hard to read, fails AA

❌ Terrible (Gray #999 on White #FFF = 3.78:1)
Text: Fails accessibility
```

### Testing Color Contrast

**Tools:**

- Chrome DevTools (Inspect element → Color picker)
- WebAIM Contrast Checker
- Deque axe DevTools
- Figma plugins (Able, Color Contrast Analyzer)

### Color Combinations to Avoid

❌ **Don't rely on color alone**

- Red/Green (color blindness: 8% can't distinguish)
- Red/Blue (low vision)
- Light colors on light (no contrast)

✅ **Do combine with:**

- Text labels
- Icons with text
- Patterns or textures
- Symbols

---
