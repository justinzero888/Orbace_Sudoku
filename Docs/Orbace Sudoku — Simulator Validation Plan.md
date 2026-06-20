# Orbace Sudoku — Simulator Validation Plan

**Version**: 1.0  
**Date**: 2026-06-20  
**Scope**: iOS Simulator and Android Emulator validation before Phase 4

---

## 1. When Simulator Validation Starts

Simulator validation can start now.

The earliest meaningful simulator validation gate is **after Phase 2**, because that is when the app first has a playable board, input controls, notes, hints, pause, and completion. Orbace is now past Phase 3, so simulator validation should happen before Phase 4 begins.

Recommended validation rhythm:

| Phase | Simulator Validation Expectation |
|---|---|
| Phase 0 | App launches on simulator/emulator skeleton |
| Phase 1 | Optional only; engine is mostly unit-test driven |
| Phase 2 | First required playable-flow simulator smoke test |
| Phase 3 | Required persistence, scoring, replay smoke test |
| Phase 4 | Required awards, daily, Extreme smoke test |
| Phase 5 | Full release-candidate UAT and store-readiness validation |

## 2. Current Pre-Phase-4 Gate

Before Phase 4 starts, validate:

- App installs on iOS Simulator.
- App installs on Android Emulator.
- Home screen renders.
- Tea Moment opens playable puzzle.
- Board accepts number input.
- Notes mode works.
- Undo/redo works.
- Hint dialog appears.
- Pause overlay appears.
- Completion dialog can show score breakdown.
- Replay screen can render move history.

## 3. Target Devices

### iOS Simulator

Use at least:

- iPhone 16 or current default iPhone simulator.
- iPhone SE class small-screen simulator if available.
- iPad Pro or iPad Air simulator.

### Android Emulator

Use at least:

- Pixel phone emulator.
- Small phone emulator if available.
- Android tablet emulator if available.

## 4. Validation Commands

General project validation:

```sh
scripts/run_validation.sh
```

iOS simulator smoke run:

```sh
flutter run -d ios
```

Android emulator smoke run:

```sh
flutter run -d android
```

List available devices:

```sh
flutter devices
```

Run on a specific device:

```sh
flutter run -d "<device-id>"
```

## 5. Pre-Phase-4 Exit Criteria

Phase 4 can begin when:

- `scripts/run_validation.sh` passes.
- iOS Simulator launches the app.
- Android Emulator launches the app.
- Manual smoke test cases UAT-001 through UAT-012 pass on at least one iOS simulator.
- Manual smoke test cases UAT-001 through UAT-012 pass on at least one Android emulator.
- Any simulator-only layout or runtime bugs are logged before Phase 4 implementation starts.

## 6. Notes

Full formal UAT belongs in Phase 5. The current pre-Phase-4 validation is a smoke gate, not a release-candidate signoff.
