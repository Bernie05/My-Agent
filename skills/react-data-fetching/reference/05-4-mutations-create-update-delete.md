## 4. Mutations (Create/Update/Delete)

### useMutation for POST/PUT/DELETE

```tsx
const updateUser = async (userId: number, data: Partial<User>) => {
  const res = await fetch(`/api/users/${userId}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error("Failed to update user");
  return res.json();
};

const EditUserForm = ({ userId }: { userId: number }) => {
  const queryClient = useQueryClient();

  const updateMutation = useMutation({
    mutationFn: (data: Partial<User>) => updateUser(userId, data),
    onSuccess: (updatedUser) => {
      // Invalidate and refetch user data
      queryClient.invalidateQueries({
        queryKey: userKeys.detail(userId),
      });

      // Or directly update cache (optimistic update)
      queryClient.setQueryData(userKeys.detail(userId), updatedUser);
    },
    onError: (error) => {
      // Show error toast/notification
      console.error("Update failed:", error);
    },
  });

  const handleSubmit = (formData: Partial<User>) => {
    updateMutation.mutate(formData);
  };

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        handleSubmit({ name: "New Name" });
      }}
    >
      <button disabled={updateMutation.isPending}>
        {updateMutation.isPending ? "Saving..." : "Save"}
      </button>
      {updateMutation.isError && (
        <div>Error: {updateMutation.error?.message}</div>
      )}
    </form>
  );
};
```

---
