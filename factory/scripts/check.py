#!/usr/bin/env python3
"""Consistency check for this toolkit. Read-only; exit 1 if anything is off.

    python3 factory/scripts/check.py            # from the repo root (~/.claude)
    python3 factory/scripts/check.py <root>     # or point it at a clone

Checks: doc counts, every agent/skill/command group documented, every agent has a
`tools:` line and preloads token-efficiency, preloaded skills exist, SKILL.md size,
and links from SKILL.md to sibling files.
"""
import os
import re
import sys

ROOT = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(__file__), "..", ".."))
MAX_SKILL_LINES = 150
problems, warnings = [], []


def read(rel):
    with open(os.path.join(ROOT, rel), encoding="utf-8") as f:
        return f.read()


def frontmatter(text):
    m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    return m.group(1) if m else None


def preloaded_skills(fm):
    m = re.search(r"^skills:[ \t]*(.*)$", fm, re.M)
    if not m:
        return []
    if m.group(1).strip():
        return [s.strip(" '\"") for s in m.group(1).strip("[] ").split(",") if s.strip()]
    rest = fm[m.end():].split("\n")[1:]
    out = []
    for line in rest:
        item = re.match(r"^\s+-\s*(.+)$", line)
        if not item:
            break
        out.append(item.group(1).strip(" '\""))
    return out


agents = sorted(os.path.relpath(os.path.join(d, f), ROOT)
                for d, _, fs in os.walk(os.path.join(ROOT, "agents")) for f in fs if f.endswith(".md"))
skills = sorted(d for d in os.listdir(os.path.join(ROOT, "skills"))
                if os.path.isfile(os.path.join(ROOT, "skills", d, "SKILL.md")))
commands = sorted(os.path.relpath(os.path.join(d, f), ROOT)
                  for d, _, fs in os.walk(os.path.join(ROOT, "commands")) for f in fs if f.endswith(".md"))
groups = sorted({c.split(os.sep)[1] for c in commands if c.count(os.sep) >= 2})

system, catalog = read("docs/AGENT-SYSTEM.md"), read("CATALOG.md")

# 1. Counts in the AGENT-SYSTEM header
m = re.search(r"\*\*(\d+) agents · (\d+) commands · (\d+) skills", system)
if not m:
    problems.append("docs/AGENT-SYSTEM.md: header counts line not found")
else:
    for label, want, got in zip(("agents", "commands", "skills"), m.groups(), (len(agents), len(commands), len(skills))):
        if int(want) != got:
            problems.append(f"docs/AGENT-SYSTEM.md header says {want} {label}, repo has {got}")

# 2. Everything documented
for a in agents:
    name = os.path.splitext(os.path.basename(a))[0]
    for doc, text in (("CATALOG.md", catalog), ("docs/AGENT-SYSTEM.md", system)):
        if f"`{name}`" not in text:
            problems.append(f"{doc}: agent `{name}` not documented")
for s in skills:
    if f"`{s}`" not in catalog:
        problems.append(f"CATALOG.md: skill `{s}` not documented")
    if not re.search(rf"(?<![\w-]){re.escape(s)}(?![\w-])", system):
        problems.append(f"docs/AGENT-SYSTEM.md: skill `{s}` not in the skills list")
for g in groups:
    for doc, text in (("CATALOG.md", catalog), ("docs/AGENT-SYSTEM.md", system)):
        if f"/{g}:" not in text:
            problems.append(f"{doc}: command group /{g}:* not documented")

# 3. Agents: tools line, token-efficiency, preloaded skills exist
for a in agents:
    fm = frontmatter(read(a))
    if fm is None:
        problems.append(f"{a}: no frontmatter")
        continue
    if not re.search(r"^tools:", fm, re.M):
        problems.append(f"{a}: no `tools:` line (inherits every tool)")
    pre = preloaded_skills(fm)
    if "token-efficiency" not in pre:
        problems.append(f"{a}: doesn't preload token-efficiency")
    for s in pre:
        if s not in skills:
            problems.append(f"{a}: preloads missing skill `{s}`")

# 4. Skills: size and links to sibling files
for s in skills:
    text = read(f"skills/{s}/SKILL.md")
    n = text.count("\n")
    if n > MAX_SKILL_LINES:
        warnings.append(f"skills/{s}/SKILL.md: {n} lines (> {MAX_SKILL_LINES}); move long sections to reference files")
    for link in re.findall(r"`((?:reference|references|scripts|templates)/[^`]+?\.\w+)`", text):
        if not os.path.exists(os.path.join(ROOT, "skills", s, link)):
            problems.append(f"skills/{s}/SKILL.md: links to missing {link}")

for w in warnings:
    print(f"warn: {w}")
for p in problems:
    print(f"FAIL: {p}")
print(f"\n{len(agents)} agents · {len(commands)} commands · {len(skills)} skills — "
      f"{len(problems)} problem(s), {len(warnings)} warning(s)")
sys.exit(1 if problems else 0)
