---
name: performance-optimization
description: Measure-first performance work across the stack - DB queries, API latency, caching, rendering, bundle and assets - with one loop (measure, fix the biggest cost, measure again) and before/after numbers. Also holds the shared plan → apply rules of the optimize operation (/fs:optimize, /fe:optimize, /be:optimize). Use for the performance and optimize operations of frontend-dev, backend-dev and fullstack-dev. Not for writing new features or for security or accessibility audits.
---

# Performance optimization

Speed comes from removing work, not adding machinery. This skill picks *which* cost to cut. The `ponytail` ladder decides how little code cuts it: an index before a cache, a native `loading="lazy"` before a lazy-load library, deleting a dependency before code-splitting it.

## The loop
1. **Pick the target.** Choose one user-visible path (page load, an endpoint, a job) and say what "fast enough" means: a budget, the spec's number, or "the slowest thing found".
2. **Measure before touching code.** Use the cheapest real tool the stack already has (table below). No numbers means no fix: report what you'd measure and how.
3. **Fix the biggest cost only.** Use the Pareto rule: one cause per step. Root cause over symptom (an N+1 is fixed in the query, not hidden behind a cache).
4. **Measure again** with the same tool, input and environment. A change that doesn't move the number gets reverted.
5. **Stop at the budget.** Past the budget, more speed is speculative (YAGNI).

| Layer | Measure with | Deep rules |
|---|---|---|
| DB | `EXPLAIN (ANALYZE)`, slow-query log, query count per request, Supabase performance advisors | `database-design` (indexes, N+1, pagination); `supabase-mcp` if Supabase |
| API | Request timings (server logs, `curl -w "%{time_total}"`), payload size, a profiler | `api-design` (pagination, filtering) |
| Caching | Hit rate, repeated identical calls in logs | `checklist.md` → Caching |
| UI render | React Profiler / browser Performance panel, re-render counts | `react-best-practices` (React), `frontend-component-development` |
| Bundle and assets | The bundler's analyzer or build output sizes, Lighthouse, Network panel | `checklist.md` → Bundle and assets |
| Data fetching (UI) | Network waterfall, duplicate requests | `frontend-api-integration`, `react-data-fetching` (React) |

Grep `checklist.md` for the layer's heading. Never read it whole.

## Cost order (cheapest fix first)
1. **Delete the work.** Unused queries, fields, dependencies, effects, re-fetches.
2. **Let the platform do it.** DB constraint or index, `SELECT` only the needed columns, HTTP caching headers, `loading="lazy"`, CSS over JS.
3. **Batch or move it.** Join or `IN (...)` instead of N queries, parallel instead of sequential awaits, work moved off the request path.
4. **Cache it.** Only after 1-3, only for data that's read far more than it's written, and always with a stated invalidation rule. `// ponytail: in-process cache, move to Redis at >1 instance`.
5. **New infrastructure** (queue, CDN, read replica): propose it in the report. Never add it in this operation.

## Rules
- Behavior stays identical: same output, same errors, same permissions. A faster result that changes behavior (staler data, different sort, dropped fields) needs the user's approval.
- Never trade away validation, permission checks, transactions or accessibility for speed.
- Report each fix as `file:line - cost - fix - before → after (tool)`.

## Optimize operation (shared by fe, be and fullstack)
The agent's own scope sets which areas apply: **frontend** = render, bundle, assets, component structure, UI patterns. **backend** = queries, indexes, API latency, caching, layering, service patterns. **fullstack** = both, plus the API contract between them.

**Phase 1: Plan (default; no code changes).**
1. Map the target: the folder structure, entry points and layers. Skip vendor and build output.
2. Run each lens and skip the ones the `focus:` argument excludes:
   - **perf:** the loop above, steps 1-2 only (measure, don't fix).
   - **structure:** layering, folder layout, naming, where shared code lives (`code-patterns`).
   - **patterns:** a pattern only where `code-patterns` → "When a pattern is earned" passes.
   - **best practices:** the stack skills the agent's load table names for this code.
   - **over-engineering:** `ponytail-audit` for the whole repo, `ponytail-review` for an area.
   - **robustness:** boundaries, swallowed errors, timeouts, retries, transactions (`code-quality` → Robustness lens).
   - **maintainability:** names, function size, dead code, consistency (`code-quality` → Maintainability lens).
   `focus:` takes perf|structure|patterns|robustness|maintainability|all (default all).
3. Write the plan file: `<feature folder>/OPTIMIZE.md` if a feature is named, otherwise `OPTIMIZE.md` at the repo root. Overwrite the previous plan, but keep rows already marked `done`. Use a table ranked by impact ÷ effort:
   `| O-# | Lens | file:line | Finding | Fix | Impact | Effort | Risk | Behavior change (y/n) | Status |`
4. Security or accessibility problems you spot go in the plan as `flag` rows pointing to `/<group>:security` or `/<group>:accessibility`. Don't fix them here.
5. Stop and report the top items. The user picks the O-# to apply.

**Phase 2: Apply (only the O-# named in the call).**
1. Run a baseline: build, lint and tests must pass first. If they already fail, stop and report.
2. Apply one O-# per step: the smallest diff, then build and tests. Perf items also get the re-measure. On failure, revert that step, mark it `failed` with the reason, and continue.
3. Rows marked `Behavior change: y` run only if the call names them. Never apply an O-# that wasn't named.
4. Set each row's Status (`done` / `failed` / `skipped`) and record before → after numbers in OPTIMIZE.md.
