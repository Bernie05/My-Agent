---
name: code-quality
description: Robustness and maintainability lenses for any stack. Robustness covers validation at trust boundaries, failing fast, no swallowed errors, timeouts, idempotent retries, transactions, deliberate degradation and failure logging. Maintainability covers names, function size and complexity, dead code and consistency. Use in the review, refactor (maintainability only) and optimize operations of frontend-dev, backend-dev and fullstack-dev. Not for performance (performance-optimization), structure or design patterns (code-patterns), or security audits (backend-security).
---

# Code quality

Robust code fails loudly in the right place. Maintainable code is easy to read top to bottom. Neither means more code: the `ponytail` ladder still decides how little code gets there. Most fixes here are deletions (a swallowed catch, a dead branch) or one guard at a boundary.

Grep `checklist.md` for the heading you need (`## HTTP input`, `## Outside calls`, `## Maintainability`…). Never read it whole.

## Robustness lens
Guard where data **enters** or **leaves** your code. Trust it everywhere in between.

| Check | Rule | Deep rules |
|---|---|---|
| Trust boundaries | Validate and parse input **once**, where it enters (request, form, file, queue message, env, outside API response). Use an allow-list over a block-list, then pass typed, already-valid data inward ("parse, don't validate"). | `api-design`, `backend-security` |
| Fail fast inside | Inside the boundary, a broken assumption is a bug: throw, don't patch it with a default. No defensive re-checks on every layer. | - |
| No swallowed errors | Every catch either handles the error (recover, retry, user message) or rethrows it with context. Flag empty catches, catch-log-continue, `?.`/`??` hiding a real failure, and broad catches that also trap unrelated errors. | - |
| Outside calls | Every network, DB or third-party call has a timeout. Retry only idempotent operations, with capped backoff. Non-idempotent writes need an idempotency key first. | `checklist.md` → Outside calls |
| Consistency | Multi-step writes go in one transaction, or have a compensating step. Use DB constraints over app checks for invariants. | `database-design` |
| Degradation | A fallback is a feature: only where the spec or user asks for it. Every fallback is visible: logged, and shown to the user when it changes what they see. | `frontend-component-development` (UI states) |
| Failure logging | Log once, at the layer that handles the error, with the operation and IDs. Never log secrets, tokens or full personal data. | `backend-security` |
| Types | Make illegal states unrepresentable where it's cheap: a union over boolean flags, no `any` at a boundary. | `typescript-for-frontend` |

**Ponytail guard:**
- No try/catch at every layer. Handle the error where something can be done about it.
- No error-class hierarchy for one or two error kinds.
- No circuit breaker or bulkhead for a single caller.
- No retry library when a three-line loop fits.

Name the ceiling instead: `// ponytail: no circuit breaker, add when a 2nd service depends on this API`.

## Maintainability lens
Signals, not limits. Flag one only when it slows a reader down here.

- **Names say intent.** `pendingInvoices`, not `data2`. Booleans read as questions (`isPaid`). Use one word per concept, matching the repo's vocabulary.
- **Functions do one thing.** You can name it without "and". Long or deeply nested → guard clauses and early returns first, then extract only a block with a clear name. A branch-heavy function also needs tests before you split it.
- **Dead code goes.** Unused exports, unreachable branches, commented-out code, flags that are always on. Check by grep or the tool first (`ponytail-audit` for dependencies).
- **Consistency over preference.** Follow the repo's existing error style, naming, file layout and formatting. Never reformat files you aren't changing.
- **Comments say why, not what.** Delete comments that restate the code. Keep ones that explain a constraint or a `ponytail:` ceiling.
- Structural smells (god files, duplication, wrong layer, wrong pattern) belong to `code-patterns`. Don't repeat them here.

## Rules
- **refactor** uses the maintainability lens only: behavior stays identical.
- **review** and **optimize** use both lenses. Robustness fixes usually change behavior (a new 400, a timeout error, a surfaced failure), so mark them `Behavior change: y` unless they clearly don't.
- Never cut validation, permission checks or error handling that prevents data loss to shorten a diff.

## Reporting
One line per finding: `file:line - robustness|maintainability - issue - fix - behavior change y/n`. Say when you chose to leave something and what would change that.

Based on public practice, in our own words: OWASP Input Validation Cheat Sheet, Nygard's *Release It!* stability patterns, Fowler's *Refactoring* code smells, and "parse, don't validate".
