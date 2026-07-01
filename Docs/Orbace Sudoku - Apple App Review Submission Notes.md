# Orbace Sudoku - Apple App Review Submission Notes

**Purpose:** Prepare the App Store Connect review information, reviewer notes, privacy disclosures, and final review checklist for Orbace Sudoku.

**Date:** 2026-06-30  
**App name:** Orbace Sudoku  
**Developer / seller:** Orbace Technologies LLC  
**Apple Team ID:** `4Q4LMBRDM3`  
**Bundle ID:** `com.orbace.orbaceSudoku`  
**SKU:** `orbace-sudoku-ios`  
**Current beta build:** `1.0.0 (35)`  
**Target release:** V1.0.0

---

## 1. App Review Summary

Orbace Sudoku is a calm, teaching-first Sudoku game for iPhone and iPad. It includes built-in Sudoku puzzle packs, a daily Tea Moment puzzle, imported personal puzzles, replay, local score certificates, Record Hall, local ranking, and non-gameplay banner ads.

There is no account login, no social network, no server-side user profile, no user-generated public content, no in-app purchase, no subscription, and no gambling. All gameplay records are stored locally on the user's device.

Active Sudoku gameplay is ad-free. Banner ads appear only on non-gameplay screens such as Home, Level Packs, Record Hall, Import Puzzle, replay/detail screens, Scholar's Path, Extreme Challenge hub, and Settings.

---

## 2. App Store Connect Review Information

### Contact Information

Use the App Store Connect contact fields for the current release owner.

Recommended values:

| Field | Value |
| --- | --- |
| First name | Alex |
| Last name | Zhang |
| Phone | `[release contact phone]` |
| Email | `support@orbacetech.com` |

Confirm the email and phone can receive Apple review follow-up during the review window.

### Sign-In Information

Orbace Sudoku does **not** require sign-in.

Recommended App Review field:

```text
No sign-in is required. The app is fully usable without an account.
```

### Demo Account

Not required.

Reason:

- No login.
- No account-only feature.
- No server-gated content in V1.
- All reviewer-accessible features are available from the Home screen after launch.

---

## 3. Review Notes to Paste Into App Store Connect

Use this as the main **Notes for Review** content:

```text
Orbace Sudoku is a local, teaching-first Sudoku game. No account or demo login is required.

Core review path:
1. Launch the app.
2. Tap Tea Moment to start today's puzzle.
3. Use the number pad, notes, undo/redo, erase, hint, pause, and completion flow.
4. Return Home and open Level Packs to browse bundled puzzles.
5. Open Import Puzzle to paste or manually enter a personal Sudoku. Example paste string:
   530070000600195000098000060800060003400803001700020006060000280000419005000080079
6. Open Record Hall after completing a puzzle to view saved local Su-Pu records, replay, score card, and local ranking details.
7. Open Settings to view Privacy Policy, Terms of Use, and Ad Privacy Status.

Ads:
- Banner ads appear only on non-gameplay screens.
- Active Sudoku gameplay is ad-free.
- This beta/review build may use Google test banner ads for validation.
- Production ads use Google AdMob and are gated by Google's User Messaging Platform consent flow when required.

Privacy:
- Orbace Sudoku does not require an account and does not send gameplay records to Orbace servers.
- Gameplay progress, imported puzzles, score cards, replay records, notes, and local rankings are stored locally on the device.
- Google AdMob may process device/ad data as described in the in-app Privacy Policy.
- UMP consent forms appear only when Google determines consent is required and AdMob Privacy & messaging forms are configured for the app.

No in-app purchases, subscriptions, external purchases, gambling, user-generated public content, chat, or account-based features are included in V1.
```

If the build being submitted still uses `ORBACE_FORCE_TEST_ADS=true`, keep the "may use Google test banner ads" line. For a final production-live-ad build, replace that line with:

```text
Production ads use the configured Orbace Sudoku Google AdMob banner unit.
```

---

## 4. Feature Access Map for Reviewers

| Feature | How Reviewer Accesses It | Notes |
| --- | --- | --- |
| Home | Launch app | Main navigation hub. |
| Tea Moment | Home > Tea Moment | Starts today's daily puzzle. |
| Level Packs | Home > Level Packs | Browse 1,800 bundled puzzles. |
| Import Puzzle | Home > Import Puzzle | Paste or manually enter 81-cell Sudoku. |
| Record Hall | Home > Record Hall | Requires at least one completed puzzle to show records. |
| Replay | Complete puzzle or open saved Record Hall record | Local replay of solve actions. |
| Completion certificate | Finish any puzzle | Shows score, timing, mistakes, hints, rating, notes, and calculation explanation. |
| Save/Share card | Completion certificate / Record Hall | Uses native share sheet; score card is local. |
| Su-Pu Detail | Record Hall > saved record | Same-puzzle solve history, local ranking, compare. |
| Local Ranking | Su-Pu Detail | Local-only ranking for same built-in puzzle on same device. |
| Scholar's Path | Home > Scholar's Path | Local awards/progression. |
| Extreme Challenge | Home > Extreme Challenge | Local locked/no-assist challenge hub. |
| Settings | Gear icon on Home | Privacy, Terms, Ad Privacy Status. |

---

## 5. Privacy and Data Handling Statement

Use this wording for internal review alignment and metadata QA:

Orbace Sudoku stores gameplay data locally on the device, including:

- Puzzle progress.
- Imported puzzle strings/manual puzzle entries.
- Completed Su-Pu records.
- Replay histories.
- Score cards.
- Player difficulty ratings and ranking notes.
- Local ranking state.

Orbace Sudoku does not require:

- Name.
- Email.
- Phone number.
- Account login.
- Contact list.
- Location permission.
- Camera/photo permission in V1.
- Push notification permission.
- Cloud sync.

Third-party advertising:

- Google AdMob is integrated.
- Google Mobile Ads SDK and Google UMP SDK are included.
- `GADApplicationIdentifier`: `ca-app-pub-7497527413129091~4050935967`
- `NSUserTrackingUsageDescription` is present:

```text
Orbace Sudoku uses this identifier to support personalized ads where you allow ad personalization.
```

Encryption:

- `ITSAppUsesNonExemptEncryption` is set to `false`.
- App does not implement custom encryption beyond standard platform/network behavior.

---

## 6. App Privacy Answers - Recommended Direction

Final App Store privacy answers must match the submitted binary and Apple questionnaire wording.

Recommended direction for the current AdMob-enabled build:

| Category | Recommended Answer / Direction |
| --- | --- |
| Data collected by Orbace servers | None; no Orbace backend in V1. |
| Third-party advertising data | Disclose Google AdMob data collection according to Apple's privacy questionnaire and Google AdMob SDK disclosures. |
| Tracking | If AdMob uses IDFA/tracking for personalized ads, disclose tracking and ensure ATT purpose string is present. |
| Location | No precise location permission requested. AdMob may infer approximate location from IP; disclose if prompted under third-party advertising. |
| User content | Imported puzzles, notes, score cards remain local; not uploaded. |
| Diagnostics | Only disclose if crash/analytics SDKs are added; none are intentionally added in current code. |

Do not claim "Data Not Collected" if App Store Connect treats AdMob SDK processing as collected/tracked data for the submitted build.

---

## 7. Age Rating Direction

Recommended age rating: low rating / general audience.

Content characteristics:

- Sudoku puzzle gameplay.
- No violence.
- No sexual content.
- No profanity.
- No alcohol/drug/tobacco content.
- No gambling or contests for money.
- No unrestricted web access.
- No user-generated public content.
- No chat/messaging.

Ads are present on non-gameplay screens, so answer any advertising-related age-rating questions accurately.

---

## 8. App Store Metadata Checklist

| Area | Recommended Value |
| --- | --- |
| Name | Orbace Sudoku |
| Subtitle | Calm · Teaching-first · Local Play |
| Category | Games |
| Subcategory | Puzzle |
| Secondary category | Education, if desired |
| Pricing | Free |
| Support URL | `https://orbace.com/support` or final Orbace support URL |
| Privacy Policy URL | `https://orbace.com/privacy` or final Orbace privacy URL |
| Marketing URL | Optional |
| Copyright | `© 2026 Orbace Technologies LLC` |
| Bundle ID | `com.orbace.orbaceSudoku` |
| SKU | `orbace-sudoku-ios` |

Before submission, confirm support/privacy URLs are live, not placeholders.

---

## 9. Screenshot / Demo Expectations

Recommended screenshots should show:

- Home screen with Tea Moment and major navigation cards.
- Active gameplay board with no ad visible.
- Level Packs / puzzle list.
- Completion certificate / Su-Pu score card.
- Record Hall or Su-Pu Detail.
- Import Puzzle paste/grid screen.

Avoid screenshots that imply:

- Global ranking is live in V1.
- Paid packs or subscriptions are available.
- Photo import/OCR is available.
- Account login/global leaderboard exists.

Those features are planned/deferred and should not appear in V1 App Store metadata.

---

## 10. Review Risk Checklist

| Risk | Status / Mitigation |
| --- | --- |
| App crashes or blank screen | Run smoke test on physical iPhone and iPad before submission. |
| Ads in gameplay | Gameplay screen intentionally has no banner. Verify before submission. |
| UMP form not showing | Expected unless consent required and AdMob Privacy & messaging form configured. Configure AdMob forms before production. |
| App privacy mismatch | Ensure App Store privacy answers disclose AdMob/IDFA behavior. |
| ATT missing | `NSUserTrackingUsageDescription` is present. |
| Metadata mentions unavailable features | Do not mention global ranking, official events, photo import, IAP, or paid packs for V1. |
| iPad orientation | App currently supports portrait/full-screen iPad behavior for V1. Confirm App Store validation passes. |
| Support/privacy URLs | Must be live and corporate-owned before release. |
| Test ads in production | Production-live build must be built without `--dart-define=ORBACE_FORCE_TEST_ADS=true`. |

---

## 11. Pre-Submission Smoke Test

Run this before submitting a build to App Review:

1. Install App Store/TestFlight candidate on iPhone.
2. Install App Store/TestFlight candidate on iPad.
3. Launch app; Home appears.
4. Open Settings; Privacy Policy, Terms, and Ad Privacy Status open.
5. Confirm banner ad appears on Home or other non-gameplay screen.
6. Start Tea Moment; confirm no banner appears on active game board.
7. Enter notes and numbers.
8. Use undo/redo/erase/hint.
9. Complete a puzzle, or use a nearly solved imported puzzle to validate completion.
10. Confirm completion certificate appears.
11. Save/share score card.
12. Open Record Hall.
13. Open Replay and Su-Pu Detail.
14. Relaunch app; confirm local data still opens.

---

## 12. Build Commands

### TestFlight / App Store Candidate With Production Ads

Use for final production review after AdMob forms/app-ads/privacy setup is complete:

```sh
flutter build ipa --release \
  --build-name=1.0.0 \
  --build-number=<next_build> \
  --export-options-plist=ios/ExportOptions.plist
```

### Beta Review Build With Google Test Ads

Use only for beta/UAT validation of ad placement:

```sh
flutter build ipa --release \
  --build-name=1.0.0 \
  --build-number=<next_build> \
  --export-options-plist=ios/ExportOptions.plist \
  --dart-define=ORBACE_FORCE_TEST_ADS=true
```

Do not submit a forced-test-ad build as the final production candidate unless the review intent is TestFlight-only validation.

---

## 13. Official Apple References

- App Review Guidelines: https://developer.apple.com/app-store/review/guidelines/
- Provide App Review information: https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/provide-app-review-information

Apple's App Review Guidelines emphasize that apps should be tested for crashes and bugs, metadata should be accurate, contact information should be current, reviewers should get full access or demo information when needed, backend services should be live, and review notes should explain non-obvious features.
