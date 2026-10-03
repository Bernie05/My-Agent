# Pattern catalog: the 22 classic (GoF) patterns

The pattern names and grouping follow the Refactoring.Guru catalog (https://refactoring.guru/design-patterns). The summaries and examples here are original. Follow the link on each entry for the full explanation, diagrams and code. Don't paste content from those pages into code or docs. The site only allows short quotes, with a link back.

**How to use:** Grep this file for `### <Pattern>` with about 6 lines of context. Don't read it whole. Check SKILL.md > "When a pattern is earned" first. If the smell isn't in the code today, don't use the pattern. In modern JS/TS, Python, Go and similar languages, many of these collapse into a function, a map or a language feature. The **Native** line tells you when the plain form is enough.

Each entry lists: **Intent** · **Smell** (what calls for it) · **Not when** · **FE** / **BE** example · **Native** (the simpler form).

---

## Creational: how objects get made

### Factory Method
Link: https://refactoring.guru/design-patterns/factory-method
- **Intent:** let a function or subclass decide which concrete type to create, so callers depend only on the shared interface.
- **Smell:** `new X()` / `if (kind) new A() else new B()` repeated at several call sites, and the set of kinds grows.
- **Not when:** there is one concrete type, or the creation happens in one place.
- **FE:** `createChart(type)` returns a line, bar or pie renderer. **BE:** `makeNotifier(channel)` returns an email, SMS or push sender.
- **Native:** a plain function or a `{ [kind]: create }` map. You almost never need a creator class hierarchy.

### Abstract Factory
Link: https://refactoring.guru/design-patterns/abstract-factory
- **Intent:** create *families* of related objects that must match each other, without naming their concrete types.
- **Smell:** mixing parts from two families causes bugs (dark button with a light dialog; an AWS queue with a GCP bucket), and both families really ship.
- **Not when:** there is only one family today. Wait for the second.
- **FE:** a theme or platform kit that hands out a matching Button, Input and Dialog. **BE:** a cloud-provider kit that hands out a matching storage, queue and secrets client.
- **Native:** one module per family that exports the same names, chosen once at startup.

### Builder
Link: https://refactoring.guru/design-patterns/builder
- **Intent:** build a complex object step by step, so a constructor doesn't need a long list of optional arguments.
- **Smell:** constructors or functions with 6+ parameters, many of them optional, or call sites full of `undefined, undefined, true`.
- **Not when:** the language has named or keyword arguments or an options object, and the object has no ordering rules.
- **FE:** a query/filter URL builder. **BE:** a SQL query builder, or a test-data builder (`anOrder().paid().withItems(3)`).
- **Native:** an options object with defaults (`fn({ a, b = 1 })`). Use a real builder only when the steps have an order or need validation.

### Prototype
Link: https://refactoring.guru/design-patterns/prototype
- **Intent:** create new objects by copying a configured existing one instead of building from scratch.
- **Smell:** expensive or deeply configured setup repeated just to get a slightly different copy.
- **Not when:** the setup is cheap. Just construct it again.
- **FE:** cloning a template block in an editor. **BE:** copying a default config or a seed record, then overriding a few fields.
- **Native:** `structuredClone`, spread (`{ ...base, x }`), `copy.deepcopy`. Watch out for shared nested references.

### Singleton
Link: https://refactoring.guru/design-patterns/singleton
- **Intent:** guarantee one instance of something and give everyone access to it.
- **Smell:** several instances of something that must be single (a DB pool, a config, a logger) are being created by accident.
- **Not when:** almost always. A hidden global makes testing and parallel use harder. Prefer passing the dependency in.
- **FE:** one API client or store instance. **BE:** one connection pool per process.
- **Native:** a module-level instance (`export const db = createPool()`). Modules are already cached singletons. Never write a `getInstance()` class for this.

## Structural: how pieces fit together

### Adapter
Link: https://refactoring.guru/design-patterns/adapter
- **Intent:** wrap something with an incompatible interface so it matches the interface your code expects.
- **Smell:** third-party API shapes (field names, error types, callbacks) leak across many files.
- **Not when:** a stable library used in one file.
- **FE:** wrap a maps or analytics SDK behind `track(event, props)`. **BE:** wrap a payment provider behind `charge(amount, customer)`.
- **Native:** one thin module of plain functions.

### Bridge
Link: https://refactoring.guru/design-patterns/bridge
- **Intent:** split two independent dimensions of variation (what it is × how it's done) so they don't multiply into N×M classes.
- **Smell:** class or file names like `PdfInvoiceEmail`, `CsvInvoiceDownload`, `PdfReportEmail`: a grid of combinations that grows in two directions.
- **Not when:** only one dimension actually varies.
- **FE:** a chart type × a rendering backend (SVG or canvas). **BE:** a report type × an output format or delivery channel.
- **Native:** composition. Pass the "how" (a function or object) into the "what".

### Composite
Link: https://refactoring.guru/design-patterns/composite
- **Intent:** treat single items and groups of items the same way through one interface, so trees can be walked uniformly.
- **Smell:** code keeps asking `if (isGroup) loop children else handle item` on tree-shaped data.
- **Not when:** the data is flat, or the depth is fixed and shallow.
- **FE:** nested menus, file trees, a form builder's groups and fields. **BE:** permission groups containing users and groups, nested categories, price bundles.
- **Native:** a recursive type (`type Node = Leaf | { children: Node[] }`) plus one recursive function.

### Decorator
Link: https://refactoring.guru/design-patterns/decorator
- **Intent:** add behavior around an object or function by wrapping it, without changing it or subclassing it.
- **Smell:** the same before/after code (logging, retry, caching, timing, auth) copied around many calls.
- **Not when:** one call site. Just inline it.
- **FE:** `withRetry(fetchX)`, a higher-order component, a hook wrapping another hook. **BE:** middleware, interceptors, a `cached(fn)` wrapper.
- **Native:** higher-order functions, and the framework's middleware or interceptor system.

### Facade
Link: https://refactoring.guru/design-patterns/facade
- **Intent:** give a complicated subsystem one simple entry point for the common case.
- **Smell:** callers repeat the same 5-step sequence against a complex library or several services.
- **Not when:** it would just forward one call (a pass-through layer is an anti-pattern).
- **FE:** `uploadFile(file)` hiding presign, upload, progress and confirm steps. **BE:** `checkout(cart)` coordinating stock, payment and order services.
- **Native:** a single function or service method.

### Flyweight
Link: https://refactoring.guru/design-patterns/flyweight
- **Intent:** save memory by sharing the repeated, unchanging part of many small objects.
- **Smell:** profiling shows memory pressure from thousands or millions of near-identical objects.
- **Not when:** there is no measured memory problem. This is a performance fix, so measure first.
- **FE:** shared glyphs, icons or style objects in a huge canvas or grid. Usually list virtualization solves the real problem first. **BE:** interning repeated strings or lookup values in a large in-memory dataset.
- **Native:** a cache or `Map` keyed by the shared state, or the runtime's string interning.

### Proxy
Link: https://refactoring.guru/design-patterns/proxy
- **Intent:** put a stand-in with the same interface in front of a real object to control access (lazy loading, caching, access checks, remote calls).
- **Smell:** expensive or protected objects are used directly, and every caller re-implements the lazy loading or the check.
- **Not when:** a decorator or one plain function says it more clearly.
- **FE:** a lazy-loaded component or image placeholder, or JS `Proxy` for reactive state (frameworks already do this). **BE:** a caching repository, a rate-limited API client, an ORM lazy relation.
- **Native:** JS `Proxy`, lazy imports, the framework's caching layer.

## Behavioral: how pieces talk and share work

### Chain of Responsibility
Link: https://refactoring.guru/design-patterns/chain-of-responsibility
- **Intent:** pass a request along a list of handlers, where each one either handles it, changes it, or passes it on.
- **Smell:** one big function runs a sequence of independent checks or steps that keeps getting new ones.
- **Not when:** the steps are fixed and few. A sequence of plain calls is clearer.
- **FE:** keyboard shortcut handlers, or route guards checked in order. **BE:** HTTP middleware pipelines, validation pipelines, approval chains.
- **Native:** an array of functions run in order, or the framework's middleware.

### Command
Link: https://refactoring.guru/design-patterns/command
- **Intent:** turn an action into an object or data, so it can be queued, logged, retried or undone.
- **Smell:** you need undo/redo, a replayable history, a job queue, or the same action triggered from several UI places (button, menu, shortcut).
- **Not when:** actions run immediately once and are never stored.
- **FE:** editor undo/redo stacks, redux-style actions, a command palette. **BE:** queued jobs (`{ type: "sendEmail", payload }`), CQRS commands, audit logs.
- **Native:** a plain object `{ type, payload }` plus a handler map.

### Iterator
Link: https://refactoring.guru/design-patterns/iterator
- **Intent:** walk a collection without exposing how it's stored.
- **Smell:** callers depend on a collection's internals (indexes, cursors, page tokens) to loop over it.
- **Not when:** a plain array or list is enough.
- **FE:** paginated or infinite lists behind one "next page" API. **BE:** streaming large query results or paging through an external API.
- **Native:** language iterators and generators (`for…of`, `function*`, `async function*`, Python generators). Never hand-roll an iterator class.

### Mediator
Link: https://refactoring.guru/design-patterns/mediator
- **Intent:** make components talk through one coordinator instead of directly to each other.
- **Smell:** many components that all reference each other (an N×N tangle), where changing one breaks several others.
- **Not when:** two or three parts. Direct calls or lifting the state up is simpler. Also watch that the mediator doesn't turn into a god object.
- **FE:** a form or wizard controller coordinating fields; a parent component or store owning sibling state. **BE:** an orchestrator or workflow service coordinating several services.
- **Native:** a parent component or store (FE), or one orchestrating service function (BE).

### Memento
Link: https://refactoring.guru/design-patterns/memento
- **Intent:** capture and restore an object's state without exposing its internals.
- **Smell:** you need snapshots, undo or "discard changes", and callers are reaching into private state to copy it.
- **Not when:** the state is already plain immutable data. Just keep the old value.
- **FE:** form drafts with "reset", editor snapshots, time-travel debugging. **BE:** saving a workflow or game state, versioned documents.
- **Native:** immutable state plus keeping references to past versions, or `structuredClone`.

### Observer
Link: https://refactoring.guru/design-patterns/observer
- **Intent:** let many subscribers react to changes or events from a source that doesn't know them.
- **Smell:** a source calls N unrelated modules directly, and every new reaction means editing the source.
- **Not when:** one listener. Call it directly.
- **FE:** DOM events, store subscriptions, signals, `EventTarget`. **BE:** domain events (`order.paid` → email, invoice, stats), webhooks, `EventEmitter`.
- **Native:** `EventTarget` / `EventEmitter`, the framework's reactivity, an in-process event bus. Use a message broker only across services.

### State
Link: https://refactoring.guru/design-patterns/state
- **Intent:** let an object's behavior change with its internal state, with the legal transitions written down in one place.
- **Smell:** the same `if (status === …)` checks scattered around, and illegal moves (paid → draft) are possible.
- **Not when:** two states and one boolean.
- **FE:** wizard, checkout and upload flows; async status (`idle | loading | error | success`) as one union, not three booleans. **BE:** order, invoice or subscription lifecycles, checked in one place and ideally enforced by a DB constraint.
- **Native:** a transitions table (`{ draft: ["sent"], sent: ["paid", "void"] }`) or a state-machine library the repo already uses.

### Strategy
Link: https://refactoring.guru/design-patterns/strategy
- **Intent:** make a family of interchangeable algorithms selectable at runtime behind one call signature.
- **Smell:** a `switch` on a kind, provider or plan, repeated in several places and growing.
- **Not when:** one switch in one place.
- **FE:** sorting/filter strategies, validation rules per field type, a component map per variant. **BE:** pricing, tax or shipping rules per region; one handler per payment provider.
- **Native:** a `{ [kind]: fn }` map, or passing a function as an argument.

### Template Method
Link: https://refactoring.guru/design-patterns/template-method
- **Intent:** fix the skeleton of an algorithm in one place and let the variants fill in specific steps.
- **Smell:** several near-identical procedures that differ in one or two steps, copied in full.
- **Not when:** it would need an inheritance hierarchy. Prefer passing the varying steps as functions.
- **FE:** a shared data-table hook where each page supplies its own `fetch` and `columns`. **BE:** an import job with a fixed parse → validate → save flow and a different parser per format.
- **Native:** a function that takes the variable steps as callbacks (composition over inheritance).

### Visitor
Link: https://refactoring.guru/design-patterns/visitor
- **Intent:** add new operations over a fixed set of node types without editing those types.
- **Smell:** many different operations (render, validate, export, count) each walking the same stable tree of node types.
- **Not when:** the node types change often, or there are only one or two operations. Rarely earned in app code.
- **FE:** walking a rich-text or markdown AST (render, word count, export). **BE:** walking a query or expression AST, or a document tree for export.
- **Native:** a discriminated union plus an exhaustive `switch` per operation, or a `{ [node.type]: fn }` handler map.
