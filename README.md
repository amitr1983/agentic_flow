# agentic_flow

A structured, human-in-the-loop workflow for building iOS apps with Claude Code. Instead of asking Claude to "build me an app", you run specialised agents one stage at a time — each one does a focused job, writes its output, and waits for your approval before the next stage starts.

The result is a full software development lifecycle (SDLC) where you stay in control of every decision, and Claude handles the execution.

---

## What Problem Does This Solve?

When you ask an AI to build something large in one shot, you lose visibility and control. This repo breaks the work into eight named stages — from defining the product idea all the way to CI — with a human approval gate between each one. You can course-correct at any point, and nothing gets built without your sign-off.

---

## Prerequisites

Before you start, make sure you have:

- **Claude Code** installed and running (`claude` CLI)
- **Xcode 15+** (for iOS development)
- **xcodegen** installed — `brew install xcodegen`
- **Atlassian account** (optional but recommended) — for Jira story tracking and Confluence docs
- **GitHub account** — for pushing code and running CI
- The **Atlassian Rovo MCP** connected in Claude Code settings (enables Jira + Confluence tools)

---

## How It Works

There are nine agents. The **orchestrator** is always available to tell you where you are and what to run next. The other eight each own one stage. You trigger an agent with a slash command, it does its work, and then you review the output. Only after you approve does the next stage begin.

```
             /orchestrator  ←  run this any time to check pipeline status
                    ↓
You describe the project
        ↓
1. /product   →  Writes the project definition doc
        ↓
2. /shape     →  Designs the product shape (problem, appetite, solution)
        ↓
3. /scope     →  Breaks the shape into a scoped bet with slices
        ↓
4. /stories   →  Turns slices into Jira-ready user stories, creates tickets
        ↓
5. /implement →  Writes the iOS code story by story, runs tests
        ↓
6. /qa        →  Verifies every acceptance criterion, runs the test suite
        ↓
7. /review    →  Reviews code quality, architecture, and test coverage
        ↓
8. /ci        →  Sets up GitHub Actions to run tests on every push
```

At each stage, Claude writes a document or code, presents it to you, and waits. You say "looks good" or request changes. Nothing moves forward until you approve.

---

## Adapting to a New Project

Everything project-specific lives in **`config.yml`** at the repo root. To use this pipeline for a different app, just update that one file:

```yaml
project:
  name: "Your App Name"

ios:
  bundle_id: "com.yourcompany.YourApp"
  scheme: "YourApp"
  deployment_target: "17.0"

jira:
  project_key: "YOUR_KEY"
  story_prefix: "STORY"

confluence:
  space_key: "YOUR_SPACE"
  space_id: "123456"
  parent_page_id: "789012"

github:
  repo: "yourorg/yourrepo"
```

All agents read from `config.yml`, so you never have to hunt through multiple files to change a project name or bundle ID.

---

## Starting a New Project

1. **Clone this repo** and open the folder in Claude Code.
2. **Describe your project** in plain English — what you want to build and why.
3. **Run `/product`** — Claude writes `docs/01-project-definition.md`. Review and approve.
4. **Run `/shape`** — Claude designs the product shape. Review and approve.
5. **Run `/scope`** — Claude scopes the bet into buildable slices. Review and approve.
6. **Run `/stories`** — Claude writes user stories and (if Atlassian is connected) creates Jira tickets and assigns them to you. Review and approve.
7. **Run `/implement`** — Claude implements the stories one by one. Each story is transitioned to "In Progress" in Jira while being worked on, then "Done" when committed. Run tests pass before each commit.
8. **Run `/qa`** — Claude verifies every acceptance criterion against the code and posts results as Jira comments.
9. **Run `/review`** — Claude reviews code quality and posts a verdict as Jira comments.
10. **Run `/ci`** — Claude sets up GitHub Actions CI and closes the CI story in Jira.

---

## Slash Commands

| Command | What it does |
|---------|-------------|
| `/product` | Runs the product agent — writes the project definition |
| `/shape` | Runs the shape agent — designs the product shape |
| `/scope` | Runs the scope agent — scopes the bet |
| `/stories` | Runs the stories agent — writes user stories and creates Jira tickets |
| `/implement` | Runs the implementation agent — writes iOS code and tests |
| `/qa` | Runs the QA agent — verifies all acceptance criteria |
| `/review` | Runs the review agent — code quality review |
| `/ci` | Runs the CI agent — sets up GitHub Actions |
| `/orchestrator` | Shows pipeline status and tells you which agent to run next |

You can also pass an argument to target a specific story:

```
/implement COUNTER-2
```

---

## Checking Where You Are

If you're not sure which stage you're on, run `/orchestrator`. It reads the current state of `docs/` and tells you:

- Which stages are done
- Which stage is next
- Whether you need to approve something before continuing

---

## Jira Integration

When the Atlassian Rovo MCP is connected, agents automatically keep Jira in sync:

- **Stories agent** creates tickets and assigns them to you (status: To Do)
- **Implementation agent** moves each story to In Progress when work starts, then Done when committed
- **QA agent** posts a pass/fail comment on each story's ticket
- **Review agent** posts the review verdict as a comment on each story's ticket
- **CI agent** closes the CI story when the workflow is committed

The Jira project key is `KAN`. The mapping between local story IDs and Jira keys lives at the top of `docs/04-jira-stories.md`.

---

## Confluence Sync

All SDLC documents have a matching Confluence page. The space key, space ID, and parent page ID are all set in `config.yml` — agents read from there, so you never hard-code them here.

| Local file | Confluence page |
|------------|-----------------|
| `docs/01-project-definition.md` | 01 - Project Definition |
| `docs/02-shape.md` | 02 - Shape |
| `docs/03-bet-and-scope.md` | 03 - Bet & Scope |
| `docs/04-jira-stories.md` | 04 - Jira Stories |
| `docs/05-review-notes.md` | 05 - Review Notes |

Confluence space and Jira project key are configured in `config.yml`. See that file for the current values.

If you edit a doc manually, update both the local file and the Confluence page to keep them in sync.

---

## What Each Agent Does

| Agent | Plain English |
|-------|--------------|
| **product-agent** | Turns your idea into a structured project definition — goals, users, requirements, and constraints |
| **shape-agent** | Frames the problem and designs a solution at the right level of detail — not too vague, not too prescriptive |
| **scope-agent** | Decides what's in and what's out for this cycle, and breaks the work into bite-sized slices |
| **jira-stories-agent** | Writes implementation-ready user stories with clear acceptance criteria, then creates and assigns Jira tickets |
| **implementation-agent** | Writes production-quality SwiftUI code story by story, with unit tests, following MVVM and SOLID principles |
| **qa-agent** | Runs the test suite, checks every acceptance criterion against the actual code, and flags any gaps |
| **review-agent** | Reviews code quality, architecture, test coverage, and Swift style — gives an Approved / Needs Changes verdict |
| **ci-agent** | Creates a GitHub Actions workflow that builds and tests the app on every push and pull request |
| **orchestrator-agent** | Reads the pipeline state and tells you exactly where you are and what to do next |

---

## Folder Structure

```
agents/          Agent definitions — each file is the full spec for one agent
docs/            SDLC documents produced by agents (source of truth synced to Confluence)
src/             iOS app source code (written by implementation-agent)
.github/
  workflows/     GitHub Actions CI (written by ci-agent)
CLAUDE.md        Instructions Claude reads at the start of every session
AGENTS.md        Overview of the human-agent contract and approval rules
```

---

## Engineering Standards

All code produced by this pipeline follows:

- **MVVM architecture** — Model (plain Swift struct), ViewModel (`@Observable`, protocol-backed), View (pure SwiftUI, zero logic)
- **SOLID principles** — especially Dependency Inversion: views depend on ViewModel protocols, not concrete classes
- **Google Swift Style Guide** — naming, formatting, and documentation conventions
- **Principal iOS Engineer standard** — production-quality, testable, idiomatic Swift
- **SwiftUI only** — no UIKit, no third-party dependencies

Full standards are documented in `CLAUDE.md`.

---

## Current Project

**Counter App** — A simple SwiftUI iOS counter with increment, decrement, and reset.

**Status: Mostly complete — pending human verification**

All 7 stories implemented, all 16 tests pass, code review approved. Two items remain open and require a human to close them:

- [ ] **CI green run** — check the [GitHub Actions tab](https://github.com/amitr1983/agentic_flow/actions) and confirm the workflow passes
- [ ] **Manual smoke test** — launch the app on an iOS 17+ simulator, tap +, −, Reset, force-quit and relaunch; verify FR1–FR5

Once both boxes are checked, the pipeline is fully complete.

See `docs/01-project-definition.md` for the full spec.
