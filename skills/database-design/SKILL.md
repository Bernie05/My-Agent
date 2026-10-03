---
name: database-design
description: Design relational database schemas and migrations in any SQL database/ORM - tables, relationships, constraints, indexes, soft delete, transactions, query optimization. Use when creating or changing the data model or fixing slow queries.
---

# Database Design

Use the database and migration tool from SPEC.md → Tech Stack (Postgres/MySQL/SQLite/SQL Server; Knex, Prisma, Drizzle, TypeORM, Eloquent, Django, Alembic, EF...). Examples below are plain SQL.

## Table conventions
```sql
CREATE TABLE items (
  id          BIGINT PRIMARY KEY,           -- or UUID, per project convention
  owner_id    BIGINT NOT NULL REFERENCES users(id),
  name        VARCHAR(200) NOT NULL,
  status      VARCHAR(20) NOT NULL DEFAULT 'active',
  amount      DECIMAL(12,2) NOT NULL DEFAULT 0,   -- money: DECIMAL, never FLOAT
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at  TIMESTAMP NULL                      -- soft delete, if the spec needs recovery/history
);
CREATE INDEX idx_items_owner_id ON items(owner_id);
```
- Always `created_at` / `updated_at`. Store timestamps in UTC.
- Use constraints to enforce rules: `NOT NULL`, `UNIQUE`, `CHECK`, foreign keys. The database is the last line of defense.
- Choose `ON DELETE` behavior deliberately (RESTRICT for records with history, CASCADE only for true children).

## Relationships
- One-to-many: foreign key on the "many" side.
- Many-to-many: junction table with a composite unique key on the two foreign keys.
- One-to-one: foreign key + UNIQUE.
- History over time (e.g. who held X when): a separate table with start/end dates rather than overwriting.

## Indexes
- Index columns used in WHERE, JOIN and ORDER BY on large tables; every foreign key.
- Composite index order = most selective / equality columns first.
- Partial index for common filters (e.g. `WHERE deleted_at IS NULL`).
- Indexes speed reads and slow writes — don't index everything.

## Soft delete
Set `deleted_at = now()` instead of deleting; every normal query filters `deleted_at IS NULL`; UNIQUE constraints must account for it.

## Migrations
- Every schema change is a migration with a working `down`/rollback.
- Never edit a migration that has already run in a shared environment — add a new one.
- Separate schema changes from large data backfills.

## Transactions & concurrency
- Wrap multi-table writes in a transaction.
- Prevent double-booking/duplicates with UNIQUE constraints or row locks (`SELECT ... FOR UPDATE`), not app-level checks alone.
- Use optimistic locking (`version` column) where concurrent edits matter.

## Query performance
- Avoid N+1: fetch related rows with a JOIN or a single `WHERE id IN (...)` / eager loading.
- Select only the needed columns; paginate lists.
- Check slow queries with `EXPLAIN` before adding indexes blindly.
- Targets unless the spec says otherwise: typical query < 100ms.

## Checklist
- [ ] Every entity in SPEC.md → Data Model has a table and constraints
- [ ] Foreign keys, indexes and ON DELETE rules chosen
- [ ] Money as DECIMAL, times in UTC
- [ ] Migration up and down both run
- [ ] Seed/test data available for QA
