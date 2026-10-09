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
