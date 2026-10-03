# Code patterns: backend

Stack-neutral. Use the idiom the framework and repo already use (for example NestJS modules and providers, Django apps and managers, Express middleware, Spring beans).

## Smell → pattern
| Smell | Pattern | Not when |
|---|---|---|
| Business rules live in route handlers, and 2+ entry points (route, job, CLI, webhook) need the same rules | **Service layer**: plain functions or a class that holds the rules; handlers only parse input and shape output | One entry point and a short handler |
| The same queries appear in several services, or tests need to run without the database | **Repository / data-access module** per aggregate | The ORM already gives a clean query API and there's one caller; don't wrap an ORM just to wrap it |
| Code calls a payment, email, storage or AI provider directly in many places | **Adapter** around the provider (one module, your own small interface), so it can be faked in tests or swapped | One call site to a stable SDK |
| Behavior switches on provider, plan, region or type, repeated and growing | **Strategy map** keyed by the type | One switch in one place |
| The same check before or after many handlers (auth, rate limit, logging, tenant scoping, timing) | **Middleware / decorator / interceptor** | One route |
| A request does slow or unreliable work (emails, webhooks, image processing, third-party calls) | **Background job / queue**, and return early | It's fast and must be done before the response anyway |
| Several parts must react to one domain event (order paid → email, invoice, stats) | **Domain events** (in-process first; a message broker only when you run several services) | One reaction: call it directly |
| Several writes must all succeed or all fail | **Transaction** (unit of work) around them in the service | A single write |
| An entity has a status with legal and illegal moves (`draft → sent → paid`) | **State machine**: a transitions table checked in one place, and ideally a DB constraint | Two states |
| The same input validation in several handlers | **One schema per input**, validated at the boundary (see `api-design`), shared with the frontend when possible | Never "not when" at trust boundaries |
| Config values read from env all over the code | **One config module**, validated at startup | Never "not when" |

## Architecture patterns
The names follow Martin Fowler's *Patterns of Enterprise Application Architecture* catalog (https://martinfowler.com/eaaCatalog/). The summaries are original; follow the link for the definition. For the classic GoF patterns, grep `catalog.md`.

| Pattern | Use when (smell) | Not when | Link (eaaCatalog/…) |
|---|---|---|---|
| Service Layer | The same business rules are needed from 2+ entry points | One entry point, short handler | serviceLayer.html |
| Repository | Query logic repeated across services, or the domain must be tested without the DB | A clean ORM API with one caller | repository.html |
| Data Mapper | Domain objects must stay free of persistence code (rich domain logic) | CRUD-shaped data: the ORM's Active Record is fine | dataMapper.html |
| Active Record | Simple CRUD where table and object match 1:1 | Domain rules are growing complex | activeRecord.html |
| Unit of Work | Several writes in one business operation must commit or roll back together | A single write | unitOfWork.html |
| Gateway | One object wraps access to an external system or resource (≈ Adapter) | A stable SDK used in one file | gateway.html |
| Data Transfer Object | API or queue payloads must not expose internal entities, or must batch fields | Internal calls inside one module | dataTransferObject.html |
| Identity Map | The same row loaded twice in one request causes conflicting copies | The ORM's session already does it | identityMap.html |
| Optimistic Offline Lock | Two users can edit the same record and overwrite each other's changes | The data is single-writer or append-only | optimisticOfflineLock.html |
| Transaction Script | Simple procedures with little shared logic: one function per use case | Rules repeated across scripts: move them to a domain model or service | transactionScript.html |

## Structure
- A module per feature or domain (`orders/`: routes, service, repository, schemas, tests), following the repo's existing layout.
- Layers point inward: routes → services → repositories. A service never imports the HTTP request or response objects; pass plain data in and out.
- Cross-module calls go through the other module's service, never straight into its tables or repository.

## Anti-patterns
- A service that only forwards calls to a repository with the same method names (delete the layer)
- A generic `BaseRepository<T>` with every CRUD method when each entity uses two of them
- Business rules duplicated in a handler and a job (move them to the service)
- Catching errors only to log and rethrow the same error in every layer (handle them once, at the boundary)
- A queue or event bus added before anything is slow or has a second listener
