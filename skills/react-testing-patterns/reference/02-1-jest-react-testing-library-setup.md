## 1. Jest & React Testing Library Setup

### Basic Installation

```bash
npm install --save-dev @testing-library/react @testing-library/jest-dom @testing-library/user-event jest @types/jest
```

### Jest Config (jest.config.js)

```js
module.exports = {
  testEnvironment: "jsdom",
  setupFilesAfterEnv: ["<rootDir>/src/setupTests.ts"],
  moduleNameMapper: {
    "^@/(.*)$": "<rootDir>/src/$1", // Path aliases
  },
  collectCoverageFrom: ["src/**/*.{ts,tsx}", "!src/**/*.d.ts"],
};
```

### Setup File (setupTests.ts)

```ts
import "@testing-library/jest-dom";

// Global test utilities
global.matchMedia =
  global.matchMedia ||
  function () {
    return { matches: false, addListener: () => {}, removeListener: () => {} };
  };
```

---
