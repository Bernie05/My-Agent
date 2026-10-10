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
