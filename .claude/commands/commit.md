---
description: Create a Conventional Commits message from the staged (or all) changes and commit
argument-hint: "[optional hint about intent]"
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*)
---

Intent hint from me (may be empty): $ARGUMENTS

## Context
- Status: !`git status --short`
- Staged diff: !`git diff --cached`
- Unstaged diff: !`git diff`
- Recent commits (match their style): !`git log --oneline -10`

## Task
1. If nothing is staged, stage the related changes. If the changes cover unrelated concerns, propose splitting them into separate commits and ask me first.
2. Never stage secrets or local env files (`.env*`, keys, credentials). Warn me if any are present.
3. Write the message in Conventional Commits format:
   ```
   <type>(<optional scope>): <imperative summary, ≤ 72 chars>

   <body: what changed and WHY, wrapped at 72 chars — omit for trivial changes>
   ```
   Types: `feat`, `fix`, `refactor`, `test`, `docs`, `style`, `perf`, `build`, `ci`, `chore`. Add `!` and a `BREAKING CHANGE:` footer for breaking changes.
4. Commit, then show the result with `git log -1 --stat`.
