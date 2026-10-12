---
name: mongodb
description: Work with MongoDB on Atlas, local Docker or self-hosted mongod - connection and client reuse (incl. serverless), database users and network access, document modeling (embed vs reference), indexes (ESR rule, explain), $jsonSchema validation, transactions, NoSQL injection defenses, migrations, and the MongoDB MCP server. Use ONLY when the stack uses MongoDB (SPEC.md Tech Stack, `mongodb` or `mongoose` packages, a `mongodb://` or `mongodb+srv://` URL, or the user names MongoDB/Atlas). Not for SQL databases (use database-design).
---

# MongoDB (Atlas, local, self-hosted)

Never print, log or commit a connection string (it holds the password). Ask the user before anything that writes to production data, drops a collection or index, changes Atlas network access, or costs money (cluster tier changes).

## 0. Detect
- Deployment: `mongodb+srv://...mongodb.net` = Atlas; `mongodb://localhost` or a Docker service = local; anything else = self-hosted. Reuse the existing env var name (`MONGODB_URI` by default), client module and driver (`mongodb` native or `mongoose`).
- First connection or a new environment → follow `connect.md` (load it only then).
- Designing or changing collections → load `modeling.md`.
- Record in your report: `MongoDB: <atlas | local | self-hosted>, <driver>, <db name>`.

## 1. Client: one per process
- Create the `MongoClient` (or `mongoose.connect`) **once** at module level and reuse it. Serverless: cache the connect promise on a module-level variable; Next.js dev also needs it on `globalThis` so hot reload doesn't open a new pool each time.
- Never connect and close per request. Set `serverSelectionTimeoutMS` so a down database fails fast with a clear error.
- **Reuse first (Ponytail):** keep the driver the repo has. Don't add Mongoose to a native-driver project (or the reverse) for one feature.

## 2. Access and network
- **One database user per app and environment**, with the least built-in role it needs (`readWrite` on its own database, not `atlasAdmin` or `root`). Migrations or admin tasks get a separate user if they need more.
- **Atlas IP access list:** the developer's IP for local work and the host's fixed egress IPs for production. `0.0.0.0/0` only for throwaway dev clusters, or when the host has no fixed IPs (many serverless hosts). Then it needs a strong generated password and TLS, and the tradeoff goes in the report. Private endpoints and peering are paid options; offer, don't assume.
- **Self-hosted:** authorization on (`security.authorization: enabled`), `bindIp` limited to the hosts that need it (never a public `0.0.0.0` without auth and a firewall), and TLS for any traffic leaving the machine.
- URL-encode special characters in the password inside the URI.

## 3. Queries and safety (load `backend-security` for auth work)
- **NoSQL injection:** validate request input at the boundary (schema validator). Reject objects where a string or number is expected, and drop keys that start with `$` or contain `.` before they reach a filter. Mongoose: keep `sanitizeFilter` / `strictQuery` on. Never pass user input to `$where`, `$function` or `$accumulator`.
- Project only the fields you return (`projection` / `.select()`); never send whole documents with internal fields to the client.
- Paginate with a range on an indexed field (`_id > lastId`) for large collections. `skip` is fine for small ones.
- Single-document writes are atomic: use `$set`, `$inc`, `$push` and `findOneAndUpdate` with a condition before reaching for a transaction.
- **Transactions** need a replica set (Atlas always has one; local Docker needs `--replSet`, see `connect.md`). Use them only when several documents must change together. Pass the session to every operation inside.

## 4. Indexes
- Every query a route runs on a growing collection needs an index. Compound key order follows **ESR**: Equality fields, then Sort, then Range.
- Check with `explain("executionStats")`: you want `IXSCAN`, not `COLLSCAN`, and `totalDocsExamined` close to `nReturned`.
- Use unique indexes for natural keys (email, slug) instead of a find-then-insert check. Use TTL indexes for expiring data (sessions, tokens) instead of cleanup jobs (Ponytail: native first).
- Create indexes in code or a migration (`createIndexes` is idempotent), never only by hand in a UI. Dropping an index needs the user's yes on production.

## 5. Validation and migrations
- Database-level `$jsonSchema` validator on collections that several writers touch, or that hold important data (`modeling.md` → Validation). Mongoose schemas only guard writes that go through Mongoose.
- There is no built-in migration system. Keep idempotent, numbered scripts in the repo (or the migration tool already installed) for index creation, validators and data backfills. Run them on dev first.
- Version documents (`schemaVersion`) only when an old shape must coexist with a new one.

## 6. MongoDB MCP (when connected)
- Find the tools with ToolSearch `mongodb`. Use them to list databases and collections, sample a collection's schema, run `find`/`aggregate` and `explain`, and (Atlas) inspect clusters, users and access lists.
- Default to read-only use. Inserts, updates, deletes, drops and Atlas changes (users, access list, clusters) need the user's yes for this task, and production writes always do.
- MCP not connected → report: "MongoDB MCP not connected; add the official MongoDB MCP server (read-only mode recommended), then rerun", and work from the repo plus `mongosh` against the dev database.
- When you propose adding the MCP server, pin its package version and pass its connection string through the client's env config, never inline in a committed file.

## 7. Verify (before you report done)
- [ ] One create/read/update/delete round trip works against dev.
- [ ] `explain` shows `IXSCAN` for each new query on a growing collection.
- [ ] An injection probe (`{"email": {"$ne": null}}` as a login field) is rejected.
- [ ] `git status` shows no env file with a real URI; the client bundle has no `mongodb` URI (build, then grep the output for `mongodb+srv` and `mongodb://`).

## Gotchas
| Symptom | Cause / fix |
|---|---|
| `MongoServerSelectionError` / timeout on Atlas | IP not on the access list, or wrong user/password. Check the list, then the credentials. |
| Connection count climbs in serverless | A client per request. Cache it (section 1). |
| `Transaction numbers are only allowed on a replica set member` | Local standalone `mongod`. Start it as a single-node replica set (`connect.md`). |
| Query slow only in production | Missing index, hidden locally by small data. `explain` it (section 4). |
| Auth fails with a correct password | Special characters not URL-encoded, or wrong `authSource`. |

Skipped by default (Ponytail): sharding, Atlas Search / Vector Search, change streams, time series collections and client-side field-level encryption. Add them when the spec asks.
