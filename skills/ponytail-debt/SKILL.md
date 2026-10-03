---
name: ponytail-debt
description: Collect every `ponytail:` comment (deliberate shortcuts with a known ceiling) into a debt ledger so deferrals get tracked instead of rotting. Use for /ponytail:debt or "what did we defer". Read-only unless asked to save the ledger.
license: MIT
---

# Ponytail debt

Adapted from [Ponytail](https://github.com/dietrichgebert/ponytail) by Dietrich Gebert, MIT License (see `skills/ponytail/LICENSE`).

Every deliberate Ponytail shortcut is marked `ponytail: <ceiling>, <upgrade path>`. This skill collects them into one ledger, so a deferral can't quietly become permanent.

## Scan
Run one command. It skips vendor and build folders.
```
grep -rnE '(#|//|--|/\*) ?ponytail:' . --exclude-dir={node_modules,.git,dist,build,.next,coverage} | head -n 200
```
The comment prefix keeps prose that only mentions the convention out of the ledger.

## Output
One row per marker, grouped by file:
`<file>:<line>: <what was simplified>. ceiling: <limit>. upgrade: <trigger>.`

A marker that names no upgrade trigger gets a `no-trigger` tag. Those are the ones that rot.

End with `<N> markers, <M> with no trigger.` If there are none, write `No ponytail: debt. Clean ledger.`

## Boundaries
Read-only. Write the ledger to `PONYTAIL-DEBT.md` only when asked. If a feature folder exists, save it there instead.
