---
name: motion-design
description: UI animation and interaction feel, from Emil Kowalski's design engineering practice - whether something should animate at all, purpose, easing, duration, springs, interruptibility, press feedback, origin-aware popovers, performance (transform/opacity, CSS vs JS), reduced motion, and a Before/After/Why review format. Use when adding, changing or reviewing any animation, transition, gesture or micro-interaction in a web UI.
license: MIT
---

# Motion design

Adapted from [emilkowalski/skill](https://github.com/emilkowalski/skill) (`emil-design-eng`, `review-animations`, `animate`) by Emil Kowalski (MIT, see `LICENSE`), reviewed at `d16ebe6`. Condensed; the principles and values are his.

Unseen details compound: users never notice one good transition, but they feel the sum. Motion earns its place or it goes.

## Sibling file (load on demand)
| When | Read |
|---|---|
| Building a specific effect: clip-path reveals, tabs, hold-to-delete, drawers, drag/swipe, springs on the pointer, stagger, `@starting-style` | `recipes.md` |

## 1. Decide before writing any animation
**Should it animate at all?** Go by how often the user sees it.

| Frequency | Decision |
|---|---|
| 100+ times a day (keyboard shortcuts, command palette) | No animation. Ever. |
| Tens of times a day (hover, list navigation) | Remove or drastically reduce |
| Occasionally (modals, drawers, toasts) | Standard animation |
| Rarely / first time (onboarding, celebrations) | Room for delight |

**Never animate keyboard-initiated actions.**

**What's the purpose?** Spatial consistency (a toast leaves the way it came), state indication, explanation, feedback (a press), or preventing a jarring change. "It looks cool" on something seen often is not a purpose.

## 2. Easing
- Entering or exiting → **ease-out**
- Moving or morphing on screen → **ease-in-out**
- Hover or color change → **ease**
- Constant motion (marquee, progress) → **linear**
- **Never ease-in on UI**: it delays the exact moment the user is watching.

Built-in curves are too weak. Use strong custom ones, as tokens:
```css
--ease-out: cubic-bezier(0.23, 1, 0.32, 1);      /* UI enter/exit */
--ease-in-out: cubic-bezier(0.77, 0, 0.175, 1);  /* on-screen movement */
--ease-drawer: cubic-bezier(0.32, 0.72, 0, 1);   /* iOS-like drawer */
```

## 3. Duration
| Element | Duration |
|---|---|
| Button press feedback | 100-160ms |
| Tooltips, small popovers | 125-200ms |
| Dropdowns, selects | 150-250ms |
| Modals, drawers | 200-500ms |
| Marketing / explanatory | Longer is fine |

**UI animations stay under 300ms.** Faster feels more responsive, and a faster spinner makes loading feel faster. **Asymmetric timing:** slow where the user decides (hold-to-delete 2s linear), fast where the system responds (release 200ms ease-out). Exit is usually faster than enter.

## 4. Physicality
- **Press feedback:** `transform: scale(0.97)` on `:active` with `transition: transform 160ms ease-out` (0.95-0.98) on anything pressable.
- **Never `scale(0)`.** Start at `scale(0.95)` + `opacity: 0`.
- **Origin-aware popovers:** scale from the trigger (`transform-origin: var(--transform-origin)` in Base UI/Radix). **Modals stay centered.**
- **Tooltips:** delay the first one; once one is open, neighbors open instantly with no animation.
- **Transitions over keyframes** for anything triggered rapidly (toasts, toggles): transitions retarget mid-flight, keyframes restart from zero.
- **Springs** for drag with momentum, "alive" elements and interruptible gestures: `{ type: "spring", duration: 0.5, bounce: 0.2 }`. Bounce 0.1-0.3, and none in most UI.
- **Crossfade looks like two objects swapping?** Add `filter: blur(2px)` during the transition (keep blur under 20px).
- **Stagger** groups 30-80ms apart; never block interaction while it plays.
- **Cohesion:** match motion to personality. Playful can bounce; a dashboard is crisp and fast. One motion language per product: the same curves and duration scale everywhere.

## 5. Performance
- Animate **only `transform` and `opacity`** (plus `clip-path`/`filter` in moderation). Never `width`, `height`, `top`, `left`, `margin`, `padding`.
- Don't drive per-frame child motion through a CSS variable on the parent (restyles every child); set `transform` on the element.
- Motion/Framer Motion shorthands (`x`, `y`, `scale`) run on the main thread; under load use `animate={{ transform: "translateX(100px)" }}`.
- CSS animations beat JS under load. CSS for predetermined motion, JS for dynamic and interruptible motion, WAAPI (`element.animate`) for JS control at CSS performance.
- No `window` scroll listeners: use IntersectionObserver, `useInView`/`useScroll`, or CSS scroll-driven animations.
- `will-change` only on elements about to animate, not at rest.

## 6. Accessibility
- `prefers-reduced-motion: reduce` means **fewer and gentler, not zero**: keep opacity and color changes that explain state; remove movement, parallax, loops and scroll-jacking.
- Gate hover motion with `@media (hover: hover) and (pointer: fine)` so taps don't trigger it.
- Motion never blocks focus, reading or task completion.

## 7. Reviewing motion
Report findings as **one markdown table**, one row per issue:

| Before | After | Why |
|---|---|---|
| `transition: all 300ms` | `transition: transform 200ms var(--ease-out)` | Name the properties; `all` animates layout by accident |
| `scale(0)` on enter | `scale(0.95); opacity: 0` | Nothing appears from nothing |
| `ease-in` on dropdown | `ease-out` custom curve | ease-in feels sluggish |
| No `:active` state | `scale(0.97)` on `:active` | Press must feel heard |
| Popover `transform-origin: center` | `var(--transform-origin)` | Scale from the trigger (modals exempt) |

Also check: animation on a keyboard action, UI duration over 300ms, hover without the media query, keyframes on rapidly-triggered elements, same enter/exit speed, everything appearing at once.

When the feel is uncertain, suggest checking in slow motion (2-5× duration or the DevTools Animations panel), frame by frame, on a real device for gestures, and again with fresh eyes the next day.
