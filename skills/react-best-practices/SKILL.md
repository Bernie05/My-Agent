---
name: react-best-practices
description: React fundamentals - hooks, component structure, rendering performance. Use ONLY when the project's stack is React (per SPEC.md Tech Stack or package.json).
---

# React Best Practices

## Core Principles

### 1. Functional Components as Default

- Always use functional components + hooks (class components are legacy)
- Hooks enable better code reuse via custom hooks
- Easier to test, reason about, and optimize

**Pattern:**

```tsx
// ✅ Preferred
const Button: React.FC<ButtonProps> = ({ label, onClick }) => {
  return <button onClick={onClick}>{label}</button>;
};

// ❌ Avoid (class components)
class Button extends React.Component { ... }
```

---

### 2. Custom Hooks for Logic Reuse

Extract complex logic into custom hooks instead of higher-order components or render props.

**Pattern:**

```tsx
// Custom hook - reusable logic
const useFormInput = (initialValue: string) => {
  const [value, setValue] = useState(initialValue);
  return {
    value,
    bind: {
      value,
      onChange: (e: React.ChangeEvent<HTMLInputElement>) =>
        setValue(e.target.value),
    },
    reset: () => setValue(initialValue),
  };
};

// Usage
const LoginForm = () => {
  const email = useFormInput("");
  const password = useFormInput("");

  return (
    <>
      <input {...email.bind} />
      <input {...password.bind} type="password" />
    </>
  );
};
```

---

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

### 4. Key Prop Strategy

The `key` prop tells React which items have changed, been added, or removed.

**❌ Anti-pattern:**

```tsx
// DON'T use index as key if list can reorder/filter/add items
{
  items.map((item, index) => <Item key={index} {...item} />);
}
```

**✅ Correct:**

```tsx
// Use stable, unique identifier
{
  items.map((item) => <Item key={item.id} {...item} />);
}
```

**Why:** If you reorder items with index keys, React thinks item 0 still exists, causing:

- Form state to move with wrong items
- Animations to play incorrectly
- Component instances to become inconsistent

---

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

### 6. Separation of Concerns: Smart vs. Presentational

- **Smart (Container)**: Handles state, side effects, business logic
- **Presentational (Dumb)**: Pure function, receives props, renders UI

```tsx
// ❌ Mixed concerns
const UserList = () => {
  const [users, setUsers] = useState([]);
  useEffect(() => {
    fetch("/api/users").then((data) => setUsers(data));
  }, []);

  return (
    <ul>
      {users.map((u) => (
        <li key={u.id}>{u.name}</li>
      ))}
    </ul>
  );
};

// ✅ Separated concerns
// Smart container
const UserListContainer = () => {
  const [users, setUsers] = useState([]);
  useEffect(() => {
    fetch("/api/users").then((data) => setUsers(data));
  }, []);

  return <UserListView users={users} />;
};

// Presentational (reusable, testable)
const UserListView: React.FC<{ users: User[] }> = ({ users }) => (
  <ul>
    {users.map((u) => (
      <li key={u.id}>{u.name}</li>
    ))}
  </ul>
);
```

---

### 7. Error Boundaries

Catch errors in component trees and display fallback UI.

```tsx
class ErrorBoundary extends React.Component {
  state = { hasError: false };

  static getDerivedStateFromError(error: Error) {
    return { hasError: true };
  }

  render() {
    if (this.state.hasError) {
      return <div>Something went wrong</div>;
    }
    return this.props.children;
  }
}

// Usage
<ErrorBoundary>
  <RiskyComponent />
</ErrorBoundary>;
```

---

## Quick Checklist

✅ Use functional components + hooks  
✅ Extract logic into custom hooks  
✅ Memoize callbacks/computations when needed  
✅ Use stable keys in lists  
✅ Include all dependencies  
✅ Separate smart/presentational components  
✅ Use Error Boundaries for error handling  
✅ Keep components small and focused
