# Audit file template (AUDIT-<date>.md)

Path: `docs/security/AUDIT-<yyyy-mm-dd>.md` in the project (`-2`, `-3`… for a second run that day). Findings are sorted CRITICAL → LOW, then by how easy they are to exploit.

```
# Security audit: <app>   Date: <yyyy-mm-dd>   Commit: <short sha>[-dirty]
Scope: <whole app | area | diff>   Stack: <runtime, server, client, ORM/DB, auth>
Summary: CRITICAL <n> · HIGH <n> · MEDIUM <n> · LOW <n>   Dependencies: <tool → advisories>

## Findings
### SEC-1 · CRITICAL · <short title>   Status: open
- Where: `<path>:<line>` (+ sibling locations)
- OWASP/ASVS: <A01 / V4.2.1>
- Evidence: <1-5 code lines or the exact condition; secrets as [REDACTED]>
- Exploit: <attacker, request or action, gain>
- Fix (owner: backend | frontend | both): <minimal change, where it goes; built-in protection first>
- Verify: <the test or request that must fail after the fix>

## Hardening notes
- <unproven or best-practice items, one line each>

## Not checked
- <area: why (not present, tool missing, out of scope)>

## Hand-off
| SEC-# | Owner | Effort (S/M/L) | Decision needed |
```

## Status values (recheck)
`open` · `fixed (<commit or file:line>)` · `partial (<what remains>)` · `accepted risk (<who, why>)` · `decision (architect)`.
