---
name: react-data-fetching
description: TanStack Query / SWR data fetching - caching, invalidation, retries, loading states. Use ONLY when a React frontend talks to an API.
---

# API Integration & Data Fetching

> Long sections live in `reference/`. Read only the ones the current task needs (Read tool, path relative to this skill's folder).

## Core Principle

**Separate data fetching from UI rendering. Use a dedicated library for caching, synchronization, and state management.**

---

## 1. Why Not Just useState + useEffect?
→ `reference/02-1-why-not-just-usestate-useeffect.md`: ❌ No caching (re-fetches on every component mount)

## 2. React Query (TanStack Query) Approach
→ `reference/03-2-react-query-tanstack-query-approach.md`: ✅ Automatic caching by queryKey

## 3. Query Keys Strategy
→ `reference/04-3-query-keys-strategy.md`: Query keys are crucial for caching and invalidation. Think of them as database indices.

## 4. Mutations (Create/Update/Delete)
→ `reference/05-4-mutations-create-update-delete.md`: covers: useMutation for POST/PUT/DELETE

## 5. Error Handling & Retry Logic
→ `reference/06-5-error-handling-retry-logic.md`: covers: Custom Retry Logic, Global Error Handling

## 6. Loading States
→ `reference/07-6-loading-states.md`: covers: Handling Different States, Status-based Rendering

## 7. Cache Invalidation
→ `reference/08-7-cache-invalidation.md`: covers: Invalidate and Refetch, Partial Invalidation, Optimistic Updates

## 8. SWR Alternative (Simpler Syntax)
→ `reference/09-8-swr-alternative-simpler-syntax.md`: If you prefer a lighter library:

## 9. Pagination & Infinite Queries
→ `reference/10-9-pagination-infinite-queries.md`: covers: Infinite Query (Load More)

## 10. Dependent Queries
→ `reference/11-10-dependent-queries.md`

## Best Practices
→ `reference/12-best-practices.md`: ✅ Use React Query or SWR, not manual useState

## Architecture Pattern
→ `reference/13-architecture-pattern.md`

## ERROR HANDLING
→ `reference/14-error-handling.md`
