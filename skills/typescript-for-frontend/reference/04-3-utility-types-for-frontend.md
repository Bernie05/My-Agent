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
