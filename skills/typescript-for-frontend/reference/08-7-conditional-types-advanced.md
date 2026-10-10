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
