---
description: "Factory: security review of an agent, skill, command or plugin - local path, installed plugin name, or GitHub URL"
argument-hint: "<path | plugin name | https://github.com/owner/repo>"
---

Security review of: $ARGUMENTS

1. **Resolve the target to a local path.**
   - A local path: use it as-is.
   - An installed plugin name: find its folder under `~/.claude/plugins/cache/` or `~/.claude/plugins/marketplaces/` (Glob for the name).
   - A GitHub URL: clone it into quarantine and record the SHA. Never run anything inside quarantine.
     ```
     git clone --depth 1 <url> "$HOME/.claude/factory/quarantine/<repo>"
     git -C "$HOME/.claude/factory/quarantine/<repo>" rev-parse HEAD
     ```
2. Use the **agent-factory** agent, operation **review**, with the path (and the SHA, for GitHub). Say which pass to use: **light** for `anthropics/*` first-party items, **full** for everything else.
3. Relay the verdict and top findings briefly, plus where the full findings file is if the agent wrote one.
   - If the verdict is `SAFE WITH CHANGES` and the target is the user's own file, offer to apply the fixes.
   - Delete the quarantine folder afterwards, unless the user wants to install the item next (`/factory:agent`, `/factory:skill` or `/factory:command`).
