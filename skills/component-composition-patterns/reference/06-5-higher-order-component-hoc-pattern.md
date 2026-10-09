## 5. Higher-Order Component (HOC) Pattern

Wraps a component to add behavior (less common now, but still useful).

**Use case:** Adding auth checks, logging, styling

```tsx
const withAuth = <P extends object>(
  Component: React.ComponentType<P>,
): React.FC<P> => {
  return (props: P) => {
    const [isAuth, setIsAuth] = useState(false);

    useEffect(() => {
      checkAuthStatus().then(setIsAuth);
    }, []);

    if (!isAuth) return <div>Not authenticated</div>;
    return <Component {...props} />;
  };
};

// Usage
const Dashboard = () => <div>Dashboard</div>;
export default withAuth(Dashboard);
```

**Note:** Prefer custom hooks over HOCs in modern React.

---
