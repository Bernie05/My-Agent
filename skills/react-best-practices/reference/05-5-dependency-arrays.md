### 5. Dependency Arrays

Always think carefully about dependencies in hooks.

**useEffect dependencies:**

```tsx
const Component = ({ userId }: { userId: string }) => {
  useEffect(() => {
    fetchUser(userId); // Depends on userId
  }, [userId]); // Include all values from closure

  // ESLint rule: exhaustive-deps catches missing dependencies
};
```

**Common mistake:**

```tsx
// ❌ Missing dependency - stale closure
useEffect(() => {
  console.log(userId); // But dependency array is empty!
}, []); // Will always log the initial userId value

// ✅ Correct
useEffect(() => {
  console.log(userId);
}, [userId]);
```

---
