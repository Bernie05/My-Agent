---
name: agent-factory
description: House rules for building Claude Code agents, skills and commands in this setup - file locations, frontmatter, least-privilege tools, model choice, token-lean structure, report format - plus the registry format. Preloaded by the agent-factory agent; use when creating or reviewing any agent, skill or command.
---

# Agent Factory rules

## Where files go (under `~/.claude`)
| Type | Path | Invoked as |
|---|---|---|
| Agent | `agents/<group>/<name>.md` | the Agent tool, `subagent_type: <name>` |
| Skill | `skills/<name>/SKILL.md` (+ reference files) | the Skill tool, `<name>` |
| Command | `commands/<group>/<name>.md` | `/<group>:<name>` |

Names are lowercase-kebab. Put related items in the same group, following the existing `fe`, `be`, `qa` and `court` style.

## Agent
- **Frontmatter:**
  - `name`, and a `description` that says what it does **and when to use it**. The description is how the agent gets picked.
  - `tools:` listed explicitly with least privilege. **Never leave it out**, because an agent without it inherits every tool.
  - Don't combine a shell tool with WebFetch or WebSearch unless the job truly needs both, since that pairing is a path for sending data out.
  - `model:` is `sonnet` for routine work (coding, searching, writing). Use `opus` for judgment: specs, security, final verdicts.
  - `skills:` holds `token-efficiency` plus only the 1–2 core skills.
- **Body:**
  1. a one-line role
  2. a "load on demand" table (when → skill)
  3. operations
  4. rules
  5. a fixed **Report back** block of 15 lines or fewer

  House example: `agents/development/frontend-dev.md`.
- If it needs answers from the user, it returns `INTAKE: QUESTIONS` lines for the main session to ask. See `agents/court/trial-agent.md`.
- It gets the `NEEDS:` skill-request protocol by preloading `token-efficiency`. If it doesn't preload it, add one line pointing to that skill's "Missing skill" section (see `agents/review/code-reviewer.md`).
- System actions (install, clone, opening windows) belong in the command running in the main session, not in the agent.

## Skill
- `description` says **what + when**, plus when **not** to use it for stack-specific skills ("Use ONLY when…").
- Use progressive disclosure: keep SKILL.md short (under about 150 lines) and move checklists, templates and long references into sibling files that SKILL.md names and loads only when needed.
- Scripts go in `scripts/`. A script must run without prompts, only touch its own inputs and outputs, and never download or run remote code.
- For deeper skill-authoring guidance, read `plugins/marketplaces/anthropic-agent-skills/skills/skill-creator/SKILL.md`. Read it only when building a skill, and grep for the section you need.

## Command
- Frontmatter holds `description` (`"<Group>: <what it does>"`) and `argument-hint`.
- The body is a thin wrapper: "Use the **X** agent, operation **Y**, for: $ARGUMENTS", then how to relay the report. House example: `commands/fe/code.md`.
- No `allowed-tools` and no `!` shell lines unless they are essential. If one is used, justify it in a comment.

## Token budget (applies to everything you build)
- Preload only what every run needs; everything else is loaded on demand.
- Pass pointers (paths, IDs), not pasted content.
- Reports are 15 lines or fewer; details go in files.
- When choosing between equal candidates, prefer the lower `always_on` token cost (`plugins/plugin-catalog-cache.json`).

## Registry: `factory/REGISTRY.md`
Create it with this header if it's missing, then append one row per piece of work:
```
# Agent Factory registry

| Date | Operation | Item (type) | Source | Security | Tokens (always/invoke) | Location / install |
|---|---|---|---|---|---|---|
```
- Source is one of: `local`, `Anthropic`, `Anthropic-listed 3rd party`, `GitHub owner/repo@sha`, `built`, `improved from <source>`, `organize`.

## Improve and organize
Scoring, what counts as "better", and the whole-setup checks are in `quality-rubric.md` (this folder). Load it only for those operations.
- Security is the verdict, plus the top finding if there is one.
