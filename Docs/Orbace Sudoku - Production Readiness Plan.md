# Orbace Sudoku - Production Readiness Plan

**Version**: 1.0  
**Date**: 2026-06-25  
**Purpose**: Define the remaining work to move Orbace Sudoku from UAT/TestFlight builds to a product-ready iOS and Android release candidate.

## 1. Current Baseline

| Area | Current State |
| --- | --- |
| Current source baseline | `fdaf60c` - `Add local ranking and imported certificate labels` |
| Current iOS UAT build | `1.0.0 (21)` |
| Current iOS IPA | `build/ios/ipa/orbace_sudoku.ipa` |
| Current Android closed-test build | `1.0.0 (12)` |
| Content catalog | 1,800 bundled puzzles, content version `2026.06.003`, 0 duplicate-scan warnings |
| Su-Pu system | Replay, Record Hall, score certificate, save/share card, notes, imported labels, and local ranking complete for iOS UAT |
| Active feedback tracker | `Docs/Orbace Sudoku - UAT Feedback and Ideas Log.md` |

The UAT Feedback and Ideas Log remains the intake point for new UAT bugs, feature requests, release feedback, and monetization/store tasks. This document tracks production-readiness gates and sequencing.

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

- Game Pack Creation plan still has stale sections that reference 100-puzzle UAT and unresolved duplicate warnings.
- Local `Package.resolved` drift and untracked competitive-analysis artifacts are present but not part of the current release baseline.

Exit criteria:

- `git status` contains no release-scope uncommitted changes.
- Production readiness plan, UAT log, and game-pack plan agree on current build/content status.
- Latest build number, commit hash, and IPA/AAB paths are documented.

### Gate 2: Pack Progress and Resume

Goal: make the 1,800-puzzle catalog feel like a real product library, not only a playable list.

Deliverables:

- Completed count per pack.
- Best score per puzzle.
- Clean/Official markers per puzzle.
- Continue or Next Unsolved action per pack.
- Save and reload in-progress puzzle state.
- Resume in-progress puzzle from Level Packs.

Why this matters:

- Product users need clear progress through a large catalog.
- UAT already has completion markers, but product readiness needs resume and best-score behavior.
- The database has current-progress schema, but app workflows do not yet use it.

Exit criteria:

- Closing and reopening the app preserves an unfinished puzzle.
- Pack cards show meaningful progress.
- Puzzle rows show best score and status.
- Continue/Next Unsolved chooses the expected puzzle.
- Unit, widget, and simulator smoke tests pass.

### Gate 3: Su-Pu Compare / 对谱

Goal: complete the next core Su-Pu learning loop after local ranking.

Deliverables:

- Compare two Su-Pu for the same puzzle.
- Start with a simple comparison table:
  - score delta
  - time delta
  - steps delta
  - mistakes/hints delta
  - clean/official markers
- Link Compare from Su-Pu Detail when at least two attempts exist.
- Keep synchronized side-by-side replay deferred until the table is validated.

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

Deliverables:

- Build fresh Android AAB from current code after iOS build 21 features.
- Validate imported certificate labels and local ranking on Android.
- Validate 1,800-puzzle pack browsing and board scaling on Android phone/tablet.
- Update Android closed-test build number and document upload path.

Current gap:

- Android closed-test candidate is still build `1.0.0 (12)`, behind iOS build `1.0.0 (21)`.

Exit criteria:

- Fresh signed AAB exists.
- Android closed-test notes are updated.
- Android UAT smoke covers gameplay, replay, Record Hall, certificate, imported puzzle, and local ranking.

### Gate 5: AdMob, IPA, TestFlight, and App Store Integration

Goal: treat monetization and Apple upload mechanics as one explicit release gate, because release failures here are easy to miss late.

This gate must be run every time the app moves from UAT candidate to release-candidate build.

Deliverables:

- Confirm AdMob code state:
  - iOS AdMob app ID is present in `Info.plist`.
  - iOS banner ad unit is configured.
  - debug builds use Google test ads.
  - release builds use Orbace production unit only after store metadata/privacy are ready.
  - ads remain absent during active gameplay, replay, Record Hall detail, and certificates.
- Confirm AdMob account/store setup:
  - app is linked to the correct App Store record when available.
  - app-ads.txt is published on the developer website.
  - privacy/data-safety answers include ad SDK behavior.
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

- Delete imported puzzle.
- Delete Su-Pu / replay record.
- Delete saved score-card image.
- Confirm deleting a puzzle does not corrupt unrelated attempts.
- Decide whether `Export my data` is launch, post-launch, or support-only.

Why this matters:

- The app now stores replay histories and generated images.
- Imported puzzles are personal content; users need basic control.

Exit criteria:

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

## 3. Recommended Sequence From Current Build

1. Update stale planning docs and keep build baseline committed.
2. Implement Pack Progress and Resume.
3. Build fresh iOS IPA and Android AAB for UAT parity.
4. Run Gate 5 as a dry run: AdMob + IPA + TestFlight process checklist.
5. Implement Compare / 对谱 if UAT does not surface higher-priority blockers.
6. Complete store/privacy/app-ads.txt decisions.
7. Add local data management for imported puzzles and Su-Pu records.
8. Run full Release Candidate validation and go/no-go.

## 4. Deferred Post-Product-Build Scope

- Worldwide leaderboard backend.
- Game Center / Google Play Games leaderboards.
- Remote seasonal content catalog.
- OCR/photo puzzle import.
- Save score card directly to Photos.
- Cloud sync or account login.
- Analytics/crash SDK, unless release operations require it and privacy docs are updated.
