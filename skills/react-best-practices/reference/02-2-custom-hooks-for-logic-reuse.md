### 2. Custom Hooks for Logic Reuse

Extract complex logic into custom hooks instead of higher-order components or render props.

**Pattern:**

```tsx
// Custom hook - reusable logic
const useFormInput = (initialValue: string) => {
  const [value, setValue] = useState(initialValue);
  return {
    value,
    bind: {
      value,
      onChange: (e: React.ChangeEvent<HTMLInputElement>) =>
        setValue(e.target.value),
    },
    reset: () => setValue(initialValue),
  };
};

// Usage
const LoginForm = () => {
  const email = useFormInput("");
  const password = useFormInput("");

  return (
    <>
      <input {...email.bind} />
      <input {...password.bind} type="password" />
    </>
  );
};
```

---
