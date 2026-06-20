# TestFlight Setup Process - Generic New App Runbook

Last reviewed: 2026-06-20

This document describes the generic step-by-step process for setting up a new iOS app for TestFlight using Flutter, Xcode, Apple Developer, and App Store Connect. Use it for any new app, then replace the bracketed placeholders with the app-specific values.

## 1. Required Inputs

Collect these before touching Xcode or App Store Connect:

- App display name: `[App Name]`
- Apple Developer team name and Team ID: `[Team Name]`, `[TEAMID1234]`
- Bundle identifier: `[com.company.appName]`
- SKU: `[internal-sku-or-project-code]`
- Primary language: `[English (U.S.)]`
- App category: `[Games, Health & Fitness, Productivity, etc.]`
- Minimum iOS version: `[iOS version]`
- Test owner: `[name/email]`
- Internal tester emails: `[emails]`
- External tester emails or public-link plan: `[emails/public link]`
- Beta test notes: `[what testers should validate]`
- Privacy/data collection summary: `[none/local only/cloud account/etc.]`
- Encryption/export compliance answer: `[standard HTTPS only / custom crypto / exempt / unknown]`

## 2. Apple Account and Role Prerequisites

1. Confirm the organization is enrolled in the Apple Developer Program.
2. Confirm the Account Holder has accepted the latest Apple agreements in App Store Connect.
3. Confirm the release operator has one of these roles:
   - Account Holder
   - Admin
   - App Manager
4. Confirm the release Mac has:
   - Current stable Xcode installed
   - Flutter installed
   - CocoaPods installed if the Flutter iOS project uses Pods
   - The correct Apple ID signed in under Xcode > Settings > Accounts
5. In Xcode, select the correct Apple Developer team and let Xcode download signing assets.

Expected result:

- Xcode can see the team.
- App Store Connect can create or access apps.
- The local machine can sign an iOS archive.

## 3. Register the Bundle ID

1. Go to Apple Developer > Certificates, Identifiers & Profiles.
2. Open Identifiers.
3. Add a new App ID.
4. Select App.
5. Enter:
   - Description: `[App Name]`
   - Bundle ID type: Explicit
   - Bundle ID: `[com.company.appName]`
6. Enable only the capabilities the app actually uses.
   - Examples: Game Center, Push Notifications, Sign in with Apple, iCloud, In-App Purchase.
7. Continue, review, and register.

Best practices:

- Use one stable bundle id for the production/TestFlight app.
- Do not use a temporary bundle id if the app will go to App Store later.
- Keep dev/staging bundle ids separate only when you truly need separate installed apps.

## 4. Configure Flutter and Xcode Project Identity

1. In the Flutter project, open the iOS workspace:

```sh
open ios/Runner.xcworkspace
```

2. In Xcode, select Runner project > Runner target.
3. In General > Identity, set:
   - Display Name: `[App Name]`
   - Bundle Identifier: `[com.company.appName]`
   - Version: `[1.0.0]`
   - Build: `[1]`
4. In Signing & Capabilities:
   - Enable Automatically manage signing.
   - Select the correct Team.
   - Confirm Xcode shows no signing errors.
5. If the app uses capabilities, add the same capabilities here that were enabled on the Bundle ID.
6. In `pubspec.yaml`, set the Flutter version/build number:

```yaml
version: 1.0.0+1
```

Rules:

- Marketing version maps to iOS `CFBundleShortVersionString`.
- Build number maps to iOS `CFBundleVersion`.
- Every App Store Connect upload must use a new build number.

## 5. Create the App Record in App Store Connect

1. Go to App Store Connect.
2. Open Apps.
3. Click `+` and select New App.
4. Fill in:
   - Platform: iOS
   - Name: `[App Name]`
   - Primary language: `[language]`
   - Bundle ID: `[com.company.appName]`
   - SKU: `[internal-sku-or-project-code]`
   - User access: Full Access, unless app access should be restricted.
5. Click Create.
6. Confirm the app status is Prepare for Submission.

Notes:

- The App Store Connect app record must exist before upload.
- The Account Holder must accept required agreements before new apps can be created.
- The Bundle ID selected here must match the Xcode bundle identifier exactly.

## 6. Complete Minimum App Metadata for TestFlight

TestFlight does not require the full App Store listing, but keep these areas ready because they often block build processing, beta review, or later submission:

1. App Information:
   - Category
   - Content Rights
   - Age rating, if prompted
2. Pricing and Availability:
   - Usually can stay incomplete for internal TestFlight, but complete before App Store submission.
3. App Privacy:
   - Prepare this early.
   - Document whether data is collected, linked to user identity, used for tracking, or kept on-device.
4. Export Compliance:
   - Be ready to answer encryption questions for every build unless exempted via app metadata or Info.plist.
5. Test Information:
   - Beta app description
   - Feedback email
   - Contact information
   - Demo account credentials, if login is required
   - Notes for reviewers/testers

## 7. Validate Locally Before Archive

From the Flutter project root:

```sh
flutter doctor -v
flutter pub get
flutter analyze
flutter test
flutter build ios --release --no-codesign
```

Expected result:

- `flutter doctor` has no blocking Xcode/iOS issues.
- Analyze and tests pass.
- Unsigned release build succeeds.

If the unsigned build fails, fix app code before touching TestFlight signing.

## 8. Build the TestFlight IPA

From the Flutter project root:

```sh
flutter build ipa --release
```

Expected outputs:

```sh
build/ios/archive/*.xcarchive
build/ios/ipa/*.ipa
```

Optional explicit build/version override:

```sh
flutter build ipa --release --build-name 1.0.0 --build-number 2
```

If using a saved export options file:

```sh
flutter build ipa --release --export-options-plist=/path/to/ExportOptions.plist
```

Common signing failures:

- `No Accounts`: Sign in to Xcode > Settings > Accounts.
- `No profiles for '[bundle id]' were found`: Confirm bundle id exists, team is correct, and Xcode can automatically manage signing.
- `Provisioning profile doesn't include capability`: Enable the capability in both Apple Developer and Xcode.
- `Bundle identifier mismatch`: Make Xcode, App Store Connect, and Apple Developer use the same bundle id.
- `Build number already uploaded`: Increment the build number and rebuild.

## 9. Upload the Build

Preferred options:

1. Transporter app:
   - Open Apple's Transporter app.
   - Drag `build/ios/ipa/*.ipa` into Transporter.
   - Sign in with the Apple ID that has App Store Connect access.
   - Click Deliver.
2. Xcode Organizer:
   - Open `build/ios/archive/*.xcarchive`.
   - Validate App.
   - Distribute App.
   - Choose App Store Connect upload.
3. Command line with App Store Connect API key:

```sh
xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey [KEY_ID] --apiIssuer [ISSUER_ID]
```

Expected result:

- Upload succeeds.
- App Store Connect shows the build under the app's Activity or TestFlight area after processing.
- Processing often takes minutes; plan for up to 30 minutes before troubleshooting.

## 10. Resolve Build Processing Items

In App Store Connect:

1. Open Apps > `[App Name]`.
2. Open TestFlight.
3. Select the uploaded iOS build.
4. If status is Missing Compliance:
   - Click Manage or Provide Export Compliance Information.
   - Answer encryption/export compliance questions.
   - Save.
5. If required, enter:
   - What to Test
   - Beta app description
   - Feedback email
   - Contact information
   - Demo account credentials

Build status checkpoints:

- Processing: wait.
- Missing Compliance: answer export compliance.
- Ready to Test: internal testers can receive it.
- Waiting for Review / In Review: external TestFlight review is pending.
- Rejected: open App Review details, fix metadata or app issue, upload a new build if needed.

## 11. Set Up Internal Testing

Use internal testing for the first validation loop.

1. In App Store Connect, open the app.
2. Open TestFlight.
3. Create or open an internal tester group.
4. Add App Store Connect users as internal testers.
5. Add the processed build to the group.
6. Enter What to Test.
7. Save and notify testers.

Rules:

- Internal testers must be App Store Connect users with app access.
- Internal tester limit is up to 100 users.
- Internal builds are available for 90 days.
- Internal testing usually does not require the same beta review flow as external testing.

Recommended internal groups:

- `Core Team`
- `Product / QA`
- `Leadership Preview`

## 12. Set Up External Testing

Use external testing when testers are not App Store Connect users or when a broader beta group is needed.

1. In App Store Connect, open the app.
2. Open TestFlight.
3. Create an external tester group.
4. Add testers by email or enable a public link.
5. Add the build to the group.
6. Enter:
   - What to Test
   - Beta app description
   - Feedback email
   - Contact information
   - Demo account, if needed
7. Submit for Beta App Review if prompted.
8. After approval, start testing or notify testers.

Rules:

- External tester limit is up to 10,000 users.
- The first external build for a version requires fuller beta review.
- Later builds for the same version may be reviewed faster, but are not guaranteed.
- Apple currently limits TestFlight App Review submissions per app version; do not burn review attempts with half-ready builds.

Recommended external groups:

- `Friends and Family`
- `Expert Testers`
- `Public Beta`
- `Press / Advisors`, if applicable

## 13. Prepare Tester Instructions

Use this template for the TestFlight What to Test field:

```text
Please test:
- Install and first launch
- Main navigation
- Core feature: [feature]
- Save/resume behavior
- Offline behavior, if applicable
- Account/login flow, if applicable
- Purchase flow, if applicable, using sandbox/TestFlight behavior only
- Visual issues on iPhone and iPad
- Crashes, freezes, data loss, or confusing flows

Known limitations:
- [limitation 1]
- [limitation 2]

Please include:
- Device model
- iOS version
- Steps to reproduce
- Screenshot or screen recording when useful
```

## 14. UAT and Feedback Loop

1. Create or update the project UAT test case document.
2. Ask testers to run through the highest-risk flows first.
3. Monitor:
   - TestFlight feedback
   - Crash reports
   - App Store Connect build metrics
   - Tester emails/messages
4. Triage findings:
   - P0: crash, data loss, cannot launch, cannot complete core flow
   - P1: core feature broken or serious UX blocker
   - P2: confusing, visually broken, non-critical defect
   - P3: polish or nice-to-have
5. Fix issues.
6. Increment build number.
7. Rebuild and upload.
8. Add the new build to tester groups.

## 15. Version and Build Number Policy

Recommended:

- Keep marketing version stable during a beta wave:
  - `1.0.0+1`
  - `1.0.0+2`
  - `1.0.0+3`
- Increment marketing version only when changing the release train:
  - `1.0.0` beta
  - `1.0.1` patch
  - `1.1.0` feature release
- Never reuse an uploaded build number for the same bundle id and marketing version.

Flutter examples:

```sh
flutter build ipa --release --build-name 1.0.0 --build-number 1
flutter build ipa --release --build-name 1.0.0 --build-number 2
flutter build ipa --release --build-name 1.0.1 --build-number 3
```

## 16. Release Readiness Checklist

Before sending to internal testers:

- [ ] Bundle ID registered.
- [ ] App record created in App Store Connect.
- [ ] Xcode team selected.
- [ ] Signing works locally.
- [ ] App icon present.
- [ ] Launch screen acceptable.
- [ ] Version/build number set.
- [ ] `flutter analyze` passes.
- [ ] `flutter test` passes.
- [ ] `flutter build ios --release --no-codesign` passes.
- [ ] `flutter build ipa --release` produces IPA.
- [ ] IPA uploaded.
- [ ] Export compliance answered.
- [ ] What to Test filled in.
- [ ] Internal tester group created.
- [ ] Build assigned to internal group.

Before sending to external testers:

- [ ] Internal smoke test completed.
- [ ] No launch-blocking bugs.
- [ ] Beta app description complete.
- [ ] Feedback email valid.
- [ ] Demo account provided if needed.
- [ ] External tester group created.
- [ ] Build submitted for Beta App Review if required.
- [ ] Approval received.
- [ ] External testers notified.

## 17. Troubleshooting Matrix

| Symptom | Likely Cause | Fix |
| --- | --- | --- |
| Xcode says No Accounts | Apple ID not signed in | Xcode > Settings > Accounts, add Apple ID |
| No provisioning profile found | Bundle ID/team mismatch or signing not downloaded | Confirm Bundle ID, Team, automatic signing |
| Capability provisioning error | Apple Developer and Xcode capabilities differ | Enable same capability in both places |
| IPA not created | Archive/export failed | Read Xcode signing/export error and rebuild |
| Build uploaded but not visible | App Store Connect processing delay | Wait, then check Activity |
| Missing Compliance | Export compliance unanswered | Answer TestFlight export compliance questions |
| Build number already exists | Reused uploaded build number | Increment build number |
| External testers cannot test | Build not approved or not assigned to group | Submit/finish beta review and add build to group |
| Internal tester not visible | User lacks App Store Connect access | Add user or adjust role/access |
| App installs then crashes | Runtime bug or missing entitlement | Check crash feedback, device logs, capabilities |

## 18. Generic Command Sequence for Flutter Apps

Use this once Apple signing is configured:

```sh
cd /path/to/flutter/project
git status --short
flutter doctor -v
flutter pub get
flutter analyze
flutter test
flutter build ios --release --no-codesign
flutter build ipa --release --build-name [1.0.0] --build-number [1]
ls -la build/ios/ipa
```

Upload:

```sh
open -a Transporter build/ios/ipa/*.ipa
```

Or upload with API key:

```sh
xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey [KEY_ID] --apiIssuer [ISSUER_ID]
```

## 19. References

- Apple: Add a new app - https://developer.apple.com/help/app-store-connect/create-an-app-record/add-a-new-app
- Apple: TestFlight overview - https://developer.apple.com/help/app-store-connect/test-a-beta-version/testflight-overview
- Apple: Add internal testers - https://developer.apple.com/help/app-store-connect/test-a-beta-version/add-internal-testers
- Apple: Invite external testers - https://developer.apple.com/help/app-store-connect/test-a-beta-version/invite-external-testers
- Apple: Add testers to builds - https://developer.apple.com/help/app-store-connect/test-a-beta-version/add-testers-to-builds
- Apple: Export compliance for beta builds - https://developer.apple.com/help/app-store-connect/test-a-beta-version/provide-export-compliance-information-for-beta-builds
- Flutter: Build and release an iOS app - https://docs.flutter.dev/deployment/ios
