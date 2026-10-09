## 4. Props Drilling Solution

**Problem:** Passing props through many layers just to reach a deep component.

```tsx
// ❌ Prop drilling nightmare
const App = ({ theme }) => <Page theme={theme} />;
const Page = ({ theme }) => <Layout theme={theme} />;
const Layout = ({ theme }) => <Content theme={theme} />;
const Content = ({ theme }) => <Button theme={theme} />; // Finally!
```

**Solution 1: Context API**

```tsx
const ThemeContext = React.createContext<"light" | "dark">("light");

const App = ({ theme }: { theme: "light" | "dark" }) => (
  <ThemeContext.Provider value={theme}>
    <Page /> {/* No need to pass theme! */}
  </ThemeContext.Provider>
);

const Button = () => {
  const theme = useContext(ThemeContext); // Access directly
  return <button className={theme}>Click</button>;
};
```

**Solution 2: Composition (move logic down)**

```tsx
// Move theme-aware logic to component that needs it
const AppWithTheme = ({ theme }) => (
  <ThemeProvider theme={theme}>
    <Page />
  </ThemeProvider>
);
```

**When to use each:**

- Context: Global state (theme, auth, locale)
- Composition: Avoid passing unrelated props

---
