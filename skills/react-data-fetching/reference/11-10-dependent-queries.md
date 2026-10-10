## 10. Dependent Queries

```tsx
const userId = 1;

// First query: fetch user
const { data: user } = useQuery({
  queryKey: ["user", userId],
  queryFn: () => fetchUser(userId),
});

// Second query: only runs after user is loaded
const { data: posts } = useQuery({
  queryKey: ["posts", user?.id],
  queryFn: () => fetchUserPosts(user!.id),
  enabled: !!user, // Wait for user to load
});
```

---
