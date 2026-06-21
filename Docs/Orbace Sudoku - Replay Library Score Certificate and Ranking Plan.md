# Orbace Sudoku - Replay Library, Score Certificate, and Ranking Plan

**Version**: 1.0  
**Date**: 2026-06-21  
**Purpose**: Define the v1 production plan for local replay save/reload, formal Orbace score cards, player difficulty ratings, score fairness, local storage, and future sharing/leaderboard readiness.

## 1. Product Intent

Orbace Sudoku should treat every completed puzzle as a meaningful record:

- **Replay** is the learning record.
- **Score** is the comparable performance record.
- **Score Certificate** is the branded achievement artifact.
- **Player Difficulty Rating** is the player's subjective experience record.
- **Leaderboard publishing** is deferred, but local data must be ready for it.

The v1 production scope is local-first:

- Save and reload replay locally for any completed game.
- Save and reload score certificate data locally.
- Allow user to save/share a generated score card image through the platform share sheet.
- Do not publish replay or score to worldwide leaderboard yet.
- Do not make sharing part of ranking integrity yet.

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
- Preserve ranked integrity by separating official score from practice score.
- Use player difficulty rating as a learning and curation signal, not as official score.

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

### 4.3 Recommended v1 Score Classes

Add an explicit score class:

| Score Class | Eligibility | Display |
| --- | --- | --- |
| `official` | First completion, no reveal hint, no retry, puzzle eligible, scoring version current | Eligible for future ranking |
| `assisted` | Used hints or assist features | Practice score |
| `retry` | Retry attempt | Personal improvement only |
| `legacy` | Old scoring version | Display only; not ranked |

Note: v1 can keep current numeric score while adding classification fields.

### 4.4 Ranked Fairness Rules

For future ranking:

- Compare only same `puzzleId` or same `challengeId`.
- Compare only same `scoringVersion`.
- Accept only `official` attempts.
- Exclude retries.
- Exclude reveal hints.
- Exclude auto-check/mistake reveal.
- Store replay hash to validate that the score was derived from the recorded move sequence.
- Store content version and puzzle checksum to prevent ranking against modified puzzle data.

### 4.5 Best Score Logic

For each puzzle:

- Personal best can include practice attempts if clearly labeled.
- Official best must include only official attempts.
- Future leaderboard should use official best only.

Recommended UI labels:

- `Best Official`
- `Best Practice`
- `Latest Replay`

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

## 7. Replay Library

### 7.1 User Stories

As a player:

- I can view replays from any completed puzzle.
- I can replay a specific attempt.
- I can distinguish best replay, latest replay, and favorite replay.
- I can reload replay after app restart.
- I can keep score cards for meaningful solves.

### 7.2 Entry Points

Recommended v1 entry points:

- Completion card: `View Replay`.
- Home screen: `Replay Library`.
- Scholar's Path: `Replay Library`.
- Level pack puzzle row: replay icon / best score row.

### 7.3 Replay Library List

Sort default:

1. Favorites.
2. Most recent completed.
3. Best official score.

Filters:

- Pack.
- Difficulty.
- Official only.
- Favorites.
- Extreme.

V1 minimal filters:

- All.
- Favorites.
- Extreme.

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
| `replayNotes` | text nullable | Optional private notes, future. |
| `replayHash` | text nullable | Integrity hash of replay inputs. |
| `puzzleChecksum` | text nullable | Integrity hash of givens/solution. |
| `contentVersion` | text nullable | Puzzle content version at attempt time. |
| `scoreCardImagePath` | text nullable | Cached/generated card image path. |
| `scoreCardGeneratedAt` | datetime nullable | Last card render timestamp. |

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

### Phase 1: Data Model and Migration

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

### Phase 2: Score Fairness Classification

Tasks:

- Add `ScoreClass` enum.
- Classify attempt at completion.
- Compute replay hash and puzzle checksum.
- Show score class in completion flow.
- Keep `rankedEligible` strict.

Validation:

- Clean first no-assist solve becomes official when puzzle allows it.
- Hint/reveal/auto-check/retry becomes practice or retry.
- Replay viewing never creates a new attempt.

### Phase 3: Orbace Score Certificate UI

Tasks:

- Replace basic completion dialog with score certificate layout.
- Add player difficulty rating input.
- Add buttons:
  - View Replay.
  - Save Card.
  - Share Card.
  - Next Puzzle / Done.
- Ensure card is readable on iPhone and iPad.

Validation:

- Card fits portrait iPhone and iPad.
- Brand cues are clear.
- No overlap with AdMob banner because completion is in game screen, where ads are absent.

### Phase 4: Replay Library

Tasks:

- Add Replay Library screen.
- Add Home/Scholar Path entry.
- List completed attempts.
- Show replay metadata.
- Allow favorite toggle.
- Open replay by attempt.

Validation:

- Completed attempt appears after app restart.
- Multiple attempts for same puzzle are distinguishable.
- Favorite persists.

### Phase 5: Save and Share Score Card

Tasks:

- Add card render boundary.
- Generate PNG from certificate widget.
- Save PNG to app-local documents path.
- Share PNG with platform share sheet.
- Store generated image path and timestamp.

Validation:

- Shared PNG displays correct score and puzzle metadata.
- Sharing works on iOS.
- No leaderboard publish occurs.
- Testers are not asked to post publicly.

## 10. UAT Test Cases

### Replay

- Complete a puzzle and view replay immediately.
- Close app, reopen, find replay in Replay Library.
- Save multiple attempts for the same puzzle.
- Confirm attempt number, score, and date distinguish them.
- Mark favorite and reload app.

### Score Certificate

- Complete clean solve.
- Complete solve with mistakes.
- Complete solve with hints.
- Confirm score class and score breakdown are understandable.
- Set player difficulty rating `4.6`.
- Reload attempt and confirm rating persists.

### Sharing

- Tap Share Card.
- Confirm native share sheet opens.
- Confirm generated image has Orbace branding.
- Confirm card does not expose private data.

### Ranking Readiness

- Confirm official attempts have replay hash and puzzle checksum.
- Confirm retry is not official.
- Confirm assisted play is not official.
- Confirm score version is stored.

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

1. Schema v2 and score classification.
2. Formal score certificate with player difficulty rating.
3. Replay Library.
4. Save/share score card image.

This order reduces risk because it locks the data model first, then builds UI and sharing on top of stable stored records.
