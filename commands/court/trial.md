---
description: "Court: put any work (idea, plan, spec, code, design, or last result) on trial - intake questions, then a live trial in a split terminal (one pane each for clerk, attacker, defender and judge)"
argument-hint: "<work to judge: text, file path, or 'last result'> [--rounds N] [--tabs] [--no-intake] [--no-tabs]"
---

Run a court trial on: $ARGUMENTS

Keep tokens low. Pass agents only what is listed here, never the whole conversation. Never read the briefs yourself unless the user asks.

1. **Subject.**
   - Inline text: use as-is.
   - File or folder path: pass the paths only.
   - `last result`, or nothing: the most recent agent output or answer in this conversation.
2. **Intake.** Skip this step with `--no-intake`.
   - Call **trial-agent**, operation `questions`, with the subject.
   - If it returns `QUESTIONS`, ask them all in **one** AskUserQuestion call.
3. **Case File.** Call **trial-agent**, operation `casefile`, with the subject and the answers. It returns the Case File text.
4. **Launch.** Skip this step with `--no-tabs`. Do it yourself in this session. Do not hand it to a subagent, because a subagent cannot open terminal windows reliably.
   - Create `docs/court/<slug>-<yyyyMMdd-HHmm>/` under the project root (the current working directory). `<slug>` is the Case File title in lowercase-kebab.
   - Write the Case File to `casefile.md` in that folder.
   - Run with the PowerShell tool:
     ```
     powershell -ExecutionPolicy Bypass -File "$HOME\.claude\skills\court-terminal\scripts\start-trial.ps1" -Dir "<folder>" -Rounds <N> -ProjectDir "<project root>" -Layout <tabs|split>
     ```
     `-Rounds` comes from `--rounds N` (default 2, max 5). `-Layout` is `tabs` with `--tabs`, otherwise `split`.
   - If the script errors, go to step 6.
5. **Wait.** Once it prints `Trial started`:
   - Tell the user in one line that the `court` terminal window is open: as a 2x2 split, or as tabs (`--tabs`). Name the colors: Attacker red, Defender blue, Judge yellow, Clerk gray.
   - Run the wait command from the `court-terminal` skill **once**, in the background, on `<folder>\trial.done`.
   - When it finishes, read `status.md`. If it says `done`, also read `verdict.md`.
6. **In-session fallback.** Use this for `--no-tabs`, a launch error, or a `failed` status. Run the same trial with subagents:
   - For each round: **lawyer-attacker** gets the Case File plus the previous defense brief. Stop if it says `No further material holes.`
   - **lawyer-defender** gets the Case File, its previous brief, and this round's attack brief.
   - Then **judge** gets the Case File plus all the briefs.
7. **Report**, briefly:
   - Ruling and confidence
   - Rounds run, and whether the trial ended early
   - Sustained holes, one line each
   - Required actions
   - The judge's FINAL VERSION
   - The trial folder path, which holds the full record

**Flow log:** load the `flow-log` skill and keep this run's `FLOW.md` current: create it when the run starts, then update it at every step, gate, pause and finish. Show its path in your first message.
