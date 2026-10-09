## 9. Pagination & Infinite Queries

### Infinite Query (Load More)

```tsx
const { data, fetchNextPage, hasNextPage, isFetchingNextPage } =
  useInfiniteQuery({
    queryKey: ["posts"],
    queryFn: ({ pageParam = 1 }) => fetchPosts(pageParam),
    getNextPageParam: (lastPage) => lastPage.nextPage ?? undefined,
    initialPageParam: 1,
  });

return (
  <>
    {data?.pages.map((page) =>
      page.items.map((post) => <PostCard key={post.id} post={post} />),
    )}
    <button
      onClick={() => fetchNextPage()}
      disabled={!hasNextPage || isFetchingNextPage}
    >
      {isFetchingNextPage ? "Loading..." : "Load More"}
    </button>
  </>
);
```

---
