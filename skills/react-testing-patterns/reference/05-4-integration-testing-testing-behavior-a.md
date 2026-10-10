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
