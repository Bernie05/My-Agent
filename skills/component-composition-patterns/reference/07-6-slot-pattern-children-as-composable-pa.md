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
