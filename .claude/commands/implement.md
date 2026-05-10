Read agents/implementation-agent.md and follow its steps exactly.

Input: docs/04-jira-stories.md, docs/03-bet-and-scope.md, docs/02-shape.md
Output: code in src/

$ARGUMENTS

If a story ID is provided (e.g. COUNTER-1), implement only that story.
If no argument is given, ask me which story to implement before starting.

Run all tests before committing. All tests must pass.
