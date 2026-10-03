# Motion recipes

From Emil Kowalski's skills (MIT), condensed. Use the project's stack: plain CSS first, the installed animation library second.

## Enter without JavaScript: `@starting-style`
```css
.toast {
  opacity: 1; transform: translateY(0);
  transition: opacity 400ms ease, transform 400ms ease;
  @starting-style { opacity: 0; transform: translateY(100%); }
}
```
Fallback where unsupported: set `data-mounted` after the first render and style from it.

## Percent translates
`translateY(100%)` moves an element by its own height, whatever it is. This is how toasts and drawers hide off-screen; prefer it over hard-coded pixels. `scale()` scales children too, which is right for press feedback.

## clip-path: `inset(top right bottom left)`
Each value eats in from that side; hardware-accelerated.
- **Reveal on scroll:** `inset(0 0 100% 0)` → `inset(0 0 0 0)` when in view (IntersectionObserver or `useInView({ once: true, margin: "-100px" })`).
- **Tabs with a perfect color change:** duplicate the tab list, style the copy as active, clip it to the active tab, animate the clip on change.
- **Hold to delete:** overlay at `inset(0 100% 0 0)`; on `:active` go to `inset(0 0 0 0)` over 2s linear; on release snap back in 200ms ease-out; add `scale(0.97)` on the button.
- **Comparison slider:** two stacked images, clip the top one with `inset(0 <x>% 0 0)` from the drag position.

## Springs on the pointer
Tying a value straight to the mouse feels artificial. Interpolate it:
```jsx
const rotation = useSpring(mouseX * 0.1, { stiffness: 100, damping: 10 });
```
Only for decorative motion. A functional chart in a banking app gets no spring.

## Drag and swipe
- **Momentum dismissal:** dismiss when the distance passes the threshold **or** velocity `abs(distance) / elapsedMs > ~0.11`. A flick is enough.
- **Damping past boundaries:** the further past the edge, the less it moves. Friction, not a wall.
- **Pointer capture** once dragging starts (`setPointerCapture`), so it continues outside the element.
- **Multi-touch:** ignore new touch points once a drag has begun (`if (isDragging) return`).
- Clear drag state on `pointercancel`, lost capture and window blur; set `touch-action` on drag surfaces so page scroll and drag don't fight.

## Stagger
```css
.item { opacity: 0; transform: translateY(8px); animation: fade-in 300ms var(--ease-out) forwards; }
.item { animation-delay: calc(var(--i) * 50ms); } /* set --i per item */
@keyframes fade-in { to { opacity: 1; transform: translateY(0); } }
```
30-80ms between items; interaction is never blocked.

## WAAPI for programmatic motion
```js
el.animate(
  [{ clipPath: 'inset(0 0 100% 0)' }, { clipPath: 'inset(0 0 0 0)' }],
  { duration: 600, fill: 'forwards', easing: 'cubic-bezier(0.77, 0, 0.175, 1)' }
);
```

## Lists entering and leaving
Opacity and height must work together; there's no formula. Tune until it feels right, and check it in slow motion.
