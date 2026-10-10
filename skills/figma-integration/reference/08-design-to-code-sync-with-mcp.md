## Design-to-Code Sync with MCP

### Figma MCP tools (real names)

| Tool | Use | Load this skill first |
|---|---|---|
| `create_new_file` | New Figma Design / FigJam file | `figma:figma-create-new-file` |
| `use_figma` | Create/edit nodes, variables, components, auto-layout | `figma:figma-use` (+ `figma:figma-generate-library` for systems, `figma:figma-generate-design` for screens) |
| `search_design_system` / `get_libraries` | Find existing library components/variables to reuse | — |
| `get_metadata` / `get_variable_defs` | Inspect structure and tokens | — |
| `get_screenshot` | Visually verify what was built | — |
| `generate_diagram` | User flows / sitemaps in FigJam | `figma:figma-generate-diagram` |
| `get_design_context` | Design → code (frontend-dev) | `figma:figma-design-to-code` |

The tools may be deferred: load them with ToolSearch (`figma`) before the first call.

### Workflow (this setup)

```
/design:start <feature>      figma-designer builds foundations, components, screens  → Gate 0
/design:approve              DESIGN.md handoff → architect /arch:analyze (Gate 1)
/fe:code F#                  frontend-dev reads DESIGN.md + get_design_context per frame
/design:review <url>         figma-designer compares implementation vs design
```

---
