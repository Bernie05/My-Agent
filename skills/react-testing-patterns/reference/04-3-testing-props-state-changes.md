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
