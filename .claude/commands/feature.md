---
description: Plan, build, test, and review a feature end to end on its own branch
argument-hint: <feature description>
---

Build this feature: $ARGUMENTS

Work through these phases in order. Stop and ask me at each **checkpoint** before moving on.

## 1. Understand
- Read the relevant parts of the codebase and `CLAUDE.md` (if present) to learn the existing patterns, folder structure, and conventions.
- Restate the feature as concrete acceptance criteria. List any open questions.
- Create a branch: `feat/<short-kebab-name>` from the current default branch.

## 2. Design — checkpoint
- If the feature touches the database, consult the `database-architect` agent (and the `supabase` / `supabase-postgres-best-practices` skills): schema, migrations, RLS policies.
- If it adds or changes an API / server action, consult the `backend-architect` agent for the contract.
- Produce a short plan: files to create or change, data flow, and key design decisions with the trade-off behind each.
- **Checkpoint:** show me the plan and wait for approval.

## 3. Implement
- Follow the plan in small, coherent steps. Match the surrounding code style.
- Keep layers separate (UI → server action / route handler → service → data access); no business logic in components.
- Use the `frontend-developer` agent for UI work and apply the `vercel-react-best-practices` skill.

## 4. Test
- Use the `test-automator` agent to add unit tests for logic and integration tests for API / data paths. Cover happy path, edge cases, and errors.
- Run the project's test, lint, and typecheck scripts. Fix everything until they pass.

## 5. Review — checkpoint
- Run the `code-reviewer` agent on the diff; if auth, user data, or RLS is touched, also run `security-auditor`.
- Fix confirmed issues.
- **Checkpoint:** summarize what was built, the key decisions, and any follow-ups. Ask whether to commit (then use `/commit`).
