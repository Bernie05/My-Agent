---
name: shadcn-ui
description: Build UI with shadcn/ui (Radix/Base UI primitives + Tailwind, components copied into the repo) - setup, adding components with the CLI, theming with CSS variables, forms, data tables, dark mode, accessibility, and the shadcn MCP. Use ONLY when the project uses shadcn/ui (components.json, components/ui/) or frontend-dev picked it for a React/Next.js project.
---

# shadcn/ui

shadcn/ui is not a package. The CLI **copies component source into your repo** (`components/ui/*`), and you own and edit it. It is built on Radix (or Base UI) primitives and Tailwind CSS.

## Detect
- `components.json` at the root gives you `style`, `tailwind.css`, `aliases` (usually `@/components`, `@/lib/utils`) and `iconLibrary`.
- `components/ui/` and `lib/utils.ts` (with `cn()`).
- The Tailwind version: check `package.json`. v4 uses `@import "tailwindcss"` and `@theme` in CSS; v3 uses `tailwind.config.*`. Follow whichever the project has.

## MCP (use it when connected)
The shadcn MCP server searches, browses and installs components from registries. It uses current docs, which prevents made-up props.
- Setup, for the user: `npx shadcn@latest mcp init --client claude`, then restart Claude Code.
- If it isn't connected, fall back to the CLI and `npx shadcn@latest view <name>`, or the docs at ui.shadcn.com.

## Setup and adding components
- **New project:** `npx shadcn@latest init`. Accept the project's framework (Next.js, Vite, React Router…).
- **Add a component:** `npx shadcn@latest add button dialog form 2>&1 | tail -n 5`
  - Always use the CLI. Never hand-write a component that the registry ships.
  - Before adding, check whether it already exists: `ls components/ui`. **Reuse first (Ponytail).**
  - Don't pass `--overwrite` on components the project has customized.
- **Blocks** (login, dashboard, sidebar): `npx shadcn@latest add <block>`, then adapt it. Don't rebuild a layout that a block already covers.

## Rules
- **Compose, don't fork.** Build feature components out of `components/ui` primitives in `components/<feature>/`. Edit files in `components/ui` only for project-wide changes to the design system.
- **Styling:** Tailwind utilities, merged with `cn()` so callers can override (`className={cn("…", className)}`).
  - Variants go through `cva` (class-variance-authority), like the existing button. Don't add ad-hoc conditional class strings.
- **Theming:** use the semantic CSS variables in the global CSS (`--background`, `--foreground`, `--primary`, `--muted`, `--destructive`, `--border`, `--ring`, `--radius`…) and their Tailwind classes (`bg-primary`, `text-muted-foreground`).
  - **No hard-coded colors** such as `bg-blue-600` in feature code.
  - Map DESIGN.md or Figma tokens onto these variables.
- **Dark mode:** use the `.dark` class variables; in Next.js, via `next-themes` with `attribute="class"`. Every color must come from a variable, so dark mode works for free.
- **Icons:** the library named in `components.json`, usually `lucide-react`. Give icon-only buttons an `aria-label` or `sr-only` text.
- **Forms:** use the `Form` / `Field` components with `react-hook-form` and a `zod` schema, reusing the same schema as the server if one exists.
  - Show errors with `FormMessage`, or the field's error slot.
  - Disable submit and show pending state while submitting.
- **Tables:** use the `data-table` pattern (TanStack Table + `Table`) only when you need sorting, filtering or pagination. A plain `Table` is fine otherwise.
- **Toasts:** `sonner`. **Dialogs and sheets:** `Dialog` / `Sheet` / `Drawer`, never custom modals.
- **Accessibility** comes from the primitives. Keep it:
  - Never swap `DialogTitle` for a `div`. Use `VisuallyHidden` if it must be hidden.
  - Keep `asChild` semantics correct: one child element that forwards refs.
  - Keep focus rings (`focus-visible:ring-*`).
- **Next.js App Router:** interactive components need `"use client"`. Keep server components as the default and push `"use client"` down to the smallest leaf.

## All UI states
Use the primitives for the states required by `frontend-component-development`:
- **loading:** `Skeleton`, or `Button` with `disabled` and a spinner
- **empty:** a simple empty-state block
- **error:** `Alert variant="destructive"`
- **success:** a `sonner` toast

## Don'ts
- Don't install a second component library such as MUI or Chakra next to shadcn.
- Don't use raw `<button>`, `<input>` or `<select>` in feature code when `components/ui` has them.
- Don't copy components from memory. Pull them with the CLI or MCP, because APIs change between versions.
