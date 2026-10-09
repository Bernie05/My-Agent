### 1. Functional Components as Default

- Always use functional components + hooks (class components are legacy)
- Hooks enable better code reuse via custom hooks
- Easier to test, reason about, and optimize

**Pattern:**

```tsx
// ✅ Preferred
const Button: React.FC<ButtonProps> = ({ label, onClick }) => {
  return <button onClick={onClick}>{label}</button>;
};

// ❌ Avoid (class components)
class Button extends React.Component { ... }
```

---
