# Orbace Sudoku V1 — Production Release Checklist

**Version:** 1.0.0 (Build 30)  
**Entity:** Orbace Technologies LLC  
**Date:** 2026-06-29  

---

## Code Changes in This Build (Build 29)

- [x] Import Puzzle screen: cleaned up to Paste + Grid tabs only; removed ranking reference from description
- [x] Official Ranking placeholder card removed from Home screen (V1 scope)
- [x] "Remove Ads" IAP tile removed from Settings (V1 scope)
- [x] Ads confirmed on every non-gameplay screen (Home, Level Packs, Scholar's Path, Extreme Hub, Record Hall, Import Puzzle, Su-Pu Compare, Su-Pu Detail, Replay, Settings)
- [x] Gameplay screen (SudokuGameScreen) remains ad-free
- [x] Privacy Policy updated to production text (Orbace Technologies LLC, AdMob disclosure, contact email)
- [x] Terms of Use updated to production text (IP ownership, personal use, liability)
- [x] Settings header cleaned up (removed "upcoming ad-free options" language)
- [x] Version bumped: 1.0.0+28 → 1.0.0+29

---

## iOS — App Store (IPA)

### Signing
- **Team ID:** 4Q4LMBRDM3
- **Entity:** Orbace Technologies LLC
- **Distribution Certificate:** Apple Distribution: Orbace Technologies LLC (4Q4LMBRDM3)
- **Bundle ID:** com.orbace.orbaceSudoku
- **Signing style:** Automatic (Xcode selects distribution cert at archive time)

### Build Command
```bash
cd /Users/alexzhang/DevProjects/Orbace_Sudoku

# Archive
flutter build ipa --release \
  --build-name=1.0.0 \
  --build-number=30 \
  --export-options-plist=ios/ExportOptions.plist
```

The IPA will be at: `build/ios/ipa/orbace_sudoku.ipa`

### App Store Connect Steps
1. Open Xcode → Instruments → Organizer (or use Transporter app)
2. Upload IPA via Transporter or `xcrun altool`
3. In App Store Connect (appstoreconnect.apple.com):
   - Log in as developer under **Orbace Technologies LLC** team
   - Navigate to Apps → Orbace Sudoku
   - Create new version: 1.0.0
   - Add build 29 from TestFlight
   - Fill in release notes (see section below)
   - Set age rating, pricing (Free), categories (Games → Puzzle)
   - Confirm AdMob/advertising disclosure in app metadata
   - Submit for review

### Altool Upload (alternative to Transporter)
```bash
xcrun altool --upload-app \
  -f build/ios/ipa/orbace_sudoku.ipa \
  -t ios \
  -u <apple_id_email> \
  -p <app_specific_password>
```

---

## Android — Google Play (AAB)

### Signing
- **Keystore:** `android/app/upload-keystore.jks`
- **Key alias:** orbace-sudoku-upload
- **Application ID:** com.orbace.orbaceSudoku
- Signing config is in `android/key.properties` (not committed)

### Build Command
```bash
cd /Users/alexzhang/DevProjects/Orbace_Sudoku

flutter build appbundle --release \
  --build-name=1.0.0 \
  --build-number=30
```

The AAB will be at: `build/app/outputs/bundle/release/app-release.aab`

### Google Play Console — Account Transfer (Individual → Corporate)

The app must be transferred from the individual developer account to the **Orbace Technologies LLC** corporate account before production launch.

**Steps to transfer:**
1. Log in to [Google Play Console](https://play.google.com/console) with the **individual** account
2. Navigate to Setup → Advanced settings → Developer account transfer
3. Enter the email of the **Orbace Technologies LLC** corporate Google Play account as the recipient
4. The recipient accepts the transfer in their console
5. All app data, reviews, ratings, and install history transfer automatically
6. After transfer, upload the AAB and create a new internal/production release from the corporate account

**Note:** Google Play account transfers are permanent and irreversible. Confirm billing and payment profiles are set up on the corporate account before initiating the transfer.

---

## App Store Listing Content

### App Name
Orbace Sudoku

### Subtitle
Calm · Teaching-first · Local Play

### Description
Orbace Sudoku is a calm, teaching-first Sudoku experience designed for focused, mindful play.

**Features:**
- Daily Tea Moment puzzle — one calm puzzle per day
- Level Packs — curated puzzles from Foundation to Mastery difficulty
- Scholar's Path — track awards, replays, and unlock Extreme challenges
- Extreme Challenge Hub — no-assist, no-hint locked challenges for experts
- Import Puzzle — paste or enter any 81-cell Sudoku from external sources
- Record Hall — save and replay your best solves (Su-Pu)
- Lantern hints, move undo, pencil notes — full teaching toolset
- All gameplay is ad-free; banner ads appear on browsing screens only

All data is stored locally. No account required.

### Keywords
sudoku, puzzle, calm, daily puzzle, brain training, logic, teaching

### Support URL
https://orbace.com/support

### Privacy Policy URL
https://orbace.com/privacy

### Age Rating
4+ (no objectionable content)

### Category
Primary: Games → Puzzle  
Secondary: Education

### Pricing
Free (with ads on non-gameplay screens)

---

## Release Notes (What's New — V1.0.0)

```
Orbace Sudoku V1 — official launch.

• Daily Tea Moment: one calm puzzle each day
• Level Packs: Foundation through Mastery difficulty
• Scholar's Path: awards, replays, and Extreme unlocks
• Extreme Challenge Hub: no-assist challenges for experts
• Import Puzzle: paste or enter any Sudoku string
• Record Hall: save and replay your best Su-Pu solves
• Full teaching toolset: lantern hints, undo, pencil notes
• All gameplay is completely ad-free
```

---

## Pre-Submission Checklist

### Both Platforms
- [ ] Run `flutter analyze` — zero issues
- [ ] Run `flutter test` — all passing
- [ ] Run `dart run scripts/validate_puzzle_packs.dart` — zero integrity failures
- [ ] Run `dart run scripts/audit_level_alignment.dart` — production catalog aligns to approved level plan
- [ ] Confirm production content target is 2,000 games: Tea Moments 200, Foundation 360, Discipline 360, Insight 360, Mastery 270, Expert Challenge 270, True Extreme 180
- [ ] Confirm Insight, Mastery, and Expert Challenge were generated from 110% candidate pools and ship only 100% aligned puzzles
- [ ] Confirm True Extreme uses the no-hint/no-assist validation path before it appears in app navigation
- [ ] Confirm final production game-level audit and catalog sync: generated assets, `packs.json`, `pubspec.yaml`, Daily Expert Challenge source, Level Packs counts, and app UI all point to the same approved catalog
- [ ] Confirm visible app naming uses Orbace Sudocoo while bundle IDs/package IDs remain unchanged
- [ ] Confirm Home shows `一局一茶 · One Puzzle, One Tea`
- [ ] Confirm Privacy Policy and Terms of Use dialogs scroll to the full text on iPhone and iPad
- [ ] Confirm Score Card image includes the unsolved givens grid below the score and status tags fit at smaller font size
- [ ] Smoke test on physical iOS device (Release mode)
- [ ] Smoke test on physical Android device (Release mode)
- [ ] Verify AdMob production unit IDs load real ads (not test ads) in release build
- [ ] Verify gameplay screen has NO ads
- [ ] Verify all tabs: Home, Level Packs, Scholar's Path, Extreme Hub, Record Hall, Import, Su-Pu screens show banner ads
- [ ] Verify Official Ranking card is absent from Home screen
- [ ] Verify Remove Ads option is absent from Settings
- [ ] Verify Privacy Policy and Terms of Use open correctly in Settings

### iOS Specific
- [ ] Archive builds successfully with "Apple Distribution: Orbace Technologies LLC (4Q4LMBRDM3)"
- [ ] IPA exported via ExportOptions.plist (method: app-store)
- [ ] App Store Connect — app listing created under Orbace Technologies LLC team
- [ ] App icons set at all required sizes (1024x1024 for App Store)
- [ ] Screenshots prepared for iPhone 6.7", 6.5", and iPad 12.9"
- [ ] Privacy manifest (PrivacyInfo.xcprivacy) confirmed if required by Apple

### Android Specific
- [ ] AAB signed with upload keystore (orbace-sudoku-upload)
- [ ] Play Console account transfer initiated from individual → Orbace Technologies LLC
- [ ] Transfer confirmed and accepted by corporate account
- [ ] Internal test track release created in corporate account
- [ ] Production release created after internal track validation
- [ ] App content rating questionnaire completed in Play Console
- [ ] Privacy policy URL added to Play Console listing

---

## AdMob Production Unit IDs

| Platform | Unit ID |
|----------|---------|
| iOS      | ca-app-pub-7497527413129091/7584766530 |
| Android  | ca-app-pub-7497527413129091/8812517487 |
| Test (debug) | ca-app-pub-3940256099942544/2435281174 |

AdMob switches automatically: test ID in debug builds, production IDs in release builds.

---

## Contacts

- **Developer / Signer:** Orbace Technologies LLC (Team ID: 4Q4LMBRDM3)
- **Apple Distribution Cert:** Apple Distribution: Orbace Technologies LLC (4Q4LMBRDM3)
- **Android Upload Key Alias:** orbace-sudoku-upload
- **Bundle ID (iOS):** com.orbace.orbaceSudoku
- **Application ID (Android):** com.orbace.orbaceSudoku
