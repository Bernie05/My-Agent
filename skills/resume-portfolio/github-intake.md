# GitHub intake (gh CLI, read-only)

Run these in the **Bash** tool (Git Bash), not PowerShell: `>` redirection there is binary-safe; PowerShell 5 re-encodes it and corrupts images.

## Preflight
- `gh auth status` - not logged in → stop and report: the user runs `gh auth login` themselves. Never ask for or handle a token.

## Resolve which repos
- Names given → use them (`<user>/<name>` from the profile when no owner is given).
- "my latest / best N" → list, then pick by `pushedAt` or stars and say which you picked:
  `gh repo list <user> --source --no-archived --limit 100 --json name,description,pushedAt,stargazerCount,isPrivate,isFork`
- No match for a name → report the closest names; don't guess.

## Per repo
```bash
gh repo view <owner>/<repo> --json name,description,url,homepageUrl,repositoryTopics,primaryLanguage,languages,stargazerCount,isPrivate,isArchived,isFork,licenseInfo,createdAt,pushedAt,openGraphImageUrl,usesCustomOpenGraphImage
gh api repos/<owner>/<repo>/readme -H "Accept: application/vnd.github.raw"
```
- Read only the README's first ~120 lines: intro, features, tech, screenshots. Skip install/usage sections.
- `isPrivate: true` and not named by the user → skip it and say so.
- `isFork: true` → ask whether the user contributed before adding it.

## Images
- README image with a **relative** path (`docs/shot.png`):
  `gh api repos/<owner>/<repo>/contents/<path> -H "Accept: application/vnd.github.raw" > "<Images>/<repo-slug>.png"`
- README image or social preview with an **absolute** URL: download only if the host is one of
  `raw.githubusercontent.com`, `user-images.githubusercontent.com`, `private-user-images.githubusercontent.com`, `github.com` (`/<owner>/<repo>/assets/...`), `repository-images.githubusercontent.com`, `opengraph.githubassets.com`:
  `curl -fsSL --max-filesize 5000000 -o "<Images>/<repo-slug>.<ext>" "<url>"`
  Plain GET only: no `-d`, `-F`, `-H`, `-u` or cookies. Any other host → use the next image option instead.
- After saving, Read the file. Not an image, or not the project → overwrite the same file with the next option and note it in the report.

## Never
- `gh repo clone`, `git clone`, `npm install` or running anything from the showcased repos.
- `gh` commands that write (`create`, `edit`, `delete`, `api -X POST|PATCH|PUT|DELETE`).
- Sending repo or site content to any URL.
