## 5. TypeScript with Hooks

### useState with Inference

```tsx
// Type inferred from initial value
const [count, setCount] = useState(0); // count: number

// Explicitly type when needed
const [user, setUser] = useState<User | null>(null);

// For complex state
interface FormState {
  email: string;
  password: string;
  errors: Record<string, string>;
}

const [form, setForm] = useState<FormState>({
  email: "",
  password: "",
  errors: {},
});
```

### Custom Hooks with Types

```tsx
interface UseCounterReturn {
  count: number;
  increment: () => void;
  decrement: () => void;
  reset: () => void;
}

const useCounter = (initial: number = 0): UseCounterReturn => {
  const [count, setCount] = useState(initial);

  return {
    count,
    increment: () => setCount((c) => c + 1),
    decrement: () => setCount((c) => c - 1),
    reset: () => setCount(initial),
  };
};
```

### useCallback with Type Safety

```tsx
const handleChange: React.ChangeEventHandler<HTMLInputElement> = useCallback(
  (e) => {
    // e is automatically typed as ChangeEvent<HTMLInputElement>
    console.log(e.target.value);
  },
  [],
);
```

---
