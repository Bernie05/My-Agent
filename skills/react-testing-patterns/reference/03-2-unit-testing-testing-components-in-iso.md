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
