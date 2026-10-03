---
name: design-patterns
description: Proven UI/UX patterns (forms, navigation, tables, empty/error/loading states, modals). Use when choosing how a screen or interaction should work. Not for code/software design patterns (see code-patterns).
---

# Design Patterns

## Core Patterns

### 1. Button Patterns

- **Primary Action** - Main call-to-action (high contrast, prominent)
- **Secondary Action** - Alternative action (lower contrast)
- **Tertiary Action** - Additional options (minimal style)
- **Danger Action** - Destructive actions (red, warning)
- **Loading State** - Disabled with spinner during submission
- **Disabled State** - Cannot be interacted (low opacity, cursor not-allowed)

**Sizing:**

- Small (32px height) - Inline actions, compact spaces
- Medium (40px height) - Default, most common
- Large (48px height) - Hero actions, mobile primary

**Best Practices:**

- Minimum touch target: 44x44px
- Clear hover state (color, shadow, or scale)
- Loading state shows feedback
- Disabled state is obvious

---

### 2. Card Patterns

- **Simple Card** - Image + title + description
- **Interactive Card** - Clickable entire card + hover state
- **Card with Actions** - Card + action buttons in footer
- **Expandable Card** - Collapsed/expanded states
- **Featured Card** - Highlighted with special styling

**Spacing:**

- Padding: 16px (mobile), 24px (desktop)
- Gap between cards: 16px
- Border radius: 8px (standard)

**States:**

- Default
- Hover (shadow increase, scale 1.02)
- Focus (outline/border)
- Active/Selected

---

### 3. Form Patterns

- **Text Input** - Single line, multiple lines (textarea)
- **Select Dropdown** - Multiple options
- **Checkbox** - Multiple selections
- **Radio Button** - Single selection from group
- **Date Picker** - Calendar, date range
- **File Upload** - Drag-drop + file selection
- **Toggle Switch** - On/off state

**Validation:**

- Required field indicator (\*)
- Error message (red text, icon)
- Success state (green checkmark)
- Loading state (spinner)
- Help text (gray, below field)

**Accessibility:**

- `<label>` associated with input
- `aria-required` for required fields
- `aria-invalid` for error states
- Error ID in `aria-describedby`

---

### 4. Navigation Patterns

- **Horizontal Navbar** - Top navigation (desktop)
- **Mobile Menu** - Hamburger menu (mobile)
- **Sidebar** - Side navigation
- **Breadcrumbs** - Navigation path
- **Tabs** - Horizontal tabs
- **Pagination** - Page navigation
- **Stepper** - Progress through steps

**Mobile Considerations:**

- Hamburger menu at top
- Touch-friendly spacing (44x44px)
- Full-screen overlay menu

---

### 5. Modal/Overlay Patterns

- **Modal Dialog** - Centered, blocking overlay
- **Drawer/Sidebar Modal** - Slides from edge
- **Popover** - Floating panel near trigger
- **Tooltip** - Small hover info
- **Dropdown Menu** - Context menu
- **Alert Dialog** - Requires user action

**Keyboard Support:**

- Escape to close
- Focus trap inside modal
- Focus returns to trigger after close

---

### 6. Loading/State Patterns

- **Skeleton Loader** - Gray placeholder shapes
- **Spinner** - Rotating icon
- **Progress Bar** - Linear progress
- **Empty State** - No data message
- **Error State** - Error message with retry
- **Success State** - Confirmation message

---

### 7. List Patterns

- **Simple List** - Items in vertical stack
- **List with Icons** - Icon + content
- **List with Avatars** - User profiles
- **Data Table** - Rows/columns with data
- **Grouped List** - Sections with headers
- **Sortable List** - Click column to sort

**Interactions:**

- Hover state (background color change)
- Selection (checkbox, highlight)
- Draggable (drag to reorder)
- Expandable (expand/collapse rows)

---

### 8. Badge/Tag Patterns

- **Status Badge** - Success, warning, error, info
- **Count Badge** - Notification count
- **Label Tag** - Categorization
- **Pill Tag** - Rounded tag with close button
- **Avatar Badge** - Small avatar with status

**Colors:**

- Success: Green (#10B981)
- Warning: Yellow (#F59E0B)
- Error: Red (#EF4444)
- Info: Blue (#3B82F6)

---

### 9. Breadcrumb Pattern

```
Home > Products > Shoes > Nike Air Max

- Shows navigation path
- Last item is current page (no link)
- Click to navigate back
- Mobile: Collapse to icon + current page
```

---

### 10. Search Pattern

- **Search Input** - Text input with search icon
- **Search Results** - Filtered list or no results state
- **Search Suggestions** - Autocomplete dropdown
- **Advanced Search** - Filters + facets
- **Search State** - Loading during search

---

## Pattern Selection Matrix

| Use Case           | Pattern             | When               |
| ------------------ | ------------------- | ------------------ |
| Main action        | Primary Button      | Once per section   |
| Alternative action | Secondary Button    | 2+ actions needed  |
| Destroy data       | Danger Button       | Destructive action |
| Display info       | Card                | Content grouping   |
| User input         | Form inputs         | Data entry         |
| Navigate sections  | Tabs or Sidebar     | 3-5 sections       |
| Show options       | Dropdown menu       | 5+ options         |
| Get confirmation   | Modal dialog        | Important decision |
| Show loading       | Skeleton or Spinner | Data loading       |
| No data            | Empty state         | No results         |

---

## Best Practices

✅ **Consistent spacing** (4px, 8px, 12px, 16px grid)
✅ **Touch targets >= 44x44px**
✅ **Color contrast >= 4.5:1**
✅ **Clear feedback** (hover, focus, active states)
✅ **Keyboard navigation** (tab, enter, escape)
✅ **Semantic HTML** (use correct elements)
✅ **ARIA labels** (for screen readers)
✅ **Mobile-first design** (then enhance for desktop)
✅ **Consistent patterns** (reuse components)
✅ **Visual hierarchy** (size, color, weight, spacing)
