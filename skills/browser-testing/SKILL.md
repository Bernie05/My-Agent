---
name: browser-testing
description: Test a running web app in a real browser with Playwright (Node) - start the dev server, explore the page, run user flows, capture screenshots and console/network errors. Based on the approach of Anthropic's official webapp-testing skill, adapted for Node (no Python needed). Use when QA or frontend-dev must verify UI behavior end to end, reproduce a UI bug, or collect visual evidence.
---

# Browser Testing (Playwright, Node)

## Pick the tool (in this order)
1. **The project's own Playwright/Cypress setup.** If `@playwright/test` or `cypress` is in the package manifest, write tests there and run them with the project's script (e.g. `npx playwright test <file>`). Tests stay in the repo and can be re-run.
2. **Playwright MCP** (`browser_*` tools; load them with ToolSearch `playwright`). Good for interactive exploration and reproducing a bug before writing a test.
3. **A throwaway Node script** with the `playwright` package in a temp folder, when neither of the above exists. Ask before adding Playwright as a project dependency.

## Server lifecycle
- Find the dev command and port in the package scripts or README. Start it in the background, wait until the URL responds (poll with curl), run the tests, then stop the server.
- If a `webServer` block exists in `playwright.config.*`, let Playwright manage the server instead.
- Static HTML with no server → open it with a `file://` URL.

## Reconnaissance, then action
Don't guess selectors.
1. Navigate, then wait for the app to settle (`await page.waitForLoadState('networkidle')`, or a specific element to be visible).
2. Inspect the page: take an accessibility snapshot or a screenshot, and list buttons, links and inputs.
3. Choose **user-facing locators**: `getByRole`, `getByLabel`, `getByText`, `getByTestId`, rather than CSS or XPath.
4. Act, then assert on what the user sees (`await expect(locator).toBeVisible()` / `toHaveText()` / `toHaveURL()`).

```ts
import { test, expect } from '@playwright/test';

test('SC-3: shows error when required field is empty', async ({ page }) => {
  const errors: string[] = [];
  page.on('console', m => m.type() === 'error' && errors.push(m.text()));
  await page.goto('/items/new');
  await page.getByRole('button', { name: 'Save' }).click();
  await expect(page.getByText('Name is required')).toBeVisible();
  await page.screenshot({ path: 'test-results/sc-3-empty-name.png', fullPage: true });
  expect(errors).toEqual([]);
});
```

## Evidence to capture
- Screenshots at key steps and on failure (save them under `test-results/` or the feature's `qa-evidence/` folder, and reference the path).
- Console errors and failed network requests (`page.on('console')`, `page.on('requestfailed')`, response status codes).
- Viewports: mobile 390×844 and desktop 1440×900 for the responsive checks.

## Rules
- Name each test after its scenario ID (`SC-#`) so results map back to scenarios.md.
- No fixed sleeps. Wait for conditions instead.
- Use seeded test accounts and data, never real user data. Run against local or dev environments only, never production.
- Clean up: stop servers and close browsers when done.
