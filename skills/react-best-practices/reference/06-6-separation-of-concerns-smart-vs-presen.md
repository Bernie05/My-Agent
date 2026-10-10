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
