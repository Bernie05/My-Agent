---
name: ponytail-review
description: Over-engineering review of a diff or files - finds what to delete, reinvented stdlib, unneeded dependencies, speculative abstractions, dead flexibility. One line per finding with location, what to cut and what replaces it. Use in review and refactor operations and /ponytail:review. Complements (never replaces) correctness and security review.
license: MIT
---

# Ponytail review

Adapted from [Ponytail](https://github.com/dietrichgebert/ponytail) by Dietrich Gebert, MIT License (see `skills/ponytail/LICENSE`).

Review the diff or files for unnecessary complexity. The best outcome for a diff is getting shorter.

## Format
One line per finding: `<file>:L<line>: <tag> <what>. <replacement>.`

| Tag | Meaning |
|---|---|
| `delete:` | Dead code, unused flexibility, a speculative feature. Replacement: nothing. |
| `stdlib:` | Hand-rolled code for something the standard library ships. Name the function. |
| `native:` | A dependency or code doing what the platform already does. Name the feature. |
| `yagni:` | An abstraction with one implementation, config nobody sets, or a layer with one caller. |
| `reuse:` | Duplicates a helper that already exists in this codebase. Name it. |
| `shrink:` | Same logic, fewer lines. Show the shorter form. |

## Examples
- `form.ts:L12-38: stdlib: 27-line email validator class. "@" check + confirmation mail, 1 line.`
- `date.ts:L4: native: moment.js imported for one format call. Intl.DateTimeFormat, 0 deps.`
- `repo.py:L88: yagni: AbstractRepository with one implementation. Inline it until a second exists.`
- `api.ts:L30-44: shrink: manual loop builds a map. Object.fromEntries(pairs), 1 line.`

❌ "This class might be more complex than necessary. Have you considered…" Say what to cut, not a question.

## Scoring
End with `net: -<N> lines possible.` If there is nothing to cut, write `Lean already. Ship.`

## Boundaries
- Only over-engineering. Correctness, security and performance belong to the normal review. When the reviewing agent runs both, keep this as its own section.
- Never flag as bloat anything the spec, DESIGN.md or scenarios require, validation at trust boundaries, security, accessibility, or a single smoke test / assert-based self-check.
- Lists findings only. It applies nothing unless asked.
