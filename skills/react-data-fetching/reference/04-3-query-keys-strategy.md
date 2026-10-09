## 3. Query Keys Strategy

Query keys are crucial for caching and invalidation. Think of them as database indices.

```tsx
// Create a file for consistent key naming
export const userKeys = {
  all: ["user"] as const,
  lists: () => [...userKeys.all, "list"] as const,
  list: (filters: UserFilters) =>
    [...userKeys.lists(), { ...filters }] as const,
  details: () => [...userKeys.all, "detail"] as const,
  detail: (id: number) => [...userKeys.details(), id] as const,
};

// Usage
const { data: users } = useQuery({
  queryKey: userKeys.list({ status: "active" }),
  queryFn: () => fetchUsers({ status: "active" }),
});

const { data: user } = useQuery({
  queryKey: userKeys.detail(1),
  queryFn: () => fetchUser(1),
});
```

**Benefits:**

- Hierarchical structure (invalidate all users: `userKeys.all`)
- Type-safe if using `as const`
- Easy to find what needs invalidating

---
