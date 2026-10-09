## 6. Testing Hooks

### Custom Hook Test

```tsx
import { renderHook, act } from "@testing-library/react";

const useCounter = (initial: number = 0) => {
  const [count, setCount] = useState(initial);
  return {
    count,
    increment: () => setCount((c) => c + 1),
  };
};

test("increments counter", () => {
  const { result } = renderHook(() => useCounter());

  expect(result.current.count).toBe(0);

  act(() => {
    result.current.increment();
  });

  expect(result.current.count).toBe(1);
});
```

### Hook with Dependencies

```tsx
const useUser = (userId: number) => {
  const [user, setUser] = useState<User | null>(null);

  useEffect(() => {
    fetchUser(userId).then(setUser);
  }, [userId]);

  return user;
};

test("refetches when userId changes", async () => {
  const { result, rerender } = renderHook(({ userId }) => useUser(userId), {
    initialProps: { userId: 1 },
  });

  // Wait for first fetch
  await waitFor(() => {
    expect(result.current?.id).toBe(1);
  });

  // Change prop
  rerender({ userId: 2 });

  // Should fetch again
  await waitFor(() => {
    expect(result.current?.id).toBe(2);
  });
});
```

---
