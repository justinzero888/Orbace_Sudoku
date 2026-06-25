# Orbace Sudoku - Su-Pu, Record Hall, Score Certificate, and Ranking Plan

**Version**: 1.1
**Date**: 2026-06-22
**Purpose**: Define the v1 production plan for the Orbace Su-Pu system: local replay save/reload, formal Orbace score certificates, player difficulty ratings, score fairness, local storage, Record Hall collection management, and future sharing/leaderboard readiness.

**Related strategy doc**: `Orbace Sudoku — Qi Pu System & Ranking Plan v2.md`
**Decision**: Adopt the Su-Pu / Record Hall concept as the product north star, but keep v1 UI approachable by pairing cultural terms with plain English labels.

## 1. Product Intent

Orbace Sudoku should treat every completed puzzle as a meaningful **Su-Pu**: a recorded solve that can be replayed, studied, collected, certified, compared, and eventually ranked.

- **Su-Pu / Solve Record** is the core object.
- **Replay** is the study mode for that record.
- **Score** is the comparable performance record.
- **Score Certificate** is the branded shareable artifact.
- **Record Hall** is the player's personal archive.
- **Player Difficulty Rating** is the player's subjective experience record.
- **Leaderboard publishing** is deferred, but local data must be ready for it.

The v1 production scope is local-first:

- Save and reload replay locally for any completed game.
- Save and reload score certificate data locally.
- Let the player find saved solves in a branded Record Hall, not a generic replay list.
- Allow user to save/share a generated score card image through the platform share sheet.
- Do not publish replay or score to worldwide leaderboard yet.
- Do not make sharing part of ranking integrity yet.

### 1.1 Brand and CX Decision

The Qi Pu plan is directionally stronger than the original Replay Library plan because it creates a differentiated product language. The risk is terminology overload. V1 should use a bilingual ladder:

| Concept | V1 Primary UI | Cultural Cue | Notes |
| --- | --- | --- | --- |
| Recorded solve | `Solve Record` | `Su-Pu · 数谱` | Introduce on completion and detail views. |
| Archive | `Record Hall` | `藏谱阁` | Use as screen title/subtitle, not every button. |
| Replay | `Replay` | `复盘` | Use `Replay` in buttons; `复盘` can appear as section flavor. |
| Compare | `Compare` | `对谱` | Post-v1 core feature; do not block local save/share. |
| Share | `Share` | `传谱` | V1 shares certificate image only. |
| Official record | `Official` | `正谱` | Use in badges and certificate. |
| Practice record | `Practice` | `习谱` | Internal enum may remain `assisted`; external label should be `Practice`. |
| Retry record | `Retry` | `重修谱` | Never ranked; used for improvement tracking. |
| Clean record | `Clean` | `净谱` | Strong positive marker for score certificate and collection filters. |

Recommendation: avoid making users learn romanization before they understand value. Use English first, Chinese as a seal-like brand cue.

## 2. Clarifications and Decisions

### 2.1 Score Comparability

Scores for the same unique game are comparable only when all score inputs and eligibility rules are identical.

Orbace should define two score categories:

| Category | Comparable Scope | Use |
| --- | --- | --- |
| **Official Score** | Same puzzle ID, same scoring version, same assist rules | Local ranking, future leaderboard |
| **Practice Score** | Personal progress only | Assisted play, retries, learning |

For player ranking, use **Official Score** only.

### 2.2 Replay Save Behavior

Every completed attempt should be saved automatically.

Do not ask the player to manually save replay. Manual save risks losing the most valuable learning data.

Instead:

- Completed attempts are always persisted.
- User can mark replay as favorite.
- User can delete local replay later if storage management is added.
- Replay sharing/publishing remains future leaderboard/social scope.

### 2.3 Score Card Save/Share Behavior

The score certificate should be generated from stored attempt data. It should not be the system of record.

Recommended behavior:

- Store score card metadata in database.
- Generate the card image on demand.
- Cache the generated image only when user taps **Save Card** or **Share Card**.
- Share through platform share sheet.
- Save to Photos only after explicit user action and permission.

This avoids filling device storage with images for every attempt while still letting players keep or share their best solves.

## 3. Competitive Analysis Implications

Observed market pattern from prior benchmark:

- Mass-market Sudoku apps emphasize volume, ads, streaks, and generic score/time.
- Premium/teaching apps emphasize better hints and board feel.
- Replay is underused as a product feature.
- Most score systems are opaque or too time-dominant.
- Leaderboards often reward speed and guessing, which harms puzzle quality.

Orbace differentiation:

- Make score transparent and accuracy-weighted.
- Make replay a first-class study object.
- Make the completion card feel like a formal record, not a generic modal.
- Turn the replay library into a Record Hall so saved solves feel collected and owned.
- Make the "Clean Record / 净谱" and "Official / 正谱" labels a source of pride.
- Preserve ranked integrity by separating official score from practice score.
- Use player difficulty rating as a learning and curation signal, not as official score.

### 3.1 Critique of the Qi Pu Plan

What to adopt:

- The Su-Pu concept is the strongest differentiation idea so far. It turns ordinary replay, scoring, sharing, and ranking into one coherent system.
- Record Hall is a better experience than `Replay Library`; it gives saved solves emotional value.
- Comparison / 对谱 is a strong post-v1 learning feature because it makes replay active, not passive.
- Certificate content is more complete and more brand-specific than the original score-card plan.
- Per-puzzle ranking rules are correct: compare only the same puzzle/checksum/scoring version and only official-class records.

What to adjust:

- The document title says `Qi Pu`, while the product term inside is `Su-Pu`. V1 should standardize on **Su-Pu / 数谱** for Sudoku solve records.
- The plan introduces too many Chinese terms at once. Use them as cultural cues, not required navigation vocabulary.
- Several proposed fields are useful but not v1 blockers: parent Su-Pu ID, player tags, technique-count storage, share history, local leaderboard UI, and comparison.
- Side-by-side comparison is valuable but complex. It should follow the stable Record Hall and Replay experience, not precede certificate/save/share.
- `Official` eligibility must be stricter than "no T3 hints": any hint, auto-check, mistake reveal, or retry should prevent official ranking eligibility.

Best CX conclusion:

1. Completion should immediately feel rewarding through a formal Su-Pu certificate.
2. Saved records should have a home in Record Hall.
3. Replay should be reliable and consequence-free.
4. Compare, shareable replay files, and leaderboards should build on that foundation.

## 4. Score Fairness Model

### 4.1 Fairness Principles

The scoring logic must be:

| Principle | Requirement |
| --- | --- |
| Deterministic | Same puzzle + same performance inputs = same score. |
| Versioned | Every score stores `scoringVersion`. |
| Puzzle-specific | Rankings compare scores within the same puzzle/challenge, not across unrelated puzzles unless normalized. |
| Accuracy-dominant | Mistakes and hints matter more than raw speed. |
| Assist-aware | Hints, auto-check, mistake reveal, and retries affect eligibility. |
| Tamper-aware | Future leaderboard submission can validate score inputs against replay. |
| Explainable | Score card shows why the player earned the score. |

### 4.2 Current Score Inputs

Current code already uses:

- Difficulty base score.
- Elapsed seconds.
- Target time.
- Error count.
- Hint counts by tier:
  - nudge
  - explanation
  - reveal
- Auto-check flag.
- Clean solve flag.
- Player steps.
- Optimal steps.
- Scoring version.

Current score formula is suitable for v1 local play, but leaderboard readiness needs stricter rule labeling.

Implementation status - 2026-06-25:

- A centralized `AttemptEligibilityEngine` now owns score-class and ranking eligibility decisions.
- The game session controller passes factual inputs into the engine: completion state, retry state, attempt number, hint counts, assist flags, puzzle ranked flag, and scoring version.
- The engine returns deterministic reason codes internally, including `not_completed`, `retry_or_later_attempt`, `hints_used`, `assist_enabled`, `puzzle_not_ranked`, and `scoring_version_mismatch`.
- Current bundled catalog puzzles remain `rankedEligible: false`, so normal UAT solves are protected from accidental ranking until Orbace certifies rankable content.
- Unit coverage confirms a certified, completed, no-assist first attempt becomes `Official` and ranked eligible, while hints, assists, retries, uncertified puzzles, and scoring-version mismatch are blocked.

### 4.3 Recommended v1 Score Classes

Add an explicit score class:

| Score Class | Eligibility | Display |
| --- | --- | --- |
| `official` | First completion, no hints, no auto-check/mistake reveal, no retry, puzzle eligible, scoring version current | `Official · 正谱`; eligible for future ranking |
| `assisted` | Used hints or assist features | `Practice · 习谱`; personal progress only |
| `retry` | Retry attempt | `Retry · 重修谱`; improvement tracking only |
| `legacy` | Old scoring version or pre-v2 migrated attempt | `Legacy · 旧谱`; display only, not ranked |

Note: the current internal enum value `assisted` can remain; the player-facing label should be `Practice`.

### 4.4 Ranked Fairness Rules

For future ranking:

- Compare only same `puzzleId` or same `challengeId`.
- Compare only same `scoringVersion`.
- Accept only `official` attempts.
- Exclude retries.
- Exclude all hints, including nudge, explanation, and reveal.
- Exclude auto-check/mistake reveal.
- Store replay hash to validate that the score was derived from the recorded move sequence.
- Store content version and puzzle checksum to prevent ranking against modified puzzle data.

### 4.5 Best Score Logic

For each puzzle:

- Personal best can include practice attempts if clearly labeled.
- Official best must include only official attempts.
- Future leaderboard should use official best only.

Recommended UI labels:

- `Best Official · 最佳正谱`
- `Best Practice · 最佳习谱`
- `Latest Su-Pu · 最新数谱`
- `Latest Replay` only where the action is specifically replay playback.

## 5. Player Difficulty Rating

### 5.1 Purpose

Player difficulty rating captures subjective experience:

- "This felt like 4.6 to me."
- Especially useful for Extreme puzzles where solver difficulty may not fully match player perception.

It must not affect official score.

### 5.2 Scale

Use a 1.0 to 5.0 scale with 0.1 precision.

| Range | Label |
| --- | --- |
| 1.0-1.9 | Gentle |
| 2.0-2.9 | Steady |
| 3.0-3.9 | Challenging |
| 4.0-4.6 | Hard |
| 4.7-5.0 | Extreme |

### 5.3 Storage

Store rating per attempt:

- `playerDifficultyRating` nullable real.
- `playerDifficultyRatedAt` nullable timestamp.

Later, when backend exists:

- Aggregate by puzzle ID.
- Compute community perceived difficulty.
- Compare solver difficulty vs player-perceived difficulty.

## 6. Score Certificate Design

### 6.1 Brand Direction

The score card should feel like a formal Orbace record with Chinese cultural cues.

Visual language:

- Rice-paper background.
- Vermilion seal accent.
- Strong black ink typography.
- Blue player-score accent used sparingly.
- Red square seal with one Chinese character.
- Thin dividers like a formal certificate.
- No flashy confetti or generic arcade visuals.

Suggested names:

- **Solve Record**
- **Orbace Solve Certificate**
- **一局成績**
- **弈局印記**

Recommended v1 title:

```text
Orbace Solve Record
一局成績
```

### 6.2 Card Content

Required:

- App name: Orbace Sudoku.
- Puzzle title / ID.
- Pack name.
- Official difficulty.
- Score total.
- Score class: Official / Practice / Retry.
- Completion date.
- Time.
- Mistakes.
- Hints used.
- Clean solve marker.
- Accuracy multiplier.
- Player difficulty rating if supplied.
- Small replay marker if replay is saved.

Optional:

- Required techniques.
- Attempt number.
- Content version.
- Scoring version.
- Short quote or seal phrase.

### 6.3 Card Layout

Recommended structure:

1. Header:
   - `Orbace Sudoku`
   - `一局成績`
   - Vermilion seal.

2. Hero score:
   - Large score number.
   - Score class badge.

3. Details grid:
   - Time.
   - Mistakes.
   - Hints.
   - Clean solve.

4. Difficulty strip:
   - Official difficulty.
   - Player rating, e.g. `4.6 / 5`.

5. Footer:
   - Puzzle ID.
   - Date.
   - `Replay saved locally`.

### 6.4 Save and Share

Use platform-native share APIs.

Implementation recommendation:

- Render certificate as a Flutter widget.
- Capture widget as PNG with `RepaintBoundary`.
- Save generated PNG to app documents/cache.
- Share via platform share sheet.
- Save to Photos only through explicit action.

Packages likely needed:

- `share_plus` for platform share sheet.
- `path_provider` already exists.
- Optional later: `image_gallery_saver` or `photo_manager` for saving to Photos.

V1 recommendation:

- Implement **Share Card** with `share_plus`.
- Implement **Save Card** to app-local storage first.
- Add Save to Photos later only if UAT asks for it, because it adds permissions and review surface.

## 7. Record Hall

### 7.1 User Stories

As a player:

- I can view every completed Su-Pu / Solve Record in my Record Hall.
- I can replay a specific Su-Pu.
- I can distinguish Best Official, Best Practice, latest Su-Pu, and favorites.
- I can reload a Su-Pu after app restart.
- I can keep score certificates for meaningful solves.
- I can feel that my solved puzzles are becoming a personal body of work, not just a stats list.

### 7.2 Entry Points

Recommended v1 entry points:

- Completion card: `View Replay`.
- Completion card: `View in Record Hall`.
- Home screen: `Record Hall`.
- Scholar's Path: `Record Hall`.
- Level pack puzzle row: replay icon / best score row.

### 7.3 Record Hall List

Sort default:

1. Favorites.
2. Most recent completed.
3. Best official score.

Filters:

- Pack.
- Difficulty.
- Official only.
- Clean only.
- Favorites.
- Extreme.

V1 minimal filters:

- All.
- Favorites.
- Official.
- Clean.
- Extreme.

### 7.4 V1 Record Hall Scope

The Qi Pu plan's full Record Hall concept is excellent, but v1 should avoid building a complex archive before the completion and replay foundations are polished.

V1 should include:

- Screen title: `Record Hall` with `藏谱阁` as subtitle.
- List of completed Su-Pu / Solve Records.
- Favorite toggle.
- Score class badge: `Official`, `Practice`, `Retry`, `Legacy`.
- Clean marker.
- Player difficulty rating when available.
- `Replay`, `Certificate`, and `Retry` actions.
- Simple grouping by puzzle when multiple attempts exist, if low effort; otherwise show attempts individually and add grouping in the next pass.

Post-v1 should add:

- Puzzle collection view with all versions.
- Best Official vs Best Overall comparison.
- Player notes / 谱评.
- Tags.
- Delete/export controls.
- Side-by-side Compare / 对谱.

## 8. Data Storage Plan

### 8.1 Current Storage

Current `AttemptRows` already stores:

- attempt ID.
- puzzle ID.
- attempt number.
- elapsed seconds.
- error count.
- hint counts.
- assist flags.
- clean solve.
- ranked eligibility.
- score breakdown.
- move history JSON.
- started/completed timestamps.

This is enough to reconstruct replay and score, but not enough for the new v1 production requirements.

### 8.2 Required Schema Upgrade

Move database schema from version 1 to version 2.

Add columns to `AttemptRows`:

| Column | Type | Purpose |
| --- | --- | --- |
| `scoreClass` | text nullable | `official`, `assisted`, `retry`, `legacy`. |
| `playerDifficultyRating` | real nullable | Player 1.0-5.0 rating. |
| `playerDifficultyRatedAt` | datetime nullable | Rating timestamp. |
| `replayFavorite` | bool default false | User-marked important replay. |
| `replayTitle` | text nullable | Optional user label, future. |
| `replayNotes` | text nullable | Player ranking notes / 谱评. |
| `replayHash` | text nullable | Integrity hash of replay inputs. |
| `puzzleChecksum` | text nullable | Integrity hash of givens/solution. |
| `contentVersion` | text nullable | Puzzle content version at attempt time. |
| `scoreCardImagePath` | text nullable | Cached/generated card image path. |
| `scoreCardGeneratedAt` | datetime nullable | Last card render timestamp. |

Naming note:

- Do not rename database columns to Su-Pu terminology in v1. The app can present attempts as Su-Pu while preserving the stable schema already implemented.
- `scoreClass = assisted` should be displayed as `Practice`.
- `replayFavorite` should be displayed as Favorite / 珍藏.
- `replayNotes` is now player ranking notes / 谱评 for the completion certificate and Record Hall.
- Add `parentSuPuId`, tags, technique counts, and share history only when those features are actively implemented.

Add optional table later, not required v1:

```text
SharedArtifacts
```

Purpose:

- Track shared card/replay export events.
- Store export file paths.
- Support delete/cleanup.

Recommended v1: keep share/export event tracking out of schema unless analytics is added.

### 8.3 Storage Size Considerations

Replay move history is compact JSON:

- Typical completed puzzle: hundreds of moves including notes.
- Expected size: small enough for thousands of attempts in SQLite.
- 10,000 attempts should remain manageable if images are not generated for every attempt.

Score card images are the storage risk:

- PNG card can be hundreds of KB to several MB.
- Do not auto-generate images for every attempt.
- Generate only when user saves/shares.
- Provide cleanup later if local artifacts grow.

### 8.4 Data Retention Rules

V1 defaults:

- Keep all completed attempt rows.
- Keep all replay JSON.
- Keep saved score card images only after explicit user action.
- Do not delete user replay data automatically.

Future settings:

- Delete replay.
- Delete saved score card.
- Export my data.
- Clear all local history.

## 9. Implementation Plan

### Phase 1: Su-Pu Data Foundation

Status: **Complete - 2026-06-21**

Tasks:

- Add schema version 2.
- Add attempt metadata fields listed above.
- Add migration from v1 to v2.
- Extend `SudokuAttempt` domain model.
- Extend repository mapping.
- Add methods:
  - `updatePlayerDifficultyRating(attemptId, rating)`.
  - `toggleReplayFavorite(attemptId)`.
  - `updateScoreCardImagePath(attemptId, path)`.
  - `completedAttemptsForReplayLibrary()`.
- Add tests for migration and persistence.

Validation:

- Existing attempts still load.
- New attempts save with score class and replay hash.
- Rating persists and reloads.

Implementation notes:

- Drift schema is now version 2.
- Completed attempts can be queried for Record Hall in favorite-first, newest-first order.
- Attempt rows now support score class, player difficulty rating, replay favorite, replay title/notes, replay hash, puzzle checksum, content version, and generated score-card image path.
- New attempts save puzzle checksum and replay hash for later replay/card integrity work.
- Existing migrated rows map missing `scoreClass` as `Legacy`.
- Local validation passed with formatter clean, 1,800-puzzle validator, analyzer, and test suite.

### Phase 2: Completion Su-Pu Certificate CX

Status: **Complete for iOS UAT - 2026-06-22**

Tasks:

- Replace the basic completion dialog with a branded Su-Pu / Solve Record certificate.
- Show score class as both plain English and cultural cue:
  - `Official · 正谱`
  - `Practice · 习谱`
  - `Retry · 重修谱`
  - `Legacy · 旧谱`
- Show clean marker as `Clean · 净谱` when zero errors and zero hints.
- Add player difficulty rating input with 0.1 precision.
- Persist player difficulty rating immediately.
- Show transparent score breakdown:
  - Base score.
  - Accuracy multiplier.
  - Time bonus.
  - Efficiency bonus.
  - Clean solve bonus.
- Include `Replay saved` / `Saved to Record Hall` status.
- Add actions:
  - `Replay`.
  - `Save Card`.
  - `Share Card`.
  - `View in Record Hall`.
  - `Next Puzzle`.

Validation:

- Card fits portrait iPhone and iPad.
- Brand cues are clear but not visually heavy.
- Score class is understandable without knowing Chinese.
- Player difficulty rating persists and reloads.
- No overlap with AdMob banner because completion is in the game screen, where ads are absent.

Implementation notes:

- Completion now opens a branded Su-Pu / Solve Record certificate dialog.
- Score class is shown as English plus Chinese cultural cue.
- Clean records show `Clean · 净谱`.
- Player difficulty rating uses a 1.0-5.0 slider with 0.1 precision and persists through the repository.
- Ranking notes / 谱评 can be added from the completion certificate and persist through the repository.
- Replay action remains fully functional.
- Share Card and Record Hall buttons communicate the upcoming Phase 3 and Phase 4 scope while confirming the Su-Pu is already saved locally.

### Phase 3: Save and Share Score Certificate

Status: **Complete for iOS UAT - 2026-06-22**

Tasks:

- Add card render boundary.
- Generate PNG from the certificate widget.
- Save PNG to app-local documents path.
- Share PNG with platform share sheet.
- Store generated image path and timestamp.
- Regenerate on demand if cached image is missing.
- Keep Save to Photos deferred unless UAT asks for it.

Validation:

- Shared PNG displays correct score, class, puzzle, and player rating.
- Sharing works on iOS.
- Saved PNG reloads after app restart.
- No leaderboard publish occurs.
- Testers are not asked to post publicly.

Implementation notes:

- Added native share sheet support with `share_plus`.
- `Save Card` renders the Su-Pu certificate widget as a PNG in app-local documents storage.
- `Share Card` renders or reuses the saved PNG and opens the platform share sheet.
- Saved score-card path and generated timestamp are persisted through the existing attempt metadata.
- Save to Photos remains deferred to avoid adding photo-library permission surface before UAT asks for it.
- iOS launch screen no longer references the default Flutter `LaunchImage` placeholder; it uses a storyboard-only Orbace launch treatment.

### Phase 4: Record Hall

Status: **Complete for iOS UAT - 2026-06-22**

Tasks:

- Add Record Hall screen with `藏谱阁` subtitle.
- Add Home/Scholar Path entry.
- List completed Su-Pu / Solve Records.
- Show replay metadata:
  - Puzzle title / ID.
  - Score.
  - Score class.
  - Clean marker.
  - Player difficulty rating.
  - Completion date.
  - Attempt number.
- Allow favorite toggle.
- Open replay by attempt.
- Open certificate by attempt.
- Provide minimal filters: All, Favorites, Official, Clean, Extreme.

Validation:

- Completed attempt appears after app restart.
- Multiple attempts for same puzzle are distinguishable.
- Favorite persists.
- Score class filter works.
- Clean filter works.

Implementation notes:

- Added a Home screen entry for `Record Hall`.
- Added the `Record Hall / 藏谱阁` screen with collection stats, empty state, and filters for All, Favorites, Official, Clean, and Extreme.
- Completed Su-Pu records load from persisted attempt rows after app restart.
- Each record can reopen saved replay with the original puzzle givens and move history.
- Favorite toggle persists and refreshes the list.
- Each record can edit and display local ranking notes / 谱评.
- Saved score-card PNGs can be viewed and shared from Record Hall when a card was previously saved.
- The completion certificate `Record Hall` action now opens Record Hall directly when the puzzle catalog is available.

### Phase 5: Su-Pu Detail and Puzzle Versions

Status: **Complete for iOS UAT - 2026-06-25**

Tasks:

- Add a single Su-Pu detail screen.
- Add puzzle-specific version list for all Su-Pu on the same puzzle.
- Show Best Official and Best Overall.
- Show improvement deltas between attempts.
- Promote player notes / 谱评 from the current completion/Record Hall UI into the detail view.
- Add Retry from detail view.

Validation:

- Versions are grouped correctly by puzzle.
- Retry creates a new retry-class record.
- Retry does not affect official ranking eligibility.
- Notes persist if included.

Implementation notes:

- Record Hall cards now open a Su-Pu detail screen for the selected puzzle.
- The detail screen shows Best Official, Best Overall, Latest Su-Pu, and all completed versions for the same puzzle.
- Each version shows score, time, mistakes, hints, steps, score class, notes, and improvement deltas against the previous attempt.
- Detail actions include Notes, Certificate, Replay, and Retry This Puzzle.
- Retry launched from detail and retry from completion now save the next completed attempt as `Retry · 重修谱`.

### Phase 6: Compare / 对谱

Tasks:

- Compare two Su-Pu for the same puzzle.
- Start with a non-animated comparison table:
  - Score delta.
  - Time delta.
  - Step count delta.
  - Error/hint delta.
  - Clean marker.
- Add side-by-side synchronized replay only after the simple comparison is validated.
- Add divergence detection later when technique labeling is reliable enough.

Validation:

- Only same-puzzle records can be compared.
- Comparison explains improvement clearly.
- Replay comparison remains consequence-free.

### Phase 7: Local Ranking / 名谱榜

Prerequisite status:

- Ranked eligibility hardening is complete for build `1.0.0 (20)`.
- Local ranking can now trust stored `scoreClass` and `rankedEligible` because both are derived from one audited engine path.
- Before enabling ranked lists for bundled packs, certify which puzzle catalog entries should flip `rankedEligible` from false to true.

Tasks:

- Add per-puzzle local ranking.
- Include only `Official · 正谱` records.
- Compare only same puzzle checksum and scoring version.
- Highlight Best Official.
- Keep worldwide leaderboard deferred until backend/account/privacy work exists.

Validation:

- Practice, Retry, and Legacy records are excluded.
- Scoring version mismatch is excluded.
- Puzzle checksum mismatch is excluded.
- Uncertified puzzle content is excluded even when solved cleanly.
- Ranking order is deterministic.

## 10. UAT Test Cases

### Replay / Su-Pu

- Complete a puzzle and view replay immediately.
- Close app, reopen, find the Su-Pu in Record Hall.
- Save multiple attempts for the same puzzle.
- Confirm attempt number, score, and date distinguish them.
- Mark favorite and reload app.

### Completion Certificate

- Complete clean solve.
- Complete solve with mistakes.
- Complete solve with hints.
- Complete solve with auto-check off and no hints; confirm it is `Official · 正谱`.
- Complete solve with any hint or assist; confirm it is `Practice · 习谱`.
- Retry a puzzle; confirm it is `Retry · 重修谱`.
- Confirm score class and score breakdown are understandable without knowing Chinese.
- Set player difficulty rating `4.6`.
- Reload attempt and confirm rating persists.
- Confirm `Saved to Record Hall` is visible after completion.

### Sharing

- Tap Share Card.
- Confirm native share sheet opens.
- Confirm generated image has Orbace branding.
- Confirm card does not expose private data.

### Ranking Readiness

- Confirm official attempts have replay hash and puzzle checksum.
- Confirm retry is not official.
- Confirm practice/assisted play is not official.
- Confirm score version is stored.
- Confirm same score is compared only within same puzzle ID/checksum.

## 11. Open Questions

1. Should **Save Card** mean save inside app only, or save to Photos?
   - Recommendation: app-local first, Photos later.

2. Should player difficulty rating be required?
   - Recommendation: optional.

3. Should score card include QR code/deep link?
   - Recommendation: no for v1; add when backend or app deep links exist.

4. Should every replay be favorite-able?
   - Recommendation: yes.

5. Should standard level-pack puzzles have official local rankings?
   - Recommendation: yes locally, but worldwide ranking should start only with Extreme challenge puzzles.

## 12. Recommendation

Proceed with implementation in this order:

1. Su-Pu data foundation and score classification. Complete.
2. Completion Su-Pu certificate with player difficulty rating.
3. Save/share score certificate image.
4. Record Hall / 藏谱阁.
5. Su-Pu detail and puzzle versions.
6. Compare / 对谱.
7. Local ranking / 名谱榜. Next after build `1.0.0 (20)` UAT smoke.

This order gives the best customer experience because the player first feels the value of creating a formal record at completion, then gains a place to collect records, then receives deeper study and competition features. It also reduces engineering risk because sharing, Record Hall, comparison, and ranking all build on the same stable Su-Pu data foundation.
