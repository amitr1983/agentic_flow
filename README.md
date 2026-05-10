# agentic_flow

A multi-agent SDLC repo for building iOS apps with Claude Code. Each stage of development is handled by a specialised agent, with human review and approval between each step.

## How It Works

1. Each agent reads its input doc(s), does its work, and writes its output doc.
2. The human reviews the output and approves before the next agent runs.
3. No agent skips ahead without approval.

## Pipeline

```
[You] Describe project
       ↓
product-agent   → docs/01-project-definition.md
       ↓
shape-agent     → docs/02-shape.md
       ↓
scope-agent     → docs/03-bet-and-scope.md
       ↓
jira-stories-agent → docs/04-jira-stories.md
       ↓
implementation-agent → src/
       ↓
qa-agent        → docs/05-review-notes.md
       ↓
review-agent    → docs/05-review-notes.md (appends)
       ↓
ci-agent        → .github/workflows/ci.yml
```

## Running an Agent

Tell Claude which agent to run:

```
Run the shape-agent on this project.
Run the implementation-agent for story COUNTER-2.
```

Claude will read the agent definition from `agents/`, follow its steps, and write the output.

## Folder Structure

```
agents/          # Agent definitions (role, inputs, outputs, steps)
docs/            # SDLC artifacts produced by agents
src/             # iOS app source code (created by implementation-agent)
.github/
  workflows/     # CI (created by ci-agent)
CLAUDE.md        # Session bootstrap for Claude Code
AGENTS.md        # Overview of the human-agent contract
```

## Source of Truth

Confluence stores the official SDLC documents for this project.
This repo keeps local copies under `docs/` for Claude Code execution.
When a doc changes, update **both** the Confluence page and the matching local file.

| Local file | Confluence page |
|------------|-----------------|
| `docs/01-project-definition.md` | 01 - Project Definition |
| `docs/02-shape.md` | 02 - Shape |
| `docs/03-bet-and-scope.md` | 03 - Bet & Scope |
| `docs/04-jira-stories.md` | 04 - Jira Stories |
| `docs/05-review-notes.md` | 05 - Review Notes |

Confluence space: **MFS** — `https://amitrajoriya.atlassian.net/wiki/spaces/MFS`

## Current Project

**Counter App** — Simple SwiftUI iOS counter with increment, decrement, and reset.
See `docs/01-project-definition.md` for full spec.
