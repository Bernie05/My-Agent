---
name: code-patterns
description: Software design patterns, reuse and code structure for frontend and backend in any stack - which pattern a real code smell calls for (and when none does), SOLID in plain terms, where shared code lives, layering and folder structure, anti-patterns, plus a catalog of the 22 GoF patterns and frontend (patterns.dev) / backend (Fowler PoEAA) architecture patterns. Use on refactor and review, or when new code has real variation (several types, providers or states). Not for UI/UX patterns (see design-patterns). Works with ponytail, never against it.
---

# Code patterns

A pattern is a fix for a problem you **already have**, not a shape to start from. This skill sits on rung 7 of the `ponytail` ladder ("only then: write the minimum code"). It decides *which* structure the minimum code needs, not whether to add one. If ponytail says "you don't need this", that wins.

## Load the stack file you need
| You are | Also read (sibling file) |
|---|---|
| frontend-dev | `frontend.md` |
| backend-dev | `backend.md` |
| anyone naming, choosing or checking a classic GoF pattern (Strategy, Adapter, Observer…) | `catalog.md`: grep `### <Pattern>` with about 6 lines of context; never read it whole |

Read only your own file; grep for the smell you're fixing instead of reading it whole if it's long. The "When a pattern is earned" gate below applies to everything in the catalog.

## When a pattern is earned
Apply one only when **all three** are true:
1. **The smell is in the code now**, not predicted. (There are 3+ variants today, or the same change keeps touching the same N places.)
2. **The rule of three holds.** Duplicate once; extract on the third copy. Two similar blocks stay inline.
3. **The diff after the pattern is smaller or clearer**, counting the tests. If a reviewer needs a diagram to follow it, it isn't clearer.

If one of these fails, write the plain version and, where the ceiling is real, leave a `ponytail:` comment naming the trigger:
`// ponytail: switch on provider; move to a strategy map at the 3rd provider`

## Smell → pattern (both stacks)
| Smell you can point to | Pattern | Not when |
|---|---|---|
| A `switch`/`if` on a type or kind, repeated in several places, and growing | **Strategy** / lookup map (`{ [kind]: handler }`) | One switch in one place: leave it |
| Code talks directly to an outside service or library whose API you don't control | **Adapter** (one thin wrapper module) | The library is stable and used in one file |
| Creating an object needs branching on config or input, in several places | **Factory function** (a plain function, not a class hierarchy) | Only one kind of object exists |
| Several parts must react to one event, and the sender shouldn't know them | **Observer** / events / pub-sub | There's one listener: call it directly |
| A long function mixes fetching, rules and formatting | **Split by responsibility** (see Layering) | It's short and read top to bottom |
| The same 3+ lines copied into 3+ places | **Extract a function** next to its callers | Two copies, or the copies are drifting apart on purpose |
| A value passed down 3+ levels that the middle never uses | **Context / dependency injection** (FE: context or store; BE: pass it in the constructor or the request) | 1–2 levels: keep passing it |
| Behavior depends on a status with rules about which moves are legal | **State machine** (a transitions table) | Two states and one flag |
| Wrapping calls with the same before/after (logging, retry, auth, timing) | **Decorator** / middleware / higher-order function | One call site |

## SOLID, in plain terms (use it as a check, not a checklist to satisfy)
- **Single responsibility:** a module has one reason to change. Test: can you name it without "and"?
- **Open/closed:** adding a new *kind* shouldn't mean editing a switch in five files. Only matters where new kinds really arrive.
- **Liskov:** a replacement must honor what the original promised (same inputs are accepted, same errors are thrown).
- **Interface segregation:** don't make callers depend on functions they never use. Pass what's needed.
- **Dependency inversion:** core logic shouldn't import the database driver or HTTP client directly **when you need to swap or fake it** (tests, a second provider). Otherwise, import it directly.

## Reuse: where shared code lives
Look before you write (ponytail rung 2): Grep for an existing helper, hook, service or type first.

| Used by | Put it |
|---|---|
| One module | Inside that module, not exported |
| One feature | The feature's own folder (`features/<name>/…`) |
| 2+ features | A shared folder (`shared/`, `lib/`, `common/`, whatever the repo already uses) |
| Frontend **and** backend | Shared types or schemas (a shared package, generated API types, or the validation schema reused on both sides). Never hand-copy the same type into both. |

- Extract for reuse only when the second real caller exists. A "reusable" module with one caller is a guess.
- A shared module has no knowledge of its callers: no imports back into features.
- Configuration over copies: when two components differ only in text or a value, add a prop or parameter. When they differ in **behavior**, keep them separate or compose them; don't grow a flag per caller.

## Layering and structure
- **Group by feature, then by layer** (`orders/api.ts`, `orders/service.ts`), not one global folder per layer, unless the repo already does it the other way. Follow the repo.
- Dependencies point **inward**: UI/routes → logic/services → data access. Logic never imports UI or route code.
- Add a layer only when it has a job: a service layer earns its place when the same rules are called from 2+ entry points, or when they need testing without HTTP. A pass-through layer that only forwards calls is an anti-pattern.

## Anti-patterns to flag in review
- An interface or abstract class with one implementation (and no fake in tests)
- Generic "manager", "helper", "utils" modules that collect unrelated functions
- A god object or file (the thing every change touches)
- A boolean flag parameter that switches the function's behavior (split it into two functions)
- Inheritance for reusing code (prefer composition)
- A pattern named in the code (`OrderStrategyFactoryProvider`) with nothing to vary
- Premature DRY: merging two blocks that only look alike, then adding flags to separate them again

## Reporting
In review or refactor reports, write each finding as `file:line - smell - pattern (or "leave it") - why`. Say when you **chose not** to apply a pattern and which trigger would change that.
