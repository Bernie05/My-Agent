# Craft floor

From Impeccable (Apache-2.0, Paul Bakaus), lightly condensed. Read after the direction is settled, before any UI edit. A pinned brief or the committed visual world overrides anything here; your own habit does not.

## Verify (checks on the built result, run together in one inspection round)
- **Contrast:** body and placeholder text ≥ 4.5:1, large text ≥ 3:1. On colored surfaces tint secondary text from that hue; never plain gray.
- **Depth:** shadows have an offset and a soft blur. A zero-offset colored halo is decoration.
- **Spacing:** tight inside groups, generous between them, more space above a heading than below it. Read the computed values.
- **Type:** body measure 65-75ch, display max ~6rem, tracking no tighter than -0.04em, balanced headings, clear scale and weight steps. Run the real copy at every breakpoint and fix overflow.
- **Motion:** one authored moment, not scattered effects or the same entrance on every section. Ease-out from an already-visible default (see `motion-design`).
- **States:** hover, focus, active, disabled, loading, error, empty, success. Real content, working controls, keyboard focus.
- **Browser surfaces:** text selection, caret, scrollbars, focus rings, underline offset and tabular numerals ship with browser defaults unless you theme them from the palette. The cheapest signal of a built page, and the one most often skipped.
- **Copy:** the product's own words. Controls name their action; errors name the problem and the way out.
- **Coverage:** every brief requirement present and findable within seconds.

## Refuse (category defaults; the brief's own words can earn any of them back, except the eyebrow)
Page scaffolds:
- Same-size icon + heading + text cards as the page structure. Nested cards are always wrong.
- The hero-metric template: big number, small label, supporting stats, accent.
- An eyebrow/kicker above a heading. Delete it; the heading carries its own weight.
- Section numbers (01 / 02 / 03) unless the sequence itself is information.
- A modal for a task that needs neither interruption nor protected focus.

Surface habits:
- Gradient text. Emphasis comes from weight or size.
- Glass and blur as decoration rather than a specific effect.
- Colored `border-left`/`border-right` above 1px on cards, list items, callouts or alerts.
- Hard offset shadows (`4px 4px 0`) outside a genuinely neobrutalist world.
- Sparklines, progress rings and soft rounded rectangles standing in for content.
- Monospace as a "technical" costume rather than for code, data or measurements.
- A system display face (Impact, Arial Black, the platform sans) as the display voice of a branded page.
- Unicode or emoji standing in for icons; icons come from one library, one stroke and weight.
- Geometric masks faking an organic cut-out of a photo subject.
- Light or dark chosen by category. Choose from the use scene: who, where, under what light.

With every check green, spend the effort on the committed direction; when torn between refined and committed, commit.
