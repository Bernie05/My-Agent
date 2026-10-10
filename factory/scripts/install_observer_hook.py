#!/usr/bin/env python3
"""Install (or remove) the observer's run-log hook in your Claude Code user settings.

    python3 ~/.claude/factory/scripts/install_observer_hook.py              # install
    python3 ~/.claude/factory/scripts/install_observer_hook.py --uninstall  # remove

Merges into settings.json (never replaces other settings), backs it up first, and is safe
to run twice. Uses this Python's absolute path in exec form, so it works on Windows,
macOS and Linux without shell quoting. Run once per device, then restart Claude Code.
"""
import json
import os
import shutil
import sys
import time

SCRIPT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "log_run.py")
CONFIG_DIR = os.environ.get("CLAUDE_CONFIG_DIR") or os.path.join(os.path.expanduser("~"), ".claude")
SETTINGS = os.path.join(CONFIG_DIR, "settings.json")
EVENTS = ("SubagentStop", "Stop")
HOOK = {"type": "command", "command": sys.executable, "args": [SCRIPT], "async": True, "timeout": 5}


def ours(h):
    return isinstance(h, dict) and h.get("args") and os.path.basename(str(h["args"][-1])) == "log_run.py"


def main():
    uninstall = "--uninstall" in sys.argv
    settings = {}
    if os.path.exists(SETTINGS):
        with open(SETTINGS, encoding="utf-8-sig") as f:
            settings = json.load(f)  # fail loudly on broken JSON instead of overwriting it
        shutil.copy2(SETTINGS, f"{SETTINGS}.bak-{time.strftime('%Y%m%d%H%M%S')}-{os.getpid()}")
    hooks = settings.setdefault("hooks", {})
    changed = []
    for event in EVENTS:
        groups = hooks.setdefault(event, [])
        # drop any earlier copy of our hook, keep everything else untouched
        for g in groups:
            g["hooks"] = [h for h in g.get("hooks", []) if not ours(h)]
        groups[:] = [g for g in groups if g.get("hooks")]
        if not uninstall:
            groups.append({"hooks": [dict(HOOK)]})
        if not groups:
            del hooks[event]
        changed.append(event)
    if not hooks:
        del settings["hooks"]
    os.makedirs(CONFIG_DIR, exist_ok=True)
    with open(SETTINGS, "w", encoding="utf-8") as f:
        json.dump(settings, f, indent=2)
        f.write("\n")
    action = "Removed" if uninstall else "Installed"
    print(f"{action} the run-log hook for {', '.join(changed)} in {SETTINGS}")
    if not uninstall:
        print(f"Runs will be logged to {os.path.normpath(os.path.join(os.path.dirname(SCRIPT), '..', 'observe', 'runs.jsonl'))}")
    print("Restart Claude Code (or open /hooks) to load the change.")


if __name__ == "__main__":
    main()
