## Design System Maintenance

### Version Control in Figma

```
Library File Versions:
- Version history (automatic in Figma)
- Archive old versions
- Document changelog

Changelog example:
v2.0.0 (Jan 2024)
- Added Button danger variant
- Updated color palette
- Improved spacing scale

v1.9.0 (Dec 2023)
- Fixed modal focus management
- Added dark mode support
```

### Deprecating Components

```
When replacing an old component:
1. Create new component
2. Mark old as "DEPRECATED" in name
   Example: "Button/Primary [DEPRECATED]"
3. Document migration path
4. Give teams time to migrate
5. Remove after period
```

### Library Health

```
Regular audits:
- Unused components? Remove
- Inconsistent naming? Fix
- Outdated documentation? Update
- Missing variants? Add
- Design-code mismatch? Sync
```

---
