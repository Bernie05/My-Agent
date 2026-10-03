---
name: court-terminal
description: Run a court trial (lawyer-attacker vs lawyer-defender rounds, then the judge) live in Windows Terminal - one tab or split pane per agent plus a Clerk - so the user can watch the collaboration. Use when /court:trial launches a trial from a Case File. Launch from the main session, not a subagent.
---

# Court terminal

A trial runs outside the Claude session as headless `claude -p --agent <name>` processes. The work is split across one Windows Terminal window named `court`, as a 2x2 split in one tab (`-Layout split`, default) or 4 tabs (`-Layout tabs`):

| Pane | Color | Runs | Shows |
|---|---|---|---|
| Clerk | gray | `scripts/clerk.ps1` | Case File, the order of the steps, errors |
| Attacker | red | `scripts/agent-tab.ps1 -Agent lawyer-attacker` (sonnet) | each attack brief |
| Defender | blue | `scripts/agent-tab.ps1 -Agent lawyer-defender` (sonnet) | each defense brief + enhanced version |
| Judge | yellow | `scripts/agent-tab.ps1 -Agent judge` (opus) | the verdict |

Each agent pane shows every step as QUESTION (what the agent was asked, Case File replaced by a note, cut to 40 lines) then ANSWER (its full brief).

Split layout: Clerk | Attacker on top, Judge | Defender below. If Windows Terminal is missing, each role gets its own PowerShell window instead.

## Launch
1. Make a **new** trial folder in the project: `docs/court/<slug>-<yyyyMMdd-HHmm>/`.
2. Write the Case File to `<folder>/casefile.md`.
3. Start the trial. This returns right away:
   ```
   powershell -ExecutionPolicy Bypass -File "$HOME\.claude\skills\court-terminal\scripts\start-trial.ps1" -Dir "<folder>" -Rounds <N> -ProjectDir "<project root>" -Layout <tabs|split>
   ```
   `-Rounds` defaults to 2 and is clamped to 1–5. The agents run in `-ProjectDir`, so paths in the Case File are resolved against it.

## Wait for the result
The trial is over when `<folder>/trial.done` exists. Wait for it with **one** background command, never repeated polling calls:
```
$f="<folder>\trial.done"; $t=(Get-Date).AddMinutes(60); while(-not(Test-Path $f) -and (Get-Date) -lt $t){Start-Sleep 5}; Get-Content "<folder>\status.md"
```
Run it with `run_in_background: true`; you are notified when it exits.

## Read only what you need
- `status.md`: `done` (plus rounds and early stop) or `failed` plus the reason
- `verdict.md`: the judge's verdict. Read this, and not the briefs, to keep tokens low. The Clerk opens it for the user automatically (VS Code, else Notepad) when the trial ends.
- Briefs: `lawyer-attacker.r<n>.out.md`, `lawyer-defender.r<n>.out.md`, `judge.final.out.md`. Open them only if the user asks.
- Failures: `<agent>.<step>.err.md` holds the CLI error. A step times out after 15 minutes.

The folder is the full trial record; nothing else needs saving.
