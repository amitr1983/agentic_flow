# CLAUDE.md

This repo runs a human-in-the-loop multi-agent SDLC for iOS development.

## Project Config

All project-specific values (app name, bundle ID, Jira key, Confluence space, etc.) live in **`config.yml`** at the repo root. Read this file at the start of every session. When starting a new project, update `config.yml` first — agents derive all project-specific values from it.

## Pipeline

The **orchestrator-agent** is the entry point — run it any time to check pipeline status and get the recommended next step. The remaining eight agents each own one stage. The human reviews and approves before the next step starts.

```
orchestrator-agent  ←  run any time to check status and get next action
        ↓
product-agent  →  shape-agent  →  scope-agent  →  jira-stories-agent
                                                          ↓
ci-agent  ←  review-agent  ←  qa-agent  ←  implementation-agent
```

## Agent Files

Each agent's role, inputs, outputs, and steps are defined in `agents/`.

| Agent | File | Writes To |
|-------|------|-----------|
| Orchestrator | `agents/orchestrator-agent.md` | *(pipeline status report only — no files written)* |
| Product | `agents/product-agent.md` | `docs/01-project-definition.md` |
| Shape | `agents/shape-agent.md` | `docs/02-shape.md` |
| Scope | `agents/scope-agent.md` | `docs/03-bet-and-scope.md` |
| Jira Stories | `agents/jira-stories-agent.md` | `docs/04-jira-stories.md` |
| Implementation | `agents/implementation-agent.md` | `src/` |
| QA | `agents/qa-agent.md` | `docs/05-review-notes.md` |
| Review | `agents/review-agent.md` | `docs/05-review-notes.md` |
| CI | `agents/ci-agent.md` | `.github/workflows/ci.yml` |

## Jira Integration

All agents that touch individual stories must keep Jira in sync as they work.

- **Site (cloudId)**: `amitrajoriya.atlassian.net`
- **Project key**: `KAN`
- **Story key lookup**: Read the Jira Key Mapping table at the top of `docs/04-jira-stories.md` to map `COUNTER-n` → `KAN-n`.

### MCP tools

| Task | Tool |
|------|------|
| Get current user's accountId | `mcp__claude_ai_Atlassian_Rovo__atlassianUserInfo` |
| List available transitions | `mcp__claude_ai_Atlassian_Rovo__getTransitionsForJiraIssue` |
| Move story status | `mcp__claude_ai_Atlassian_Rovo__transitionJiraIssue` |
| Assign story to user | `mcp__claude_ai_Atlassian_Rovo__editJiraIssue` |
| Add comment to story | `mcp__claude_ai_Atlassian_Rovo__addCommentToJiraIssue` |

### Lifecycle per story

```
jira-stories-agent creates ticket → assigns to current user (To Do)
         ↓
implementation-agent starts story → transitions to In Progress
         ↓
implementation-agent finishes story → transitions to Done
         ↓
qa-agent / review-agent → add comment with findings
```

### How to transition

1. Call `getTransitionsForJiraIssue` with the `KAN-n` key to get available transition IDs.
2. Match by name: `"In Progress"` or `"Done"` (names may vary — pick the closest match).
3. Call `transitionJiraIssue` with that ID.

### How to assign

1. Call `atlassianUserInfo` to get `accountId` of the current user.
2. Call `editJiraIssue` with `{"assignee": {"accountId": "<id>"}}` in the fields body.

---

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

| Artifact | Status | Notes |
|----------|--------|-------|
| `docs/01-project-definition.md` | ✅ Done | |
| `docs/02-shape.md` | ✅ Done | |
| `docs/03-bet-and-scope.md` | ✅ Done | |
| `docs/04-jira-stories.md` | ✅ Done | All 7 stories — KAN-2 through KAN-8 |
| `docs/05-review-notes.md` | ✅ Done | QA passed (16/16); review verdict: Approved with minor fixes |
| `src/` | ✅ Done | MVVM, 16 tests pass, 0 warnings, Swift 6 |
| `.github/workflows/ci.yml` | ✅ Done | Dynamic simulator selection, `set -euo pipefail` |
| CI green run | ⏳ Pending | Human must confirm first green run in GitHub Actions |
| COUNTER-4 smoke test | ⏳ Pending | Human must verify FR1–FR5 on iOS 17+ simulator |
