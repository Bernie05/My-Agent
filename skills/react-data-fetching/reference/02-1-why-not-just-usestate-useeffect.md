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
