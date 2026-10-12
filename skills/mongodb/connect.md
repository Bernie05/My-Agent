# MongoDB: first connection

Load this from `SKILL.md` section 0 only for a first connection or a new environment. Load `project-gitignore` and merge its baseline first.

## Pick the deployment
| Situation | Use |
|---|---|
| The spec or user names Atlas, or it's going to a cloud host | **Atlas** (free M0 for dev; tiers that cost money need the user's yes) |
| Local development, offline, or tests | **Local Docker** |
| The user runs their own server | **Self-hosted**: the user provides host, user and TLS details; you never provision a server |

## Atlas
1. Reuse the user's project and cluster if the spec or repo names one. Creating one: via the MongoDB MCP Atlas tools (ToolSearch `mongodb`) or the Atlas UI, after the user says yes.
2. Database user: generated password, role `readWrite@<appDb>` (`SKILL.md` section 2).
3. Access list: per `SKILL.md` section 2. Say in the report which entries you added and why.
4. The URI comes from the cluster's Connect dialog: `mongodb+srv://<user>:<password>@<cluster>.<id>.mongodb.net/<appDb>?retryWrites=true&w=majority`.

## Local Docker
- Standalone, enough without transactions: `docker run -d --name mongo -p 127.0.0.1:27017:27017 -v mongo-data:/data/db mongo:8`
- Transactions need a single-node replica set: add `--replSet rs0` to the container command, then run once: `docker exec mongo mongosh --eval "rs.initiate()"`. URI: `mongodb://127.0.0.1:27017/<appDb>?replicaSet=rs0&directConnection=true`
- Bind to `127.0.0.1` as above so the unauthenticated dev database isn't reachable from the network. In `docker-compose.yml`, keep the same port binding.

## Env files
| File | Committed | Holds |
|---|---|---|
| `.env.example` | yes | `MONGODB_URI=mongodb+srv://USER:PASSWORD@CLUSTER.mongodb.net/DB` (placeholder) and `MONGODB_DB` if used |
| `.env.local` / `.env` (ignored) | **no** | the dev URI |
| Deploy host env vars | n/a | the production URI, set by the user or `vercel-deploy` |

The URI never gets a `VITE_` or `NEXT_PUBLIC_` prefix. MongoDB is reached from server code only.

## Then
1. Client module per `SKILL.md` section 1: one file, fail fast on a missing `MONGODB_URI`, export the cached client/db (or the Mongoose connection).
2. Index and validator script per `SKILL.md` sections 4-5, run on dev.
3. Seed: idempotent (`updateOne(..., { upsert: true })` on fixed keys), and refuses a non-local URI unless an explicit flag is passed.
4. Verify with `SKILL.md` section 7, then add a README section: prerequisites (Docker or Atlas), env names (never values), indexes/migrations, seed.
