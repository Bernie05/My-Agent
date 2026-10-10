# Skill tests (evals)

Small, self-contained tasks that show whether a skill change made it **better or worse**. `/factory:needed` runs them before and after changing a skill that has a file here, and blocks the change if the score drops.

## Format: `<skill>.md`
```
### C1: <short name>
Prompt: <a self-contained task; no repo access needed>
Checks:
- <objective check a grader can verify from the output alone>
```
2–4 cases per skill, 3–6 checks each. Checks must be **verifiable** ("returns 201 for create"), never taste ("code is clean").

## How a run works
1. For each case, a general-purpose subagent gets the skill's `SKILL.md` (old version from `git show HEAD:<path>`, new version from the working tree) plus the Prompt, and answers. Same model for both.
2. A separate grader subagent sees only the Checks and the answer (not which version produced it) and marks each check pass/fail with a one-line reason.
3. Score = checks passed / total, per version. The change passes if new ≥ old and no case loses a check it passed before; otherwise the row is marked `failed: regression` with the lost checks.

Add a file here when a skill matters enough that a bad edit would hurt. Keep cases short: each one costs two answers and two gradings per run.
