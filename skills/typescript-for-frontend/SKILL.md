---
name: typescript-for-frontend
description: Type-safe React/TypeScript components, generics, utility types, avoiding any. Use ONLY when the frontend stack is React + TypeScript.
---

# TypeScript for Frontend

> Long sections live in `reference/`. Read only the ones the current task needs (Read tool, path relative to this skill's folder).

## Core Principle

**Use types to catch errors at compile time, document intent, and improve IDE autocomplete.**

---

## 1. Type-Safe React Components
→ `reference/02-1-type-safe-react-components.md`: covers: Function Component with Props Type, Children Typing, Event Handler Typing

## 2. Generic Components
→ `reference/03-2-generic-components.md`: Reuse component logic across different types.

## 3. Utility Types for Frontend
→ `reference/04-3-utility-types-for-frontend.md`: covers: Partial - Make all props optional, Pick - Select specific properties, Omit - Exclude specific properties, Record…

## 4. Avoiding `any`
→ `reference/05-4-avoiding-any.md`: covers: ❌ Anti-pattern, ✅ Solution 1: Define the shape, ✅ Solution 2: Use unknown + narrowing, ✅ Solution 3: Type guard …

## 5. TypeScript with Hooks
→ `reference/06-5-typescript-with-hooks.md`: covers: useState with Inference, Custom Hooks with Types, useCallback with Type Safety

## 6. API Response Typing
→ `reference/07-6-api-response-typing.md`

## 7. Conditional Types (Advanced)
→ `reference/08-7-conditional-types-advanced.md`

## Best Practices

✅ Always type component props with interfaces  
✅ Use `React.FC<Props>` or `React.ReactNode` for children  
✅ Prefer explicit types over `any`  
✅ Use utility types (Pick, Omit, Partial, Record)  
✅ Create reusable types for common patterns  
✅ Type event handlers correctly  
✅ Use `unknown` instead of `any` when you need flexibility  
✅ Enable strict mode in tsconfig.json  
✅ Use type guards for runtime validation  
✅ Keep API response types documented and versioned
