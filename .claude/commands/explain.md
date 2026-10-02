---
description: Explain code, its design patterns, and the reasoning behind it (learning mode)
argument-hint: <file, function, folder, or concept>
---

Explain: $ARGUMENTS

I know programming fundamentals; skip beginner material. Read the code first, then structure the explanation as:

1. **Purpose** — what this code is responsible for, in 2–3 sentences, and where it sits in the architecture (UI, server, data, shared).
2. **Flow** — walk through the main execution / data flow step by step, referencing `file_path:line_number`. Add a Mermaid diagram if more than three pieces interact.
3. **Patterns & conventions** — name each design pattern or framework convention in use (e.g. Repository, Server Component vs Client Component, compound components, RLS policy), why it fits here, and what the alternative would have been.
4. **Gotchas** — non-obvious behavior, edge cases, or likely bugs.
5. **Improvements** — anything that violates best practice, with the principle behind it. Do not edit files; only explain.
6. **Check yourself** — two short questions I should be able to answer after reading this.
