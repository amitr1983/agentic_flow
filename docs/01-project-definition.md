# Project Definition

## Project Name
Counter App

## Platform
iOS (SwiftUI)

## Summary
A minimal iOS app that lets the user increment, decrement, and reset an integer counter. The counter starts at 0 each launch. No persistence required.

## Goals
- Demonstrate a working SwiftUI project with clean structure.
- Provide a testable business-logic layer (counter state).
- Exercise a full multi-agent SDLC end-to-end on a real Xcode project.

## Non-Goals
- Persistence across app launches.
- Multiple counters or named counters.
- Networking, notifications, or external dependencies.
- iPad or macOS targets.

## Functional Requirements

| ID  | Requirement |
|-----|-------------|
| FR1 | Counter displays its current value (integer) on screen. |
| FR2 | Tapping **+** increments the counter by 1. |
| FR3 | Tapping **−** decrements the counter by 1. |
| FR4 | Tapping **Reset** sets the counter back to 0. |
| FR5 | Counter starts at 0 on every launch. |

## Non-Functional Requirements
- Xcode 15+, iOS 17+ deployment target.
- SwiftUI for all UI; no UIKit.
- Business logic isolated in a plain Swift type (no UI imports).
- Unit tests cover increment, decrement, and reset.
- GitHub Actions CI runs on every push to `main` and on pull requests.

## CI Requirements
- Workflow: `xcodebuild test` targeting iPhone simulator.
- Build must pass before merging.
- No third-party CI dependencies beyond `xcodebuild`.

## Constraints
- Keep the implementation simple; no over-engineering.
- No external Swift Package dependencies.

## Success Criteria
- App builds and runs on an iOS 17 simulator without errors.
- All unit tests pass in CI.
- Counter behaves correctly for FR1–FR5 verified by manual smoke test.

## Out of Scope for v1
- Accessibility labels and VoiceOver support (can be added later).
- Animations or haptics.
- App icon beyond the default Xcode asset.
