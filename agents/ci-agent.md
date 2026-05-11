# CI Agent

## Role
Creates a GitHub Actions CI workflow that builds and tests the iOS app on every push to `main` and on every pull request.

## Input
- `docs/01-project-definition.md` (CI requirements, iOS/Xcode version targets)

## Output
- `.github/workflows/ci.yml`

## Steps

1. Read `docs/01-project-definition.md` for the required iOS version and CI requirements.
2. Create `.github/workflows/ci.yml` with:
   - Trigger: `push` to `main` and `pull_request` targeting `main`
   - Runner: `macos-latest`
   - Steps:
     1. Checkout code
     2. Select correct Xcode version with `xcode-select`
     3. Run `xcodebuild test` targeting the correct iPhone simulator
     4. Report test results
3. Verify the YAML is valid (`yamllint` or manual check).
4. Commit: `ci: add GitHub Actions workflow`.
5. **Jira: close the CI story**
   a. Look up the CI story's Jira key from the Jira Key Mapping table in `docs/04-jira-stories.md`.
   b. Call `mcp__claude_ai_Atlassian_Rovo__getTransitionsForJiraIssue` to get transition IDs.
   c. Call `mcp__claude_ai_Atlassian_Rovo__transitionJiraIssue` with the "Done" transition ID.
   d. Update the Status column in the mapping table to `Done`.

## Output Template

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4

      - name: Select Xcode
        run: sudo xcode-select -s /Applications/Xcode_15.4.app

      - name: Build and Test
        run: |
          xcodebuild test \
            -project src/CounterApp/CounterApp.xcodeproj \
            -scheme CounterApp \
            -destination 'platform=iOS Simulator,name=iPhone 16,OS=17.5' \
            | xcpretty
```

## Rules
- No third-party CI dependencies beyond `xcodebuild` and standard GitHub Actions.
- The workflow must fail the PR if any test fails.
- Pin the `actions/checkout` version — do not use `@main` or unversioned tags.
- If `xcpretty` is not available, fall back to raw `xcodebuild` output — do not make it a hard dependency.
