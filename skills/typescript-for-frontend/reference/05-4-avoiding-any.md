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
