---
name: test-checklist
description: Full 9-category QA checklist - functional, error handling, edge cases, permissions, integration, performance, security, accessibility, mobile. Use when planning or running complete feature testing (/qa:start-testing, /qa:test-checklist).
---

# Test Checklist (9 categories)

Adapt each item to the feature; mark ✅ PASS, ❌ FAIL (with ISSUE-###) or ➖ N/A (with reason). Thresholds below are defaults — SPEC.md overrides them.

## 1. Functional
- [ ] Main path works end to end
- [ ] All buttons/links/actions work
- [ ] Forms submit correctly
- [ ] Data saves to the database correctly
- [ ] UI updates after each action
- [ ] State persists after refresh

## 2. Error handling
- [ ] Empty required fields → clear error
- [ ] Invalid format → clear error
- [ ] Over max length → error
- [ ] Special characters handled
- [ ] Duplicate entries → error or warning per spec
- [ ] Server/network errors don't crash the app; user can recover

## 3. Edge cases
- [ ] Minimum valid input
- [ ] Maximum valid input
- [ ] Unicode / emoji
- [ ] HTML / script tags are escaped
- [ ] Rapid clicks don't create duplicates
- [ ] Network interruption mid-action
- [ ] Very slow network
- [ ] Concurrent operations on the same record
- [ ] Boundary values (0, negative, dates across month/year ends)

## 4. Permissions
- [ ] Public data readable by the intended audience only
- [ ] Private data: owner/authorized roles only
- [ ] Edit and delete: authorized users only (tested via direct API calls, not just the UI)
- [ ] Admin actions: admin only
- [ ] Unauthenticated requests rejected
- [ ] Expired/invalid tokens rejected

## 5. Integration
- [ ] API called with correct data and headers
- [ ] Responses parsed correctly; all status codes handled
- [ ] Database changes visible in the UI
- [ ] Cache invalidated after changes
- [ ] Multiple endpoints work together in the full flow

## 6. Performance
- [ ] Page load < 1s
- [ ] API response < 200ms (typical)
- [ ] List render / search < 500ms
- [ ] Interaction feedback < 100ms
- [ ] No memory leaks or janky scrolling

## 7. Security
- [ ] No XSS (user input is escaped on output)
- [ ] No SQL/command injection
- [ ] CSRF protection present (cookie auth)
- [ ] HTTPS only in production
- [ ] No secrets in code, URLs or responses
- [ ] Rate limiting present on sensitive endpoints
- [ ] Input sanitized, output encoded

## 8. Accessibility
- [ ] Fully keyboard navigable, logical tab order, visible focus
- [ ] Labels on inputs; errors linked to fields
- [ ] Color is not the only indicator; contrast ≥ 4.5:1
- [ ] Text resizable to 200% without breaking
- [ ] Alt text on images

## 9. Mobile / responsive
- [ ] Works portrait and landscape at common widths (360, 768, 1280)
- [ ] Touch targets ≥ 44–48px
- [ ] No horizontal scrolling
- [ ] Readable fonts; mobile-friendly forms
- [ ] Usable on a slow network

## Summary block (top of qa-task.md → Results)
```
Category        Pass  Fail  N/A
1 Functional     x     x     x
...
Overall: x/9 categories passed | Open issues: CRITICAL x, HIGH x, MEDIUM x, LOW x
Release recommendation: GO | NO-GO (reason)
```
