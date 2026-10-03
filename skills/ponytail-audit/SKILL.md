---
name: ponytail-audit
description: Whole-repo audit for over-engineering - a ranked list of what to delete, simplify, or replace with stdlib/native equivalents and unused dependencies to drop. Like ponytail-review but for the entire codebase. Use for /ponytail:audit. Report only; applies nothing.
license: MIT
---

# Ponytail audit

Adapted from [Ponytail](https://github.com/dietrichgebert/ponytail) by Dietrich Gebert, MIT License (see `skills/ponytail/LICENSE`).

This is `ponytail-review` run across the whole repo instead of a diff. It uses the same tags: `delete:` `stdlib:` `native:` `yagni:` `reuse:` `shrink:`.

## Hunt, cheaply
- Skip `node_modules`, `.git`, `dist`, `build`, `.next`, coverage, lockfiles and generated files.
- Start from the manifest (`package.json`, `requirements.txt`, …) and find dependencies the stdlib or platform already covers:
  - date libraries → `Intl`
  - lodash one-offs → native array/object methods
  - axios → `fetch`
  - uuid → `crypto.randomUUID`
  - Grep each dependency's imports to count how often it's used.
- Grep for:
  - single-implementation interfaces or abstract classes
  - `Factory` / `Manager` / `Wrapper` with one product or one caller
  - files that export one trivial thing
  - dead flags and config
  - hand-rolled stdlib
- Read only the slices your grep hits point to.

## Output
One line per finding, biggest cut first: `<tag> <what to cut>. <replacement>. [path]`

End with `net: -<N> lines, -<M> deps possible.` If nothing is found, write `Lean already. Ship.`

## Boundaries
- Only over-engineering. Correctness bugs, security and performance go to a normal review.
- Never list spec-required features, validation at trust boundaries, security or accessibility as cuts.
- Report only; it applies nothing.
