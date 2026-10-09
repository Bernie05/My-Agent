## 5. Mocking Strategies

### Mocking Child Components

```tsx
// Real component
const UserProfile = ({ userId }: { userId: number }) => {
  const [user, setUser] = useState<User | null>(null);

  useEffect(() => {
    fetchUser(userId).then(setUser);
  }, [userId]);

  if (!user) return <div>Loading...</div>;
  return <div>{user.name}</div>;
};

// Mock when testing parent
jest.mock("./UserProfile", () => ({
  UserProfile: ({ userId }: { userId: number }) => (
    <div>Mocked UserProfile: {userId}</div>
  ),
}));

test("passes userId to UserProfile", () => {
  render(<ParentComponent userId={123} />);
  expect(screen.getByText("Mocked UserProfile: 123")).toBeInTheDocument();
});
```

### Mocking API Calls

```tsx
// Mock fetch
global.fetch = jest.fn();

beforeEach(() => {
  (fetch as jest.Mock).mockClear();
});

test("displays user data after fetch", async () => {
  const mockUser = { id: 1, name: "Alice" };
  (fetch as jest.Mock).mockResolvedValueOnce({
    json: async () => mockUser,
  });

  render(<UserProfile userId={1} />);

  // Wait for async data
  expect(await screen.findByText("Alice")).toBeInTheDocument();

  // Verify fetch was called correctly
  expect(fetch).toHaveBeenCalledWith("/api/users/1");
});
```

### Mocking Modules

```tsx
jest.mock("./api", () => ({
  fetchUsers: jest.fn().mockResolvedValue([{ id: 1, name: "Alice" }]),
}));

import { fetchUsers } from "./api";

test("loads users", async () => {
  const users = await fetchUsers();
  expect(users).toHaveLength(1);
  expect(users[0].name).toBe("Alice");
});
```

---
