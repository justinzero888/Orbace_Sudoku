# Orbace Sudoku — Simulator Validation Plan

**Version**: 1.1
**Date**: 2026-06-29
**Scope**: iOS Simulator and Android Emulator build/install/launch validation

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

## 5. Push Latest Build to iPhone, iPad, and Android Sims

Use this process when a UAT build needs to be loaded onto three local simulator targets:

- one iPhone Simulator
- one iPad Simulator
- one Android Emulator

The examples below use the current local simulator set from 2026-06-29. Device IDs can change after Xcode or simulator resets, so list devices first.

### 5.1 Confirm Devices

```sh
cd /Users/alexzhang/DevProjects/Orbace_Sudoku
flutter devices
xcrun simctl list devices available
```

Recommended current targets:

| Target | Device | Device ID |
| --- | --- | --- |
| iPhone | iPhone 17 Pro, iOS 26.5 | `DEC49E2B-36CD-47EA-97B9-5E1396DD01DA` |
| iPad | iPad Pro 13-inch (M5), iOS 26.5 | `7AC0C6B7-FEF2-42B7-BB4E-AB3147EAA5BF` |
| Android | sdk gphone64 arm64 | `emulator-5554` |

### 5.2 Boot iOS Simulators

```sh
xcrun simctl boot DEC49E2B-36CD-47EA-97B9-5E1396DD01DA
xcrun simctl boot 7AC0C6B7-FEF2-42B7-BB4E-AB3147EAA5BF
open -a Simulator
xcrun simctl list devices booted
```

If a device is already booted, `simctl boot` may report that it is already booted. That is safe.

### 5.3 Build iOS Simulator App

```sh
flutter build ios --simulator --debug
```

Expected output:

```text
Built build/ios/iphonesimulator/Runner.app
```

### 5.4 Install and Launch on iPhone Simulator

```sh
xcrun simctl install DEC49E2B-36CD-47EA-97B9-5E1396DD01DA build/ios/iphonesimulator/Runner.app
xcrun simctl launch DEC49E2B-36CD-47EA-97B9-5E1396DD01DA com.orbace.orbaceSudoku
```

### 5.5 Install and Launch on iPad Simulator

```sh
xcrun simctl install 7AC0C6B7-FEF2-42B7-BB4E-AB3147EAA5BF build/ios/iphonesimulator/Runner.app
xcrun simctl launch 7AC0C6B7-FEF2-42B7-BB4E-AB3147EAA5BF com.orbace.orbaceSudoku
```

### 5.6 Build Android Debug APK

```sh
flutter build apk --debug
```

Expected output:

```text
Built build/app/outputs/flutter-apk/app-debug.apk
```

### 5.7 Install and Launch on Android Emulator

Use the full `adb` path if `adb` is not on the shell path:

```sh
$HOME/Library/Android/sdk/platform-tools/adb install -r build/app/outputs/flutter-apk/app-debug.apk
$HOME/Library/Android/sdk/platform-tools/adb shell am start -n com.orbace.orbaceSudoku/.MainActivity
```

If the app is already running, Android may print:

```text
Warning: Activity not started, intent has been delivered to currently running top-most instance.
```

That is acceptable.

### 5.8 Verify App Is Open

iOS:

```sh
xcrun simctl list devices booted
```

Android:

```sh
$HOME/Library/Android/sdk/platform-tools/adb shell dumpsys window | rg "mCurrentFocus|mFocusedApp"
```

Expected Android focus includes:

```text
com.orbace.orbaceSudoku/com.orbace.orbaceSudoku.MainActivity
```

Also verify that only the current Android package is installed:

```sh
$HOME/Library/Android/sdk/platform-tools/adb shell pm list packages | rg "orbace|sudoku"
```

Expected result:

```text
package:com.orbace.orbaceSudoku
```

Capture a visual proof screenshot after launch:

```sh
$HOME/Library/Android/sdk/platform-tools/adb shell screencap -p /sdcard/orbace_android_home.png
$HOME/Library/Android/sdk/platform-tools/adb pull /sdcard/orbace_android_home.png build/orbace_android_home.png
```

The Home screen must show:

- App title `Orbace Sudoku`.
- Settings gear in the app bar.
- Home cards such as Tea Moment, Import Puzzle, Record Hall, Level Packs, and Scholar's Path.
- Banner ad constrained to the bottom area only.
- No full-screen or centered ad covering the Home cards.

### 5.9 Notes and Common Issues

- `flutter install -d emulator-5554` may install the last available APK instead of rebuilding. For a true latest build, run `flutter build apk --debug` first, then install `build/app/outputs/flutter-apk/app-debug.apk`.
- If the emulator has both the old Android package (`com.orbace.orbace_sudoku`) and current package (`com.orbace.orbaceSudoku`), uninstall the old package before UAT:

```sh
$HOME/Library/Android/sdk/platform-tools/adb uninstall com.orbace.orbace_sudoku
```

- If `adb` fails with a local daemon/socket permission error in a restricted shell, run the same `adb` command with elevated local permissions.
- If a validation tap accidentally opens an AdMob test ad or external app, relaunch Orbace Sudoku directly and re-run the focus check before trusting any screenshots:

```sh
$HOME/Library/Android/sdk/platform-tools/adb shell am start -n com.orbace.orbaceSudoku/.MainActivity
$HOME/Library/Android/sdk/platform-tools/adb shell dumpsys window | rg "mCurrentFocus|mFocusedApp"
```

Expected focus must include `com.orbace.orbaceSudoku/.MainActivity`. A screenshot of an external app, browser, or Play/Google surface is not valid evidence for Orbace UI.
- Lesson learned from 2026-06-29 Android simulator issue:
  - A stale package can make the emulator look like it is running the latest build while actually showing an older app. Always verify the installed package list and focused package.
  - An AdMob banner in `Scaffold.bottomNavigationBar` must be height-constrained. If the banner widget expands to the full viewport, Android can show only a centered test ad with the Home content hidden behind it.
  - Visual screenshot verification is required after every ad/layout change. A successful install and focused package are not enough.
- Lesson learned from 2026-07-01 Import Grid validation:
  - Manual import should not rely on 81 small keyboard-driven text fields on phones. The preferred mobile pattern is a selected Sudoku cell plus an in-app number pad so the soft keyboard never hides the board/keypad.
  - For imported puzzle validation, fail fast before expensive uniqueness solving when the grid has fewer than 17 givens. Very sparse grids can stall Android enough to look like an app crash during UAT.
  - When a physical Android phone already has the release-signed app installed, a local debug APK may fail to install because the signatures do not match. Use a signed beta/internal build for phone UAT, or explicitly uninstall the existing app first when it is acceptable to lose local app data.
- The simulator build is a debug/development build for UAT smoke validation. It is not the same as TestFlight IPA or Google Play AAB production packaging.
- Do not change the app IDs during simulator validation:
  - iOS: `com.orbace.orbaceSudoku`
  - Android: `com.orbace.orbaceSudoku`

## 6. Pre-Phase-4 Exit Criteria

Phase 4 can begin when:

- `scripts/run_validation.sh` passes.
- iOS Simulator launches the app.
- Android Emulator launches the app.
- Manual smoke test cases UAT-001 through UAT-012 pass on at least one iOS simulator.
- Manual smoke test cases UAT-001 through UAT-012 pass on at least one Android emulator.
- Any simulator-only layout or runtime bugs are logged before Phase 4 implementation starts.

## 7. Notes

Full formal UAT belongs in Phase 5. The current pre-Phase-4 validation is a smoke gate, not a release-candidate signoff.
