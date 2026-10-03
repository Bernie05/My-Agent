# Global rules

- **New projects get a .gitignore first.** When creating or scaffolding a project, running `git init`, or working in a repo with no `.gitignore`, load the `project-gitignore` skill and add or merge its security baseline **before the first commit**. Never commit `.env` files, keys, credentials or local cloud config. If one is already tracked, untrack it and tell the user to rotate the secret.
