## 6. API Response Typing

```tsx
// Define API contracts
interface ApiResponse<T> {
  status: "success" | "error";
  data?: T;
  message?: string;
}

interface User {
  id: number;
  name: string;
  email: string;
}

// Type-safe fetch
const fetchUser = async (id: number): Promise<ApiResponse<User>> => {
  const res = await fetch(`/api/users/${id}`);
  return res.json();
};

// Usage with type safety
const MyComponent = () => {
  const [user, setUser] = useState<User | null>(null);

  useEffect(() => {
    fetchUser(1).then((response) => {
      if (response.status === "success" && response.data) {
        setUser(response.data); // response.data is typed as User
      }
    });
  }, []);
};
```

---
