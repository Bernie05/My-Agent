---
name: typescript-for-frontend
description: Type-safe React/TypeScript components, generics, utility types, avoiding any. Use ONLY when the frontend stack is React + TypeScript.
---

# TypeScript for Frontend

## Core Principle

**Use types to catch errors at compile time, document intent, and improve IDE autocomplete.**

---

## 1. Type-Safe React Components

### Function Component with Props Type

```tsx
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: "primary" | "secondary";
  disabled?: boolean;
}

const Button: React.FC<ButtonProps> = ({
  label,
  onClick,
  variant = "primary",
  disabled = false,
}) => (
  <button
    className={`btn btn-${variant}`}
    onClick={onClick}
    disabled={disabled}
  >
    {label}
  </button>
);
```

### Children Typing

```tsx
interface LayoutProps {
  children: React.ReactNode; // Any valid JSX
  title?: string;
}

const Layout: React.FC<LayoutProps> = ({ children, title }) => (
  <div>
    {title && <h1>{title}</h1>}
    <main>{children}</main>
  </div>
);

// If you need more specific children:
interface FormProps {
  children: React.ReactElement<FormFieldProps>[]; // Only FormField components
}

const Form: React.FC<FormProps> = ({ children }) => <form>{children}</form>;
```

### Event Handler Typing

```tsx
interface InputProps {
  onChange: (value: string) => void;
  onBlur?: (e: React.FocusEvent<HTMLInputElement>) => void;
}

const Input: React.FC<InputProps> = ({ onChange, onBlur }) => (
  <input
    onChange={(e) => onChange(e.target.value)} // e is typed as ChangeEvent
    onBlur={onBlur}
  />
);

// Specific handler type
type ClickHandler = (e: React.MouseEvent<HTMLButtonElement>) => void;

const MyButton: React.FC<{ onClick: ClickHandler }> = ({ onClick }) => (
  <button onClick={onClick}>Click me</button>
);
```

---

## 2. Generic Components

Reuse component logic across different types.

### Generic List Component

```tsx
interface ListProps<T> {
  items: T[];
  renderItem: (item: T) => React.ReactNode;
  keyExtractor: (item: T) => string | number;
}

const List = <T,>({ items, renderItem, keyExtractor }: ListProps<T>) => (
  <ul>
    {items.map((item) => (
      <li key={keyExtractor(item)}>{renderItem(item)}</li>
    ))}
  </ul>
);

// Usage
interface User {
  id: number;
  name: string;
}

const users: User[] = [{ id: 1, name: "Alice" }];

<List<User>
  items={users}
  renderItem={(user) => user.name} // user is typed as User
  keyExtractor={(user) => user.id}
/>;
```

### Generic Form Input Component

```tsx
interface FormInputProps<T> {
  value: T;
  onChange: (value: T) => void;
  formatter?: (value: T) => string;
  parser?: (str: string) => T;
}

const FormInput = <T,>({
  value,
  onChange,
  formatter,
  parser,
}: FormInputProps<T>) => {
  const displayValue = formatter ? formatter(value) : String(value);

  return (
    <input
      value={displayValue}
      onChange={(e) => {
        const newValue = parser
          ? parser(e.target.value)
          : (e.target.value as any);
        onChange(newValue);
      }}
    />
  );
};

// Usage
<FormInput<number>
  value={age}
  onChange={setAge}
  formatter={(n) => n.toString()}
  parser={(s) => parseInt(s, 10)}
/>;
```

---

## 3. Utility Types for Frontend

### Partial - Make all props optional

```tsx
interface UserProfile {
  name: string;
  email: string;
  bio: string;
}

// For form submissions with incomplete data
type PartialUserUpdate = Partial<UserProfile>; // All fields optional
```

### Pick - Select specific properties

```tsx
interface User {
  id: number;
  name: string;
  email: string;
  password: string;
  createdAt: Date;
}

// Public user info (exclude password)
type PublicUserInfo = Pick<User, "id" | "name" | "email">;

interface UserDisplayProps extends PublicUserInfo {
  avatarUrl?: string;
}
```

### Omit - Exclude specific properties

```tsx
// Same as Pick approach above, but explicitly exclude
type PublicUserInfo = Omit<User, "password" | "createdAt">;
```

### Record - Map keys to values

```tsx
// Status badge colors
const statusColors: Record<"success" | "error" | "warning", string> = {
  success: "green",
  error: "red",
  warning: "yellow",
};

// Component with status variants
interface BadgeProps {
  status: keyof typeof statusColors; // Autocomplete: success | error | warning
}

const Badge: React.FC<BadgeProps> = ({ status }) => (
  <div style={{ color: statusColors[status] }}>Status: {status}</div>
);
```

### Exclude - Remove types from union

```tsx
type UserRole = "admin" | "user" | "guest";
type EditableRoles = Exclude<UserRole, "guest">; // admin | user

const allowedRoles: EditableRoles[] = ["admin", "user"]; // ✅
// allowedRoles.push("guest"); // ❌ Error
```

### Readonly - Make properties immutable

```tsx
interface AppSettings {
  apiUrl: string;
  maxRetries: number;
}

type ReadonlySettings = Readonly<AppSettings>;

const config: ReadonlySettings = {
  apiUrl: "https://api.example.com",
  maxRetries: 3,
};

// config.apiUrl = "changed"; // ❌ Error: Cannot assign to readonly property
```

---

## 4. Avoiding `any`

### ❌ Anti-pattern

```tsx
const processData = (data: any) => {
  // No type safety - data could be anything
  return data.user.name.toUpperCase();
};
```

### ✅ Solution 1: Define the shape

```tsx
interface DataShape {
  user: {
    name: string;
  };
}

const processData = (data: DataShape) => {
  return data.user.name.toUpperCase(); // Type-safe
};
```

### ✅ Solution 2: Use unknown + narrowing

```tsx
const processData = (data: unknown) => {
  if (typeof data === "object" && data !== null && "user" in data) {
    const typedData = data as DataShape; // Narrowed type
    return typedData.user.name.toUpperCase();
  }
  throw new Error("Invalid data shape");
};
```

### ✅ Solution 3: Type guard function

```tsx
const isDataShape = (data: unknown): data is DataShape => {
  return (
    typeof data === "object" &&
    data !== null &&
    "user" in data &&
    typeof (data as any).user.name === "string"
  );
};

const processData = (data: unknown) => {
  if (!isDataShape(data)) throw new Error("Invalid data");
  return data.user.name.toUpperCase(); // data is now DataShape
};
```

---

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

## 6. API Response Typing

```tsx
// Define API contracts
interface ApiResponse<T> {
  status: "success" | "error";
  data?: T;
  message?: string;
}

interface User {
  id: number;
  name: string;
  email: string;
}

// Type-safe fetch
const fetchUser = async (id: number): Promise<ApiResponse<User>> => {
  const res = await fetch(`/api/users/${id}`);
  return res.json();
};

// Usage with type safety
const MyComponent = () => {
  const [user, setUser] = useState<User | null>(null);

  useEffect(() => {
    fetchUser(1).then((response) => {
      if (response.status === "success" && response.data) {
        setUser(response.data); // response.data is typed as User
      }
    });
  }, []);
};
```

---

## 7. Conditional Types (Advanced)

```tsx
// Show delete button only if component can handle deletion
type ButtonProps<CanDelete extends boolean = false> = {
  onClick: () => void;
  label: string;
} & (CanDelete extends true
  ? { onDelete: () => void; deleteLabel: string }
  : {});

const Button = <T extends boolean = false>(props: ButtonProps<T>) => {
  // Button implementation
};

// Usage
<Button onClick={() => {}} label="Submit" />;
<Button
  onClick={() => {}}
  label="Submit"
  onDelete={() => {}}
  deleteLabel="Delete"
/>;
```

---

## Best Practices

✅ Always type component props with interfaces  
✅ Use `React.FC<Props>` or `React.ReactNode` for children  
✅ Prefer explicit types over `any`  
✅ Use utility types (Pick, Omit, Partial, Record)  
✅ Create reusable types for common patterns  
✅ Type event handlers correctly  
✅ Use `unknown` instead of `any` when you need flexibility  
✅ Enable strict mode in tsconfig.json  
✅ Use type guards for runtime validation  
✅ Keep API response types documented and versioned
