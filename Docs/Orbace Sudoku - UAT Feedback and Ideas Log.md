# Orbace Sudoku - UAT Feedback and Ideas Log

**Version**: 1.0  
**Date Started**: 2026-06-21  
**Purpose**: Track UAT feedback, actions taken, validation status, and new product/monetization/content ideas that were not part of the original PRD or implementation plan.

## Current UAT Build Context

| Build | Platform | Content | Notes |
| --- | --- | --- | --- |
| `1.0.0 (9)` | iOS TestFlight IPA | 100 UAT puzzles | Stronger selected-cell highlight, curated/versioned content `2026.06.001`. |
| `1.0.0 (8)` | Android AAB | 100 UAT puzzles | First Android release bundle for current UAT content. |
| Unbuilt local candidate | Local assets | 1,800 production-candidate puzzles | GP-5/IDEA-003 started with content `2026.06.002`; content is split into 31 batch files; 38 duplicate-scan warnings remain before TestFlight. |

The current distributed UAT builds still have 100 puzzles. The 1,800-puzzle catalog exists locally as a candidate asset set only and should not be treated as production-approved until duplicate-scan warnings are resolved.

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
| UAT-009 | GP-4 UAT | In note-key format, keypad numbers should be italic, but board notes should not be italic because small italic numbers are hard to read. | Medium | Complete | Kept keypad note-mode italic; removed italic from small board note numbers in live board and replay board. | Local validation passed; included in next IPA/AAB build. |
| UAT-010 | GP-4 UAT | Replay should add "Back" actions to replay history for both big game numbers and small note numbers. | High | Complete | Added value-back and note-back replay events when Undo is pressed. Replay history now shows both big-number and note-number back actions. | Local validation passed; included in next IPA/AAB build. |

## New Requirements and Ideas Backlog

| ID | Type | Idea / Requirement | Status | Notes / Next Step |
| --- | --- | --- | --- | --- |
| IDEA-001 | Monetization | AdMob setup | Not started | Define ad policy first: banner vs interstitial vs rewarded hints. Avoid disrupting calm gameplay. Need app IDs, privacy disclosures, consent flow, and store listing impact. |
| IDEA-002 | Content / Education | Create a Sudoku solution guide book | Not started | Could become an in-app guide, downloadable PDF, website lead magnet, or App Store marketing asset. Should align with Orbace teaching tone and named techniques supported by the engine. |
| IDEA-003 | Content | 1,800-puzzle production library | In progress | GP-5 started. Candidate content version `2026.06.002` generated with 1,800 puzzles split into 31 batch files. Validator passes correctness/human-solver gates; 38 shared normalized solution-grid warnings remain for curation before production approval. |
| IDEA-004 | Competitive | Worldwide leaderboard for Extreme Challenge | Planned | Requires backend, anti-cheat rules, ranked attempt integrity, and privacy/account design. |
| IDEA-005 | Content Ops | Remote seasonal/event packs | Future | Requires remote manifest, checksum/signing, offline fallback, and content retirement strategy. |

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
