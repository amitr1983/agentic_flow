# Bet & Scope

## The Bet

We are committing to building a minimal iOS counter app in SwiftUI — one screen, three buttons, a plain Swift model — that demonstrates a clean separation between UI and business logic. The bet is that a fully working, CI-verified app can be delivered in four focused slices, each independently testable. Success means the app builds and runs on an iOS 17 simulator without errors, all unit tests pass in GitHub Actions CI on every push, and FR1–FR5 are verified by manual smoke test. This also validates the full multi-agent SDLC pipeline end-to-end on a real Xcode project.

## Slices

### Slice 1 — Xcode Project Setup

- **Goal**: A bare Xcode project that builds cleanly on an iOS 17 simulator with the correct target configuration and no placeholder logic.
- **Acceptance Criteria**:
  - [ ] Xcode project exists with iOS 17+ deployment target
  - [ ] SwiftUI app entry point (`@main`) is in place
  - [ ] Project compiles with 0 errors and 0 warnings on an iOS 17 simulator
  - [ ] No UIKit imports anywhere in the project
  - [ ] A unit test target exists (even if empty) and runs successfully
- **Risks**: Wrong deployment target set at creation; test target missing or not linked to the app target.
- **Size**: S

---

### Slice 2 — MVVM Business Logic Layer (Model + ViewModel)

- **Goal**: A fully tested, protocol-backed MVVM business logic layer with zero SwiftUI dependency, following SOLID principles.
- **Acceptance Criteria**:
  - [ ] `Counter` is a plain Swift `struct` with no framework imports; owns `count: Int = 0` and `mutating` methods `increment()`, `decrement()`, `reset()`
  - [ ] `CounterViewModelProtocol` defines `count: Int { get }`, `increment()`, `decrement()`, `reset()`
  - [ ] `CounterViewModel` is a `@Observable final class` conforming to `CounterViewModelProtocol`; owns a `Counter` instance and delegates all mutations to it
  - [ ] No SwiftUI or UIKit import in `Counter.swift` or `CounterViewModel.swift`
  - [ ] Unit tests cover `Counter` directly: increment, decrement (including below zero), reset
  - [ ] Unit tests cover `CounterViewModel` via `CounterViewModelProtocol`: same operations verified through the protocol interface
  - [ ] All tests pass
- **Risks**: `@Observable` requires the `Observation` framework (iOS 17+); test target must import the app module; protocol + `@Observable` interaction requires care with `@State` binding later.
- **Size**: S

---

### Slice 3 — View Layer (ContentView)

- **Goal**: A pure SwiftUI `ContentView` that depends only on `CounterViewModelProtocol` and satisfies FR1–FR5.
- **Acceptance Criteria**:
  - [ ] `ContentView` holds `@State private var viewModel: CounterViewModel` and calls actions through the ViewModel — zero business logic in the view
  - [ ] Counter value is prominently displayed on screen (FR1)
  - [ ] Tapping **+** increments and display updates immediately (FR2)
  - [ ] Tapping **−** decrements and display updates immediately (FR3)
  - [ ] Tapping **Reset** returns to 0 and display updates immediately (FR4)
  - [ ] Negative values render correctly (e.g. `−3`)
  - [ ] Counter shows `0` on every fresh launch (FR5)
  - [ ] No UIKit anywhere in the project
  - [ ] Manual smoke test on iOS 17 simulator confirms FR1–FR5
- **Risks**: `@Observable` + `@State` wiring — ViewModel must be a reference type held in `@State` for observation to work correctly; any logic that leaks into the view violates MVVM.
- **Size**: S

---

### Slice 4 — GitHub Actions CI

- **Goal**: A CI workflow that automatically builds and tests the app on every push to `main` and on every pull request.
- **Acceptance Criteria**:
  - [ ] `.github/workflows/ci.yml` exists in the repository
  - [ ] Workflow triggers on `push` to `main` and on `pull_request`
  - [ ] `xcodebuild test` targets an iPhone simulator (e.g. `iPhone 16`, `iOS 17`)
  - [ ] All unit tests pass in CI
  - [ ] Workflow uses no third-party CI actions beyond what `xcodebuild` requires
  - [ ] A failing test causes the workflow to fail (verified by inspection)
- **Risks**: Simulator name or runtime string mismatch on the GitHub Actions runner; Xcode version on the runner may differ from local; scheme name must match exactly.
- **Size**: M
