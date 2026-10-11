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
