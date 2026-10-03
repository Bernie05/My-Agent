---
name: material-ui
description: Build UI with Material UI (MUI, @mui/material) - theme setup, the sx prop and styled(), current v6/v7 APIs (Grid v2, slots/slotProps, CSS variables and color schemes), forms, MUI X data grid and pickers, Next.js integration, performance, accessibility, and the MUI MCP. Use ONLY when the project uses @mui/material or frontend-dev picked it for a React project.
---

# Material UI (MUI)

## Detect
- Check `package.json` for `@mui/material` and the version: **major 7, 6 or 5 changes the APIs, so check it first.** Also look for `@mui/icons-material`, `@mui/x-data-grid`, `@mui/x-date-pickers`, `@emotion/react` and `@emotion/styled`.
- Find the theme file (`theme.ts`, or `createTheme(` via grep) and where `ThemeProvider` is mounted.
- Follow the project's existing version and patterns. Never upgrade a major version as part of a feature task.

## MCP (use it when connected)
The official MUI MCP answers from the real MUI docs, which prevents made-up props and outdated v4/v5 APIs.
- Setup, for the user: `claude mcp add mui-mcp -- npx -y @mui/mcp@latest`, then restart Claude Code.
- If it isn't connected, use the docs at mui.com for the project's major version.

## Theme first
- **Design decisions live in one theme:** `createTheme({ palette, typography, shape, spacing, components })`.
  - Map DESIGN.md or Figma tokens onto `palette` (primary, secondary, error, warning, info, success, background, text), `typography` and `shape.borderRadius`.
- **Dark mode (v6+):**
  - Use `createTheme({ cssVariables: true, colorSchemes: { light: {...}, dark: {...} } })` with `useColorScheme()`.
  - Add `InitColorSchemeScript` in SSR apps to avoid a flash on load.
  - On v5, use `CssVarsProvider` or a palette `mode`.
- **Change component defaults globally** with `components.MuiButton.defaultProps` and `styleOverrides` in the theme. Don't repeat the same `sx` on every usage.
- Mount `<ThemeProvider theme={theme}><CssBaseline />…` once, at the root.

## Styling
- **One-off styles:** use the `sx` prop with theme values: `sx={{ p: 2, color: 'text.secondary', borderRadius: 1 }}`.
  - Use spacing units and palette paths, **never hard-coded pixels or hex colors**.
  - For responsive values, use objects: `sx={{ p: { xs: 1, md: 3 } }}`.
- **Reusable styled pieces:** use `styled(Component)(({ theme }) => …)`.
- Don't mix in Tailwind or CSS modules unless the project already does.

## Current APIs
Check them against the version you detected.
- **Layout:** `Stack` for one-dimensional layouts, `Grid` for two-dimensional ones.
  - In **v7**, `Grid` *is* Grid v2 (`<Grid size={{ xs: 12, md: 6 }}>`, no `item` prop). The old grid is `GridLegacy`.
  - In v5 and v6, Grid v2 is `Unstable_Grid2` / `Grid2`.
- **Customizing inner parts:** use `slots` / `slotProps`. The v4/v5 `components` / `componentsProps` / `*Props` (for example `InputProps`, `PaperProps`) are deprecated.
- **Icons:** use path imports (`import SaveIcon from '@mui/icons-material/Save'`), or named imports on a tree-shaking bundler.
  - Icon-only buttons are `IconButton` with an `aria-label`.
- **Next.js App Router:** use `@mui/material-nextjs` (`AppRouterCacheProvider`) in the root layout, and `"use client"` on interactive components.

## Components
- **Forms:** `TextField` (label, `helperText`, `error`) wired to `react-hook-form` through `Controller`, with a `zod` or `yup` schema.
  - Every input needs a visible label.
  - Show errors in `helperText`.
- **Feedback:**
  - loading: `CircularProgress` / `LinearProgress` / `Skeleton`
  - error: `Alert severity="error"`
  - success: `Snackbar` + `Alert`
  - confirm: `Dialog` with a `DialogTitle`
- **Data:** a plain `Table` for simple lists; `@mui/x-data-grid` for sorting, filtering or pagination. Check whether it's installed, and use server-side mode for large data.
- **Dates:** `@mui/x-date-pickers` with one adapter (`AdapterDayjs` or `AdapterDateFns`, whichever is installed), inside `LocalizationProvider`.
  - Don't add a date picker package when a native `<input type="date">` meets the spec (Ponytail).
- **Navigation:** `AppBar`, `Drawer`, `Tabs`, `Breadcrumbs`, `Menu`. No custom-built versions.

## Accessibility
- MUI components are accessible by default. Keep it that way:
  - `Dialog` needs `aria-labelledby` pointing at its `DialogTitle`.
  - Don't remove the focus-visible outlines.
  - Check contrast when overriding the palette (text needs 4.5:1).
- Use `component="…"` to render correct semantics, for example `<Typography component="h1" variant="h4">`.

## Performance
- Avoid building inline `sx` objects in huge lists. Use `styled()` or memoize.
- Don't wrap the app in more than one `ThemeProvider` unless you need a nested theme.

## Don'ts
- Don't install a second component library such as shadcn or Chakra next to MUI.
- Don't use `makeStyles`, `withStyles` or `@mui/styles` (v4, JSS). Use `sx` or `styled`.
- Don't use deep imports from `@mui/material/*/*` internals.
