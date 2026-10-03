---
description: "Flow: show status, progress, blockers and recent activity for a feature (or all features)"
argument-hint: "[feature | all]"
---

Arguments: $ARGUMENTS

Read-only; don't call agents, just read the files directly.

- If the argument is `all` or there are several features and none is named: list every folder in `docs/features/` with Phase, Mode, overall % and open issue count (one row each).
- Otherwise, for the resolved feature (`docs/features/<slug>/`), read PROJECT_CONTEXT.md (it already has progress and sections). Only Grep the task files or issues.md if a number is missing, and read just the last ~15 lines of activity.log. Show:

```
<Feature> — Phase: <phase> · Mode: <mode> · Gates: G0 ✅|n/a G1 ✅ G2 ✅ G3 ⏳
Design     <source: figma | frontend> <DESIGN.md status + Figma link or preview route, or "no design stage">
Scope      all | per-section — current: SEC-n <name>
Sections   SEC-1 ✅ · SEC-2 🔄 · SEC-3 ⏳   (per-section only)
Progress   Frontend x/n (x%) · Backend x/n (x%) · QA x/9 · Overall x%
Agents     figma-designer: <last action> · architect: <last action> · frontend-dev: <current/last task> · backend-dev: ... · qa-agent: ...
Blockers   <who is waiting on what> (or none)
Issues     open: CRITICAL x HIGH x MEDIUM x LOW x
Recent     <last 5 activity.log lines>
Next       <suggested command>
```

Assess the pace as on track / at risk / behind only if the spec has dates; otherwise leave it out.
