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
