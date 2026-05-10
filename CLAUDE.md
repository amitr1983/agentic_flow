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
