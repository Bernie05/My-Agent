# Factory learnings

The factory's memory: one entry per `NEEDED.md` row it worked on, **pass or fail**, newest last. `/factory:needed` appends it; the observer reads it before proposing, so failed ideas aren't proposed again and confirmed patterns get stronger evidence. Format adapted from [auto-harness](https://github.com/neosigmaai/auto-harness) (MIT).

Rules that read this file:
- **3 strikes:** a Type + Target whose build failed 3 times (gate, tests or file guard) is set to `parked` in `NEEDED.md`; the observer doesn't re-propose it unless the evidence is clearly new, and asks you instead.
- **No-effect stop:** if the last 5 measured results in `factory/RESULTS.tsv` for one agent or skill are `no-change` or `worse`, the observer stops proposing changes to it and reports that to you with a summary.

## Format
```
## N-x · <type> <target> · <yyyy-mm-dd> · <done ✓ | failed ✗>
**What changed:** <one sentence, or what was attempted>
**Pattern confirmed:** <the failure mode the row was about>
**What worked / didn't:** <specifics: eval scores, lost checks, guard violations>
**Needs from human:** <or "none">
```

## Log
