---
name: react-data-fetching
description: TanStack Query / SWR data fetching - caching, invalidation, retries, loading states. Use ONLY when a React frontend talks to an API.
---

# API Integration & Data Fetching

## Core Principle

**Separate data fetching from UI rendering. Use a dedicated library for caching, synchronization, and state management.**

---

## 1. Why Not Just useState + useEffect?

### ❌ Manual Approach (Problematic)

```tsx
const UserProfile = ({ userId }: { userId: number }) => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    setLoading(true);
    fetch(`/api/users/${userId}`)
      .then((r) => r.json())
      .then((data) => {
        setUser(data);
        setLoading(false);
      })
      .catch((e) => {
        setError(e);
        setLoading(false);
      });
  }, [userId]);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;
  return <div>{user?.name}</div>;
};
```

**Problems:**

- ❌ No caching (re-fetches on every component mount)
- ❌ No retry logic on failure
- ❌ Manual state management (boilerplate)
- ❌ Race conditions (fast changing userId)
- ❌ No background sync
- ❌ Hard to share state across components

### ✅ Solution: Use React Query or SWR

---

## 2. React Query (TanStack Query) Approach

### Installation & Setup

```bash
npm install @tanstack/react-query
```

### QueryClient Setup (main.tsx)

```tsx
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5, // 5 minutes
      gcTime: 1000 * 60 * 10, // 10 minutes (formerly cacheTime)
      retry: 3,
      retryDelay: (attemptIndex) => 1000 * 2 ** attemptIndex, // Exponential backoff
    },
  },
});

export default function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <YourApp />
    </QueryClientProvider>
  );
}
```

### Simple Fetch Query

```tsx
// Define the query function
const fetchUser = async (userId: number): Promise<User> => {
  const res = await fetch(`/api/users/${userId}`);
  if (!res.ok) throw new Error("Failed to fetch user");
  return res.json();
};

// Use in component
const UserProfile = ({ userId }: { userId: number }) => {
  const {
    data: user,
    isLoading,
    error,
    isError,
  } = useQuery({
    queryKey: ["user", userId], // Unique key for caching
    queryFn: () => fetchUser(userId),
  });

  if (isLoading) return <div>Loading...</div>;
  if (isError) return <div>Error: {error?.message}</div>;

  return <div>{user?.name}</div>;
};
```

**Key benefits:**

- ✅ Automatic caching by queryKey
- ✅ Smart revalidation (stale/fresh)
- ✅ Built-in retry logic
- ✅ Shares state across components (same queryKey)
- ✅ Background sync

---

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

## 4. Mutations (Create/Update/Delete)

### useMutation for POST/PUT/DELETE

```tsx
const updateUser = async (userId: number, data: Partial<User>) => {
  const res = await fetch(`/api/users/${userId}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error("Failed to update user");
  return res.json();
};

const EditUserForm = ({ userId }: { userId: number }) => {
  const queryClient = useQueryClient();

  const updateMutation = useMutation({
    mutationFn: (data: Partial<User>) => updateUser(userId, data),
    onSuccess: (updatedUser) => {
      // Invalidate and refetch user data
      queryClient.invalidateQueries({
        queryKey: userKeys.detail(userId),
      });

      // Or directly update cache (optimistic update)
      queryClient.setQueryData(userKeys.detail(userId), updatedUser);
    },
    onError: (error) => {
      // Show error toast/notification
      console.error("Update failed:", error);
    },
  });

  const handleSubmit = (formData: Partial<User>) => {
    updateMutation.mutate(formData);
  };

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        handleSubmit({ name: "New Name" });
      }}
    >
      <button disabled={updateMutation.isPending}>
        {updateMutation.isPending ? "Saving..." : "Save"}
      </button>
      {updateMutation.isError && (
        <div>Error: {updateMutation.error?.message}</div>
      )}
    </form>
  );
};
```

---

## 5. Error Handling & Retry Logic

### Custom Retry Logic

```tsx
const { data, error, isLoading } = useQuery({
  queryKey: ["sensitive-data"],
  queryFn: async () => {
    const res = await fetch("/api/data");

    // Custom error handling
    if (res.status === 401) {
      throw new Error("Unauthorized - redirecting to login");
    }
    if (res.status >= 500) {
      throw new Error("Server error - will retry");
    }
    if (!res.ok) {
      throw new Error(`HTTP ${res.status}`);
    }

    return res.json();
  },
  retry: (failureCount, error) => {
    // Don't retry on 401 (auth errors)
    if (error.message.includes("Unauthorized")) return false;
    // Retry up to 3 times for server errors
    return failureCount < 3;
  },
  retryDelay: (attemptIndex) => {
    // Exponential backoff: 1s, 2s, 4s
    return Math.min(1000 * 2 ** attemptIndex, 30000);
  },
});
```

### Global Error Handling

```tsx
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: (failureCount, error: any) => {
        // Don't retry on auth errors
        if (error?.status === 401) return false;
        return failureCount < 3;
      },
    },
  },
});

// Error boundary or global error handler
queryClient.getDefaultOptions().queries?.retry;
```

---

## 6. Loading States

### Handling Different States

```tsx
const { data, status, isLoading, isError, error, isFetching } = useQuery({
  queryKey: ["user"],
  queryFn: fetchUser,
});

return (
  <>
    {isLoading && <SkeletonLoader />} {/* First load */}
    {isError && <ErrorAlert error={error?.message} />}
    {data && (
      <>
        <UserCard user={data} />
        {isFetching && <RefreshingIndicator />} {/* Background refetch */}
      </>
    )}
  </>
);
```

### Status-based Rendering

```tsx
const { status, data, error } = useQuery({
  queryKey: ["user"],
  queryFn: fetchUser,
});

switch (status) {
  case "pending":
    return <Skeleton />;
  case "error":
    return <ErrorAlert error={error?.message} />;
  case "success":
    return <UserCard user={data} />;
}
```

---

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

## 8. SWR Alternative (Simpler Syntax)

If you prefer a lighter library:

```bash
npm install swr
```

```tsx
import useSWR from "swr";

const fetcher = (url: string) => fetch(url).then((r) => r.json());

const UserProfile = ({ userId }: { userId: number }) => {
  const { data, error, isLoading } = useSWR(`/api/users/${userId}`, fetcher, {
    revalidateOnFocus: true,
    dedupingInterval: 60000, // Cache for 1 min
  });

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error</div>;

  return <div>{data?.name}</div>;
};
```

**SWR vs React Query:**

- SWR: Lighter, simpler API, good for simple use cases
- React Query: More powerful, better for complex scenarios (pagination, filters, dependent queries)

---

## 9. Pagination & Infinite Queries

### Infinite Query (Load More)

```tsx
const { data, fetchNextPage, hasNextPage, isFetchingNextPage } =
  useInfiniteQuery({
    queryKey: ["posts"],
    queryFn: ({ pageParam = 1 }) => fetchPosts(pageParam),
    getNextPageParam: (lastPage) => lastPage.nextPage ?? undefined,
    initialPageParam: 1,
  });

return (
  <>
    {data?.pages.map((page) =>
      page.items.map((post) => <PostCard key={post.id} post={post} />),
    )}
    <button
      onClick={() => fetchNextPage()}
      disabled={!hasNextPage || isFetchingNextPage}
    >
      {isFetchingNextPage ? "Loading..." : "Load More"}
    </button>
  </>
);
```

---

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

## Best Practices

✅ Use React Query or SWR, not manual useState  
✅ Create a consistent query key structure  
✅ Implement proper error handling  
✅ Use optimistic updates for better UX  
✅ Leverage cache invalidation strategies  
✅ Set appropriate stale times  
✅ Handle loading and error states  
✅ Use dependent queries for sequential data  
✅ Avoid redundant API calls with deduping  
✅ Mock API calls in tests  
✅ Keep API layer separate (custom hooks)  
✅ Use TypeScript for API contracts

---

## Architecture Pattern

```
API Layer (api.ts)
  ↓ (fetch operations)
Custom Hooks (useUser, usePost, etc.)
  ↓ (React Query + state)
Components (UI rendering)
```

```typescript
const API_BASE = "http://localhost:3000/api";

export const postService = {
  async listPosts() {
    const response = await fetch(`${API_BASE}/posts`);
    if (!response.ok) throw new Error("Failed");
    return response.json();
  },
};
```

## ERROR HANDLING

- Try/catch around fetch
- Validate responses
- Show error messages
- Retry failed requests

```

**Separation of concerns:**

- API layer: HTTP requests, error handling
- Hooks: React Query wrapper, cache keys
- Components: Pure UI, no API logic
```
