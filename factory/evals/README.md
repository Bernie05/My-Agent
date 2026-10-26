# Skill tests (evals)

Small, self-contained tasks that show whether a skill change made it **better or worse**. `/factory:needed` runs them before and after changing a skill that has a file here, and blocks the change if the score drops. Suite growth and the held-out split are adapted from [auto-harness](https://github.com/neosigmaai/auto-harness) (MIT).

## Two sets per skill
| File | Who sees it | Purpose |
|---|---|---|
| `<skill>.md` (**seen**) | anyone, including the factory | Known cases; grows as fixed problems are promoted (below) |
| `held-out/<skill>.md` | **the grader only**: the agent-factory never reads `held-out/` | Checks the change generalizes instead of being tuned to the seen cases |

## Format
```
### C1: <short name>   (from N-x)   ← the tag only on promoted cases
Prompt: <a self-contained task; no repo access needed>
Checks:
- <objective check a grader can verify from the output alone>
```
Case IDs are unique across both files of a skill. 3–6 checks each. Checks must be **verifiable** ("returns 201 for create"), never taste ("code is clean").

## How a run works
1. For each case (seen and held-out), a general-purpose subagent gets the skill's `SKILL.md` (old version from `git show HEAD:<path>`, new version from the working tree) plus the Prompt, and answers. Same model for both.
2. A separate grader subagent sees only the Checks and the answer (not which version produced it) and marks each check pass/fail with a one-line reason.
3. Score = checks passed / total, per version, reported as `seen x/y · held-out x/y`. The change passes if new ≥ old on **both** sets and no case loses a check it passed before; otherwise the row is marked `failed: regression` with the lost checks.

## Growing the suite (promotion)
When a `fix`, `stale` or `context` row on a skill passes, the main session turns the row's Evidence into **one** new seen case (`(from N-x)`) and runs it on the old and new versions:
- fails on old, passes on new → **promote** it: append it to `<skill>.md` (create the file with that case if the skill had none).
- passes on both → don't add it (it doesn't test the fix); fails on both → don't add it, and note it in `factory/LEARNINGS.md`.

So every fixed problem stays fixed: a later change that brings it back fails the gate.

Add a held-out case by hand when a skill's seen file reaches 4+ cases and its held-out file has only one. Keep cases short: each costs two answers and two gradings per run.

## Probing: two candidates for uncertain changes
Adapted from Harness² (Apache-2.0), its Propose → Probe → Compose step. When a fix is uncertain, build two **different** versions and let the same tests pick, instead of building one and hoping.

**When** (`/factory:needed` decides; `/factory:improve --probe` forces it): the row is Level `L2` or higher, or `factory/LEARNINGS.md` already has a `failed ✗` for its Type + Target, or Your notes say `probe`. Plain L1 wording fixes stay single-candidate (cheaper).

**How**
1. **Propose:** ask the factory for a PROPOSAL with an `Alternative B` (a genuinely different approach, not a rewording).
2. **Build A**, copy every file it changed to `factory/probe/<ID>/A/<same path>`, then restore those files (`git checkout -- <paths>`, delete new files). **Build B** the same way into `factory/probe/<ID>/B/`. (`factory/probe/` is git-ignored scratch.)
3. **Probe:** run the seen + held-out cases on old, A and B (the grader is blind to which is which). For an agent or command target, the answering subagent gets that file instead of a `SKILL.md`. No eval file for the target → first write one temporary case from the row's Evidence (Prompt + 3–5 checks) and use it for all three.
4. **Pick:** a candidate qualifies only if it scores ≥ old on both sets and loses no check old passed. None qualifies → `failed: regression` (both scores in LEARNINGS). Otherwise the higher score wins; a tie goes to the smaller always-on cost (fewer lines in the description and preloaded text), then the smaller diff (Ponytail).
5. **Compose (optional, once):** if A and B each win checks the other loses, ask the factory for one combined version and test it the same way; keep it only if it beats both.
6. Apply the winner, delete `factory/probe/<ID>/`, and record in `factory/LEARNINGS.md`: `**Probe:** A (<approach>) x/y · B (<approach>) x/y [· C x/y] → chose <X> because <the check that decided it>`. The contrast is the lesson: it says *which kind* of change works for this target.

Cost: about one extra build and one extra eval run per probed row, only during the weekly build.
