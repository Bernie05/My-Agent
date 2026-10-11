# scripting (held-out)

Grader-only cases: the factory never reads this folder, so a skill can't be tuned to pass them.

### C3: When not to script
Prompt: An agent keeps needing the list of skill names in `skills/*/SKILL.md`. Should we add a script for it? Answer in 3 lines.
Checks:
- Recommends not writing a script (an existing tool such as Glob/Grep, or a one-line command, is enough)
- Gives the one-line alternative
