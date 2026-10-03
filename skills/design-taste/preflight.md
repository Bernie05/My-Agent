# Pre-flight check

From taste-skill (MIT, Leonxlnx), condensed. Tick every box before delivering. A box that can't honestly be ticked means the page isn't done.

## Direction
- [ ] Design read stated in one line; dial values stated and reasoned from the brief
- [ ] One design system and one icon family; official packages used where a real system fits
- [ ] Redesign: mode detected and audit done first (`redesign.md`)

## Locks
- [ ] One theme for the page (no inverted sections unless it's the one deliberate device)
- [ ] One accent color, used identically everywhere
- [ ] One corner-radius system
- [ ] One label per CTA intent across nav, hero and footer

## Hero and layout
- [ ] Hero fits the viewport: headline ≤ 2 lines, subtext ≤ 20 words, CTA visible, top padding ≤ ~6rem, ≤ 4 text elements
- [ ] Logo wall under the hero, logos only (no category labels), real SVG logos or proper marks
- [ ] No three equal cards; ≥ 4 layout families across 8 sections; ≤ 2 zigzags in a row
- [ ] Eyebrows ≤ ceil(sections / 3); no section numbers; no split headers with a floating paragraph
- [ ] Bento: exact cell count, varied sizes, 2-3 visually varied cells
- [ ] Nav on one line at desktop, ≤ 80px; CTAs don't wrap at desktop
- [ ] Every multi-column section collapses cleanly under 768px; `100dvh`, not `100vh`
- [ ] Lists over 5 items use a better component than a bulleted list

## Content
- [ ] Zero em-dashes in visible text
- [ ] Copy self-audit done (`ai-tells.md`); no filler verbs, placeholder names or fake-precise numbers
- [ ] Real images or clearly labelled placeholder slots; no div-built fake screenshots
- [ ] Quotes ≤ 3 lines with full attribution

## Quality
- [ ] Contrast AA for text, buttons, placeholders, focus rings and form helpers, in both themes
- [ ] Loading, empty and error states exist; press feedback on buttons
- [ ] Motion is motivated (each animation justified in one sentence), reduced-motion handled, no scroll listeners on `window`
- [ ] Transform/opacity animations only; effects cleaned up on unmount
- [ ] Core Web Vitals plausible: LCP < 2.5s (hero image prioritized), INP < 200ms, CLS < 0.1 (space reserved for media and fonts)
