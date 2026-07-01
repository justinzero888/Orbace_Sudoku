# Orbace Sudoku - Developer Ownership Migration Checklist

**Purpose:** Identify all gaps and changes required to move Orbace Sudoku from individual developer ownership (Li Zuo) to corporate ownership under **Orbace Technologies LLC**.

**Date:** 2026-06-29  
**Target legal owner:** Orbace Technologies LLC  
**Apple team:** Orbace Technologies LLC - `4Q4LMBRDM3`  
**iOS bundle ID:** `com.orbace.orbaceSudoku`  
**Android application ID:** `com.orbace.orbaceSudoku` (renamed from `com.orbace.orbace_sudoku` — intentional, to align with the iOS bundle ID for this V1 app; `com.orbace.orbace_sudoku` is reserved for a future, feature-different V2 app, see note below)

---

## Executive Summary

The codebase is mostly aligned with Orbace Technologies LLC already:

- iOS signing in `ios/Runner.xcodeproj/project.pbxproj` uses Apple Team ID `4Q4LMBRDM3`.
- iOS export options use Team ID `4Q4LMBRDM3`.
- App Store setup documentation names Orbace Technologies LLC.
- Android release signing documentation expects a signer certificate subject containing `Orbace Technologies LLC`.
- App privacy and terms text have been updated in-app to name Orbace Technologies LLC per the production checklist.

The remaining migration work is primarily **store ownership, legal/account setup, AdMob ownership, and repository/admin ownership**, not a Flutter gameplay code change.

**Update 2026-07-01: the Android transfer risk is resolved.** Build `1.0.0 (36)` (application ID `com.orbace.orbaceSudoku`) was uploaded directly to Google Play Console closed testing, and to App Store Connect TestFlight, under the Orbace Technologies LLC corporate account on both platforms — no individual-account app record exists to transfer for this app ID. UAT feedback since has come from testers on this corporate-account build on both platforms. Remaining work is AdMob publisher-account ownership confirmation and the open iOS `app-ads.txt` validation issue (see `Docs/Orbace Sudoku - UAT Feedback and Ideas Log.md` UAT-043) — Android `app-ads.txt` validation is confirmed working.

---

## Current Repo Evidence

| Area | Current Evidence | Status |
| --- | --- | --- |
| iOS signing team | `DEVELOPMENT_TEAM = 4Q4LMBRDM3` in Runner build settings | Appears corporate-ready |
| iOS bundle ID | `com.orbace.orbaceSudoku` | Stable; should not change |
| iOS export options | `ios/ExportOptions.plist` includes team `4Q4LMBRDM3` | Appears corporate-ready |
| App Store setup doc | `Docs/Orbace Sudoku - App Store Connect Setup Info.md` names Orbace Technologies LLC | Mostly aligned; some old blocker notes may be stale |
| Android application ID | `com.orbace.orbaceSudoku` (renamed 2026-07-01, intentional — see note above) | Confirmed: build 36 uploaded under this ID directly to the corporate Play Console account |
| Android signing | Production checklist references Orbace LLC upload signing | Needs secure ownership confirmation |
| Google Play ownership | Build `1.0.0 (36)` uploaded directly to Play Console closed testing under the Orbace Technologies LLC corporate account | **Resolved 2026-07-01** — no transfer needed for this app ID |
| App Store Connect ownership | Build `1.0.0 (36)` uploaded and processed in TestFlight under the Orbace Technologies LLC corporate account | **Resolved 2026-07-01** |
| AdMob | Production unit IDs are integrated/documented; Android `app-ads.txt` validates correctly | iOS `app-ads.txt` validation still failing — open, see UAT-043 in the UAT log |
| GitHub | Remote previously used `git@github.com:justinzero888/Orbace_Sudoku.git` | Need move/confirm corporate ownership |

---

## Apple Developer / App Store Connect

### What Apple Requires

Apple enrollment differs by owner type. Apple states that individual enrollment displays the personal legal name as the seller name, while organization enrollment displays the organization's legal entity name as the seller name. Apple organization enrollment requires legal binding authority, a legal entity, D-U-N-S number, organization-domain email, and a functional organization website.

Apple also states that an app transfer is used when moving an app to another App Store Connect account or organization. A transferred app keeps reviews/ratings and users continue receiving updates. After a build has been uploaded, the bundle ID is maintained and cannot be changed.

### Required Apple Checks

| Check | Required Outcome | Owner |
| --- | --- | --- |
| App Store Connect app owner | App record for Orbace Sudoku is under Orbace Technologies LLC, not Li Zuo individual seller | Release owner |
| Seller name preview | Seller/developer name shown to customers is Orbace Technologies LLC | Release owner |
| Account Holder | Corporate Apple Developer account holder has legal authority for Orbace Technologies LLC | Business owner |
| Agreements | Paid Apps / Free Apps agreements accepted as needed under corporate account | Business owner |
| Banking and tax | Corporate banking/tax completed if paid app, IAP, subscriptions, or paid features are later added | Business owner |
| Bundle ID | `com.orbace.orbaceSudoku` exists in Orbace team Certificates, IDs & Profiles | Release owner |
| Certificates/profiles | Distribution certificate and profiles are generated under `4Q4LMBRDM3` | Developer |
| TestFlight | TestFlight beta state is under the corporate app record | Release owner |

### If the App Record Is Still Under Li Zuo

Use Apple's app transfer process if the app record/build/TestFlight history must be preserved.

Recommended steps:

1. Confirm the app meets Apple's app transfer criteria.
2. Back up all App Store Connect metadata, screenshots, privacy answers, TestFlight notes, and build history.
3. Turn off TestFlight beta testing before transfer if Apple requires it for the current app state.
4. Have the Li Zuo Account Holder initiate the transfer.
5. Have the Orbace Technologies LLC Account Holder accept the transfer.
6. Re-create or verify certificates/profiles under the Orbace team.
7. Upload the next IPA from Xcode/Flutter signed by Team ID `4Q4LMBRDM3`.

### If the App Record Is Already Under Orbace Technologies LLC

No App Store app transfer is needed. Validate:

- App Store Connect > Apps > Orbace Sudoku shows the corporate team and seller.
- Xcode account can archive/export using Orbace Technologies LLC - `4Q4LMBRDM3`.
- Transporter upload lands in the corporate App Store Connect app record.

---

## Google Play Console

### What Google Requires

Google Play offers Personal and Organization developer account types. Google notes that personal accounts have additional testing requirements before distribution. For app transfers, Google requires both original and target account information and calls out specific impacts for Play App Signing, payments profiles, integrated services, AdMob, Firebase, and test groups.

Google explicitly notes that Ad SDK integrations, including AdMob, need to be updated in app binaries after transfer so ad traffic is credited to the correct account. It also notes that open/closed/internal test groups do not transfer and need to be recreated, with users possibly needing to opt in again.

### Required Google Play Checks

| Check | Required Outcome | Owner |
| --- | --- | --- |
| Corporate Play account | Orbace Technologies LLC has an Organization Play Console account | Business owner |
| Developer account verification | Corporate identity verification complete | Business owner |
| Package owner | `com.orbace.orbaceSudoku` (current app ID) is owned by the corporate Play account | Release owner |
| App transfer | If uploaded under Li Zuo, transfer request is completed and accepted | Business owner / release owner |
| Play App Signing | Corporate account owns/manages the Play app signing relationship | Release owner |
| Upload key | Upload keystore is in Orbace secure vault; reset only if ownership/security concern exists | Developer |
| Closed/internal test tracks | Recreated under corporate account after transfer | QA / release owner |
| Store listing | Developer name, support email, website, privacy policy are Orbace-owned | Release owner |
| Data safety / ads | Updated under corporate account and consistent with AdMob implementation | Release owner |

### If the Android App Was Uploaded Under Li Zuo

Use Google Play's transfer flow:

1. Confirm Orbace Technologies LLC has a verified Organization Play Console account.
2. Collect both developer account registration transaction IDs.
3. Confirm target account has any required payments profile if paid app/IAP is planned.
4. Transfer the app to the corporate account.
5. Recreate internal/closed testing tracks and tester groups.
6. Confirm Play App Signing and upload key status.
7. Update integrated services and SDK/account linkages, especially AdMob.
8. Upload the next corporate-signed AAB from the current codebase.

### If the Android App Has Not Yet Been Uploaded

Create it directly under the corporate Play Console account, using the current application ID `com.orbace.orbaceSudoku`. Do not upload from the individual account.

---

## AdMob / Ads Ownership

AdMob is a separate ownership surface from App Store Connect and Play Console.

Current documented IDs:

| Platform | App / Unit | ID |
| --- | --- | --- |
| iOS app ID | Orbace Sudoku | `ca-app-pub-7497527413129091~4050935967` |
| iOS banner | Bottom banner | `ca-app-pub-7497527413129091/7584766530` |
| Android banner | Bottom banner | `ca-app-pub-7497527413129091/8812517487` |

Required checks:

- Confirm the AdMob publisher account `ca-app-pub-7497527413129091` is owned by Orbace Technologies LLC, not Li Zuo personally.
- Confirm AdMob payments/tax setup belongs to Orbace Technologies LLC.
- If the publisher account is personal and cannot be transferred cleanly, create corporate AdMob app/ad units and update the app IDs/ad unit IDs in code before the next production build.
- Confirm `app-ads.txt` is hosted on an Orbace-controlled domain and lists the correct publisher ID.

Release risk: Google Play's transfer guidance specifically says Ad SDK integrations, including AdMob, must be updated after app transfer so ad traffic is credited correctly. Treat this as a production blocker until the account owner is verified.

---

## GitHub / Source Control Ownership

Current known remote from prior setup: `git@github.com:justinzero888/Orbace_Sudoku.git`.

Required checks:

- Confirm whether `justinzero888` is personal or corporate-controlled.
- Recommended: transfer the repo to an Orbace GitHub organization or create `github.com/orbacetech/Orbace_Sudoku`.
- Ensure Orbace Technologies LLC has at least two admin users.
- Protect `main` with branch protection once release stabilizes.
- Store signing secrets outside GitHub unless using encrypted CI secrets.

Release risk: Store ownership can be corporate while source control remains personal, but that is not ideal for IP custody, release continuity, or future contractors.

---

## Domains, Legal, and Support

Required corporate-controlled assets:

| Asset | Required Outcome |
| --- | --- |
| Privacy policy URL | Corporate domain page naming Orbace Technologies LLC |
| Terms URL | Corporate domain page naming Orbace Technologies LLC |
| Support URL/email | Orbace-owned support contact |
| Website | Public, functional website associated with Orbace Technologies LLC |
| App-ads.txt | Hosted on the developer website domain used by AdMob/store listings |
| D-U-N-S | Required for Apple organization identity if not already complete |
| Tax/EIN/banking | Corporate information used for Apple, Google Play, and AdMob payments |

Recommended production URLs:

- `https://orbace.com/privacy`
- `https://orbace.com/terms`
- `https://orbace.com/support`
- `https://orbace.com/app-ads.txt`

If Orbace Sudoku gets its own domain later, update store listings, app-ads.txt, and support links consistently.

---

## Code and Build Changes

No immediate gameplay-code change is required for developer ownership if the store accounts are already corporate.

Potential cleanup changes:

| File / Area | Suggested Change | Priority |
| --- | --- | --- |
| `Docs/Orbace Sudoku - App Store Connect Setup Info.md` | Remove stale note that project may contain previous local team value, after confirming current team ID | Low |
| `ios/Runner.xcodeproj/project.pbxproj` | Optional: set Xcode `ORGANIZATIONNAME` to `Orbace Technologies LLC` if blank | Low |
| Android release docs | Update current build number/version after next release build | Medium |
| AdMob config constants | Change only if corporate AdMob account uses different app/ad unit IDs | High if AdMob owner is personal |
| Store listing metadata | Confirm all public developer, support, privacy, and contact fields are corporate | High |

Do not change further:

- iOS bundle ID `com.orbace.orbaceSudoku`
- Android application ID `com.orbace.orbaceSudoku` (as of 2026-07-01; renamed once already to align with the iOS bundle ID — do not rename again. `com.orbace.orbace_sudoku` is now reserved for a future V2 app with different features, not this app.)
- App name `Orbace Sudoku`

---

## Recommended Migration Sequence

1. **Confirm corporate Apple status.** Verify App Store Connect app record, seller name, agreements, tax/banking, and Team ID `4Q4LMBRDM3`.
2. **Confirm Google Play ownership.** If the package is under Li Zuo, complete the Google Play transfer before production release.
3. **Confirm AdMob ownership.** Decide whether current publisher ID is corporate. If not, create corporate ad units and update the build.
4. **Move source custody.** Transfer GitHub repo to an Orbace-controlled organization or confirm the current account is corporate-owned.
5. **Verify public legal URLs.** Privacy, Terms, Support, app-ads.txt, and developer website should all be Orbace-controlled.
6. **Build clean release artifacts.** Create IPA and AAB from the same commit after ownership blockers are resolved.
7. **Store validation.** Upload IPA/AAB to corporate accounts only; verify public developer/seller names before submission.

---

## Release Blockers

| Blocker | Why It Matters | Resolution |
| --- | --- | --- |
| ~~Google Play app owned by individual account~~ | ~~Production app would show/operate under the wrong developer account~~ | **Resolved 2026-07-01** — build 36 uploaded directly to Play Console closed testing under Orbace Technologies LLC |
| iOS `app-ads.txt` fails AdMob validation | Ad revenue/policy risk specific to the iOS app; Android already validates correctly | Confirm App Store Connect website/marketing URL matches the domain hosting `app-ads.txt`; track as UAT-043 |
| AdMob publisher account ownership not yet confirmed corporate | Revenue, policy responsibility may point to wrong owner | Confirm publisher account `ca-app-pub-7497527413129091` is corporate-owned |
| ~~App Store app record not under Orbace team~~ | ~~App Store seller name may remain Li Zuo~~ | **Resolved 2026-07-01** — build 36 uploaded and processed in TestFlight under Orbace Technologies LLC |
| Corporate legal URLs not live | Store review and user trust risk | Publish/verify URLs before submission |
| GitHub repo personal-only | IP custody and release continuity risk | Transfer repo/admin rights to Orbace |

---

## Validation Checklist

### Apple

- [ ] App Store Connect team shown as Orbace Technologies LLC.
- [ ] Seller name preview is Orbace Technologies LLC.
- [ ] Bundle ID `com.orbace.orbaceSudoku` exists under team `4Q4LMBRDM3`.
- [ ] Archive/export uses `Apple Distribution: Orbace Technologies LLC (4Q4LMBRDM3)`.
- [x] IPA upload appears under the corporate app record. — confirmed: build 36 live in TestFlight under the corporate account (2026-07-01).

### Google Play

- [ ] Play Console account type is Organization for Orbace Technologies LLC.
- [x] Package `com.orbace.orbaceSudoku` is visible under corporate Play Console. — confirmed: build 36 uploaded (2026-07-01).
- [x] Closed/internal testing tracks are recreated under corporate account. — confirmed: build 36 in closed testing under the corporate account (2026-07-01).
- [ ] Play App Signing and upload key status are verified.
- [ ] Store listing developer/contact/legal fields are Orbace-owned.

### AdMob

- [ ] Publisher account is corporate-owned or replaced.
- [ ] iOS and Android ad unit IDs match the correct corporate publisher.
- [ ] `app-ads.txt` is live and verified. — Android confirmed working; iOS still fails AdMob validation (UAT-043), open as of 2026-07-01.
- [ ] Store declarations match ad behavior.

### Source / Operations

- [ ] GitHub repo is owned by Orbace or has Orbace admin custody.
- [ ] Signing assets are stored in Orbace secure vault.
- [ ] At least two corporate admins exist for Apple, Google Play, AdMob, GitHub.
- [ ] Build 1.0.0 release artifacts are generated from a known clean commit.

---

## Official References

- Apple Developer Program enrollment: https://developer.apple.com/programs/enroll/
- Apple App Store Connect app transfer overview: https://developer.apple.com/help/app-store-connect/transfer-an-app/overview-of-app-transfer/
- Google Play Console account setup: https://support.google.com/googleplay/android-developer/answer/6112435
- Google Play app transfer: https://support.google.com/googleplay/android-developer/answer/6230247
