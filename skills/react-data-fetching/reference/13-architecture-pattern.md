## Architecture Pattern

```
API Layer (api.ts)
  ↓ (fetch operations)
Custom Hooks (useUser, usePost, etc.)
  ↓ (React Query + state)
Components (UI rendering)
```

```typescript
const API_BASE = "http://localhost:3000/api";

export const postService = {
  async listPosts() {
    const response = await fetch(`${API_BASE}/posts`);
    if (!response.ok) throw new Error("Failed");
    return response.json();
  },
};
```
