---
description: Draft a pull request title and description for the current branch
argument-hint: "[base branch — defaults to main]"
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*)
---

Base branch: $ARGUMENTS (default `main` if empty).

1. Gather context: `git log <base>..HEAD --oneline` and `git diff <base>...HEAD --stat`, then read the significant hunks.
2. If a PR template exists (`.github/pull_request_template.md` or `.github/PULL_REQUEST_TEMPLATE/`), follow its structure. Otherwise use:

   ```markdown
   ## Summary
   <1–3 sentences: what this PR does and why>

   ## Changes
   - <grouped by area: UI, API, DB, tests>

   ## Design decisions
   - <non-obvious choices and the trade-off behind each>

   ## How to test
   1. <steps a reviewer can follow>

   ## Checklist
   - [ ] Tests added/updated and passing
   - [ ] Lint and typecheck pass
   - [ ] DB migrations included (if schema changed) and RLS enabled on new tables
   - [ ] No secrets or debug code committed
   ```
3. Title in Conventional Commits style (e.g. `feat(auth): add password reset flow`).
4. Show me the draft. Only push or open the PR if I explicitly ask.
