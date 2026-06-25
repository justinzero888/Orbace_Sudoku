# Orbace Sudoku - UAT Feedback and Ideas Log

**Version**: 1.0  
**Date Started**: 2026-06-21  
**Purpose**: Track UAT feedback, actions taken, validation status, and new product/monetization/content ideas that were not part of the original PRD or implementation plan.

## Current UAT Build Context

| Build | Platform | Content | Notes |
| --- | --- | --- | --- |
| `1.0.0 (9)` | iOS TestFlight IPA | 100 UAT puzzles | Stronger selected-cell highlight, curated/versioned content `2026.06.001`. |
| `1.0.0 (8)` | Android AAB | 100 UAT puzzles | First Android release bundle for current UAT content. |
| `1.0.0 (11)` | iOS TestFlight IPA | 1,800 production-candidate puzzles | GP-5/IDEA-003 content `2026.06.003`; content is split into 31 batch files; duplicate-scan warnings resolved to 0. |
| `1.0.0 (13)` | iOS TestFlight IPA | 1,800 production-candidate puzzles + iOS Home banner | AdMob iOS app ID and bottom banner integrated; no ads during active gameplay. |
| `1.0.0 (14)` | iOS TestFlight IPA | 1,800 production-candidate puzzles + Su-Pu completion certificate | Phase 2 Completion Su-Pu Certificate CX: branded Solve Record dialog, score class badge, clean marker, transparent score breakdown, and player difficulty rating persistence. |
| `1.0.0 (15)` | iOS TestFlight IPA | 1,800 production-candidate puzzles + save/share score card | Phase 3 Save and Share Score Certificate: score card PNG render, app-local save, native share sheet, stored score-card path, and branded iOS launch screen. |
| `1.0.0 (16)` | iOS TestFlight IPA | 1,800 production-candidate puzzles + Record Hall | Phase 4 Record Hall: browse saved Su-Pu, reload replay after app restart, filters, favorite toggle, and saved card view/share. |
| `1.0.0 (17)` | iOS TestFlight IPA | Build 16 UAT fixes + ranking notes | Share-card iPad popover fix, completed-game markers in Level Packs, higher-contrast certificates, and local ranking notes. |
| `1.0.0 (18)` | iOS TestFlight IPA | External import V1 + certificate persistence fix | Personal import supports paste/grid entry, validation for one solution, local Imported pack, and update-safe score-card image paths. |
| `1.0.0 (19)` | iOS TestFlight IPA | Su-Pu Phase 5 detail and versions | Record Hall cards open same-puzzle Su-Pu detail, Best Official/Best Overall/Latest summary, version deltas, and Retry from detail. |
| `1.0.0 (20)` | iOS TestFlight IPA | Ranked eligibility hardening | Centralized eligibility engine controls score class and ranked eligibility with deterministic blocking reasons before local ranking. |
| `1.0.0 (21)` | iOS TestFlight IPA | Imported certificate labels + local ranking | Imported certificates show personal/not-ranked labels; bundled puzzles are certified for local ranking; Su-Pu Detail shows per-puzzle 名谱榜. |
| `1.0.0 (12)` | Android AAB | 1,800 production-candidate puzzles | Signed with local upload key and ready for Google Play closed testing upload. |

The current iOS UAT candidate is build `1.0.0 (21)`. The current Android closed-test candidate is signed build `1.0.0 (12)`. Both use the locally validated 1,800-puzzle catalog.

Current saved baseline for production-readiness planning:

| Area | Baseline |
| --- | --- |
| Source commit | `fdaf60c` - `Add local ranking and imported certificate labels` |
| Latest iOS IPA | `build/ios/ipa/orbace_sudoku.ipa` from build `1.0.0 (21)` |
| Validation status | Local validation passed for build `1.0.0 (21)` before IPA build |
| Production readiness plan | `Docs/Orbace Sudoku - Production Readiness Plan.md` |

## Feedback Log

| ID | Source/Phase | Feedback | Priority | Status | Action Taken | Validation |
| --- | --- | --- | --- | --- | --- | --- |
| UAT-001 | iPad UAT | On iPad, all items should fit on one page proportionally. Allow portrait only for now. | High | Complete | Adjusted iOS orientation/full-screen behavior for portrait-only UAT. | Built and tested in prior IPA. |
| UAT-002 | Gameplay UAT | Add a bold line around the game board so it feels like a board. | Medium | Complete | Added stronger board border and thicker 3x3 separators. | Included in prior UAT build. |
| UAT-003 | Gameplay UAT | Filled player numbers should contrast more from givens. | Medium | Complete | Player-entered numbers use bright blue. | Included in prior UAT build. |
| UAT-004 | Gameplay UAT | Keypad numbers 1-9 should be larger and centered. | Medium | Complete | Enlarged and centered keypad numbers. | Included in prior UAT build. |
| UAT-005 | Gameplay UAT | When pencil/note mode is pressed, keypad numbers should become italic to differentiate note mode. | Low | Complete | Keypad note mode uses italic styling. | Included in prior UAT build. |
| UAT-006 | Replay UAT | Pencil-state numbers should be saved as part of replay. | High | Complete | Note toggles are included in replay reconstruction. | Included in prior UAT build. |
| UAT-007 | Expert-player UAT | Current six puzzles are too easy; load more and harder puzzles. | High | Complete for UAT | Added 100-puzzle UAT content set; 69 puzzles require pair/pointing techniques. | Validator pass; IPA `1.0.0 (8)` and `1.0.0 (9)`. |
| UAT-008 | Gameplay UAT | Highlighted selected-cell color is too weak. | Medium | Complete | Changed selected cell to stronger amber highlight. | IPA `1.0.0 (9)`. |
| UAT-009 | GP-4 UAT | In note-key format, keypad numbers should be italic, but board notes should not be italic because small italic numbers are hard to read. | Medium | Validated | Kept keypad note-mode italic; removed italic from small board note numbers in live board and replay board. | UAT validated in build `1.0.0 (11)`. |
| UAT-010 | GP-4 UAT | Replay should add "Back" actions to replay history for both big game numbers and small note numbers. | High | Validated | Added value-back and note-back replay events when Undo is pressed. Replay history now shows both big-number and note-number back actions. | UAT validated in build `1.0.0 (11)`. |
| UAT-011 | UAT | Board numbers should be 75% of the cell and scale consistently across phone and iPad instead of using fixed font sizes. | High | Validated | Live board and replay board now calculate filled-number font size as 75% of the rendered cell size; note numbers also scale proportionally. | UAT validated in build `1.0.0 (11)`. |
| UAT-012 | Content QA | Root-cause and resolve the 38 duplicate-scan warnings before the next UAT build. | High | Complete | Root cause: the generator starts from one canonical solved Sudoku pattern and shuffles digit labels plus row/column bands, creating occasional repeated normalized solution patterns at 1,800-puzzle scale. Added a repair script and replaced the 38 later duplicate-pattern puzzles. | Validator passes 1,800 puzzles with 0 duplicate-scan warnings. |
| UAT-013 | Build 16 UAT | Share Card does not work. | High | Complete | Added a platform share-position origin to score-card sharing from both the completion certificate and Record Hall so iPad/macOS-style popover sharing has an anchor. | Pending UAT in build `1.0.0 (17)`. |
| UAT-014 | Build 16 UAT | Add a symbol of "Completed" for games already completed in each level pack. | Medium | Complete | Level Packs now load completed attempt IDs and show a green completed checkmark plus completed count. | Pending UAT in build `1.0.0 (17)`. |
| UAT-015 | Build 16 UAT | Certificate colors are grey and hard to read on iPhone and one iPad. | High | Complete | Increased certificate text contrast, strengthened section surfaces, and made exported certificate copy use ink color instead of muted grey. | Pending UAT in build `1.0.0 (17)`. |
| UAT-016 | Build 16 UAT | User wants to input ranking notes for each game. | Medium | Complete | Added local ranking notes / 谱评 entry on the completion certificate and editing/display from Record Hall. Notes persist in attempt metadata. | Pending UAT in build `1.0.0 (17)`. |
| UAT-017 | Build 16 UAT | User wants to import games from other sources easily. | Medium | Complete for V1 UAT | Implemented Personal Import V1: paste 81-character string, manual grid entry, validation for exactly one solution, local Imported pack, Save & Play, and non-ranked imported puzzle metadata. | Pending UAT in build `1.0.0 (18)`. |
| UAT-018 | Build 17 UAT | Certificate is lost after app update. | High | Complete | Score cards now store relative app-document paths and Record Hall resolves old absolute paths by filename after iOS container path changes. | Pending UAT in build `1.0.0 (18)`. |

## New Requirements and Ideas Backlog

| ID | Type | Idea / Requirement | Status | Notes / Next Step |
| --- | --- | --- | --- | --- |
| IDEA-001 | Monetization | AdMob setup | iOS integrated for UAT | iOS AdMob app ID and bottom banner unit added. Banner placement is Home screen only; no ads during active play. Android AdMob remains pending Android app/ad unit IDs. App privacy, data safety, consent, and app-ads.txt still need store/account work. |
| IDEA-002 | Content / Education | Create a Sudoku solution guide book | Not started | Could become an in-app guide, downloadable PDF, website lead magnet, or App Store marketing asset. Should align with Orbace teaching tone and named techniques supported by the engine. |
| IDEA-003 | Content | 1,800-puzzle production library | Ready for UAT build | Candidate content version `2026.06.003` generated with 1,800 puzzles split into 31 batch files. Validator passes correctness, human-solver, uniqueness, and duplicate-scan gates with 0 warnings. |
| IDEA-004 | Competitive | Worldwide leaderboard for Extreme Challenge | Planned | Requires backend, anti-cheat rules, ranked attempt integrity, and privacy/account design. |
| IDEA-005 | Content Ops | Remote seasonal/event packs | Future | Requires remote manifest, checksum/signing, offline fallback, and content retirement strategy. |
| IDEA-006 | Replay / Scoring | Su-Pu Record Hall, score certificate, player difficulty rating, and ranking-ready storage | Local ranking complete for iOS UAT | Schema v2 migration and attempt metadata are complete. Completion shows a branded Su-Pu Solve Record with persisted player difficulty rating and ranking notes. Save/share score card is complete. Record Hall browses saved Su-Pu, reloads replay after app restart, supports filters/favorites, opens saved score-card images, edits/displays notes, and opens Su-Pu detail with version history, retry, and per-puzzle local 名谱榜. Score class and ranked eligibility come from one deterministic eligibility engine. Next step: compare / 对谱 after build 21 UAT smoke. |
| IDEA-007 | Content Import | Personal puzzle import from other sources | V1 implemented for UAT | See `Orbace Sudoku - External Puzzle Import Solution.md`. V1 supports paste string, manual grid entry, validation for exactly one solution, local Imported pack, Save & Play, and no worldwide ranking eligibility. |
| IDEA-008 | Release Ops | Production readiness plan | Started | Product build readiness is now tracked as a dedicated 8-step plan, with AdMob + IPA/TestFlight/App Store integration as its own major gate. Continue using this UAT log for new requests, UAT bugs, and scope changes. |

## Action Workflow

1. Record feedback with a stable ID.
2. Mark priority and current status.
3. Link action taken to code/doc/build when implemented.
4. Run local validation for every fix.
5. Build IPA/AAB when the fix needs continuous UAT.
6. Update this log after each validation/build checkpoint.

## Build Checkpoint Template

| Build | Platform | Included Feedback IDs | Validation | Notes |
| --- | --- | --- | --- | --- |
| `1.0.0 (10)` | iOS IPA | UAT-009, UAT-010 | Local validation passed | Built for continuous UAT. |
| `1.0.0 (10)` | Android AAB | UAT-009, UAT-010 | Local validation passed | Built for continuous UAT. |
| `1.0.0 (11)` | iOS IPA | UAT-011, UAT-012, IDEA-003 | Local validation passed; 1,800 puzzles; 0 duplicate warnings | Built for next TestFlight/UAT checkpoint. |
| `1.0.0 (11)` | Android AAB | UAT-011, UAT-012, IDEA-003 | Local validation passed; 1,800 puzzles; 0 duplicate warnings | Built for next Android UAT checkpoint. |
| `1.0.0 (12)` | Android AAB | Google Play closed testing setup | Signed AAB built and signature verified | Android label fixed to `Orbace Sudoku`; release signing now uses local upload keystore. |
| `1.0.0 (13)` | iOS IPA | IDEA-001 iOS AdMob banner | Local validation passed; IPA built | Home screen bottom banner integrated with Orbace iOS AdMob unit; game board remains ad-free. |
| `1.0.0 (14)` | iOS IPA | IDEA-006 Phase 2 | Local validation passed; IPA built | Completion Su-Pu Certificate CX added for TestFlight validation. |
| `1.0.0 (15)` | iOS IPA | IDEA-006 Phase 3 | Local validation passed; IPA built | Save/share score certificate image added; launch screen placeholder removed. |
| `1.0.0 (16)` | iOS IPA | IDEA-006 Phase 4 | Local validation passed; IPA built | Record Hall added for replay reload after app restart. |
| `1.0.0 (17)` | iOS IPA | UAT-013, UAT-014, UAT-015, UAT-016, UAT-017 solution | Local validation passed; IPA built | Build 16 UAT fixes plus external import solution documentation. |
| `1.0.0 (18)` | iOS IPA | UAT-017, UAT-018 | Local validation passed; IPA built | External import V1 plus update-safe certificate image path handling. |
| `1.0.0 (19)` | iOS IPA | IDEA-006 Phase 5 | Local validation passed; IPA built | Su-Pu detail/version history with best summaries, deltas, notes, replay/certificate actions, and retry-class retry. |
| `1.0.0 (20)` | iOS IPA | IDEA-006 ranked eligibility hardening | Local validation passed; IPA built | Centralized score-class/ranked eligibility engine added before local ranking. Current catalog remains non-ranked until content certification. |
| `1.0.0 (21)` | iOS IPA | IDEA-006 local ranking + imported labels | Local validation passed; IPA built | Imported certificates are labeled personal/not-ranked; bundled catalog is certified for local ranking; Su-Pu Detail shows local 名谱榜. |
