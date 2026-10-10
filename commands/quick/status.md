---
description: "Quick: show the status of a quick-team project from its PLAN.md"
argument-hint: "[feature | all]"
---

Arguments: $ARGUMENTS

Read-only: don't call agents. Resolve the folder in `docs/features/` (the named one, the only one with a `PLAN.md`, or the newest `PLAN.md`); `all` → one row per folder with a `PLAN.md`: Phase and tasks done/total.

For one project, read only the header, the Tasks table and the last 5 Log lines of `PLAN.md`, and show:
```
<Project> — Phase: <phase> · Status: <plan status> · Dev team: <fullstack|split> · Design: <none|frontend>
Tasks      Backend x/n · Frontend x/n · blocked: <IDs or none>
Deploy     <preview|production URL, skipped, n/a, or — if not reached>
Recent     <last 5 Log lines>
Next       <suggested command>
```
