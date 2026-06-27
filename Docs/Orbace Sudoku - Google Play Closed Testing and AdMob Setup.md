# Orbace Sudoku - Google Play Closed Testing and AdMob Setup

**Version**: 1.1
**Date**: 2026-06-27
**Purpose**: Prepare Orbace Sudoku for Google Play closed testing and define the AdMob setup path without violating the product rule of no ads during active play.

## 1. Current Android App Information

| Field | Value |
| --- | --- |
| App name | Orbace Sudoku |
| Android package name | `com.orbace.orbace_sudoku` |
| iOS bundle ID | `com.orbace.orbaceSudoku` |
| Current AAB version | `1.0.0 (24)` |
| Current AAB path | `build/app/outputs/bundle/release/app-release.aab` |
| Content version | `2026.06.003` |
| Puzzle count | 1,800 |
| Duplicate warnings | 0 |
| Upload signing | Local upload keystore created; backed by ignored `android/key.properties` |

Important: once an Android package name is uploaded to Play Console, it is fixed for that app record. Use `com.orbace.orbace_sudoku` only if this is the final Android package name.

## 2. Signing Setup

The repo now supports release signing through `android/key.properties`.

Tracked files:

- `android/app/build.gradle.kts`: reads `android/key.properties` when present.
- `android/key.properties.example`: safe template for the signing file.

Ignored local files:

- `android/key.properties`
- `android/app/upload-keystore.jks`

Backup requirement:

- Store `android/app/upload-keystore.jks` and the values in `android/key.properties` in Orbace's password manager or secure document vault.
- Do not commit either file.
- Losing the upload key may block future app updates unless Google Play upload-key reset is completed.

Build command:

```bash
flutter build appbundle --release --build-name=1.0.0 --build-number=24
```

Signature check:

```bash
"/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/jarsigner" -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab
```

Expected result:

- `jar verified.`
- Signer certificate subject includes `CN=Orbace Technologies LLC`.

## 3. Google Play Closed Testing Steps

Official reference: [Set up an open, closed, or internal test](https://support.google.com/googleplay/android-developer/answer/9845334).

Recommended path:

1. Create the app in Google Play Console.
2. Confirm the package name before first upload: `com.orbace.orbace_sudoku`.
3. Complete the required app setup sections enough to enable a closed test:
   - App name.
   - Default language.
   - App or game category.
   - Free or paid.
   - Store listing basics.
   - App content questionnaires.
   - Data safety draft.
   - Target audience and content.
   - Ads declaration.
4. Enable Play App Signing when prompted.
5. Upload `build/app/outputs/bundle/release/app-release.aab`.
6. Create a closed testing track.
7. Add testers by email list or Google Group.
8. Provide a feedback email or feedback URL.
9. Review the release warnings.
10. Roll out the release to the closed testing track.
11. Copy and share the opt-in link with testers.

If the Google Play developer account is a newly created personal account, Google requires a closed test with at least 12 opted-in testers for 14 continuous days before applying for production access. Organization accounts may have different access flow, but closed testing is still the recommended release gate.

## 4. Closed-Test Validation Plan

Use this checkpoint for build `1.0.0 (24)`:

| Area | Validation |
| --- | --- |
| Install | Tester can opt in, install from Play, and launch app. |
| App identity | Launcher shows `Orbace Sudoku`. |
| Catalog | Level packs load 1,800 puzzles. |
| Gameplay | Start Tea Moment and at least one pack puzzle. |
| Board scaling | Board digits remain proportional on Android phone and tablet. |
| Replay | Number and note back-actions appear in replay history. |
| Record Hall / Su-Pu | Saved Su-Pu opens from Record Hall, Su-Pu Detail shows local ranking, and Compare Su-Pu / 对谱 opens when two records exist. |
| Stability | No startup crash, no asset load failure. |
| Feedback | Tester can submit notes through the configured feedback channel. |

## 5. AdMob Product Policy

Orbace Sudoku's differentiation depends on a calm, respectful experience.

Rules:

- No ads during active puzzle solving.
- No interstitial before returning to an in-progress puzzle.
- No ad that blocks replay review.
- No ads in Extreme ranked challenge until anti-cheat and fairness rules are defined.
- Prefer low-disruption placements first.

Recommended first monetization setup:

| Surface | Ad Type | Status |
| --- | --- | --- |
| Home / pack browser bottom area | Banner | Candidate |
| Completion screen after score is shown | Banner or native | Candidate |
| Optional extra hint later | Rewarded | Future only |
| Between puzzles | Interstitial | Defer |
| Active board | Any ad | Do not use |

## 6. AdMob Account Setup

Official Flutter reference: [Google Mobile Ads Flutter quick start](https://developers.google.com/admob/flutter/quick-start).  
Official app-ads.txt reference: [Set up an app-ads.txt file](https://support.google.com/admob/answer/9363762).

Required account steps:

1. Create or sign in to AdMob.
2. Add Android app:
   - App name: Orbace Sudoku
   - Platform: Android
   - Package: `com.orbace.orbace_sudoku`
3. Add iOS app:
   - App name: Orbace Sudoku
   - Bundle ID: `com.orbace.orbaceSudoku`
4. Create initial ad units:
   - Android banner ad unit.
   - iOS banner ad unit.
   - Do not create interstitial/rewarded until the UX policy is approved.
5. Record these IDs in a private place:
   - Android AdMob app ID: `ca-app-pub-...~...`
   - iOS AdMob app ID: `ca-app-pub-7497527413129091~4050935967`
   - Android banner ad unit ID: `ca-app-pub-.../...`
   - iOS banner ad unit ID: `ca-app-pub-7497527413129091/7584766530`
6. Publish `app-ads.txt` at the root of the developer website listed in the app store listing.

Android AdMob integration cannot be completed safely in code until the Android app ID and Android ad unit ID are available. The Google Mobile Ads Flutter plugin requires the Android AdMob app ID in `AndroidManifest.xml` before Android SDK initialization.

## 7. Code Integration Plan After IDs Are Available

Current iOS implementation:

- `google_mobile_ads` Flutter plugin is installed.
- `GADApplicationIdentifier` is set in `ios/Runner/Info.plist`.
- Mobile Ads initializes on iOS at app startup.
- Bottom banner is placed on the Home screen only.
- Active Sudoku gameplay screens remain ad-free.
- Debug builds use Google's iOS test banner ad unit.
- Release builds use Orbace's iOS banner ad unit.

UAT policy note:

- Do not ask testers to click ads.
- Treat ad click behavior as out of scope for UAT.
- Validate only that the Home screen can load/display the banner area and that gameplay screens remain ad-free.
- Before broader external testing, confirm App Store privacy details, consent requirements, and app-ads.txt.

Remaining Android implementation sequence after Android IDs are available:

1. Add Android AdMob app ID to `android/app/src/main/AndroidManifest.xml`.
2. Add Android banner ad unit ID to the ad config.
3. Enable Android support in the ad config.
4. Validate with Google's Android test banner ad unit in debug builds.
5. Build a new Android AAB checkpoint.
6. Add consent/privacy work:
   - Data safety update.
   - App privacy update.
   - Consent flow if required by distribution countries.
7. Publish `app-ads.txt`.

## 8. Current Status

| Work Item | Status |
| --- | --- |
| Android app label | Complete |
| Android upload signing support | Complete |
| Local upload keystore | Complete, ignored by git |
| Signed Android AAB for closed test | Complete: `1.0.0 (24)` |
| Google Play closed-test process | Documented |
| iOS AdMob app setup | Complete |
| iOS AdMob code integration | Complete for Home-screen bottom banner |
| Android AdMob setup | Pending Android app ID and ad unit ID |
| App privacy / data safety updates for ads | Pending store metadata update |
| app-ads.txt | Pending developer website setup |
