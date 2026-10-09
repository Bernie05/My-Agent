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
