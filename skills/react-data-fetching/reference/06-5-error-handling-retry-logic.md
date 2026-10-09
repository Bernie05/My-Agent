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
