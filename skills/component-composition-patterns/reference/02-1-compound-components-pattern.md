## 1. Compound Components Pattern

Multiple components work together as a single unit. The parent doesn't need to know about all child internals.

**Use case:** Tabs, Accordion, Dropdown, Form (with fields)

```tsx
// Define context for siblings to communicate
const TabsContext = React.createContext<{
  activeTab: string;
  setActiveTab: (id: string) => void;
} | null>(null);

// Parent coordinator
const Tabs: React.FC<{ children: React.ReactNode; defaultActive: string }> = ({
  children,
  defaultActive,
}) => {
  const [activeTab, setActiveTab] = useState(defaultActive);

  return (
    <TabsContext.Provider value={{ activeTab, setActiveTab }}>
      <div role="tablist">{children}</div>
    </TabsContext.Provider>
  );
};

// Child: Tab button
const TabButton: React.FC<{ id: string; label: string }> = ({ id, label }) => {
  const context = React.useContext(TabsContext);
  if (!context) throw new Error("TabButton must be inside Tabs");

  const { activeTab, setActiveTab } = context;
  return (
    <button
      role="tab"
      aria-selected={activeTab === id}
      onClick={() => setActiveTab(id)}
    >
      {label}
    </button>
  );
};

// Child: Tab content
const TabPanel: React.FC<{ id: string; children: React.ReactNode }> = ({
  id,
  children,
}) => {
  const context = React.useContext(TabsContext);
  if (!context) throw new Error("TabPanel must be inside Tabs");

  const { activeTab } = context;
  return activeTab === id ? <div role="tabpanel">{children}</div> : null;
};

// Usage - clean, intuitive API
<Tabs defaultActive="tab1">
  <TabButton id="tab1" label="Profile" />
  <TabButton id="tab2" label="Settings" />
  <TabPanel id="tab1">Profile content</TabPanel>
  <TabPanel id="tab2">Settings content</TabPanel>
</Tabs>;
```

**Why this pattern:**

- Clear, declarative API
- Flexible nesting
- Siblings communicate via context
- Avoids "props drilling"

---
