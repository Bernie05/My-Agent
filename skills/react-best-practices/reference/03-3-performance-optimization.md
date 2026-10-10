### 3. Performance Optimization

#### useCallback - Memoize function references

Use when passing callbacks to optimized child components (to prevent unnecessary re-renders).

```tsx
const Parent = () => {
  const [count, setCount] = useState(0);

  // Without useCallback: new function created on every render
  // const handleClick = () => setCount(c => c + 1);

  // With useCallback: same function reference unless dependencies change
  const handleClick = useCallback(() => {
    setCount((c) => c + 1);
  }, []); // No dependencies = never changes

  return <Child onClick={handleClick} />;
};
```

#### useMemo - Memoize expensive computations

Use for expensive calculations or derived state.

```tsx
const ExpensiveComponent = ({ items }: { items: Item[] }) => {
  const sorted = useMemo(() => {
    console.log("Sorting...");
    return [...items].sort((a, b) => a.name.localeCompare(b.name));
  }, [items]); // Only re-sort when items changes

  return <List items={sorted} />;
};
```

#### React.memo - Memoize entire component

Prevents re-render if props haven't changed (shallow comparison).

```tsx
const Child: React.FC<ChildProps> = ({ data, onClick }) => {
  return <div onClick={onClick}>{data}</div>;
};

// Only re-render if data or onClick reference changes
export default React.memo(Child);
```

**When to use:**

- Custom hook logic frequently called
- Expensive array/object transformations
- Child components that don't always need updates

---
