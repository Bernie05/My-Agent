### 7. Error Boundaries

Catch errors in component trees and display fallback UI.

```tsx
class ErrorBoundary extends React.Component {
  state = { hasError: false };

  static getDerivedStateFromError(error: Error) {
    return { hasError: true };
  }

  render() {
    if (this.state.hasError) {
      return <div>Something went wrong</div>;
    }
    return this.props.children;
  }
}

// Usage
<ErrorBoundary>
  <RiskyComponent />
</ErrorBoundary>;
```

---

## Quick Checklist

✅ Use functional components + hooks  
✅ Extract logic into custom hooks  
✅ Memoize callbacks/computations when needed  
✅ Use stable keys in lists  
✅ Include all dependencies  
✅ Separate smart/presentational components  
✅ Use Error Boundaries for error handling  
✅ Keep components small and focused
