## 3. Render Props Pattern

Pass a function as a prop that returns JSX. Component uses it to render content.

**Use case:** Conditional rendering, data-driven components

```tsx
interface RenderPropsChildrenProps {
  data: string;
  loading: boolean;
  error?: Error;
}

const DataFetcher: React.FC<{
  url: string;
  children: (props: RenderPropsChildrenProps) => React.ReactNode;
}> = ({ url, children }) => {
  const [data, setData] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error>();

  useEffect(() => {
    fetch(url)
      .then((r) => r.json())
      .then((d) => {
        setData(d);
        setLoading(false);
      })
      .catch((e) => {
        setError(e);
        setLoading(false);
      });
  }, [url]);

  return <>{children({ data, loading, error })}</>;
};

// Usage
<DataFetcher url="/api/user">
  {({ data, loading, error }) => (
    <>
      {loading && <div>Loading...</div>}
      {error && <div>Error: {error.message}</div>}
      {data && <div>{data}</div>}
    </>
  )}
</DataFetcher>;
```

**vs. Hooks (modern approach):**
Render props is older. **Prefer custom hooks** for the same effect:

```tsx
// Modern: Custom hook instead
const useDataFetcher = (url: string) => {
  const [data, setData] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error>();

  useEffect(() => {
    fetch(url)
      .then((r) => r.json())
      .then((d) => {
        setData(d);
        setLoading(false);
      })
      .catch((e) => {
        setError(e);
        setLoading(false);
      });
  }, [url]);

  return { data, loading, error };
};

// Usage - cleaner
const MyComponent = () => {
  const { data, loading, error } = useDataFetcher("/api/user");
  // ...
};
```

---
