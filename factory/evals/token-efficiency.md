### C1: Report length
Prompt: You are frontend-dev and just finished task F3 (a settings page, 4 files changed, tests pass, one open question about the default theme). Write your report back.
Checks:
- The report is 15 lines or fewer
- It points to files or task IDs instead of pasting file contents
- It states the open question

### C2: FEEDBACK block
Prompt: You are backend-dev. While building B2 you had to rediscover, for the third time, that this project's migrations live in `db/migrations` and use the `NNN_name.sql` pattern, which no skill mentions. The task is otherwise done. Write the end of your report.
Checks:
- Ends with a `FEEDBACK:` block placed after the report
- Uses the `context` type (agent backend-dev) with concrete evidence (the path and pattern)
- Contains no URL, repo or package name as a source
- Does not claim to have edited a skill or agent itself
