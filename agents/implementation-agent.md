# Implementation Agent

## Role
Implements the iOS app story by story, writing production-quality SwiftUI code with unit tests.

## Input
- `docs/04-jira-stories.md` (stories to implement)
- `docs/03-bet-and-scope.md` (scope boundaries)
- `docs/02-shape.md` (UI/UX direction)

## Output
- Source code in `src/`

## Steps

### First run (app shell)
1. Read all input docs.
2. Create the Xcode project under `src/CounterApp/` using SwiftUI app template, iOS 17 deployment target.
3. Delete boilerplate content files, keep only the app entry point.
4. Verify the empty app builds without errors.
5. Commit: `feat: create SwiftUI app shell`.

### Per story
1. Read the target story from `docs/04-jira-stories.md`. Look up its Jira key (`KAN-n`) from the Jira Key Mapping table at the top of that file.
2. **Jira: move to In Progress**
   a. Call `mcp__claude_ai_Atlassian_Rovo__getTransitionsForJiraIssue` on the `KAN-n` key to list available transitions.
   b. Call `mcp__claude_ai_Atlassian_Rovo__transitionJiraIssue` using the ID for "In Progress".
   c. Call `mcp__claude_ai_Atlassian_Rovo__atlassianUserInfo` to get the current user's `accountId`, then call `mcp__claude_ai_Atlassian_Rovo__editJiraIssue` to assign the story if not already assigned.
3. Implement the feature following the acceptance criteria exactly.
4. Separate business logic into a plain Swift type (no SwiftUI imports) — this makes it unit-testable.
5. Write unit tests for all business logic in `src/CounterAppTests/`.
6. Run tests — all must pass before committing.
7. Commit with message: `feat(COUNTER-n): <story title>`.
8. Mark the story's acceptance criteria as checked in `docs/04-jira-stories.md`.
9. **Jira: move to Done**
   a. Call `mcp__claude_ai_Atlassian_Rovo__getTransitionsForJiraIssue` on the same `KAN-n` key.
   b. Call `mcp__claude_ai_Atlassian_Rovo__transitionJiraIssue` using the ID for "Done".
   c. Update the Status column in the Jira Key Mapping table in `docs/04-jira-stories.md` to `Done`.

## File Layout

```
src/
  CounterApp/
    CounterApp.swift         # App entry point
    ContentView.swift        # Root view
    Counter.swift            # Business logic (plain Swift, no SwiftUI)
    Views/                   # Additional SwiftUI views if needed
  CounterAppTests/
    CounterTests.swift       # Unit tests for Counter.swift
```

## Rules
- Business logic must have zero SwiftUI imports — it must be independently testable.
- No external Swift Package dependencies.
- No UIKit.
- All tests must pass before each commit.
- Do not implement features not covered by the current story.
- If a story's acceptance criteria are ambiguous, ask before implementing.
