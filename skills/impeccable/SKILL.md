---
name: impeccable
description: Design-quality playbooks for any frontend UI (app screens, dashboards, forms, landing pages) - pick the surface mode, then shape, critique (heuristic scoring), audit (a11y, performance, theming, responsive, integrity scored /20 with P0-P3), polish, harden (edge cases, errors, i18n), or refine (bolder, quieter, distill, typeset, layout, colorize, clarify, adapt), with a craft floor to check before any UI edit. Use when designing, reviewing, auditing, polishing or hardening a UI. Not for backend-only work.
license: Apache-2.0
---

# Impeccable

Adapted from [Impeccable](https://github.com/pbakaus/impeccable) by Paul Bakaus (Apache-2.0, see `LICENSE`), reviewed at `0d6b47e`. **Changes from the original:** condensed and rewritten as knowledge only. The launcher, the downloaded binary, the live-browser scripts, the design-detector hook, pinning and critique storage were removed; the evaluation, polish and hardening playbooks were merged into four reference files. Verification uses this setup's `browser-testing` skill instead.

## Principles
- **The brief wins.** Honor pinned aesthetics, fonts and palettes (DESIGN.md, brand guide, the user's words) even against a warning here. Redirecting a clear brief toward your own taste is failure.
- **Refinement preserves; redesign replaces.** Refine keeps the identity, behavior, copy and everything out of scope. Redesign keeps product truth, content and function, and replaces the look. Never polish a look you're about to discard.
- **Verify in bounded passes.** Build fully, inspect once (desktop and mobile together), fix everything found in one batch, confirm with at most one more round, stop. Open-ended self-QA burns time and money.

## Pick the mode (from the surface, not the product)
| Mode | Visitor succeeds when… | Surfaces | Priority |
|---|---|---|---|
| **Persuade** | they decide and act | landing, marketing, pricing | earn attention; pair with `design-taste` |
| **Operate** | they finish a task | app UI, dashboards, admin, settings, tools | scanability, consistency, platform expectations over expression; brand lives in details |
| **Read** | they understand | docs, articles, help, changelogs | structure for comprehension, then make reading pleasant |
| **Experience** | they're inside the work | portfolios, galleries, showcases | the artifact leads; the interface recedes |

A tool's landing page is Persuade; its docs are Read.

## Operations
| Operation | What it does | Load |
|---|---|---|
| **shape** | Plan the UX before code: user goal, primary task, information hierarchy, states, flows, what's out | — |
| **critique** | UX review: Nielsen heuristics scored 0-4, cognitive load, persona walk-throughs | `evaluate.md` |
| **audit** | Technical quality, scored /20 with P0-P3 findings. Reports only; fixes nothing | `evaluate.md` |
| **polish** | Final pass before shipping, without concealed redesign | `polish.md`, then `craft-floor.md` |
| **harden** | Real-world resilience: long/empty/odd content, errors, i18n, slow networks, concurrency | `harden.md` |
| **refine** lenses | **bolder** (amplify a timid design), **quieter** (calm an overstimulating one), **distill** (strip to the essence), **typeset** (hierarchy, scale, measure, font choice), **layout** (spacing, rhythm, alignment), **colorize** (strategic color on a monochrome UI), **clarify** (labels, errors, UX copy), **adapt** (breakpoints, touch, input methods) | `craft-floor.md` |
| **animate** | Purposeful motion | the `motion-design` skill |
| **optimize** | UI performance | measure first; `frontend-dev` **performance** |

**Before any UI edit**, including a small refinement, read `craft-floor.md`. Skip it for planning-only work.

## Context
Read the project's DESIGN.md (and PRODUCT.md or SPEC.md if they exist) plus representative tokens and shared components before judging or editing. A missing DESIGN.md doesn't make a project greenfield: the existing UI is the incumbent system.

## Reporting
- critique/audit: the score tables and P0-P3 findings from `evaluate.md`, each with location, impact, fix, and the operation that fixes it.
- polish/harden/refine: what changed, grouped by the triage order, plus anything deliberately left and why.
- Every finding is verified in context; no false positives, no generic advice, and note what already works.
