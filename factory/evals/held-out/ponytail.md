# ponytail (held-out)

Grader-only cases: the factory never reads this folder, so a skill can't be tuned to pass them.

### C3: Don't cut what matters
Prompt: Write the minimal Express handler for `POST /login` that checks an email and password against a `users` table through an existing `db.query(sql, params)` helper.
Checks:
- Validates that email and password are present and returns 400 if not
- Uses a parameterized query (no string concatenation of user input into SQL)
- Compares the password with a hash function, not plain-text equality
- Does not add abstractions such as a repository class or interface for this single use
