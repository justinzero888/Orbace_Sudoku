# Orbace Sudoku - Production Readiness Plan

**Version**: 1.2
**Date**: 2026-07-01 (refreshed twice today; originally 2026-06-25)
**Purpose**: Define the remaining work to move Orbace Sudoku from UAT/TestFlight builds to a product-ready iOS and Android release candidate.

## 1. Current Baseline

| Area | Current State |
| --- | --- |
| App-code baseline | `fec65f7` plus this session's commit bringing builds 31-37 worth of work into git history (see git log for the exact commit) |
| Current beta build (both stores) | `1.0.0 (36)` — **confirmed uploaded to App Store Connect TestFlight and Google Play Console closed testing under the Orbace Technologies LLC corporate account, both platforms.** UAT feedback has been coming from this build on both platforms. |
| Next beta build (this pass) | `1.0.0 (37)` — see section 1a |
| Current iOS IPA | `build/ios/ipa/orbace_sudoku.ipa`, rebuilt for `1.0.0 (37)` this pass |
| Current Android AAB | `build/app/outputs/bundle/release/app-release.aab`, rebuilt for `1.0.0 (37)` this pass |
| Content catalog | 1,800 bundled puzzles, content version `2026.06.003`, 0 duplicate-scan warnings; `extreme` pack renamed "Extreme Challenge" → "Expert Challenge" (UAT-041) |
| Su-Pu system | Replay, Record Hall, score certificate, save/share card, notes, imported labels, and local ranking complete for iOS UAT |
| Active feedback tracker | `Docs/Orbace Sudoku - UAT Feedback and Ideas Log.md` |
| Content/scoring reference | `Docs/Orbace Sudoku - Level Assignment Validation and Scoring Logic.md` |
| Ownership/account migration tracker | `Docs/Orbace Sudoku - Developer Ownership Migration Checklist.md` — Android/iOS corporate-account uploads confirmed 2026-07-01; AdMob publisher ownership and iOS `app-ads.txt` remain open |
| Open blocker before production | UAT-043: Google AdMob cannot validate `app-ads.txt` for the iOS app (Android confirmed working) |

The UAT Feedback and Ideas Log remains the intake point for new UAT bugs, feature requests, release feedback, and monetization/store tasks. This document tracks production-readiness gates and sequencing.

## 1a. Build 37 Changes and Resolved Items (2026-07-01)

**Confirmed resolved since the last refresh of this plan (earlier today):**
- Build `1.0.0 (36)` is live in TestFlight and Play Console closed testing under the Orbace Technologies LLC corporate account on both platforms — this resolves the Gate 1 "uncommitted drift/unknown build provenance" concern raised earlier today, and resolves the Android Play Console transfer risk called out in the Developer Ownership Migration Checklist (no transfer needed — it was uploaded directly under the corporate account).
- UAT-034 through UAT-039 (UMP consent flow, iOS App Store processing, Android icon, UMP error messaging on both platforms) are **Validated** against build 36 UAT feedback. See UAT log for per-item detail. Two contrast-related sub-items (old-iPad text contrast in UAT-037/UAT-039) were not explicitly reconfirmed and should be checked again in the next UAT round if still relevant.
- The Android application-ID rename to `com.orbace.orbaceSudoku` is confirmed intentional and already reflected in the build 36 upload — not an open risk.

**New in build 37 (this pass):**
- UAT-040: Import Puzzle -> Grid validation hang/ANR-crash on physical Android phone, root-caused and fixed for real (background-isolate validation + bitmask-based solver rewrite, not a time cutoff). Validated live on device `6ff716fb` in debug mode; this is the first time it will reach a signed release build.
- UAT-041: Level Packs `extreme` pack renamed "Extreme Challenge" → "Expert Challenge".
- UAT-042: Scholar's Path Insight stage's 4th requirement ("5 retry improvements") removed; Extreme Challenge unlock now only checks the remaining 3 Insight requirements.
- UAT-044: Removed the "Ad Privacy Status" diagnostic tile from Settings now that UMP messaging is validated fixed (UAT-034–039). The "Privacy Choices" tile remains — it is a real UMP/GDPR compliance entry point, not a diagnostic.
- Version bumped to `1.0.0+37` in `pubspec.yaml`.

**Still open, not resolved in build 37:**
- UAT-043: Google AdMob cannot validate `app-ads.txt` for the iOS app (Android is fine). This is very likely a store-metadata/domain issue, not an app-code issue — see the UAT log entry for the specific things to check (App Store Connect website/marketing URL vs. the domain hosting `app-ads.txt`). No code change addresses this.
- AdMob publisher account corporate ownership is still unconfirmed.
- GitHub repo ownership (`justinzero888` remote) is still unconfirmed as corporate-controlled.
- Old-iPad text-contrast follow-up from UAT-037/UAT-039 not explicitly reconfirmed.

## 2. Product Build Readiness Gates

### Gate 1: Baseline, Documentation, and Release Hygiene

Goal: make sure the team always knows what code, build, and plan are current.

Deliverables:

- Keep current source committed before every release-readiness step.
- Keep UAT Feedback and Ideas Log updated after every build.
- Update stale planning docs so they reflect the actual build state.
- Maintain a visible build table for iOS IPA and Android AAB.
- Keep unrelated local artifacts out of release commits.

Current gaps:

- Game Pack Creation plan was refreshed on 2026-06-26 to reflect the 1,800-puzzle UAT baseline, resolved duplicate warnings, and remaining product gaps.
- A separate level-assignment, validation, and scoring logic reference was created on 2026-06-26.
- Earlier today, Gate 1 had regressed: a large, multi-build set of changes (UAT-034–042, the Android application-ID rename) had never been committed. This pass commits that entire working tree in one pass so build `1.0.0 (37)` is traceable to a single commit, closing the regression.
- Status: **Complete as of this pass** — see the commit referenced in section 1 above. Re-run this exit check before every future release step; it has regressed once already and can regress again if changes are made without committing.

Exit criteria:

- `git status` contains no release-scope uncommitted changes.
- The Android application-ID rename is documented as intentional (done — see `Docs/Orbace Sudoku - Developer Ownership Migration Checklist.md`).
- Production readiness plan, UAT log, and game-pack plan agree on current build/content status.
- Latest build number, commit hash, and IPA/AAB paths are documented.

### Gate 2: Pack Progress and Resume

Goal: make the 1,800-puzzle catalog feel like a real product library, not only a playable list.

Status: **Started on 2026-06-26**.

Important clarification:

- The 1,800 puzzle content audit is already complete for the current UAT baseline: uniqueness, solver compatibility, duplicate-scan cleanup, difficulty distribution, and packaging have been validated.
- Gate 2 is **not** another 1,800-puzzle quality audit.
- Gate 2 is the user-experience and persistence layer that sits on top of the audited catalog: showing progress, best results, and resume paths so the large library feels navigable and owned by the player.

Deliverables:

- Completed count per pack. Complete.
- Best score per puzzle. Implemented for local validation.
- Clean/Official markers per puzzle. Implemented for local validation.
- Continue or Next Unsolved action per pack. Implemented for local validation.
- Save and reload in-progress puzzle state. Implemented for local validation.
- Resume in-progress puzzle from Level Packs. Implemented for local validation.

Current implementation notes:

- Level Packs now load a progress summary from completed attempts and current progress rows.
- Puzzle rows show best score, official, clean, completed, and in-progress status.
- Pack sections expose Continue and Next Unsolved actions.
- Gameplay auto-saves current values, notes, and elapsed time; completion clears current progress.
- Bundled puzzle seeding now preserves `rankedEligible` in the database row.

Why this matters:

- Product users need clear progress through a large catalog.
- UAT already has completion markers, but product readiness needs resume and best-score behavior.
- The database has current-progress schema, but app workflows do not yet use it.
- Without this gate, players can test all 1,800 puzzles, but the catalog behaves more like a long static list than a polished product library.

Exit criteria:

- Closing and reopening the app preserves an unfinished puzzle.
- Pack cards show meaningful progress.
- Puzzle rows show best score and status.
- Continue/Next Unsolved chooses the expected puzzle.
- Unit, widget, and simulator smoke tests pass.

### Gate 3: Su-Pu Compare / 对谱

Goal: complete the next core Su-Pu learning loop after local ranking.

Status: **Complete for UAT in build `1.0.0 (24)`**.

Deliverables:

- Compare two Su-Pu for the same puzzle. Complete.
- Start with a simple comparison table. Complete:
  - score delta
  - time delta
  - steps delta
  - mistakes/hints delta
  - clean/official markers
- Link Compare from Su-Pu Detail when at least two attempts exist. Complete.
- Keep synchronized side-by-side replay deferred until the table is validated. Still deferred by design.

Why this matters:

- Replay becomes more valuable when players can see how a retry improved.
- It strengthens Orbace's differentiation beyond generic score history.

Exit criteria:

- Only same-puzzle records can be compared.
- Comparison copy is clear on phone and iPad.
- Practice/Retry/Official labels are preserved.
- UAT can validate improvement interpretation.

### Gate 4: Android Parity and Closed-Test Refresh

Goal: bring Android to parity with current iOS UAT before product release planning.

Status: **Build refresh complete for UAT/beta in build `1.0.0 (24)`; Google Play upload/track processing pending.**

Deliverables:

- Build fresh Android AAB from current code after iOS build 21 features. Complete with build `1.0.0 (24)`.
- Validate imported certificate labels and local ranking on Android.
- Validate 1,800-puzzle pack browsing and board scaling on Android phone/tablet.
- Update Android closed-test build number and document upload path. Complete.

Current gap:

- Google Play upload and tester-track availability are still pending after local AAB generation.

Exit criteria:

- Fresh signed AAB exists. Complete: `build/app/outputs/bundle/release/app-release.aab`.
- Android closed-test notes are updated.
- Android UAT smoke covers gameplay, replay, Record Hall, certificate, imported puzzle, and local ranking.

### Gate 5: AdMob, Store Build, Test Track, and Store Upload Integration

Goal: treat monetization and platform upload mechanics as one explicit release gate, because release failures here are easy to miss late.

This gate must be run every time the app moves from UAT candidate to release-candidate build.

### Gate 5A: iOS AdMob, IPA, TestFlight, and App Store Connect

Goal: make sure the iOS binary, AdMob setup, TestFlight processing, and App Store Connect metadata are aligned before external or production release.

Deliverables:

- Confirm AdMob code state:
  - iOS AdMob app ID is present in `Info.plist`.
  - iOS banner ad unit is configured.
  - debug builds use Google test ads.
  - release builds use Orbace production unit only after store metadata/privacy are ready.
  - ads remain absent during active gameplay, replay, Record Hall detail, and certificates.
- Confirm iOS AdMob account/store setup:
  - app is linked to the correct App Store record when available. **Confirmed 2026-07-01**: build 36 live in TestFlight under the corporate App Store Connect account.
  - app-ads.txt is published on the developer website. **Open blocker (UAT-043, 2026-07-01)**: Google AdMob cannot validate `app-ads.txt` for the iOS app specifically, even though Android validates correctly. Check whether the website URL configured in App Store Connect for this app matches the domain hosting `app-ads.txt`.
  - App Store privacy answers include ad SDK behavior.
  - consent requirement is decided for launch countries.
- Confirm IPA build process:
  - build number increments.
  - `flutter build ipa --release --build-name ... --build-number ...` succeeds.
  - generated IPA path is documented.
  - Transporter upload or App Store Connect API upload succeeds.
  - TestFlight processing completes.
  - Export compliance is answered for the new build.
- Confirm TestFlight release notes:
  - include user-visible changes.
  - include UAT focus areas.
  - do not ask testers to click ads.

Recommended commands:

```bash
scripts/run_validation.sh
flutter build ipa --release --build-name 1.0.0 --build-number <next>
open -a Transporter build/ios/ipa/orbace_sudoku.ipa
```

AdMob decision point:

- If privacy/app-ads.txt/consent are not ready, disable production ads or keep the build UAT-only.
- If production ads stay enabled, App Store privacy and Google Play data-safety metadata must be updated before broader external testing.

Exit criteria:

- IPA uploads successfully to App Store Connect.
- TestFlight build is processed and available.
- Home-screen banner behavior is validated.
- Active gameplay remains ad-free.
- App Store privacy, export compliance, ads declaration, and app-ads.txt status are documented.

### Gate 5B: Android AdMob, AAB, Closed Testing, and Google Play

Goal: make sure Android uses the matching release candidate code, builds a signed AAB, and has Play Console / AdMob setup aligned before broader closed testing or production rollout.

Deliverables:

- Confirm Android AdMob readiness:
  - Android AdMob app ID is available.
  - Android banner ad unit ID is available.
  - Android `AndroidManifest.xml` includes the AdMob app ID only after IDs are final.
  - debug builds use Google test ads.
  - release builds use Orbace production unit only after Google Play data safety, ads declaration, and app-ads.txt are ready.
  - ads remain absent during active gameplay, replay, Record Hall detail, and certificates.
- Confirm AAB build process:
  - build number increments separately but stays traceable to the iOS release-candidate commit.
  - `flutter build appbundle --release --build-name ... --build-number ...` succeeds.
  - signed AAB path is documented.
  - signing certificate is verified.
  - upload keystore remains backed up and uncommitted.
- Confirm Google Play test track:
  - AAB uploads successfully. **Confirmed 2026-07-01**: build 36 uploaded to Play Console closed testing under the corporate account.
  - closed/internal test track is updated.
  - tester list / opt-in link is current.
  - release notes include user-visible changes and UAT focus areas.
  - testers are not asked to click ads.
- Confirm Google Play compliance:
  - Data safety includes ad SDK behavior.
  - Ads declaration is accurate.
  - Target audience and content rating are complete.
  - app-ads.txt is published on the developer website. **Confirmed working for Android as of 2026-07-01** (iOS is not — see Gate 5A and UAT-043).

Recommended commands:

```bash
scripts/run_validation.sh
flutter build appbundle --release --build-name 1.0.0 --build-number <next>
"/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/jarsigner" -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab
```

Exit criteria:

- Signed AAB uploads successfully to Google Play.
- Closed/internal test build is available to testers.
- Home-screen banner behavior is validated on Android if Android ads are enabled.
- Active gameplay remains ad-free.
- Google Play data safety, ads declaration, content rating, and app-ads.txt status are documented.

### Gate 6: Store Metadata, Privacy, and Compliance

Goal: remove non-code blockers for production submission.

Deliverables:

- App Store listing:
  - app name
  - subtitle
  - keywords
  - description
  - screenshots
  - app category
  - support URL
  - marketing URL if used
  - privacy policy URL
- App privacy:
  - local gameplay data
  - AdMob SDK behavior
  - no account/login unless added later
  - no cloud sync unless added later
- Export compliance.
- Age rating.
- Google Play:
  - data safety
  - ads declaration
  - target audience
  - closed-test status
  - production access requirements

Exit criteria:

- Store metadata can support a production review submission.
- Privacy answers match the actual binary.
- No release-critical compliance item is marked unknown.

### Gate 7: Local Data Management and Import Polish

Goal: reduce product risk around locally stored Su-Pu, certificate images, and imported puzzles.

Deliverables:

- Add example placeholder/help text under `Import Puzzle -> Paste` in the 81-cell puzzle string field so users can immediately test the feature.
  - Status: complete for UAT in build `1.0.0 (29)`.
- Remove `Import Puzzle -> Photo` from the V1 release path.
  - Build `1.0.0 (29)` tested a guided photo import beta.
  - UAT feedback requested removing it.
  - Camera/OCR import is deferred until a dedicated design spike can address permissions, grid detection, OCR accuracy, correction UX, and validation risk.
- Delete imported puzzle.
- Delete Su-Pu / replay record.
- Delete saved score-card image.
- Confirm deleting a puzzle does not corrupt unrelated attempts.
- Decide whether `Export my data` is launch, post-launch, or support-only.
- Import Puzzle -> Grid validation must not hang or crash the UI on under-constrained input.
  - Status: **Validated on physical Android device (UAT-040)**, uncommitted. Root cause was synchronous, unbounded backtracking on the UI isolate; fixed with background-isolate validation (`compute()`) plus a bitmask-based `SudokuSolver` rewrite (real algorithmic speedup, not a time cutoff). Added `test/import_puzzle_paste_test.dart` (15 valid puzzles across all 6 difficulty tiers + 5 invalid-input cases) and a solver-level sparse-grid regression test. Still needs re-validation in a signed release build on device, per Gate 8.

Why this matters:

- The app now stores replay histories and generated images.
- Imported puzzles are personal content; users need basic control.
- Import is a high-value differentiator only if ordinary users can bring a puzzle in without knowing the 81-character string format.
- Camera import adds camera/photo permissions, OCR/grid-detection error handling, and correction UX, so it is no longer part of the V1 production release path.

Exit criteria:

- Paste-string import shows a valid example or placeholder without blocking manual input.
- Photo import is removed from the V1 release candidate.
- User can remove personal imported content.
- User can remove local records/cards without reinstalling.
- Deletion is tested against Record Hall, local ranking, and pack progress.

### Gate 8: Release Candidate Validation and Go/No-Go

Goal: produce one clean release candidate with known scope, known risks, and passed validation.

Deliverables:

- Full local validation:
  - formatter
  - puzzle validator
  - analyzer
  - unit/widget tests
- iOS simulator smoke:
  - launch
  - Tea Moment
  - level pack puzzle
  - imported puzzle
  - completion certificate
  - Save/Share Card
  - Record Hall
  - replay
  - Su-Pu Detail
  - local ranking
  - AdMob Home banner
- Android smoke:
  - launch
  - level packs
  - gameplay
  - replay
  - Record Hall
  - imported puzzle
  - local ranking
- UAT signoff review.
- Known issues list.
- Go/no-go decision.

Exit criteria:

- iOS IPA and Android AAB are both built from the same release candidate commit.
- UAT blockers are closed or explicitly deferred.
- Store metadata and compliance are ready for the intended release track.
- A release tag can be created.

## 3. Recommended Sequence From Current Build (refreshed 2026-07-01, second pass)

Gates 2, 3, and 4 are done. Gate 1 hygiene and the Android app-ID/Play-Console questions from earlier today are resolved (build 36 confirmed uploaded under the corporate account on both platforms; UAT-034–039 validated). Remaining sequence:

1. **Commit the current working tree** as one clean baseline (this pass) so build `1.0.0 (37)` — UAT-040/041/042/044 on top of the already-shipped build 36 — is reproducible from git history.
2. **Cut build `1.0.0 (37)`** (iOS IPA + Android AAB from the same commit) for the next beta/TestFlight/closed-testing round.
3. **Re-validate UAT-040 in this signed release build**, not just debug `flutter run` — ANR behavior can differ between debug and release (R8/ProGuard, different startup timing), per the existing note on UAT-022's release-vs-debug lesson.
4. **Investigate UAT-043** (iOS `app-ads.txt` AdMob validation failure) — likely a store-metadata/domain issue; confirm the App Store Connect website/marketing URL matches the domain hosting `app-ads.txt`. This is the one open item blocking full production go/no-go.
5. Re-confirm the old-iPad text-contrast items from UAT-037/UAT-039 in the next UAT round if still relevant.
6. Confirm AdMob publisher-account corporate ownership and GitHub repo corporate custody (still open per the Developer Ownership Migration Checklist).
7. Run full Gate 8 Release Candidate validation and go/no-go once 1–6 are clear.

## 4. V1 Hook for Future Downloadable/Purchasable Packs

Recommendation: add a **lightweight V1 hook** for future packs, but do not build the full V2 download/purchase system in V1.

Rationale:

- The launch catalog has 1,800 puzzles, which is enough for V1 UAT and initial release but small compared with larger Sudoku libraries.
- A visible future-pack entry can set player expectations and collect demand without adding backend, payment, entitlement, download, or support risk before launch.
- Full pack download/purchase from `orbacesudoku.com` belongs to V2 because it requires remote catalog, account or receipt strategy, payment/compliance decisions, content signing/checksums, cache management, and customer support flows.

Recommended V1 scope:

- Add a `More Packs` / `Coming Soon` row in Level Packs.
- Copy should say additional Orbace packs are planned at `orbacesudoku.com`.
- Optional button: `Learn More` opens `https://orbacesudoku.com` only after the website page exists.
- No in-app purchase, no external purchase prompt inside gameplay, no entitlement logic, and no downloadable content in V1.
- Add a remote-pack schema/design document in V1 planning so V2 can start cleanly.

Do not do in V1:

- Do not sell digital puzzle packs through an external web checkout from inside the iOS app without a platform-policy review.
- Do not add a download button until content signing, manifest versioning, offline fallback, and support behavior are designed.
- Do not mix paid/remote packs with ranked eligibility until anti-cheat and content certification rules are defined.

Exit criteria for the V1 hook:

- The hook does not block normal pack browsing.
- The hook does not imply a purchase is currently available unless the website and store policy path are ready.
- App review risk is reviewed before adding any external purchase language.

## 5. Deferred Post-Product-Build Scope

- Worldwide leaderboard backend.
- Game Center / Google Play Games leaderboards.
- Full remote seasonal content catalog.
- Downloadable/purchasable pack entitlement system.
- OCR/photo puzzle import.
- Save score card directly to Photos.
- Cloud sync or account login.
- Analytics/crash SDK, unless release operations require it and privacy docs are updated.
