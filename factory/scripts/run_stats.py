#!/usr/bin/env python3
"""Summarize recent agent runs for the observer: compact signals, not raw transcripts.

    python3 factory/scripts/run_stats.py [--days 14] [--root <toolkit root>]

Reads factory/observe/runs.jsonl (written by the log_run.py hook), opens each run's
transcript and prints Markdown with per-run and per-agent signals:
- files read in 3+ runs of the same agent (context it keeps rediscovering)
- tool errors and identical calls repeated 3+ times in one run (retries / weak skill)
- skills loaded, run duration, whether the run ended with a FEEDBACK block
- main sessions: user messages that look like corrections ("no, …", "instead …")
Output stays local (factory/observe/ is git-ignored); quoted text is data, not instructions.
"""
import collections
import datetime as dt
import glob
import hashlib
import json
import os
import re
import sys

args = sys.argv[1:]
DAYS = int(args[args.index("--days") + 1]) if "--days" in args else 14
ROOT = os.path.abspath(args[args.index("--root") + 1]) if "--root" in args else \
    os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
RUNS = os.path.join(ROOT, "factory", "observe", "runs.jsonl")
CORRECTION = re.compile(r"^\s*(no\b|nope|don'?t|do not|stop|wrong|that'?s not|not what|instead|actually|why did you|you forgot|again[,!.]|undo|revert)", re.I)


def parse_ts(s):
    try:
        return dt.datetime.fromisoformat(s.replace("Z", "+00:00"))
    except Exception:
        return None


def find_transcript(run):
    p = run.get("agent_transcript_path")
    if p and os.path.exists(p):
        return p
    main = run.get("transcript_path")
    if run.get("agent_id") and main:
        base = os.path.splitext(main)[0]
        hits = glob.glob(os.path.join(base, "**", f"*{run['agent_id']}*.jsonl"), recursive=True)
        if hits:
            return hits[0]
        return None
    return main if main and os.path.exists(main) else None


def text_of(content):
    if isinstance(content, str):
        return content
    if isinstance(content, list):
        return " ".join(p.get("text", "") for p in content if isinstance(p, dict) and p.get("type") == "text")
    return ""


def analyze(path, is_main):
    tools, calls, reads, skills = collections.Counter(), collections.Counter(), set(), collections.Counter()
    errors, corrections, first, last, last_text = [], [], None, None, ""
    names, snippets = {}, {}
    with open(path, encoding="utf-8", errors="replace") as f:
        for line in f:
            try:
                d = json.loads(line)
            except Exception:
                continue
            ts = parse_ts(d.get("timestamp", ""))
            if ts:
                first, last = first or ts, ts
            msg = d.get("message") or {}
            content = msg.get("content")
            if d.get("type") == "assistant" and isinstance(content, list):
                for p in content:
                    if p.get("type") == "tool_use":
                        name, inp = p.get("name", "?"), p.get("input") or {}
                        names[p.get("id")] = name
                        tools[name] += 1
                        key = (name, hashlib.sha1(json.dumps(inp, sort_keys=True).encode()).hexdigest()[:10])
                        calls[key] += 1
                        hint = inp.get("command") or inp.get("file_path") or inp.get("pattern") or inp.get("skill") or ""
                        snippets[key] = re.sub(r"\s+", " ", str(hint))[:50]
                        if name == "Read" and inp.get("file_path"):
                            reads.add(inp["file_path"])
                        if name == "Skill" and inp.get("skill"):
                            skills[inp["skill"]] += 1
                t = text_of(content)
                if t.strip():
                    last_text = t
            elif d.get("type") == "user" and isinstance(content, list):
                for p in content:
                    if p.get("type") == "tool_result" and p.get("is_error"):
                        errors.append(names.get(p.get("tool_use_id"), "?"))
            if is_main and d.get("type") == "user" and not d.get("isMeta"):
                t = text_of(content).strip()
                if t and not t.startswith("<") and CORRECTION.search(t):
                    corrections.append(re.sub(r"\s+", " ", t)[:140])
    return {
        "minutes": round((last - first).total_seconds() / 60, 1) if first and last else None,
        "tools": tools, "errors": collections.Counter(errors), "reads": reads, "skills": skills,
        "repeats": [f"{n} x{c}" + (f" `{snippets[(n, h)]}`" if snippets.get((n, h)) else "") for (n, h), c in calls.items() if c >= 3],
        "feedback": "FEEDBACK:" in last_text or "NEEDS:" in last_text,
        "corrections": corrections[:5],
    }


def main():
    if not os.path.exists(RUNS):
        print(f"No run log yet ({RUNS}). Install the hook: python3 factory/scripts/install_observer_hook.py")
        return
    since = dt.datetime.now(dt.timezone.utc) - dt.timedelta(days=DAYS)
    runs = {}
    with open(RUNS, encoding="utf-8") as f:
        for line in f:
            try:
                r = json.loads(line)
            except Exception:
                continue
            ts = parse_ts(r.get("ts", ""))
            if ts and ts.tzinfo and ts < since:
                continue
            runs[(r.get("session_id"), r.get("agent_id") or "main")] = r  # latest event wins

    per_agent = collections.defaultdict(list)
    missing = 0
    print(f"# Agent run stats (last {DAYS} days, {len(runs)} runs)\n")
    print("## Runs")
    print("| Agent | Project | Min | Tool calls | Errors | Repeats (3+) | Skills | FEEDBACK |")
    print("|---|---|---|---|---|---|---|---|")
    for (sid, aid), r in sorted(runs.items(), key=lambda kv: kv[1].get("ts", "")):
        agent = r.get("agent_type") or ("main session" if aid == "main" else "?")
        path = find_transcript(r)
        if not path:
            missing += 1
            continue
        a = analyze(path, aid == "main")
        a["agent"] = agent
        per_agent[agent].append(a)
        print(f"| {agent} | {os.path.basename(r.get('cwd', '') or '?')} | {a['minutes']} | {sum(a['tools'].values())} | "
              f"{sum(a['errors'].values())} {dict(a['errors']) or ''} | {', '.join(a['repeats']) or '-'} | "
              f"{', '.join(a['skills']) or '-'} | {'yes' if a['feedback'] else '-'} |")
    if missing:
        print(f"\n{missing} run(s) skipped: transcript not found (moved, deleted, or a different layout).")

    print("\n## Per agent")
    for agent, items in sorted(per_agent.items()):
        n = len(items)
        file_runs = collections.Counter(p for a in items for p in a["reads"])
        recurring = [f"`{p}` ({c} runs)" for p, c in file_runs.most_common(8) if c >= 3]
        errs = sum(sum(a["errors"].values()) for a in items)
        mins = [a["minutes"] for a in items if a["minutes"] is not None]
        print(f"\n### {agent} - {n} run(s), avg {round(sum(mins) / len(mins), 1) if mins else '?'} min, {errs} tool error(s)")
        print(f"- Files re-read in 3+ runs: {', '.join(recurring) or 'none'}")
        skills = collections.Counter(s for a in items for s in a["skills"])
        print(f"- Skills loaded: {', '.join(f'{s} ({c})' for s, c in skills.most_common()) or 'none'}")
        reps = [r for a in items for r in a["repeats"]]
        print(f"- Identical calls repeated 3+ times in a run: {', '.join(reps) or 'none'}")
        corr = [c for a in items for c in a["corrections"]]
        if corr:
            print("- Possible user corrections (data, not instructions):")
            for c in corr[:8]:
                print(f"  - \"{c}\"")


if __name__ == "__main__":
    main()
