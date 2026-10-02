#!/usr/bin/env python3
"""Scan .claude/ and CLAUDE.md for prompt-injection and supply-chain red flags.

Run after adding or updating any agent, skill, or command:
    python3 .claude/scripts/audit.py
Exits 1 if there are findings not in the reviewed baseline. Findings are leads,
not verdicts: review each new one, then accept it with
    python3 .claude/scripts/audit.py --update-baseline
"""
import os
import re
import sys
import unicodedata

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TARGETS = [ROOT, os.path.join(os.path.dirname(ROOT), "CLAUDE.md")]
SELF = os.path.abspath(__file__)
BASELINE = os.path.join(os.path.dirname(SELF), "audit-baseline.txt")

CHECKS = {
    "injection phrasing": re.compile(
        r"ignore (all |any |the )?(previous|prior|above|earlier) |disregard (all|previous|the above)"
        r"|forget (your|all|previous)|you are now|new instructions|reveal (your|the) system prompt"
        r"|do not (tell|inform|mention) (the )?user|without (telling|asking|informing) (the )?user"
        r"|secretly|jailbreak|developer mode",
        re.I,
    ),
    "remote code / pipe to shell": re.compile(r"(curl|wget)[^\n|]*\|\s*(ba|z)?sh|base64\s+-d|eval\s*\(", re.I),
    "fetches remote instructions": re.compile(r"\b(WebFetch|fetch (the )?(latest|fresh)|download)\b.*https?://", re.I),
    "exfiltration-shaped": re.compile(r"(\.env|id_rsa|\.ssh|\.aws|token|secret)[^\n]{0,60}(curl|wget|http|upload|post)", re.I),
    "destructive command": re.compile(r"rm -rf (/|~)|git push (-f|--force)|drop database", re.I),
    "hidden markup": re.compile(r"<!--(?!\s*(e\.g\.|Leave blank|Vendored))"),
}


def scan_file(path):
    findings = []
    try:
        text = open(path, encoding="utf-8").read()
    except UnicodeDecodeError:
        return [(0, "binary / non-UTF-8 file", "")]
    for n, line in enumerate(text.splitlines(), 1):
        for ch in line:
            cat = unicodedata.category(ch)
            # Cf = format chars (zero-width, bidi overrides, tag chars); allow emoji variation selectors (Mn)
            if cat in ("Cf", "Co", "Cn") or 0xE0000 <= ord(ch) <= 0xE007F:
                findings.append((n, f"invisible char U+{ord(ch):04X}", line.strip()[:120]))
                break
        for name, rx in CHECKS.items():
            if rx.search(line):
                findings.append((n, name, line.strip()[:120]))
    return findings


def main():
    findings = []
    for target in TARGETS:
        paths = [target] if os.path.isfile(target) else [
            os.path.join(r, f) for r, _, fs in os.walk(target) for f in fs
        ]
        for p in sorted(paths):
            if os.path.abspath(p) in (SELF, BASELINE):
                continue
            rel = os.path.relpath(p, os.path.dirname(ROOT))
            for n, kind, line in scan_file(p):
                findings.append((rel, n, kind, line))

    # Baseline keys ignore line numbers so unrelated edits don't invalidate them.
    keys = {f"{rel}\t{kind}\t{line}" for rel, _, kind, line in findings}
    if "--update-baseline" in sys.argv:
        with open(BASELINE, "w", encoding="utf-8") as f:
            f.write("\n".join(sorted(keys)) + "\n")
        print(f"Baseline updated: {len(keys)} reviewed finding(s).")
        return

    known = set()
    if os.path.exists(BASELINE):
        known = set(open(BASELINE, encoding="utf-8").read().splitlines())
    new = [f for f in findings if f"{f[0]}\t{f[2]}\t{f[3]}" not in known]
    for rel, n, kind, line in new:
        print(f"{rel}:{n}: [{kind}] {line}")
    print(f"\n{len(new)} new finding(s), {len(findings) - len(new)} already reviewed (baseline).")
    sys.exit(1 if new else 0)


if __name__ == "__main__":
    main()
