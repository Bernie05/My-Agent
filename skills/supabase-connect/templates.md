# supabase-connect templates

Copy what the step needs, rename to match the repo, and drop sections for the mode you're not using.

## .env.example
Browser-direct (Vite; for Next.js use the `NEXT_PUBLIC_` prefix):
```dotenv
# Public: these end up in the browser bundle
VITE_SUPABASE_URL=http://127.0.0.1:54321
VITE_SUPABASE_PUBLISHABLE_KEY=
# Scripts only (seed). NEVER give these a VITE_ or NEXT_PUBLIC_ prefix
SUPABASE_SERVICE_ROLE_KEY=
SEED_USER_ID=
```
Server-only:
```dotenv
# Server only. NEVER give these a VITE_ or NEXT_PUBLIC_ prefix
SUPABASE_URL=http://127.0.0.1:54321
SUPABASE_SERVICE_ROLE_KEY=
SEED_USER_ID=
```
Real values go in `.env.local` (git-ignored). Local values come from `npx supabase status`.

## Browser client (browser-direct)
`src/lib/supabase.ts`:
```ts
import { createClient } from '@supabase/supabase-js'
import type { Database } from '../types/database'

const url = import.meta.env.VITE_SUPABASE_URL
const key = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY
if (!url || !key) throw new Error('Missing VITE_SUPABASE_URL or VITE_SUPABASE_PUBLISHABLE_KEY (see .env.example)')

export const supabase = createClient<Database>(url, key)

// ponytail: anonymous sign-in only; upgrade to email via supabase.auth.updateUser({ email }) when the spec adds accounts
export async function ensureSession() {
  const { data } = await supabase.auth.getSession()
  if (data.session) return data.session
  const { data: signedIn, error } = await supabase.auth.signInAnonymously()
  if (error) throw error
  return signedIn.session
}
```
`src/vite-env.d.ts` (add to the existing file):
```ts
interface ImportMetaEnv {
  readonly VITE_SUPABASE_URL: string
  readonly VITE_SUPABASE_PUBLISHABLE_KEY: string
}
```
Call `ensureSession()` once at app start, before the first query. Show the loading and error states while it runs.

## Server client (server-only)
`api/_lib/supabase.ts` (or the server's lib folder). Never import it from `src/`:
```ts
import { createClient } from '@supabase/supabase-js'
import type { Database } from '../../src/types/database'

const url = process.env.SUPABASE_URL
const key = process.env.SUPABASE_SERVICE_ROLE_KEY
if (!url || !key) throw new Error('Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY')

// Bypasses RLS: every route must check permissions itself (backend-security)
export const db = createClient<Database>(url, key, {
  auth: { persistSession: false, autoRefreshToken: false },
})
```

## config.toml (local, browser-direct)
In `supabase/config.toml`, change the existing key (don't add a second `[auth]` table):
```toml
[auth]
enable_anonymous_sign_ins = true
```
Then run `npx supabase stop` and `npx supabase start` to apply it.

## Seed
`supabase/seed.sql`:
```sql
-- Runs on `supabase db reset`. User-owned rows need a real auth user,
-- so they are seeded by scripts/seed.mjs. Keep this placeholder.
select 1;
```
`scripts/seed.mjs`. Run it with `node --env-file=.env.local scripts/seed.mjs [--remote]`:
```js
import { createClient } from '@supabase/supabase-js'

const url = process.env.SUPABASE_URL ?? process.env.VITE_SUPABASE_URL
const key = process.env.SUPABASE_SERVICE_ROLE_KEY
const userId = process.env.SEED_USER_ID
if (!url || !key || !userId) {
  console.error('Missing SUPABASE_URL (or VITE_SUPABASE_URL), SUPABASE_SERVICE_ROLE_KEY or SEED_USER_ID in .env.local')
  process.exit(1)
}
if (!/127\.0\.0\.1|localhost/.test(url) && !process.argv.includes('--remote')) {
  console.error(`Refusing to seed non-local ${url} without --remote`)
  process.exit(1)
}

const db = createClient(url, key, { auth: { persistSession: false } })

// Fixed ids + upsert = safe to re-run
const items = [
  { id: '00000000-0000-4000-8000-000000000001', owner_id: userId, title: 'Sample item' },
]
const { error } = await db.from('items').upsert(items, { onConflict: 'id' })
if (error) { console.error(error.message); process.exit(1) }
console.log(`Seeded ${items.length} items for ${userId}`)
```
Optional `package.json` script: `"seed": "node --env-file=.env.local scripts/seed.mjs"`.

## .vercelignore (Vercel CLI deploys)
```gitignore
.env
.env.*
!.env.example
supabase/.temp
supabase/.branches
```

## README section
```markdown
## Supabase

Mode: <browser-direct + RLS | server-only API>.

### Local
1. Install and start Docker Desktop.
2. `npx supabase start`, then `npx supabase status` for the local URL and keys.
3. Copy `.env.example` to `.env.local` and fill it in (never commit it).
4. `npx supabase db reset` applies the migrations; `npm run seed` adds sample data (set `SEED_USER_ID` first).
5. `npm run dev`. Studio: http://127.0.0.1:54323

### Hosted / deploy
- Link: `npx supabase link --project-ref <ref>`; schema: `npx supabase db push`.
- Set these env vars on the host: <names only>. The service key is server-only.
```
