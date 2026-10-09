# My-Agent

My personal [Claude Code](https://claude.com/claude-code) setup: agents, skills and slash commands for a gated design → spec → build → QA → deploy workflow.

This repo **is** `~/.claude`. Edits in `~/.claude` are edits to the repo. Everything Claude Code finds there is available in every project on that machine.

## What's inside

| Folder | Contents |
|---|---|
| `agents/` | Specialist agents (architect, frontend-dev, backend-dev, fullstack-dev, qa-agent, figma-designer, court, agent-factory, …) |
| `skills/` | Skills the agents load on demand |
| `commands/` | Slash commands (`/flow:*`, `/arch:*`, `/fe:*`, `/be:*`, `/qa:*`, `/factory:*`, …) |
| `docs/` | [AGENT-SYSTEM.md](docs/AGENT-SYSTEM.md): how the workflow fits together |
| `factory/` | `REGISTRY.md`: every agent/skill/command built or reviewed, with its security verdict. `NEEDED.md`: agent feedback waiting for your review; a weekly routine builds the rows you approve and opens a PR |

One-line reference for everything: [CATALOG.md](CATALOG.md).

After editing anything, run `python3 factory/scripts/check.py`: it catches stale counts, undocumented items, agents without a `tools:` line, oversized skills and broken links.

## Daily use

```bash
cd ~/.claude
git pull                                   # get changes made on GitHub or another PC
# ...edit agents / skills / commands...
git add -A && git commit -m "..." && git push
```

## Set up on another machine

If `~/.claude` already exists there (Claude Code creates it), link it without overwriting anything:

```bash
cd ~/.claude
git init -b master
git remote add origin https://github.com/Bernie05/My-Agent.git
git fetch origin
git reset origin/master    # link to the repo; local files untouched
git status                 # review the differences
git checkout -- .          # then take the repo's version of the changed files
```

## What is never committed

`.gitignore` is an allow-list: only the folders above, `CLAUDE.md`, `CATALOG.md` and this README are tracked. Credentials, settings, sessions, history, project memory and the plugin cache stay on each machine.
