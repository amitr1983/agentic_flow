# Jira Stories

## Jira Key Mapping

| Local ID | Jira Key | Title | Status |
|----------|----------|-------|--------|
| COUNTER-1 | KAN-2 | Create Xcode project shell | Done |
| COUNTER-2 | KAN-3 | Implement Counter model | Done |
| COUNTER-3 | KAN-4 | Implement CounterViewModelProtocol and CounterViewModel | Done |
| COUNTER-4 | KAN-5 | Build Counter UI (ContentView) | Done |
| COUNTER-5 | KAN-6 | Write unit tests for Counter model | Done |
| COUNTER-6 | KAN-7 | Write unit tests for CounterViewModel | Done |
| COUNTER-7 | KAN-8 | Set up GitHub Actions CI | Done |

---

## COUNTER-1 — Create Xcode project shell

**Description**
As a developer, I want a correctly configured Xcode project so that the team has a clean, warning-free foundation to build on without fighting project settings.

**Acceptance Criteria**
- [ ] Xcode project created with SwiftUI App template, targeting iOS 17+
- [ ] `@main` app entry point is in place
- [ ] Project compiles with 0 errors and 0 warnings on an iOS 17 simulator
- [ ] No UIKit import exists anywhere in the project
- [ ] A unit test target is present, linked to the app target, and `xcodebuild test` runs successfully (even with an empty test suite)

**Implementation Notes**
- Use Xcode 15+, SwiftUI App template; set deployment target to iOS 17.0 at creation time
- Include the test target at project creation — adding it later causes linking friction
- Delete any placeholder boilerplate comments; keep files clean from the start
- Bundle ID / product name: `CounterApp`

**Testing Notes**
- Run `xcodebuild build -scheme CounterApp -destination 'platform=iOS Simulator,OS=latest'` — must succeed with 0 errors
- Run `xcodebuild test` on the same destination — must exit 0 even with an empty test suite

**Size**: S

---

## COUNTER-2 — Implement Counter model

**Description**
As a developer, I want a plain Swift `Counter` struct so that counter state and all mutations are encapsulated in a framework-free value type with no side effects.

**Acceptance Criteria**
- [ ] `Counter` is a `struct` in `Counter.swift` with zero imports (not even Foundation)
- [ ] `var count: Int` is private(set), initialised to `0`
- [ ] `mutating func increment()` increases `count` by 1
- [ ] `mutating func decrement()` decreases `count` by 1 (negative values are allowed)
- [ ] `mutating func reset()` sets `count` to `0`
- [ ] Unit tests pass for: increment from 0→1, decrement from 0→−1, decrement repeatedly into negative, reset from non-zero back to 0

**Implementation Notes**
- No framework imports — `Counter` must be a pure Swift value type
- `private(set)` on `count` enforces that mutations only happen through the declared methods (SOLID: Single Responsibility)
- File location: `CounterApp/Models/Counter.swift`

**Testing Notes**
- Test class: `CounterTests` — see COUNTER-5
- All assertions via `XCTAssertEqual`; no async, no mocks needed

**Size**: S

---

## COUNTER-3 — Implement CounterViewModelProtocol and CounterViewModel

**Description**
As a developer, I want an `@Observable` ViewModel backed by a protocol so that the view layer depends on an abstraction, making the business logic testable in isolation and swappable without touching the view.

**Acceptance Criteria**
- [ ] `CounterViewModelProtocol` declares `var count: Int { get }`, `func increment()`, `func decrement()`, `func reset()`
- [ ] `CounterViewModel` is a `@Observable final class` conforming to `CounterViewModelProtocol`
- [ ] `CounterViewModel` owns a private `Counter` instance and delegates all mutations to it
- [ ] `var count: Int` is a computed property that reads from the private `Counter`
- [ ] Neither `Counter.swift` nor `CounterViewModel.swift` imports SwiftUI or UIKit
- [ ] Unit tests exercise `CounterViewModel` through the `CounterViewModelProtocol` type (not the concrete class)
- [ ] All tests pass

**Implementation Notes**
- File locations: `CounterApp/ViewModels/CounterViewModelProtocol.swift`, `CounterApp/ViewModels/CounterViewModel.swift`
- `import Observation` is required for `@Observable`; this is part of the Swift standard library on iOS 17+, not a third-party dependency
- Conform `CounterViewModel` to `CounterViewModelProtocol` — the view will hold the concrete type in `@State` but should only call methods defined on the protocol
- Do not expose the internal `Counter` struct publicly; keep it `private`

**Testing Notes**
- Test class: `CounterViewModelTests` — see COUNTER-6
- Declare test subject as `var sut: any CounterViewModelProtocol` to test through the protocol interface
- No SwiftUI in the test file

**Size**: S

---

## COUNTER-4 — Build Counter UI (ContentView)

**Description**
As a user, I want to see a counter value on screen with **+**, **−**, and **Reset** controls so that I can increment, decrement, and reset the count at any time.

**Acceptance Criteria**
- [ ] `ContentView` displays the current `viewModel.count` value prominently (FR1)
- [ ] Tapping **+** calls `viewModel.increment()` and the display updates immediately (FR2)
- [ ] Tapping **−** calls `viewModel.decrement()` and the display updates immediately (FR3)
- [ ] Tapping **Reset** calls `viewModel.reset()` and the display updates immediately (FR4)
- [ ] Negative values render correctly (e.g. `−3`)
- [ ] Counter shows `0` on every fresh app launch (FR5)
- [ ] `ContentView` contains zero business logic — all logic lives in `CounterViewModel`
- [ ] No UIKit import anywhere in the project
- [ ] Manual smoke test on iOS 17 simulator confirms FR1–FR5

**Implementation Notes**
- `@State private var viewModel = CounterViewModel()` — `@Observable` class held in `@State` is the correct iOS 17 pattern; do not use `@StateObject`
- Call actions through the ViewModel: `viewModel.increment()`, `viewModel.decrement()`, `viewModel.reset()`
- Layout: value label centred, three buttons below — keep it simple, no custom styling required
- File location: `CounterApp/Views/ContentView.swift`

**Testing Notes**
- No unit tests for the view itself — logic is fully covered by COUNTER-2 and COUNTER-3
- Manual smoke test: launch on a simulator, tap **+** several times, tap **−**, tap **Reset**, force-quit and relaunch — verify FR1–FR5 at each step

**Size**: S

---

## COUNTER-5 — Write unit tests for Counter model

**Description**
As a developer, I want a comprehensive unit test suite for `Counter` so that every mutation is verified at the model layer independently of any UI or ViewModel.

**Acceptance Criteria**
- [ ] Test file `CounterTests.swift` exists in the test target with zero framework imports beyond `XCTest`
- [ ] `testInitialCountIsZero` — a freshly created `Counter` has `count == 0`
- [ ] `testIncrement` — after one `increment()`, `count == 1`
- [ ] `testIncrementMultipleTimes` — after N increments, `count == N`
- [ ] `testDecrement` — after one `decrement()` from 0, `count == -1`
- [ ] `testDecrementBelowZero` — counter correctly goes negative (no floor enforced)
- [ ] `testReset` — after `reset()` from a non-zero value, `count == 0`
- [ ] `testResetFromNegative` — after `reset()` from a negative value, `count == 0`
- [ ] `testIncrementThenReset` — increment several times, reset, count is 0
- [ ] All tests pass with `xcodebuild test`

**Implementation Notes**
- `Counter` is a value type (struct) — instantiate a fresh `var sut = Counter()` in each test; no `setUp`/`tearDown` needed
- No mocks, no async, no MainActor — pure synchronous value testing
- File location: `CounterAppTests/CounterTests.swift`

**Testing Notes**
- All assertions via `XCTAssertEqual`
- Each test method must be independent — mutating `sut` in one test must not affect another
- Naming convention: `test<Action><Expectation>` (e.g. `testDecrementBelowZero`)

**Size**: S

---

## COUNTER-6 — Write unit tests for CounterViewModel

**Description**
As a developer, I want a unit test suite that exercises `CounterViewModel` exclusively through `CounterViewModelProtocol` so that the ViewModel's contract is verified independently of any SwiftUI binding.

**Acceptance Criteria**
- [ ] Test file `CounterViewModelTests.swift` exists in the test target with zero SwiftUI or UIKit imports
- [ ] Test subject declared as `var sut: any CounterViewModelProtocol` to enforce protocol-only access
- [ ] `testInitialCountIsZero` — freshly created `CounterViewModel()` exposes `count == 0`
- [ ] `testIncrement` — after `increment()`, `count == 1`
- [ ] `testIncrementMultipleTimes` — after N increments, `count == N`
- [ ] `testDecrement` — after `decrement()` from 0, `count == -1`
- [ ] `testDecrementBelowZero` — ViewModel correctly exposes negative count
- [ ] `testReset` — after `reset()` from a non-zero count, `count == 0`
- [ ] `testResetFromNegative` — after `reset()` from negative, `count == 0`
- [ ] `testIncrementThenReset` — increment several times, reset, count is 0
- [ ] All tests pass with `xcodebuild test`

**Implementation Notes**
- Declare `sut` as `any CounterViewModelProtocol` — never as `CounterViewModel` — to enforce Dependency Inversion in the test itself
- `CounterViewModel` is a reference type but tests are synchronous; `@Observable` changes are applied immediately on mutation so no `await` or `RunLoop` spin is needed
- File location: `CounterAppTests/CounterViewModelTests.swift`

**Testing Notes**
- No mocks required — `CounterViewModel` is the real implementation under test
- Zero SwiftUI in the test file; `@Observable` propagation is not tested here (that is an Apple framework concern)
- Each test creates a fresh `CounterViewModel()` via `setUp` or local `let sut`

**Size**: S

---

## COUNTER-7 — Set up GitHub Actions CI

**Description**
As a developer, I want a CI workflow that runs `xcodebuild test` on every push to `main` and every pull request so that regressions are caught automatically before merge.

**Acceptance Criteria**
- [ ] `.github/workflows/ci.yml` exists in the repository
- [ ] Workflow triggers on `push` to `main` and on `pull_request`
- [ ] `xcodebuild test` targets an available iPhone simulator using `OS=latest` — no hard-coded simulator name
- [ ] All unit tests pass in CI
- [ ] No third-party GitHub Actions used beyond `actions/checkout`
- [ ] A deliberately broken test causes the workflow to fail (verified manually)

**Implementation Notes**
- Runner: `macos-latest` (ships with a recent Xcode)
- Select simulator dynamically at runtime using `xcrun simctl list` — avoids breakage when runner images update
- Scheme name must match exactly what Xcode created (e.g. `CounterApp`)
- `actions/checkout` is acceptable as it is a first-party GitHub action

**Testing Notes**
- After merging the workflow, push a commit that intentionally fails a unit test; confirm the Actions run goes red
- Revert the bad commit; confirm the run goes green
- Check that both the `push` and `pull_request` triggers fire as expected

**Size**: M
