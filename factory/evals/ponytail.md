### C1: Cache an API call
Prompt: In a Python project, `get_user(user_id)` calls a slow HTTP API and is called many times with the same ids during one process run. Add caching. No other code exists yet.
Checks:
- Uses the standard library (`functools.lru_cache` or `functools.cache`), not a hand-written cache class
- Adds no new dependency
- Explanation after the code is 3 lines or fewer
- Names what was skipped (e.g. TTL/expiry) and when to add it

### C2: Date input
Prompt: React form needs a field where the user picks a date of birth. The project has no date library installed.
Checks:
- Uses the native `<input type="date">`
- Does not add a date-picker package
- Keeps a visible label for the field

### C3: Don't cut what matters
Prompt: Write the minimal Express handler for `POST /login` that checks an email and password against a `users` table through an existing `db.query(sql, params)` helper.
Checks:
- Validates that email and password are present and returns 400 if not
- Uses a parameterized query (no string concatenation of user input into SQL)
- Compares the password with a hash function, not plain-text equality
- Does not add abstractions such as a repository class or interface for this single use
