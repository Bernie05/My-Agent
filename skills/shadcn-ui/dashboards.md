# shadcn/ui: dashboards and charts

Load this from `SKILL.md` for dashboards, analytics pages, KPI tiles and charts in a shadcn project. This file covers how to build them. For design judgment (hierarchy, density, scanability) use `impeccable` in Operate mode. For which chart fits the data, colors, legends and stat-tile design, use `dataviz`.

**Reuse first (Ponytail), in this order:** a shadcn block or chart → a Tremor Raw component for what shadcn lacks → hand-written Recharts. Stop at the first one that fits.

## 1. Layout
- Start from blocks, don't build a shell: `npx shadcn@latest add dashboard-01` (sidebar, KPI cards, interactive area chart, data table) or a `sidebar-*` block, then delete what the spec doesn't need. Check `ls components/ui` and existing layouts first.
- Page = header (title, date range, filters, primary action) → KPI row → main chart(s) → detail table. Use a responsive CSS grid (`grid gap-4 md:grid-cols-2 xl:grid-cols-4`); cards stack to one column on mobile.
- Filters, date range and tabs live in the URL search params, so views can be shared and the back button works. Native first: read them with the router, don't add a state library for it.
- KPI tile = `Card` with label, value, delta (sign + text, not color alone) and the comparison period. Format numbers with `Intl.NumberFormat` (compact, currency, percent), never by hand.

## 2. Charts: shadcn `chart` first
- `npx shadcn@latest add chart`. It wraps Recharts: `ChartContainer` + a `ChartConfig` + `ChartTooltip`/`ChartTooltipContent` + `ChartLegend`/`ChartLegendContent`.
- Colors come from the theme: `--chart-1` … `--chart-5` in the global CSS. In `ChartConfig` use `color: "var(--chart-1)"` (Tailwind v3 projects: `"hsl(var(--chart-1))"`, match what the file already uses), then reference series as `var(--color-<key>)`. No hex values in feature code.
- `ChartContainer` needs a height (`className="h-[250px] w-full"` or `aspect-*`), or the chart renders at 0 px.
- Turn on `accessibilityLayer` on the Recharts chart (keyboard and screen reader support).
- Charts are client components: keep the page a server component that fetches and shapes the data, and pass plain arrays to a small `"use client"` chart leaf.
- Chart pattern library: copy from the shadcn charts gallery with the CLI or MCP (area, bar, line, pie, radar, radial), not from memory.

## 3. Tremor Raw: only for the gaps
Use it only for parts shadcn has no equivalent for, e.g. `BarList`, `Tracker`, `SparkChart` (Area/Line/Bar), `CategoryBar`, `ProgressCircle`, `DonutChart` with a center label. It is copy-paste source on Radix + Tailwind + Recharts, so it shares shadcn's foundations and **is not a second component library**.
- Copy the component source from Tremor's docs into `components/tremor/<Name>.tsx`. Install only the dependencies that component lists, and pin them in `package.json`.
- **Adapt it to the project on the way in:**
  - Tremor's `cx()` helper is the same as shadcn's `cn()`: import `cn` from `@/lib/utils` and don't add a second helper.
  - Tremor uses fixed Tailwind colors (`gray-*`, `blue-*`) and a `chartColors` map. Map them to shadcn variables (`text-muted-foreground`, `bg-muted`, `border-border`, `fill-[var(--chart-1)]` …) so theming and dark mode work. No hard-coded palette left behind.
  - Swap Tremor's icons for the icon library in `components.json` (usually `lucide-react`). Don't add a second icon set.
  - Check its Tailwind requirement (recent Tremor Raw charts target Tailwind v4). On a v3 project, adapt the classes or pick a shadcn alternative.
- **`@tremor/react` (the npm package) is legacy and counts as a second component library.** Never add it to a new or shadcn project. In a repo that already uses it, maintain it and don't mix it with Tremor Raw.

## 4. Data
- Aggregate on the server (SQL `GROUP BY`, date bucketing) and send the chart only the points it draws, at most a few hundred per series. Never ship raw rows to the browser to sum them there.
- One request per dashboard (or per independent card), cached and keyed by the filters. Use `react-data-fetching` for client-side fetching; prefer server components where the framework has them.
- Dates: bucket in one time zone (state which one in the UI), and fill empty buckets with 0 so lines don't skip.
- Drill-down: the `data-table` pattern (`SKILL.md` → Tables) with the same filters as the charts.

## 5. States and accessibility (never cut)
- Every card and chart has its own loading (`Skeleton` sized like the chart), empty ("No data for this period" plus the active filters), and error (`Alert` plus retry) state. One failing card must not blank the whole page.
- Each chart has a text alternative: a visible summary line (the key number or trend) or an `sr-only` table of the plotted values.
- Meaning never relies on color alone: deltas get a sign or arrow, and series get legend labels or direct labels.
- Tooltips work on keyboard focus (`accessibilityLayer`) as well as hover.

## Checklist
- [ ] Started from a block or existing layout; no hand-built sidebar or shell.
- [ ] All chart colors come from `--chart-*` or theme variables, and dark mode looks right.
- [ ] Tremor Raw used only for gaps: adapted to `cn`, theme variables and the project's icons. No `@tremor/react` added.
- [ ] Data aggregated server-side; filters in the URL.
- [ ] Loading, empty and error states per card; a text alternative per chart.
