---
name: token-efficiency
description: Rules for keeping token usage and cost low in the multi-agent flow - read only what's needed, load skills on demand, keep reports short, and avoid unnecessary agent calls. Preloaded into every agent; also apply it in the main session when orchestrating /flow, /arch, /design, /fe, /be and /qa commands.
---

# Token Efficiency

Every file read, preloaded skill, agent call and long reply costs tokens. Do the same work with less context.

## Reading
1. **Start from the index.** Read `PROJECT_CONTEXT.md` first: it holds phase, sections, task status and blockers. Open other files only when the task needs them.
2. **Search, then read a slice.** Grep for the task ID, requirement (R#), scenario (SC-#), screen (S#) or symbol, then Read with `offset`/`limit` around the hit. Don't read whole large files to find one section.
3. **Scope to the current work.** In per-section mode, read only the current section's tasks, requirements and scenarios.
4. **Never re-read** a file you already have in context unless it changed. For logs, read only the tail (`activity.log`: last ~15 lines).
5. **Skip generated and vendor files**: `node_modules`, `dist`, `build`, lockfiles, `.next`, coverage and minified bundles.
6. **Batch independent lookups** into one message (several Grep/Read calls at once) instead of one per turn.

## Skills
- Agents preload only their core skill(s). Load any other skill with the Skill tool **only when the current operation needs it**. Each agent's instructions list which skill goes with which operation.
- Stack-specific skills (react-*, shadcn-ui, material-ui, supabase-mcp, frontend-design, browser-testing) are loaded only when the stack or task matches. Load only one UI library skill.

## Missing skill: request it, don't improvise (agents)
If the task needs know-how or a reusable procedure that no listed skill covers (a new library, service, file format, workflow) and guessing would risk wrong or unsafe output, ask for one. Don't request a skill for a one-off answer you can get from the repo or the docs.
- **Preflight (before you start):** first, before writing or changing anything, list the know-how the task needs and check it against the `~/.claude/skills/*/SKILL.md` descriptions with Grep. If there's a gap, stop right away and return only the block(s) below with `Resume: not started (preflight)`. Do no work first.
- **Gap found mid-task** (preflight couldn't see it): finish everything the gap doesn't block, then stop and return the block(s).

Put one block per needed item at the top of your report (max 3). Each block must stand on its own, because the factory works from it:
```
NEEDS: skill | command | agent
Name: <proposed kebab-name>   For: <task ID or one line>
Summary: <one plain sentence: what it is and what it lets you do>
Why: <what's missing; what you'd get wrong without it>
Must cover: <3-5 short bullets>
Resume: <the step you stopped at, files touched so far>
```
The main session has agent-factory build it, then hands the task back to you. On resume, load the new skill with the Skill tool, or Read `~/.claude/skills/<name>/SKILL.md` if the tool doesn't list it yet, and continue from `Resume`.

## Writing
- Edit files in place with small Edits. Don't rewrite a whole file to change a few lines.
- Specs, tasks and reports stay proportional to the feature: tables and bullets, no filler, no repeating content that's already in another file. Link to it instead (`see SPEC.md > Permissions`).
- **Report back in 15 lines or fewer**, using the agent's report format. Put details in the files, not in the reply.

## Code output (Ponytail)
- Generated code is output tokens too. The developer agents preload the `ponytail` skill: climb the ladder (YAGNI → reuse → stdlib → native → installed dep → one line → minimum) and write the shortest diff that meets the spec.
- After code, explain in at most 3 lines (`skipped: X, add when Y`), not paragraphs.
- Spec requirements, validation, security and accessibility are never cut to save tokens.
- Pass `ponytail: lite|ultra|off` in a command's arguments to change the level for that call. The default is `full`.

## Orchestration (main session)
- **Don't spawn an agent for bookkeeping.** Do progress checks, status, checklist updates and log appends directly: they only read or edit a few lines. Spawn agents for real work (spec writing, coding, testing, design, triage).
- **Pass pointers, not content.** Give agents the feature slug, IDs (F3, SC-5, SEC-2) and file paths, not pasted file contents.
- **One agent call per unit of work.** Give a complete, specific instruction so the agent doesn't need a second round-trip. Batch several tasks for the same agent into one call.
- Run independent agents in parallel in one message. That saves wall time, and each agent starts with a small context.
- Prefer **per-section** implementation for large features. Each round then works on a small slice, and problems surface before they multiply.
- Relay agent reports as a short summary, not verbatim.
- **`NEEDS:` in a report** (an agent asks for a new skill, command or agent):
  1. Don't fill the gap yourself. Tell the user in one line which agent paused and why (preflight or mid-task).
  2. For each NEEDS block, call **agent-factory** with operation `create-<type>`: `Requested by: <agent> (<agent id>) for <task>` plus that block. It only proposes, writes nothing, and reuses an existing safe item when one fits.
  3. **Hard stop: validate the skill.** Show each PROPOSAL as-is: what it is, the requesting agent, its outline (what the skill will teach), wiring, security and token cost. Ask in **one** AskUserQuestion call, per item: **Approve** / **Change** (the user says what; re-propose and stop again) / **Cancel**. Call `build` with `APPROVED:` only for approved items. Never skip or merge away this stop.
  4. **Hand back** after the build: SendMessage to the same agent id (its context is intact): `Resume: <its Resume line>. New <type>: <name> at <path>; load it and continue.` (preflight: `start the task now`). List any cancelled items as `Not created: <names>; treat those gaps as assumptions.` If the agent can't be resumed, start it again with the original task plus that line. For a new **agent**, run it on the gap first, then pass its result back the same way.
  5. If the user approves nothing, resume the agent with `No new skill: continue with what you have and list the gaps as assumptions.`
  - At most one factory round per agent call. A second NEEDS for the same gap goes to the user.
  - **Team-check hires** (`Resume: none`, from the architect's analyze or plan-lite): handle them at that gate, not mid-task. Include the `Wire into:` line in the factory call so the new skill lands in those agents' load-on-demand tables. Skip step 4: there's no hand-back. Continue the flow, and the named agents load the skill when their work starts. Cancelled gaps become assumptions in SPEC.md → Open Questions.

## Models
The agents' `model:` fields route routine work (coding, testing, design execution) to a cheaper model. The architect inherits the main model, because spec quality drives everything downstream. Don't override this per call unless the user asks.
