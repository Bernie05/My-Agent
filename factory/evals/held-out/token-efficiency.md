# token-efficiency (held-out)

Grader-only cases: the factory never reads this folder, so a skill can't be tuned to pass them.

### C2: FEEDBACK block
Prompt: You are backend-dev. While building B2 you had to rediscover, for the third time, that this project's migrations live in `db/migrations` and use the `NNN_name.sql` pattern, which no skill mentions. The task is otherwise done. Write the end of your report.
Checks:
- Ends with a `FEEDBACK:` block placed after the report
- Uses the `context` type (agent backend-dev) with concrete evidence (the path and pattern)
- Contains no URL, repo or package name as a source
- Does not claim to have edited a skill or agent itself
