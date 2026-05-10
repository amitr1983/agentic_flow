# CLAUDE.md

This repo runs a human-in-the-loop multi-agent SDLC for iOS development.

## Pipeline

Each step is owned by one agent. The human reviews and approves before the next step starts.

```
product-agent  →  shape-agent  →  scope-agent  →  jira-stories-agent
                                                          ↓
ci-agent  ←  review-agent  ←  qa-agent  ←  implementation-agent
```

## Agent Files

Each agent's role, inputs, outputs, and steps are defined in `agents/`.

| Agent | File | Writes To |
|-------|------|-----------|
| Product | `agents/product-agent.md` | `docs/01-project-definition.md` |
| Shape | `agents/shape-agent.md` | `docs/02-shape.md` |
| Scope | `agents/scope-agent.md` | `docs/03-bet-and-scope.md` |
| Jira Stories | `agents/jira-stories-agent.md` | `docs/04-jira-stories.md` |
| Implementation | `agents/implementation-agent.md` | `src/` |
| QA | `agents/qa-agent.md` | `docs/05-review-notes.md` |
| Review | `agents/review-agent.md` | `docs/05-review-notes.md` |
| CI | `agents/ci-agent.md` | `.github/workflows/ci.yml` |

## Rules

- The human owns product judgment, architecture decisions, and final approval.
- Never skip a step without explicit human approval.
- Update docs when scope changes.
- Ask before any destructive git action.
- Keep code simple. No over-engineering.
- Prefer SwiftUI. No UIKit.
- Tests are required for all business logic.

## Engineering Standards

### Architecture & Design
- **MVVM**: Model (plain Swift value type), ViewModel (`@Observable`, protocol-backed), View (pure SwiftUI, zero logic).
- **SOLID**:
  - Single Responsibility: Model owns data, ViewModel owns logic, View owns display.
  - Open/Closed: Extend via protocols, not by modifying concrete types.
  - Liskov Substitution: ViewModels conform to protocols; views depend on the protocol.
  - Interface Segregation: Keep protocols focused and minimal.
  - Dependency Inversion: Views depend on ViewModel protocols, not concrete classes.
- **Clean Code**: Meaningful names, small focused methods, no magic values, no dead code, no comments that restate what the code says.
- **Principal iOS Engineer standard**: Code must be production-quality — correct, testable, idiomatic Swift.

### Swift Style Guide (Google Swift Style Guide)
Source: https://google.github.io/swift/

#### Naming
- `lowerCamelCase` for variables, properties, functions; `UpperCamelCase` for types and protocols.
- No Hungarian notation, no `k`/`g` prefixes for constants — use `lowerCamelCase`.
- File name matches the primary type it contains. Extensions: `TypeName+ProtocolName.swift`.
- One top-level type per file.

#### Formatting
- 100-character column limit.
- K&R brace style: opening brace on the same line, never on its own line.
- No semicolons. One statement per line.
- No parentheses around `if` / `guard` / `while` / `switch` conditions.
- Spaces after commas, around binary/ternary operators; no space around `.` or range operators.
- Two spaces before inline `//` comments; one space after `//`.
- Trailing commas required in multi-line array and dictionary literals.

#### Programming Practices
- Use `guard` for early exits; keep the happy path flush-left.
- Avoid force-unwrap (`!`) and implicitly unwrapped optionals — requires a comment explaining the safety invariant if used.
- Never use `try!` in production code.
- Use shorthand type syntax: `[Element]`, `[Key: Value]`, `Wrapped?`.
- One `let`/`var` declaration per line (exception: tuple destructuring).
- Prefer empty-case `enum` for namespacing constants over a struct with a private `init`.
- Use `where` clause on `for` loops instead of an inner `if` when the entire body is conditional.
- Use standard (trapping) arithmetic operators; avoid custom operators.
- Place `let`/`var` individually before each element in pattern matching, not distributed.
- Read-only computed properties: omit the `get` block, nest the body directly.

#### Documentation
- Use `///` triple-slash for all documentation comments; never `/** */` block comments.
- Required for all `public` and `open` declarations.
- Begin with a single-sentence summary ending in a period.
- Use `// MARK: -` to organise code into logical sections.
- Code must compile with zero warnings.

## Current State

| Doc | Status |
|-----|--------|
| `docs/01-project-definition.md` | Done |
| `docs/02-shape.md` | Pending |
| `docs/03-bet-and-scope.md` | Pending |
| `docs/04-jira-stories.md` | Pending |
| `docs/05-review-notes.md` | Pending |
| `src/` | Pending |
| `.github/workflows/ci.yml` | Pending |
