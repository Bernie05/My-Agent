#!/usr/bin/env python3
"""Hook: append one line per agent run to factory/observe/runs.jsonl (local only, git-ignored).

Installed for SubagentStop and Stop by install_observer_hook.py. Records metadata only
(which agent, which session, where the transcript is) - no prompts or outputs. It never
prints and always exits 0, so it can't block or slow Claude Code.
"""
import json
import os
import sys
import time

FIELDS = ("hook_event_name", "session_id", "agent_id", "agent_type",
          "transcript_path", "agent_transcript_path", "cwd")


def main():
    try:
        data = json.load(sys.stdin)
        row = {"ts": time.strftime("%Y-%m-%dT%H:%M:%S%z")}
        row.update({k: data[k] for k in FIELDS if data.get(k)})
        out_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "observe")
        os.makedirs(out_dir, exist_ok=True)
        with open(os.path.join(out_dir, "runs.jsonl"), "a", encoding="utf-8") as f:
            f.write(json.dumps(row) + "\n")
    except Exception:
        pass  # logging must never break a session


if __name__ == "__main__":
    main()
    sys.exit(0)
