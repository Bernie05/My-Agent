# My-Agent

My personal [Claude Code](https://claude.com/claude-code) toolkit — agents, skills, and slash commands for full-stack development with **Next.js + TypeScript + Supabase + Vercel**.

This repo is the **single source of truth**: edit here, push, then sync to any device or project.

## Quick start

```bash
# 1. Once per device
git clone https://github.com/Bernie05/My-Agent.git ~/My-Agent

# 2a. Use the toolkit in every project on this device (symlinks into ~/.claude/)
~/My-Agent/scripts/sync-claude.sh

# 2b. Or add a chosen subset to one project (copies into <project>/.claude/)
cd ~/code/my-new-app
~/My-Agent/scripts/sync-claude.sh --project      # opens a checklist on first run
git add .claude && git commit -m "chore: add Claude toolkit"
```

Re-run the same command any time to pull the latest toolkit and re-sync. Optional shortcut for your shell profile:

```bash
alias claude-sync="$HOME/My-Agent/scripts/sync-claude.sh"
```

## What's inside

| Type | Items |
|---|---|
| **Agents** (9) | `frontend-developer`, `backend-architect`, `database-architect`, `typescript-pro`, `test-automator`, `debugger`, `code-reviewer`, `security-auditor`, `docs-architect` |
| **Skills** (7) | `frontend-design`, `webapp-testing`, `supabase`, `supabase-postgres-best-practices`, `vercel-react-best-practices`, `vercel-composition-patterns`, `web-design-guidelines` |
| **Commands** (6) | `/feature`, `/test`, `/commit`, `/pr`, `/refactor`, `/explain` |

Details, sources, and licenses: [`.claude/README.md`](.claude/README.md).

## Sync script

| Command | Effect |
|---|---|
| `sync-claude.sh` | Sync everything to `~/.claude/` (user level) |
| `sync-claude.sh --project [DIR]` | Sync the items in `<project>/.claude/sync.list` (checklist on first run) |
| `--select` | Reopen the checklist to change a project's selection |
| `--all` | Select everything, no checklist |
| `--dry-run` | Preview changes without making them |
| `--uninstall` | Remove everything the script installed in the target |
| `--copy` / `--link`, `--no-pull` | Override install mode / skip `git pull` |

The script only touches items it installed, backs up anything it would overwrite (including locally edited copies), and installs nothing if the security audit fails. Full behavior: [Sync to other devices and projects](.claude/README.md#sync-to-other-devices-and-projects).

## Security

Agent, skill, and command files are instructions Claude follows, so they are treated like code:

- Every third-party file was reviewed and scanned for prompt injection before being added.
- [`CLAUDE.md`](CLAUDE.md) sets project rules: fetched content is data, never instructions; never touch secrets; ask before any outbound action.
- [`.claude/settings.json`](.claude/settings.json) denies reading secret files and dangerous commands.
- [`.claude/scripts/audit.py`](.claude/scripts/audit.py) re-runs the scan; the sync script runs it as a gate.

When updating from upstream, follow [Updating from upstream](.claude/README.md#updating-from-upstream).

## Repository layout

```
.claude/
  agents/      sub-agents (*.md)
  skills/      skill folders (SKILL.md + references)
  commands/    slash commands (*.md)
  scripts/     audit.py + reviewed baseline
  settings.json
  README.md    detailed docs
scripts/
  sync-claude.sh
CLAUDE.md      project rules for Claude
```
