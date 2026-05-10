# Shape

## User Flow

1. User launches the app — counter displays **0**.
2. User taps **+** — counter increments by 1; new value appears immediately.
3. User taps **−** — counter decrements by 1; new value appears immediately.
4. User taps **Reset** — counter returns to 0; display updates immediately.
5. User backgrounds the app and returns — counter retains its current in-memory value (same session).
6. User fully terminates and relaunches the app — counter starts at 0 again (model re-initializes).

All actions are synchronous and local; there is no loading or async step anywhere in the flow.

## Screens

| Screen | Purpose |
|--------|---------|
| Counter Screen | The sole screen. Displays the current counter value and provides Increment, Decrement, and Reset controls. |

## UI States

### Counter Screen

| State | When | What the user sees |
|-------|------|--------------------|
| Zero (initial) | App launches, or Reset tapped | Value displays `0`; all three controls enabled |
| Positive | One or more increments applied | Value displays a positive integer; all three controls enabled |
| Negative | Decremented below zero | Value displays a negative integer (e.g. `−3`); all three controls enabled |

There is no loading state (all operations are instant and local) and no error state (no I/O that can fail).

## Edge Cases

- **Decrement below zero** → counter goes negative; no floor is enforced (project definition places no lower bound).
- **Integer overflow** → Swift's `Int` on 64-bit hardware holds ±9.2 × 10¹⁸; a human tapping a button cannot reach this limit. No guard needed.
- **App backgrounded and resumed** → iOS keeps the process alive; counter retains its current value. No special handling required.
- **App fully terminated and relaunched** → `CounterModel` re-initializes with `count = 0`. No persistence means no stale state.
- **Rapid tapping** → all taps are processed synchronously on the main actor; no debounce or rate-limiting needed.

## Out of Scope

- Minimum or maximum counter value — counter is intentionally unbounded.
- Step sizes other than 1 (e.g. +5, +10).
- Undo / redo of individual actions.
- Visual or haptic feedback beyond the number updating (no animation, no vibration).
- Accessibility labels and VoiceOver support.
- Any UI beyond the single counter screen (navigation, sheets, modals).
- Persistence of any kind — not even `UserDefaults`.

## Technical Direction

- **Architecture:** MVVM
  - `Counter` — plain Swift `struct` (Model); pure value type, no framework imports, owns `count: Int` and mutating operations.
  - `CounterViewModelProtocol` — protocol defining the public interface (`count`, `increment()`, `decrement()`, `reset()`). Views depend on this, never on the concrete type (SOLID: Dependency Inversion).
  - `CounterViewModel` — `@Observable` `final class` conforming to `CounterViewModelProtocol`; owns a `Counter` instance and delegates all mutations to it.
  - `ContentView` — pure SwiftUI view; reads `count` and calls methods through the protocol. Zero business logic.
- **Framework:** SwiftUI only; zero UIKit.
- **Data flow:** `ContentView` calls methods on `CounterViewModelProtocol` → `CounterViewModel` mutates its `Counter` → `@Observable` propagates the change back to the view automatically.
- **State management:** `@Observable` macro on `CounterViewModel` (iOS 17+). `ContentView` holds the instance via `@State private var viewModel: CounterViewModel`.
- **Testing:** `Counter` (struct) unit-tested directly for value correctness. `CounterViewModel` tested via `CounterViewModelProtocol` for isolation. No SwiftUI in any test.
- **Dependencies:** None. No Swift Package dependencies. No external CI tools beyond `xcodebuild`.
