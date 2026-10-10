## 6. Loading States

### Handling Different States

```tsx
const { data, status, isLoading, isError, error, isFetching } = useQuery({
  queryKey: ["user"],
  queryFn: fetchUser,
});

return (
  <>
    {isLoading && <SkeletonLoader />} {/* First load */}
    {isError && <ErrorAlert error={error?.message} />}
    {data && (
      <>
        <UserCard user={data} />
        {isFetching && <RefreshingIndicator />} {/* Background refetch */}
      </>
    )}
  </>
);
```

### Status-based Rendering

```tsx
const { status, data, error } = useQuery({
  queryKey: ["user"],
  queryFn: fetchUser,
});

switch (status) {
  case "pending":
    return <Skeleton />;
  case "error":
    return <ErrorAlert error={error?.message} />;
  case "success":
    return <UserCard user={data} />;
}
```

---
