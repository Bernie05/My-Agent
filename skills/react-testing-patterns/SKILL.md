---
name: react-testing-patterns
description: Jest/Vitest + React Testing Library patterns, mocking, avoiding implementation-detail tests. Use ONLY when testing a React frontend.
---

# Testing Patterns

## Core Principle

**Test behavior, not implementation. Users don't care how your component works internally—they care what it does.**

---

## 1. Jest & React Testing Library Setup

### Basic Installation

```bash
npm install --save-dev @testing-library/react @testing-library/jest-dom @testing-library/user-event jest @types/jest
```

### Jest Config (jest.config.js)

```js
module.exports = {
  testEnvironment: "jsdom",
  setupFilesAfterEnv: ["<rootDir>/src/setupTests.ts"],
  moduleNameMapper: {
    "^@/(.*)$": "<rootDir>/src/$1", // Path aliases
  },
  collectCoverageFrom: ["src/**/*.{ts,tsx}", "!src/**/*.d.ts"],
};
```

### Setup File (setupTests.ts)

```ts
import "@testing-library/jest-dom";

// Global test utilities
global.matchMedia =
  global.matchMedia ||
  function () {
    return { matches: false, addListener: () => {}, removeListener: () => {} };
  };
```

---

## 2. Unit Testing: Testing Components in Isolation

### ❌ Anti-pattern: Testing Implementation

```tsx
// DON'T test these internals
const Counter = () => {
  const [count, setCount] = useState(0);
  return (
    <div>
      <p>{count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  );
};

// ❌ BAD: Testing state implementation
test("increments count state", () => {
  const { container } = render(<Counter />);
  const button = container.querySelector("button");
  fireEvent.click(button!);
  expect(container.querySelector("p")).toHaveTextContent("1");
});
```

### ✅ Behavior-Driven Testing

```tsx
// ✅ GOOD: Test what user sees and does
test("displays incremented number when button clicked", () => {
  render(<Counter />);

  // Initial state
  expect(screen.getByText("0")).toBeInTheDocument();

  // User interaction
  const button = screen.getByRole("button", { name: /increment/i });
  userEvent.click(button);

  // Expected result
  expect(screen.getByText("1")).toBeInTheDocument();
});
```

### Query Priority (Use in this order)

```tsx
// 1. Accessible queries (best)
screen.getByRole("button", { name: /submit/i });
screen.getByLabelText("Email");
screen.getByText("Welcome");

// 2. Semantic queries
screen.getByPlaceholderText("Enter email");
screen.getByDisplayValue("Current value");

// 3. Last resort (brittle)
screen.getByTestId("custom-id"); // Only if other methods fail
```

---

## 3. Testing Props & State Changes

### Input Component Test

```tsx
interface InputProps {
  value: string;
  onChange: (value: string) => void;
  error?: string;
}

const Input: React.FC<InputProps> = ({ value, onChange, error }) => (
  <div>
    <input
      value={value}
      onChange={(e) => onChange(e.target.value)}
      aria-invalid={!!error}
    />
    {error && <span role="alert">{error}</span>}
  </div>
);

// Test
test("calls onChange when user types", () => {
  const handleChange = jest.fn();
  render(<Input value="" onChange={handleChange} />);

  const input = screen.getByRole("textbox");
  userEvent.type(input, "hello");

  expect(handleChange).toHaveBeenCalledWith("hello");
});

test("displays error message when provided", () => {
  render(<Input value="" onChange={() => {}} error="Email is required" />);

  expect(screen.getByRole("alert")).toHaveTextContent("Email is required");
});
```

---

## 4. Integration Testing: Testing Behavior Across Components

### Form Integration Test

```tsx
interface LoginFormProps {
  onSubmit: (email: string, password: string) => void;
}

const LoginForm: React.FC<LoginFormProps> = ({ onSubmit }) => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSubmit(email, password);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        placeholder="Email"
      />
      <input
        type="password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        placeholder="Password"
      />
      <button type="submit">Login</button>
    </form>
  );
};

// Integration test - test the flow
test("form submission works end-to-end", async () => {
  const handleSubmit = jest.fn();
  render(<LoginForm onSubmit={handleSubmit} />);

  // User fills form
  userEvent.type(screen.getByPlaceholderText("Email"), "user@example.com");
  userEvent.type(screen.getByPlaceholderText("Password"), "password123");

  // User submits
  userEvent.click(screen.getByRole("button", { name: /login/i }));

  // Verify callback was called with correct values
  expect(handleSubmit).toHaveBeenCalledWith("user@example.com", "password123");
});
```

---

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

## 7. Async Testing

### Using waitFor

```tsx
test("displays loaded data", async () => {
  (fetch as jest.Mock).mockResolvedValueOnce({
    json: async () => ({ name: "Alice" }),
  });

  render(<UserComponent />);

  // Wait for async operations to complete
  await waitFor(() => {
    expect(screen.getByText("Alice")).toBeInTheDocument();
  });
});
```

### Using findBy Queries

```tsx
test("displays user after load", async () => {
  render(<UserComponent />);

  // findBy waits for element (combines getBy + waitFor)
  const userName = await screen.findByText("Alice");
  expect(userName).toBeInTheDocument();
});
```

### Avoiding waitFor Mistakes

```tsx
// ❌ DON'T: Wrap assertion logic in waitFor
await waitFor(() => {
  const elements = screen.getAllByRole("listitem"); // Called every poll
  expect(elements).toHaveLength(3);
  elements.forEach(/* more logic */); // Re-executed
});

// ✅ DO: Only check the final assertion
await waitFor(() => {
  expect(screen.getAllByRole("listitem")).toHaveLength(3);
});
```

---

## 8. Common Patterns

### Test User Interactions

```tsx
test("handles form submission", async () => {
  const onSubmit = jest.fn();
  render(<LoginForm onSubmit={onSubmit} />);

  userEvent.type(screen.getByLabelText("Email"), "test@example.com");
  userEvent.type(screen.getByLabelText("Password"), "password");
  userEvent.click(screen.getByRole("button", { name: /login/i }));

  expect(onSubmit).toHaveBeenCalledWith({
    email: "test@example.com",
    password: "password",
  });
});
```

### Test Conditional Rendering

```tsx
test("shows loading state", () => {
  render(<UserList isLoading={true} />);
  expect(screen.getByText(/loading/i)).toBeInTheDocument();
  expect(screen.queryByRole("list")).not.toBeInTheDocument();
});

test("shows list when loaded", () => {
  render(<UserList isLoading={false} users={[{ id: 1, name: "Alice" }]} />);
  expect(screen.queryByText(/loading/i)).not.toBeInTheDocument();
  expect(screen.getByRole("list")).toBeInTheDocument();
});
```

### Test Error Handling

```tsx
test("displays error message on failure", async () => {
  (fetch as jest.Mock).mockRejectedValueOnce(new Error("API Error"));

  render(<UserComponent />);

  expect(await screen.findByRole("alert")).toHaveTextContent("API Error");
});
```

---

## Best Practices

✅ Test user behavior, not implementation  
✅ Use semantic queries (getByRole, getByLabelText)  
✅ Avoid testing internal state  
✅ Mock external dependencies (API, child components)  
✅ Use userEvent instead of fireEvent  
✅ Test both happy path and error scenarios  
✅ Keep tests focused and isolated  
✅ Use descriptive test names that explain the behavior  
✅ Prefer integration tests over unit tests  
✅ Test accessibility (role, aria-labels)  
✅ Avoid testing implementation details  
✅ Don't over-mock - test real interactions when possible

---

## Coverage Goals

| Type       | Recommendation |
| ---------- | -------------- |
| Statements | 80%+           |
| Branches   | 75%+           |
| Functions  | 80%+           |
| Lines      | 80%+           |

(100% coverage is overkill and wastes time on low-value tests)
