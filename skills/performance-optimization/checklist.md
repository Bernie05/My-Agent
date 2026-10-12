# Performance checklist (grep the heading you need)

Each line: what to look for → the cheapest fix. Check a line only when measurement points at its layer.

## Database
- Query count grows with the row count (N+1) → one join, `IN (...)`, or the ORM's eager load (`include`, `select_related`, `with`)
- `EXPLAIN` shows a sequential scan on a filtered or sorted column of a large table → index matching the `WHERE` + `ORDER BY` columns (see `database-design`)
- `SELECT *` or loading whole rows to use two fields → select only those columns
- Unbounded list queries → pagination (cursor for large or changing sets)
- Counting or aggregating in app code → do it in SQL (`COUNT`, `SUM`, `GROUP BY`)
- Many single-row writes in a loop → one batch insert/update inside a transaction
- Missing foreign-key indexes on columns used in joins → add them

## API
- Sequential `await`s that don't depend on each other → run them in parallel (`Promise.all`, `asyncio.gather`, goroutines)
- Large responses with fields the client never reads → trim the response shape (keep the contract in sync)
- Slow work on the request path (email, image resize, reports) → move it to a background job only if the stack already has one. Otherwise propose it.
- No compression on large JSON or text → enable the framework's or host's gzip/brotli
- Repeated auth/config lookups per request → compute once per request or at startup

## Caching
- Before caching: deleting, batching and indexing must already be done. Name the invalidation rule, or don't cache.
- Static assets without long-lived cache headers → hashed filenames + `Cache-Control: max-age=31536000, immutable`
- Public, rarely changing responses → HTTP caching (`Cache-Control`, `ETag`) before an app cache
- The same expensive read repeated within a request → memoize per request
- Shared app cache across instances → only with a store the project already runs. Otherwise leave a `ponytail:` comment.

## UI render
- Components re-render on every parent render with unchanged props → fix the state's location first (move it down or lift it out). Memoize only when the Profiler shows it matters.
- Derived values stored in state and synced with effects → compute them during render
- Long lists (hundreds+ rows) → paginate first. Virtualize only if pagination doesn't fit the UX.
- Layout thrash from reading and writing layout in loops → batch reads, then writes. Animate only `transform`/`opacity` (see `motion-design`).
- Data fetched in a waterfall (child waits on parent) → fetch in parallel or at the route level

## Bundle and assets
- Large dependency for a small use (date, lodash, icon packs) → native API or a per-function import. Drop the dependency if you can (`ponytail-audit`).
- Heavy route or widget loaded up front → dynamic `import()` / the framework's lazy route
- Images larger than displayed, or legacy formats → the framework's image component, or `srcset` + modern formats + `width`/`height` (prevents layout shift)
- Below-the-fold images and iframes → `loading="lazy"`. Never lazy-load the LCP image.
- Fonts blocking text → `font-display: swap`, self-host, subset, preload only the main font
- Third-party scripts on the critical path → `defer`/`async`, or load after interaction
- Duplicate copies of a package in the bundle → dedupe versions in the manifest

## Core Web Vitals (web pages)
- **LCP** slow → the hero image or text arrives late: preload it, serve it smaller, remove render-blocking CSS/JS before it
- **INP** slow → long tasks on interaction: break up work, defer non-urgent updates, cut handler work
- **CLS** high → give media and embeds explicit dimensions, reserve space for late content, avoid inserting content above what the user is reading
