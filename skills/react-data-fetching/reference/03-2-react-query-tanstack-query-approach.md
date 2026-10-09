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
