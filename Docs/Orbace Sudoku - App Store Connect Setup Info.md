# Orbace Sudoku - Xcode and App Store Connect Setup Info

Last updated: 2026-06-20

This document captures the concrete app information needed to configure Orbace Sudoku in Xcode, Apple Developer, and App Store Connect for TestFlight.

## 1. App Identity

| Field | Value |
| --- | --- |
| Public app name | Orbace Sudoku |
| iOS display name | Orbace Sudoku |
| Flutter package name | orbace_sudoku |
| App description | A calm, teaching-first Sudoku game for iOS and Android. |
| Primary platform for TestFlight | iOS |
| Supported Apple device families | iPhone and iPad |
| Recommended primary language | English (U.S.) |
| Recommended primary category | Games |
| Recommended secondary category | Puzzle, if Apple prompts for game subcategory |
| Recommended age rating direction | Low age rating expected; no user-generated content, gambling, mature content, or unrestricted web access currently implemented |

## 2. Apple Developer Team

| Field | Value |
| --- | --- |
| Apple Developer Team ID | Z2GMF897Z7 |
| Xcode signing style | Automatic |
| Required Xcode account state | Apple ID signed in under Xcode > Settings > Accounts with access to team Z2GMF897Z7 |
| Current signing blocker | Local Xcode currently reported no Apple account/provisioning profile during `flutter build ipa --release` |

Action required:

1. Open Xcode.
2. Go to Xcode > Settings > Accounts.
3. Add/sign in with the Apple ID that has access to team `Z2GMF897Z7`.
4. Reopen `ios/Runner.xcworkspace`.
5. Select Runner target > Signing & Capabilities.
6. Confirm Team is `Z2GMF897Z7` and automatic signing resolves without errors.

## 3. Bundle IDs

| Target | Bundle ID | Use |
| --- | --- | --- |
| Runner app | com.orbace.orbaceSudoku | Production/TestFlight iOS app |
| RunnerTests | com.orbace.orbaceSudoku.RunnerTests | Xcode test target only |

Apple Developer setup:

1. Register explicit App ID: `com.orbace.orbaceSudoku`.
2. Description: `Orbace Sudoku`.
3. Capabilities to enable now:
   - None beyond default app capabilities for the current build.
4. Capabilities to consider later:
   - Game Center, if worldwide Extreme Challenge leaderboards use Apple Game Center.
   - In-App Purchase, if paid level packs or subscriptions are added.
   - Push Notifications, only if reminders/events are added.
   - Sign in with Apple, only if user accounts are added.

Important:

- Do not register a temporary bundle ID for TestFlight.
- App Store Connect, Apple Developer, and Xcode must all use `com.orbace.orbaceSudoku` exactly.

## 4. Flutter Versioning

Current `pubspec.yaml` value:

```yaml
version: 1.0.0+1
```

| Store Field | Current Value | Source |
| --- | --- | --- |
| Marketing version | 1.0.0 | Flutter build name / `CFBundleShortVersionString` |
| Build number | 1 | Flutter build number / `CFBundleVersion` |

Build command for first TestFlight upload:

```sh
flutter build ipa --release --build-name 1.0.0 --build-number 1
```

If build `1` has already been uploaded or rejected and a replacement is needed:

```sh
flutter build ipa --release --build-name 1.0.0 --build-number 2
```

Rule:

- Keep `1.0.0` for the first beta wave.
- Increment only the build number for each new upload: `1`, `2`, `3`, etc.

## 5. Xcode Runner Target Settings

Open:

```sh
open ios/Runner.xcworkspace
```

Set or verify Runner target > General:

| Xcode Field | Value |
| --- | --- |
| Display Name | Orbace Sudoku |
| Bundle Identifier | com.orbace.orbaceSudoku |
| Version | 1.0.0 |
| Build | 1 |
| Team | Z2GMF897Z7 |
| Signing | Automatically manage signing |
| App icon asset | AppIcon |
| Launch screen | LaunchScreen |

Set or verify Runner target > Signing & Capabilities:

| Setting | Value |
| --- | --- |
| Automatically manage signing | Enabled |
| Team | Z2GMF897Z7 |
| Bundle Identifier | com.orbace.orbaceSudoku |
| Provisioning profile | Xcode Managed Profile, once account/team access is available |

Set or verify Runner target > Build Settings:

| Build Setting | Value |
| --- | --- |
| Product Bundle Identifier | com.orbace.orbaceSudoku |
| Development Team | Z2GMF897Z7 |
| Current Project Version | `$(FLUTTER_BUILD_NUMBER)` |
| Marketing Version | from Flutter build name |

## 6. iOS Info.plist Values

Current `ios/Runner/Info.plist` values:

| Key | Value |
| --- | --- |
| CFBundleDisplayName | Orbace Sudoku |
| CFBundleName | orbace_sudoku |
| CFBundleIdentifier | `$(PRODUCT_BUNDLE_IDENTIFIER)` |
| CFBundleShortVersionString | `$(FLUTTER_BUILD_NAME)` |
| CFBundleVersion | `$(FLUTTER_BUILD_NUMBER)` |
| LSRequiresIPhoneOS | true |
| UILaunchStoryboardName | LaunchScreen |
| UIMainStoryboardFile | Main |

Supported orientations:

| Device | Orientations |
| --- | --- |
| iPhone | Portrait, Landscape Left, Landscape Right |
| iPad | Portrait, Portrait Upside Down, Landscape Left, Landscape Right |

## 7. App Store Connect App Record

Create new app record:

| App Store Connect Field | Recommended Value |
| --- | --- |
| Platform | iOS |
| Name | Orbace Sudoku |
| Primary Language | English (U.S.) |
| Bundle ID | com.orbace.orbaceSudoku |
| SKU | orbace-sudoku-ios |
| User Access | Full Access, unless restricting to selected users |

SKU notes:

- Recommended SKU: `orbace-sudoku-ios`
- SKU is internal and not shown to customers.
- If the team uses another naming convention, use one stable unique SKU and document it here.

After app record creation, fill:

| Section | Value / Direction |
| --- | --- |
| Category | Games |
| Game subcategory | Puzzle / Board, if available and appropriate |
| Content Rights | Orbace-owned original app/content |
| Pricing | Free for initial TestFlight; App Store pricing can be decided later |
| Availability | Decide before App Store release; not critical for initial internal TestFlight |

## 8. TestFlight Test Information

Recommended beta app description:

```text
Orbace Sudoku is a calm, teaching-first Sudoku game with Tea Moment puzzles, replay, score tracking, Scholar's Path awards, and an Extreme Challenge hub.
```

Recommended What to Test:

```text
Please test:
- App install and first launch
- Home navigation
- Tea Moment puzzle play
- Cell selection, number entry, notes, undo, redo, erase
- Hint flow and mistake checking
- Puzzle completion, score breakdown, retry, and replay
- Scholar's Path progress screen
- Extreme Challenge locked hub
- Visual layout on iPhone and iPad
- Crashes, freezes, confusing flows, or text/layout issues

Known limitations:
- Level packs are not fully implemented yet.
- Extreme Challenge is currently a locked/local hub, not a live worldwide leaderboard.
- App artwork and final store polish are not final.
```

Recommended feedback email:

```text
[team feedback email]
```

Recommended contact:

```text
[App owner name]
[App owner email]
[Phone optional]
```

Demo account:

```text
Not required for current build; no login is implemented.
```

## 9. Privacy and Data Collection Draft

Current implementation appears local-first.

Known local data:

- Puzzle records
- Current progress
- Solve attempts
- Move history for replay
- Score and score breakdown
- Local award progress
- Local ranked attempt history

Current network/account features:

- No login implemented.
- No cloud sync implemented.
- No ad SDK implemented.
- No analytics SDK implemented.
- No third-party tracking SDK implemented.
- No payment flow implemented.

Recommended App Privacy draft for current TestFlight build:

| Privacy Question | Recommended Current Answer |
| --- | --- |
| Does the app collect data from this app? | Likely No, if no telemetry or backend is added before upload |
| Is data linked to the user? | No, for current local-only implementation |
| Is data used for tracking? | No |
| Does the app use third-party analytics/tracking SDKs? | No |

Revisit privacy answers before App Store submission if any of these are added:

- Accounts/login
- Cloud leaderboard
- Worldwide Extreme Challenge backend
- Analytics
- Crash reporting SDK
- Ads
- In-app purchases
- Push notifications

## 10. Export Compliance Draft

Current app likely uses only standard platform/network encryption, or no custom encryption.

Recommended current direction:

- If the build has no network functionality beyond standard Apple/Flutter platform behavior, answer export compliance accordingly in App Store Connect.
- If HTTPS/backend calls are added later, answer based on standard encryption usage.
- If custom cryptography is added, revisit with Apple export compliance requirements.

Do not guess during App Store Connect submission if encryption behavior changes.

## 11. Build and Upload Commands

From project root:

```sh
cd /Users/alexzhang/DevProjects/Orbace_Sudoku
flutter doctor -v
flutter pub get
flutter analyze
flutter test
flutter build ios --release --no-codesign
flutter build ipa --release --build-name 1.0.0 --build-number 1
```

Expected IPA:

```sh
build/ios/ipa/*.ipa
```

Upload with Transporter:

```sh
open -a Transporter build/ios/ipa/*.ipa
```

## 12. Current Build Status

Last local iOS build attempt:

| Command | Result |
| --- | --- |
| `flutter build ios --release --no-codesign` | Passed; produced `build/ios/iphoneos/Runner.app` |
| `flutter build ipa --release` | Failed at signing/export |

Current blocker for IPA/TestFlight:

```text
Xcode has no Apple account/provisioning profile available for com.orbace.orbaceSudoku.
```

Resolution:

1. Add the Apple ID in Xcode.
2. Confirm access to Team ID `Z2GMF897Z7`.
3. Confirm App ID `com.orbace.orbaceSudoku` exists in Apple Developer.
4. Confirm the App Store Connect app record uses the same Bundle ID.
5. Re-run `flutter build ipa --release --build-name 1.0.0 --build-number 1`.

## 13. Internal TestFlight Group Plan

Recommended initial groups:

| Group | Purpose |
| --- | --- |
| Core Team | Founder/developer smoke testing |
| QA / UAT | Structured UAT test case execution |
| Expert Sudoku Players | Expert feedback on replay, scoring, and difficulty |

Internal tester checklist:

- Add testers as App Store Connect users.
- Give app access to Orbace Sudoku.
- Add processed build to the group.
- Paste What to Test from this document.
- Notify testers.

## 14. External TestFlight Group Plan

Recommended later groups:

| Group | Purpose |
| --- | --- |
| Friends and Family | Early broad usability pass |
| Sudoku Enthusiasts | Difficulty, scoring, replay feedback |
| Public Beta | Larger beta after internal stability |

External TestFlight notes:

- External beta may require Beta App Review.
- First external build for a version should be stable enough for Apple review and tester onboarding.
- Include a clear beta description and no broken login requirement.

## 15. Open Decisions

Before final TestFlight rollout, decide:

- Final App Store SKU, if not using `orbace-sudoku-ios`.
- Feedback email address.
- Public support/contact email.
- Whether Game Center will be enabled now or deferred.
- Whether worldwide Extreme Challenge will use Game Center, custom backend, or both.
- Whether crash reporting should be added before external beta.
- Final app icon and launch screen artwork.
- App privacy answers after any analytics/backend decisions.

