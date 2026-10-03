---
description: "Resume: update your MyResume site - add GitHub projects to the portfolio, edit experience/skills/about, sync or remove projects, preview"
argument-hint: "<request, e.g. add my repos weather-app, chat-bot and budgeter to the portfolio>"
---

Use the **resume-manager** agent for: $ARGUMENTS

Pick the operation from the request (add-projects, update, sync, remove, preview) and name it in the call; if none fits, pass the request as-is.

If the agent returns `INTAKE: QUESTIONS`, ask them with AskUserQuestion (header and options as given), then call the agent again with the answers.

If `gh` isn't installed or logged in, tell the user to run `gh auth login` themselves; don't handle tokens.

Relay the report briefly. List its "Questions for you" and ask them. Don't commit, push or deploy unless the user asks; suggest `/deploy:vercel` once they've reviewed the diff.
