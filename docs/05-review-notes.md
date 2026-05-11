# Review Notes

> **Status**: Done — QA passed (16/16 tests, 0 warnings); code review verdict: Approved with minor fixes (all minors resolved).

---

## QA Report

### Test Results

- **Total: 16 passed, 0 failed**
- Command: `xcodebuild test -scheme CounterApp -destination 'id=FA28CE82-B507-4103-A0EC-F1182D87B7F6'` (iPhone 16 iOS 18.1)
- Compiler warnings: **0**

| Suite | Tests | Result |
|-------|-------|--------|
| `CounterTests` | 8 | ✅ All passed |
| `CounterViewModelTests` | 8 | ✅ All passed |

---

### Story Verification

#### COUNTER-1 — Create Xcode project shell
- [x] Xcode project exists with iOS 17+ deployment target — `project.yml` sets `deploymentTarget: "17.0"` for both app and test targets
- [x] `@main` app entry point is in place — `CounterApp.swift:3` has `@main struct CounterApp: App`
- [x] Project compiles with 0 errors and 0 warnings on an iOS simulator
- [x] No UIKit import exists anywhere in the project — verified across all 7 source files
- [x] Unit test target present, linked to app target, and `xcodebuild test` runs successfully

#### COUNTER-2 — Implement Counter model
- [x] `Counter` is a `struct` in `Counter.swift` with zero imports — file has no import statements at all
- [x] `var count: Int` is `private(set)`, initialised to `0` — `Counter.swift:2`
- [x] `mutating func increment()` increases `count` by 1 — `Counter.swift:4`; covered by `testIncrement`, `testIncrementMultipleTimes`
- [x] `mutating func decrement()` decreases `count` by 1, negatives allowed — `Counter.swift:8`; covered by `testDecrement`, `testDecrementBelowZero`
- [x] `mutating func reset()` sets `count` to `0` — `Counter.swift:12`; covered by `testReset`, `testResetFromNegative`, `testIncrementThenReset`
- [x] All unit tests pass ✅

#### COUNTER-3 — Implement CounterViewModelProtocol and CounterViewModel
- [x] `CounterViewModelProtocol` declares `var count: Int { get }`, `func increment()`, `func decrement()`, `func reset()` — `CounterViewModelProtocol.swift:1–6`
- [x] `CounterViewModel` is `@Observable final class` conforming to `CounterViewModelProtocol` — `CounterViewModel.swift:3–4`
- [x] `CounterViewModel` owns a `private var counter = Counter()` and delegates all mutations — `CounterViewModel.swift:5–18`
- [x] `var count: Int` is a computed property reading from private `Counter` — `CounterViewModel.swift:7`
- [x] Neither `CounterViewModelProtocol.swift` nor `CounterViewModel.swift` imports SwiftUI or UIKit — protocol file has no imports; ViewModel imports only `Observation`
- [x] Unit tests exercise `CounterViewModel` through `CounterViewModelProtocol` — `CounterViewModelTests.swift:5` declares `var sut: any CounterViewModelProtocol`
- [x] All unit tests pass ✅

#### COUNTER-4 — Build Counter UI (ContentView)
- [x] `ContentView` displays `viewModel.count` prominently (FR1) — `Text("\(viewModel.count)")` at 80pt rounded font, `ContentView.swift:8`
- [x] Tapping **+** calls `viewModel.increment()` and updates immediately (FR2) — `ContentView.swift:22–25`
- [x] Tapping **−** calls `viewModel.decrement()` and updates immediately (FR3) — `ContentView.swift:15–18`
- [x] Tapping **Reset** calls `viewModel.reset()` and updates immediately (FR4) — `ContentView.swift:31–33`
- [x] Negative values render correctly — `Text("\(viewModel.count)")` renders any `Int` including negatives
- [x] Counter shows `0` on every fresh launch (FR5) — `CounterViewModel()` initialises `Counter()` which sets `count = 0`
- [x] Zero business logic in the view — `ContentView` only reads `viewModel.count` and calls ViewModel methods
- [x] No UIKit anywhere in the project — verified
- [ ] **Manual smoke test on iOS 17 simulator — PENDING** (requires human verification; cannot be automated in this environment)

#### COUNTER-5 — Write unit tests for Counter model
- [x] `CounterTests.swift` exists in test target — `CounterAppTests/CounterTests.swift`
- [x] `testInitialCountIsZero` — passed ✅
- [x] `testIncrement` — passed ✅
- [x] `testIncrementMultipleTimes` — passed ✅
- [x] `testDecrement` — passed ✅
- [x] `testDecrementBelowZero` — passed ✅
- [x] `testReset` — passed ✅
- [x] `testResetFromNegative` — passed ✅
- [x] `testIncrementThenReset` — passed ✅
- [x] All 8 tests pass ✅

#### COUNTER-6 — Write unit tests for CounterViewModel
- [x] `CounterViewModelTests.swift` exists with zero SwiftUI or UIKit imports ✅
- [x] Subject declared as `var sut: any CounterViewModelProtocol` — `CounterViewModelTests.swift:5` ✅
- [x] `testInitialCountIsZero` — passed ✅
- [x] `testIncrement` — passed ✅
- [x] `testIncrementMultipleTimes` — passed ✅
- [x] `testDecrement` — passed ✅
- [x] `testDecrementBelowZero` — passed ✅
- [x] `testReset` — passed ✅
- [x] `testResetFromNegative` — passed ✅
- [x] `testIncrementThenReset` — passed ✅
- [x] All 8 tests pass ✅

#### COUNTER-7 — Set up GitHub Actions CI
- [x] `.github/workflows/ci.yml` exists in the repository
- [x] Workflow triggers on `push` to `main` and on `pull_request`
- [x] Simulator selected dynamically at runtime via `xcrun simctl list` — no hard-coded device name
- [x] No third-party GitHub Actions beyond `actions/checkout@v4`
- [ ] **All unit tests pass in CI — PENDING** (first CI run not yet confirmed; pushed to `origin/main`, awaiting GitHub Actions result)
- [ ] **Broken test causes workflow to fail — PENDING** (requires CI verification by human)

---

### Gaps

1. **COUNTER-4 — Manual smoke test (FR1–FR5)**: Cannot be automated. The human must launch the app on an iOS 17+ simulator, tap **+**, **−**, and **Reset**, then force-quit and relaunch to verify FR5. All code paths are verified via unit tests but UI rendering requires manual confirmation.

2. **COUNTER-7 — CI green run**: The workflow has been pushed but not yet observed running. Human should confirm the Actions tab shows a green run.

3. **COUNTER-5 — AC wording vs. implementation**: The story AC says "no imports beyond XCTest" but `@testable import CounterApp` is also present (required to access `Counter`). This is a wording imprecision in the story, not a defect — `@testable import` is standard XCTest practice and there are no SwiftUI/UIKit imports.

4. **ContentView — minor out-of-scope additions**: `ContentView` uses `.contentTransition(.numericText())` and `.animation(.snappy, value:)`. These are cosmetic-only and don't affect correctness, but they were not explicitly in scope. Not a defect — no AC is violated.

---

### Regressions

None. This is the initial implementation; no previously passing behaviour has been broken.

---

## Code Review

### Findings

| Severity | File | Line | Finding | Suggestion | Status |
|----------|------|------|---------|------------|--------|
| Minor | `CounterViewModelTests.swift` | 5 | `private var sut: any CounterViewModelProtocol = CounterViewModel()` — class-level initialiser creates an instance immediately discarded by `setUp()`. | Use `private var sut: (any CounterViewModelProtocol)!` and assign only in `setUp`. | ✅ Resolved |
| Minor | `ci.yml` | 27–38 | Missing `set -e` — empty `SIMULATOR_UDID` would produce a cryptic error rather than a clear failure. | Add `set -euo pipefail` at the top of the simulator selection step. | ✅ Resolved |
| Minor | `project.yml` | 6 | `xcodeVersion: "16"` pinned but local Xcode is 26.1 — mismatch may silently produce incorrect build settings. | Omit `xcodeVersion` to let xcodegen auto-detect. | ✅ Resolved |
| Minor | `project.yml` | 8 | `SWIFT_VERSION: "5.9"` opts out of Swift 6 concurrency checking. | Bump to `SWIFT_VERSION: "6.0"`. | ✅ Resolved |
| Nit | `ContentView.swift` | 7–12 | Magic number literals for spacing and font sizes scattered inline. | Extract to `private enum Layout` with named constants. | ⏳ Open |
| Nit | `ContentView.swift` | 11–12 | `.animation()` applied directly to `Text` rather than higher in the view tree. | Move to `VStack` or wrap calls in `withAnimation {}`. | ⏳ Open |
| Nit | `CounterTests.swift` | 57 | `(0..<5).forEach { _ in sut.increment() }` — less readable than a `for` loop. | Use `for _ in 0..<5 { sut.increment() }`. | ✅ Resolved |
| Nit | `CounterViewModelTests.swift` | 55 | Same `(0..<5).forEach` pattern. | Same fix: `for _ in 0..<5 { sut.increment() }`. | ✅ Resolved |
| Nit | `Counter.swift` | 1 | No `///` doc comment on the type. | Add a triple-slash summary above `struct Counter`. | ⏳ Open |
| Nit | `CounterViewModelProtocol.swift` | 1 | No `///` doc comment on the protocol. | Add a triple-slash summary above the protocol declaration. | ⏳ Open |

---

### Overall Verdict

**Approved with minor fixes**

No blockers. The architecture is clean and correct: MVVM layers are properly separated, business logic has zero SwiftUI imports, the ViewModel is protocol-backed for testability, and all 16 tests pass with zero compiler warnings. The two CI-related minors (missing `set -e` and `xcodeVersion` mismatch) are worth fixing before this workflow is relied on in a team setting. The Swift version minor is a forward-compatibility improvement. All nits are cosmetic and optional for this demo but expected at principal-engineer level in production.

---

### Notes

**Architecture** — The MVVM layering is textbook clean. `Counter` (value type) → `CounterViewModel` (reference type, `@Observable`) → `ContentView` (pure view) is the correct iOS 17 pattern. The Dependency Inversion principle is properly applied: tests use `any CounterViewModelProtocol`, not the concrete class. No violations found.

**Test quality** — Both test classes are well-structured. `CounterTests` correctly treats `Counter` as a value type (fresh `var sut` per test, no shared state). `CounterViewModelTests` correctly exercises the ViewModel through its protocol. The symmetric coverage across both layers (8 tests each, identical scenarios) is a good signal — if the model and the ViewModel ever diverge, a test will catch it.

**Simplicity** — The implementation is correctly minimal. No unnecessary abstractions, no premature generics, no third-party dependencies. The only mild over-engineering concern is the animation modifiers in `ContentView`, which were not in scope but do not add complexity.

**CI resilience** — The dynamic simulator selection via `xcrun simctl list` is the right call. The Python script is readable and correct in logic; it just needs the `set -e` guard to make failures obvious.
