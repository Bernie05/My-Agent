---
description: "Flow: comprehensive project report - executive summary, results, quality metrics, risks, recommendations"
argument-hint: "[feature]"
---

**Feature folder:** `docs/features/<slug>/` in the current project. Resolve the slug: if the first word(s) of the arguments match an existing folder there, use it; otherwise, if exactly one feature folder exists, use it; otherwise use the one whose `PROJECT_CONTEXT.md` is newest. If still ambiguous, ask the user.

Arguments: $ARGUMENTS

Read all feature files and write `docs/features/<slug>/REPORT.md`:

1. **Executive summary**: what was built, current phase, go/no-go.
2. **Scope delivered**: requirements R# ✅ / partially / not done; changes from CHANGE HISTORY.
3. **Work by agent**: tasks completed, open, blocked.
4. **Quality**: QA results per category, issues by severity and status, test counts.
5. **Decisions and deferred items**: with links to SPEC.md decisions.
6. **Risks and known issues**.
7. **Recommendations and next steps**.

Base everything on the files; mark anything you couldn't verify. Then show the user the executive summary and a link to REPORT.md.
