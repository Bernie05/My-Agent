---
description: "Factory: search for an existing agent, skill, command or plugin (local, then Anthropic, then GitHub) - search and review only, installs nothing"
argument-hint: "<need, e.g. 'pdf editing' or 'changelog writer'>"
---

Use the **agent-factory** agent, operation **find**, for: $ARGUMENTS

Before calling it, run `claude plugin marketplace update` once (any shell) so the Anthropic catalogs are current. If it fails, continue with the local copies.

Show the ranked candidates it returns, each with its source, token cost and security verdict. GitHub candidates are marked "not reviewed yet": offer `/factory:review <github url>` for any the user wants checked. Don't install anything. Offer `/factory:agent`, `/factory:skill` or `/factory:command` to get one.
