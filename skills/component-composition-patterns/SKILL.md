---
name: component-composition-patterns
description: React composition patterns - compound components, render props, avoiding prop drilling. Use ONLY when the stack is React and a component is getting complex.
---

# Component Composition Patterns

## Core Principle

**Composition > Inheritance**: Build complex UIs by combining small, focused components rather than creating deep inheritance hierarchies.

---

## 1. Compound Components Pattern

Multiple components work together as a single unit. The parent doesn't need to know about all child internals.

**Use case:** Tabs, Accordion, Dropdown, Form (with fields)

```tsx
// Define context for siblings to communicate
const TabsContext = React.createContext<{
  activeTab: string;
  setActiveTab: (id: string) => void;
} | null>(null);

// Parent coordinator
const Tabs: React.FC<{ children: React.ReactNode; defaultActive: string }> = ({
  children,
  defaultActive,
}) => {
  const [activeTab, setActiveTab] = useState(defaultActive);

  return (
    <TabsContext.Provider value={{ activeTab, setActiveTab }}>
      <div role="tablist">{children}</div>
    </TabsContext.Provider>
  );
};

// Child: Tab button
const TabButton: React.FC<{ id: string; label: string }> = ({ id, label }) => {
  const context = React.useContext(TabsContext);
  if (!context) throw new Error("TabButton must be inside Tabs");

  const { activeTab, setActiveTab } = context;
  return (
    <button
      role="tab"
      aria-selected={activeTab === id}
      onClick={() => setActiveTab(id)}
    >
      {label}
    </button>
  );
};

// Child: Tab content
const TabPanel: React.FC<{ id: string; children: React.ReactNode }> = ({
  id,
  children,
}) => {
  const context = React.useContext(TabsContext);
  if (!context) throw new Error("TabPanel must be inside Tabs");

  const { activeTab } = context;
  return activeTab === id ? <div role="tabpanel">{children}</div> : null;
};

// Usage - clean, intuitive API
<Tabs defaultActive="tab1">
  <TabButton id="tab1" label="Profile" />
  <TabButton id="tab2" label="Settings" />
  <TabPanel id="tab1">Profile content</TabPanel>
  <TabPanel id="tab2">Settings content</TabPanel>
</Tabs>;
```

**Why this pattern:**

- Clear, declarative API
- Flexible nesting
- Siblings communicate via context
- Avoids "props drilling"

---

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

## 3. Render Props Pattern

Pass a function as a prop that returns JSX. Component uses it to render content.

**Use case:** Conditional rendering, data-driven components

```tsx
interface RenderPropsChildrenProps {
  data: string;
  loading: boolean;
  error?: Error;
}

const DataFetcher: React.FC<{
  url: string;
  children: (props: RenderPropsChildrenProps) => React.ReactNode;
}> = ({ url, children }) => {
  const [data, setData] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error>();

  useEffect(() => {
    fetch(url)
      .then((r) => r.json())
      .then((d) => {
        setData(d);
        setLoading(false);
      })
      .catch((e) => {
        setError(e);
        setLoading(false);
      });
  }, [url]);

  return <>{children({ data, loading, error })}</>;
};

// Usage
<DataFetcher url="/api/user">
  {({ data, loading, error }) => (
    <>
      {loading && <div>Loading...</div>}
      {error && <div>Error: {error.message}</div>}
      {data && <div>{data}</div>}
    </>
  )}
</DataFetcher>;
```

**vs. Hooks (modern approach):**
Render props is older. **Prefer custom hooks** for the same effect:

```tsx
// Modern: Custom hook instead
const useDataFetcher = (url: string) => {
  const [data, setData] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error>();

  useEffect(() => {
    fetch(url)
      .then((r) => r.json())
      .then((d) => {
        setData(d);
        setLoading(false);
      })
      .catch((e) => {
        setError(e);
        setLoading(false);
      });
  }, [url]);

  return { data, loading, error };
};

// Usage - cleaner
const MyComponent = () => {
  const { data, loading, error } = useDataFetcher("/api/user");
  // ...
};
```

---

## 4. Props Drilling Solution

**Problem:** Passing props through many layers just to reach a deep component.

```tsx
// ❌ Prop drilling nightmare
const App = ({ theme }) => <Page theme={theme} />;
const Page = ({ theme }) => <Layout theme={theme} />;
const Layout = ({ theme }) => <Content theme={theme} />;
const Content = ({ theme }) => <Button theme={theme} />; // Finally!
```

**Solution 1: Context API**

```tsx
const ThemeContext = React.createContext<"light" | "dark">("light");

const App = ({ theme }: { theme: "light" | "dark" }) => (
  <ThemeContext.Provider value={theme}>
    <Page /> {/* No need to pass theme! */}
  </ThemeContext.Provider>
);

const Button = () => {
  const theme = useContext(ThemeContext); // Access directly
  return <button className={theme}>Click</button>;
};
```

**Solution 2: Composition (move logic down)**

```tsx
// Move theme-aware logic to component that needs it
const AppWithTheme = ({ theme }) => (
  <ThemeProvider theme={theme}>
    <Page />
  </ThemeProvider>
);
```

**When to use each:**

- Context: Global state (theme, auth, locale)
- Composition: Avoid passing unrelated props

---

## 5. Higher-Order Component (HOC) Pattern

Wraps a component to add behavior (less common now, but still useful).

**Use case:** Adding auth checks, logging, styling

```tsx
const withAuth = <P extends object>(
  Component: React.ComponentType<P>,
): React.FC<P> => {
  return (props: P) => {
    const [isAuth, setIsAuth] = useState(false);

    useEffect(() => {
      checkAuthStatus().then(setIsAuth);
    }, []);

    if (!isAuth) return <div>Not authenticated</div>;
    return <Component {...props} />;
  };
};

// Usage
const Dashboard = () => <div>Dashboard</div>;
export default withAuth(Dashboard);
```

**Note:** Prefer custom hooks over HOCs in modern React.

---

## 6. Slot Pattern (Children as Composable Parts)

Pass multiple chunks of JSX as "slots" to be positioned by a layout component.

```tsx
interface CardProps {
  header?: React.ReactNode;
  children: React.ReactNode;
  footer?: React.ReactNode;
}

const Card: React.FC<CardProps> = ({ header, children, footer }) => (
  <div className="card">
    {header && <div className="card-header">{header}</div>}
    <div className="card-body">{children}</div>
    {footer && <div className="card-footer">{footer}</div>}
  </div>
);

// Usage
<Card header={<h2>Title</h2>} footer={<button>Action</button>}>
  Card content here
</Card>;
```

---

## Quick Decision Tree

| Problem                               | Solution                                 |
| ------------------------------------- | ---------------------------------------- |
| Multiple siblings need to share state | Compound components + Context            |
| Props traveling through many layers   | Context API or composition               |
| Simple form input state               | Uncontrolled                             |
| Complex validation/interdependencies  | Controlled                               |
| Need to wrap/enhance components       | Custom hooks (preferred) or HOC          |
| Layout with flexible content          | Slot pattern (children + optional props) |

---

## Best Practices

✅ Compose small, focused components  
✅ Use context for genuinely global state  
✅ Prefer custom hooks over HOCs  
✅ Keep controlled/uncontrolled choice consistent  
✅ Use compound components for related UI units  
✅ Document APIs clearly when nesting is complex  
✅ Avoid prop drilling by moving logic closer to usage
