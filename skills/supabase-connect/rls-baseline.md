# RLS baseline (supabase-connect)

Put it in the same migration that creates the table. For roles and shared data, follow SPEC.md → Permissions and `supabase-mcp` section 2.

## Browser-direct: owner-scoped tables
```sql
create table public.items (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  title text not null check (length(title) between 1 and 200),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.items enable row level security;
create index on public.items (owner_id);

-- One policy is enough while all four operations use the same owner check.
-- Split it per operation (supabase-mcp section 2) once they differ.
create policy "owners manage their items" on public.items
  for all to authenticated
  using ((select auth.uid()) = owner_id)
  with check ((select auth.uid()) = owner_id);
```
- `owner_id default auth.uid()` lets the client leave it out of inserts (native first, no app code). The `with check` clause still blocks spoofing.
- Anonymous users sign in as the `authenticated` role, so the policy covers them. The `anon` role has no policy, so it has no access.
- ponytail: `updated_at` is set by the app on update. Add a `moddatetime` trigger when more than one writer exists.

### Permanent users only (optional)
To keep anonymous users off a table or an action, add a restrictive policy:
```sql
create policy "no anonymous writes" on public.items
  as restrictive for insert to authenticated
  with check ((select (auth.jwt() ->> 'is_anonymous')::boolean) is false);
```

## Server-only: deny by default
```sql
alter table public.items enable row level security;
-- No policies: anon/authenticated can't reach it through the Data API.
-- The service key bypasses RLS, so the API must check permissions itself (backend-security).
```

## Upgrade from anonymous to email (later)
- Call `supabase.auth.updateUser({ email })`. After the user verifies it, the account is permanent and **keeps the same user id**, so `owner_id` rows stay. Hosted projects need the Email provider enabled.
- OAuth instead: `linkIdentity`, which needs manual linking enabled.
- Old anonymous users pile up. Cleaning them up is a delete on `auth.users`, so ask the user first, and only on a schedule they approve.

## Check
```sql
select tablename, rowsecurity from pg_tables where schemaname = 'public';   -- all true
select tablename, policyname, cmd, roles from pg_policies where schemaname = 'public';
```
Then test with two real sessions: user B can't select, update or delete user A's rows.
