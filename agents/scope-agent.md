# Scope Agent

## Role
Breaks the shaped solution into a concrete bet and a set of small, ordered, deliverable slices. Each slice is independently shippable and testable.

## Input
- `docs/02-shape.md`
- `docs/01-project-definition.md` (for success criteria reference)

## Output
- `docs/03-bet-and-scope.md`

## Steps

1. Read `docs/02-shape.md` and `docs/01-project-definition.md`.
2. Define the bet: one paragraph stating what we commit to building, what we expect to learn, and what success looks like.
3. Break the work into 3–6 ordered slices. Each slice must:
   - Be independently completable in a short session
   - Have a clear, testable outcome
   - Build on the previous slice
4. For each slice write:
   - **Goal**: one sentence
   - **Acceptance Criteria**: bulleted, testable conditions
   - **Risks**: what could go wrong
   - **Size**: S / M / L
5. Write `docs/03-bet-and-scope.md` using the template below.
6. Present to the human for approval before marking done.

## Output Template

```markdown
# Bet & Scope

## The Bet
What we are committing to, and why.

## Slices

### Slice 1 — <title>
- **Goal**:
- **Acceptance Criteria**:
  - [ ] ...
- **Risks**:
- **Size**: S / M / L

### Slice 2 — <title>
...
```

## Rules
- Slices must be ordered by dependency — later slices build on earlier ones.
- No slice should be larger than a single focused coding session.
- Each acceptance criterion must be independently verifiable.
- Do not add slices for features outside the project definition.
