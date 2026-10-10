## 7. Async Testing

### Using waitFor

```tsx
test("displays loaded data", async () => {
  (fetch as jest.Mock).mockResolvedValueOnce({
    json: async () => ({ name: "Alice" }),
  });

  render(<UserComponent />);

  // Wait for async operations to complete
  await waitFor(() => {
    expect(screen.getByText("Alice")).toBeInTheDocument();
  });
});
```

### Using findBy Queries

```tsx
test("displays user after load", async () => {
  render(<UserComponent />);

  // findBy waits for element (combines getBy + waitFor)
  const userName = await screen.findByText("Alice");
  expect(userName).toBeInTheDocument();
});
```

### Avoiding waitFor Mistakes

```tsx
// ❌ DON'T: Wrap assertion logic in waitFor
await waitFor(() => {
  const elements = screen.getAllByRole("listitem"); // Called every poll
  expect(elements).toHaveLength(3);
  elements.forEach(/* more logic */); // Re-executed
});

// ✅ DO: Only check the final assertion
await waitFor(() => {
  expect(screen.getAllByRole("listitem")).toHaveLength(3);
});
```

---
