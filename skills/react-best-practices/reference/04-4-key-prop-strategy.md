### 4. Key Prop Strategy

The `key` prop tells React which items have changed, been added, or removed.

**❌ Anti-pattern:**

```tsx
// DON'T use index as key if list can reorder/filter/add items
{
  items.map((item, index) => <Item key={index} {...item} />);
}
```

**✅ Correct:**

```tsx
// Use stable, unique identifier
{
  items.map((item) => <Item key={item.id} {...item} />);
}
```

**Why:** If you reorder items with index keys, React thinks item 0 still exists, causing:

- Form state to move with wrong items
- Animations to play incorrectly
- Component instances to become inconsistent

---
