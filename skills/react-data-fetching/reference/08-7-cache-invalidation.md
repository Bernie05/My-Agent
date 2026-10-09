## 7. Cache Invalidation

### Invalidate and Refetch

```tsx
const queryClient = useQueryClient();

const createUser = useMutation({
  mutationFn: (newUser: User) => postUser(newUser),
  onSuccess: () => {
    // Invalidate entire user list
    queryClient.invalidateQueries({
      queryKey: userKeys.lists(),
    });
  },
});
```

### Partial Invalidation

```tsx
// Invalidate only specific user
queryClient.invalidateQueries({
  queryKey: userKeys.detail(userId),
});

// Invalidate all users (any userId)
queryClient.invalidateQueries({
  queryKey: userKeys.all,
});

// Invalidate with filters
queryClient.invalidateQueries({
  queryKey: userKeys.list({ status: "active" }),
  exact: false, // Match all that start with this key
});
```

### Optimistic Updates

```tsx
const queryClient = useQueryClient();

const updateMutation = useMutation({
  mutationFn: (newData: Partial<User>) => updateUser(userId, newData),
  onMutate: async (newData) => {
    // Cancel any outgoing refetches
    await queryClient.cancelQueries({
      queryKey: userKeys.detail(userId),
    });

    // Snapshot previous value
    const previousUser = queryClient.getQueryData(userKeys.detail(userId));

    // Optimistically update cache
    queryClient.setQueryData(userKeys.detail(userId), (old: User) => ({
      ...old,
      ...newData,
    }));

    return { previousUser }; // Returned to onError
  },
  onError: (error, newData, context) => {
    // Rollback on error
    if (context) {
      queryClient.setQueryData(userKeys.detail(userId), context.previousUser);
    }
  },
  onSuccess: () => {
    // Revalidate from server after success
    queryClient.invalidateQueries({
      queryKey: userKeys.detail(userId),
    });
  },
});
```

---
