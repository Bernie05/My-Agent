---
name: design-taste
description: Anti-slop visual taste for marketing UI - read the brief, set three dials (variance, motion, density), avoid the AI-default look (purple gradients, three equal cards, eyebrows everywhere, fake screenshots, em-dashes), and pass a pre-flight check. Use when building or redesigning landing pages, marketing sites, portfolios or other pages where the look is the product. Not for dense app UI, dashboards or data tables (use impeccable, Operate mode).
license: MIT
---

# Design taste

Adapted from [taste-skill](https://github.com/Leonxlnx/taste-skill) by Leonxlnx (MIT, see `LICENSE`), reviewed at `ce26fc2`. Condensed and fitted to this setup; the rules are theirs, the trimming is ours.

Every rule is **contextual**: read the brief first, then apply what fits. A pinned brief (DESIGN.md, brand guide, the user's words) beats every default here.

## Sibling files (load on demand)
| When | Read |
|---|---|
| Before shipping, and in review | `preflight.md` (the checklist) |
| Writing copy, or checking for AI tells | `ai-tells.md` |
| Redesigning an existing page | `redesign.md` |

## 1. The design read (before any code)
Read: page kind, the user's vibe words, references (URLs, screenshots, named products), audience, existing brand assets, and quiet constraints (accessibility-first, public sector, regulated, kids). Constraints override taste.

State it in one line: **"Reading this as: <page kind> for <audience>, with a <vibe> language, leaning toward <design system or aesthetic>."**
If two readings are genuinely possible, ask **one** question. Otherwise don't ask.

## 2. The three dials
| Dial | 1 | 10 |
|---|---|---|
| `DESIGN_VARIANCE` | perfect symmetry | artsy asymmetry |
| `MOTION_INTENSITY` | static | cinematic |
| `VISUAL_DENSITY` | gallery, airy | cockpit, packed |

| Brief reads as | Variance | Motion | Density |
|---|---|---|---|
| Minimal, calm, editorial, "Linear-style" | 5-6 | 3-4 | 2-3 |
| Premium consumer, luxury | 7-8 | 5-7 | 3-4 |
| Playful, agency, experimental | 9-10 | 8-10 | 3-4 |
| Landing page / portfolio (default) | 7-9 | 6-8 | 3-5 |
| Trust-first, public sector, regulated | 3-4 | 2-3 | 4-5 |
| Redesign: preserve / overhaul | match / +2 | +1 / +2 | match |

State the values with the design read. What they mean:
- **Variance** 1-3 symmetric grid; 4-7 offsets and mixed aspect ratios; 8-10 masonry, fractional grids, big empty zones. Above 4, collapse to a single column under 768px.
- **Motion** 1-3 hover/active only; 4-7 CSS transitions and staggered load-ins; 8-10 scroll-driven choreography. Anything above 3 needs a `prefers-reduced-motion` fallback. Load `motion-design` for the details. **Motion claimed = motion shown**: if you can't ship it working, lower the dial.
- **Density** 1-3 huge section gaps; 4-7 standard app spacing; 8-10 no card boxes, 1px dividers, tabular numbers.

## 3. Foundation
- If the brief reads as a real design system (Material, Fluent, Carbon, Primer, GOV.UK, USWDS, Polaris…), use its **official package**; don't recreate its CSS by hand.
- If it reads as an aesthetic (bento, editorial, brutalist, glass, kinetic type), build with native CSS and the project's stack, and say it's inspired, not official.
- Follow the repo's UI library and icon set (`frontend-dev` step 5). **One design system, one icon family per project.** Never hand-draw SVG icons.
- Check `package.json` before importing anything; output the install command if it's missing.

## 4. Bias corrections (the defaults to reach past)
**Type**
- Headlines: tight tracking, `leading-none` to 1.1, set size and asset together. Body: max 65ch, relaxed leading.
- Don't default to Inter (fine when asked for neutral/Linear-style or accessibility-first). Don't default to serif for "creative" briefs; serif needs an editorial, luxury or heritage reason. Emphasis inside a headline uses italic or bold of the **same** family.
- Italic display words with descenders (`y g j p q`): leading at least 1.1 plus a little bottom padding.

**Color**
- One accent, saturation under 80%, locked across the whole page. Neutral base (zinc, slate, stone).
- No automatic AI purple/blue glow. Purple is fine when the brand is purple; then do it with intent.
- Premium consumer briefs: the beige + brass + espresso palette is the AI default; pick another family unless the brand names it.
- No pure `#000` or `#fff`. Tint shadows to the background hue.

**Layout**
- Centered hero only for editorial/manifesto briefs or variance ≤ 4; otherwise split, left-aligned or asymmetric.
- Hero fits the first viewport: headline ≤ 2 lines, subtext ≤ 20 words, CTA visible, top padding ≤ ~6rem, at most 4 text elements (eyebrow or brand strip, headline, subtext, CTAs). Logo walls go **under** the hero.
- No three equal feature cards. Each layout family appears once per page; 8 sections use at least 4 families. At most 2 image/text zigzags in a row.
- Bento grids: exactly as many cells as items, varied sizes, and 2-3 cells with real visual variation.
- Cards only when elevation means hierarchy; otherwise spacing and dividers. One corner-radius system. One theme for the whole page; sections don't invert.
- Nav on one line at desktop, ≤ 80px tall. Full-height sections use `min-height: 100dvh`, never `100vh`.
- Every multi-column section declares its mobile collapse.

**Content**
- Section default: headline ≤ 8 words + ≤ 25-word paragraph + one visual or one CTA.
- More than 5 items → grouped columns, card grid, tabs, pills or carousel, not a long bulleted list.
- Real images: an image tool if available, then real or placeholder photography (`picsum.photos/seed/<descriptive>/<w>/<h>`), then labelled placeholder slots and tell the user. **No div-built fake screenshots.**
- One label per CTA intent across the page. Button labels ≤ 3 words, never wrapping at desktop.
- Numbers come from real data or are labelled as samples.

**States and accessibility**
- Loading (skeletons shaped like the content), empty (says how to fill it), error (inline for forms), `:active` press feedback.
- Contrast: body 4.5:1, large text 3:1, for buttons, placeholders, focus rings and helper text too. Label above input, error below, never placeholder-as-label.
- Dark mode designed from the start for consumer pages, one token strategy.
- Performance: animate transform/opacity; grain/noise only on fixed pointer-events-none layers; lazy-load below the fold; a documented z-index scale.

## 5. Out of scope
Dashboards, data tables, multi-step product flows, editors, native mobile. Say so and use `impeccable` (Operate mode) and the project's UI library instead; apply this skill only to the marketing surfaces.

## 6. Finish
Run `preflight.md`. If a box can't honestly be ticked, the page isn't done.
