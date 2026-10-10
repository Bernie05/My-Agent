## 2. Controlled vs. Uncontrolled Components

### Uncontrolled (Component owns state)

Good for: Simple form inputs, fire-and-forget components

```tsx
const UncontrolledInput: React.FC = () => {
  const inputRef = useRef<HTMLInputElement>(null);

  const handleSubmit = () => {
    console.log("Value:", inputRef.current?.value);
  };

  return (
    <>
      <input ref={inputRef} type="text" defaultValue="Initial" />
      <button onClick={handleSubmit}>Submit</button>
    </>
  );
};
```

### Controlled (Parent owns state)

Good for: Complex validation, interdependent fields, real-time filtering

```tsx
interface ControlledInputProps {
  value: string;
  onChange: (value: string) => void;
  error?: string;
}

const ControlledInput: React.FC<ControlledInputProps> = ({
  value,
  onChange,
  error,
}) => {
  return (
    <div>
      <input
        value={value}
        onChange={(e) => onChange(e.target.value)}
        aria-invalid={!!error}
      />
      {error && <span className="error">{error}</span>}
    </div>
  );
};

// Usage
const Form = () => {
  const [email, setEmail] = useState("");
  const [error, setError] = useState("");

  const handleChange = (value: string) => {
    setEmail(value);
    setError(value.includes("@") ? "" : "Invalid email");
  };

  return (
    <ControlledInput value={email} onChange={handleChange} error={error} />
  );
};
```

**Decision tree:**

- Simple, standalone input? → Uncontrolled
- Need validation/interdependencies? → Controlled
- Building a form? → Controlled

---
