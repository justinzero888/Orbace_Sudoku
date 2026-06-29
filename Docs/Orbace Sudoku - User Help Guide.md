# Orbace Sudoku - User Help Guide

**Version**: 1.0  
**Date**: 2026-06-28  
**Purpose**: Explain the current Orbace Sudoku game features for UAT, beta testing, app support, and release preparation.

## 1. Launch

When Orbace Sudoku opens, the Home screen is the starting point for all major game paths.

From Home, players can:

- Start the daily Tea Moment.
- Open Level Packs.
- Import a personal puzzle.
- Visit Record Hall.
- See progress-oriented areas such as Scholar's Path or Extreme Challenge when available.
- View the Home-screen AdMob banner, if ads are enabled for the current build/platform.

The Home screen is designed as the quiet hub. Active Sudoku play remains ad-free.

## 2. Tea Moment

Tea Moment is the daily calm-play puzzle.

How to use:

1. Open the app.
2. Tap **Tea Moment**.
3. Play the assigned daily puzzle.

Key behavior:

- The Tea Moment puzzle is selected by day.
- The board supports normal number entry, notes, erase, undo, redo, hint, pause, timer, and mistake checking.
- Progress is saved locally while playing.
- Finishing the puzzle creates a completed Su-Pu record.

Use Tea Moment for quick daily practice, warm-up play, and repeat habit building.

## 3. Level Pack Puzzle

Level Packs contain the bundled Orbace puzzle library.

How to use:

1. From Home, tap **Level Packs**.
2. Select a difficulty or pack.
3. Choose a puzzle.
4. Play the puzzle from the board screen.

Key behavior:

- Bundled puzzles are organized by difficulty.
- Completed puzzles show a completed marker in the pack list.
- Pack progress is tracked locally.
- Built-in pack puzzles can be eligible for local ranking when the solve follows the ranking rules.

Level Packs are the main path for structured progression through the Orbace Sudoku catalog.

## 4. Imported Puzzle

Imported Puzzle lets a player bring in a personal Sudoku from another source.

How to use:

1. From Home or Level Packs, tap **Import Puzzle**.
2. Enter a puzzle name, if desired.
3. Choose one import method:
   - Paste an 81-character puzzle string.
   - Manually fill the starting grid.
4. Preview and validate the puzzle.
5. Tap **Save & Play**.

Import rules:

- The puzzle must be a valid 9x9 Sudoku.
- The puzzle must have exactly one solution.
- Empty cells can be entered as blanks, zeroes, dots, or through the manual grid.

Example test string:

```text
530070000600195000098000060800060003400803001700020006060000280000419005000080079
```

This is 81 characters long. Zeroes represent empty cells.

Ranking note:

- Imported puzzles are personal and local-only.
- They can be played, replayed, rated, saved, and shared.
- They are not eligible for official/worldwide ranking unless Orbace later reviews and certifies them.

## 5. Completion Certificate

When a player completes a puzzle, Orbace creates a Su-Pu completion certificate.

The certificate shows:

- Puzzle name and difficulty.
- Final score.
- Score class.
- Completion time.
- Steps, mistakes, hints, and accuracy.
- Clean or assisted status.
- Player difficulty rating.
- Ranking notes, if entered.
- A score calculation explanation.
- Su-Pu ID and scoring version.

Key behavior:

- The completion certificate appears immediately after finishing a puzzle.
- The completed solve is saved locally as a Su-Pu record.
- The player can add a personal difficulty rating and notes before or after saving.

Use the certificate as the formal solve summary.

## 6. Save/Share Card

Save/Share Card turns the completion certificate into a shareable image.

How to use after completion:

1. Complete a puzzle.
2. On the completion certificate, tap **Save Card** to save the score-card image locally.
3. Tap **Share Card** to open the platform share sheet.

How to use later:

1. Open **Record Hall**.
2. Select a saved Su-Pu.
3. Open the saved score card.
4. Share it again if needed.

Key behavior:

- Saved cards are stored locally on the device.
- Cards are designed with Orbace visual cues and include score details.
- Sharing uses the device's native share interface.

## 7. Record Hall

Record Hall is the local library of completed Su-Pu records.

How to use:

1. From Home, tap **Record Hall**.
2. Browse completed solves.
3. Use available filters or favorite markers.
4. Open a record to replay, view details, view/share saved card, or edit notes.

Record Hall supports:

- Saved completed attempts.
- Replay access after app restart.
- Favorite marking.
- Delete action for unwanted records.
- Score-card viewing and sharing.
- Ranking notes.
- Opening Su-Pu Detail for same-puzzle history.

Delete note:

- Deleting a Su-Pu removes that completed attempt from Record Hall.
- It also removes that attempt's replay, score, notes, and local ranking entry.
- Deleting one attempt does not delete the puzzle itself or other attempts for the same puzzle.

Record Hall is the player's personal archive.

## 8. Replay

Replay lets the player review a completed solve step by step.

How to use:

1. Open Replay from the completion certificate, Record Hall, or Su-Pu Detail.
2. Use the replay controls to move through the solve history.
3. Review number entries, note changes, and back/undo actions.

Replay records:

- Big-number placements.
- Note entries and removals.
- Back actions for numbers.
- Back actions for notes.

Replay is useful for learning, reviewing mistakes, and comparing how a puzzle was solved over time.

## 9. Su-Pu Detail

Su-Pu Detail shows the full history for one puzzle.

How to use:

1. Open **Record Hall**.
2. Select a completed record.
3. Open **Su-Pu Detail**.

Su-Pu Detail shows:

- Latest Su-Pu.
- Best official result.
- Best overall result.
- Version history for repeated solves.
- Score deltas between attempts.
- Saved card access.
- Replay access.
- Retry action.
- Ranking notes.
- Local ranking table for the puzzle.
- Compare Su-Pu / 对谱 when at least two completed records exist.

Use Su-Pu Detail to study improvement on the same puzzle.

## 10. Local Ranking

Local ranking compares completed records for the same built-in puzzle on the same device.

Local Ranking answers: **"Which of my eligible solves for this puzzle ranks best?"**

Ranking is based on:

- Score.
- Time.
- Mistakes.
- Hints.
- Clean/official status.
- Eligibility rules.

Official/ranked eligibility generally requires:

- Built-in Orbace puzzle.
- Completed solve.
- No hints.
- No auto-check assist.
- No retry condition that disqualifies the attempt.

Eligibility example:

Assume the player completes **Foundation Puzzle 012** several times.

| Solve | What happened | Score | Local Ranking status | Why |
| --- | --- | ---: | --- | --- |
| Attempt 1 | First completion, no hints, no auto-check, no retry | 7,800 | Ranked | This is an eligible official solve. |
| Attempt 2 | Retry of the same puzzle, no hints, better score | 8,450 | Not ranked | Retry solves are personal improvement records, not official ranking records. |
| Attempt 3 | First completion path, but used one hint | 7,200 | Not ranked | Hint use makes the solve assisted/practice. |
| Imported puzzle | Puzzle pasted from another source | 9,100 | Not ranked | Imported puzzles are personal until Orbace certifies them. |

In this example, Local Ranking shows **Attempt 1** as the ranked record even though Attempt 2 has a higher score. Attempt 2 still matters for personal study, Compare Su-Pu / 对谱, replay, and Scholar's Path retry-improvement progress, but it is not treated as an official ranked solve.

Important notes:

- Imported puzzles are excluded from ranking.
- Assisted solves can still be saved, replayed, rated, and shared, but may be marked personal or not ranked.
- Local ranking is device-local in the current version.
- Worldwide ranking is planned separately and will require backend identity, anti-cheat, and official challenge rules.

Local Ranking vs. Compare Su-Pu:

- **Local Ranking** is leaderboard-style. It automatically orders eligible completed records for the same built-in puzzle.
- **Compare Su-Pu / 对谱** is study-style. The player manually chooses two completed records for the same puzzle and reviews the differences.
- Local Ranking focuses on rank position and official eligibility.
- Compare focuses on learning what changed between two solves, including score, time, steps, mistakes, hints, accuracy, score class, and clean status.

## 11. Compare Su-Pu / 对谱

Compare Su-Pu helps a player compare two completed records for the same puzzle.

Compare answers: **"How did this solve differ from that solve?"**

How to use:

1. Complete the same puzzle at least twice.
2. Open **Record Hall**.
3. Open **Su-Pu Detail** for that puzzle.
4. Tap **Compare Su-Pu / 对谱**.
5. Choose two completed records to compare.

The comparison shows:

- Score delta.
- Time delta.
- Step delta.
- Mistake delta.
- Hint delta.
- Accuracy delta.
- Score class.
- Clean status.

Current limitation:

- Compare is table-based in the current build.
- Synchronized side-by-side replay is planned for a later phase after UAT validates the basic comparison experience.

## 12. Scholar's Path Retry Improvement

Scholar's Path includes a requirement currently worded in the app as:

```text
Complete 5 retry solves with a higher score than your previous best for that puzzle
```

How it works:

1. Complete a puzzle once.
2. Retry the same puzzle from a retry action.
3. Finish the retry.
4. The retry counts as an improvement only if its final score is higher than the best completed score previously recorded for that same puzzle.

Important notes:

- Simply replaying a solve does not count. Replay is only review.
- Retrying creates a new completed Su-Pu attempt.
- The retry must improve the score, not just the time.
- The requirement needs 5 improved retry solves.
- These improved retries can be across different puzzles.
- Retry solves are used for personal improvement tracking and are not official/ranked records.

## 13. AdMob Home Banner

The AdMob banner appears on Home and other non-game screens when enabled for the current platform/build.

Current ad rule:

- Ads may appear on Home, Level Packs, Import Puzzle, Record Hall, Replay, Su-Pu Detail, Compare, Scholar's Path, Extreme Challenge, and Settings.
- Ads should not appear during active Sudoku gameplay.

Why this matters:

- The Home banner supports monetization without interrupting puzzle solving.
- The game board, replay, completion certificate, Record Hall, and Su-Pu study flows should remain focused and ad-free unless a future product decision changes the policy.

Platform status:

- iOS and Android banner integration is available for UAT.
- Production release still needs store privacy/data-safety, consent, and app-ads.txt review.

## 14. Settings

Settings is available from the Home screen app bar.

Current Settings entries:

- **Privacy**: explains local gameplay data and ad placement.
- **Terms of Use**: explains beta use, imported puzzle limits, and future competition rules.
- **Remove Ads IPA**: placeholder for a future paid/ad-free release option.

## 15. Official Ranking Preview

Official Ranking appears on Home as a preview for the upcoming V2 competitive layer.

Current behavior:

- Shows a coming-soon explanation.
- Does not change V1 local ranking.
- Does not require account registration yet.
- Prepares the app UX for future daily/global ranking games with account-based official events and server validation.

## 16. Common UAT Checklist

For each new UAT build, testers should confirm:

- App launches successfully.
- Tea Moment opens and plays.
- Level Packs open and show completion markers.
- Imported Puzzle validates and saves a personal puzzle.
- Imported Puzzle paste tab includes an example string.
- Completion certificate appears after finishing.
- Save Card creates a saved score-card image.
- Share Card opens the native share flow.
- Record Hall lists completed Su-Pu.
- Record Hall search can find records by puzzle, notes, class, score, or date.
- Record Hall can delete an unwanted Su-Pu after confirmation.
- Replay works after app restart.
- Su-Pu Detail opens for a completed puzzle.
- Local ranking appears for eligible built-in puzzle attempts.
- Compare Su-Pu / 对谱 appears after two completions of the same puzzle.
- Home banner appears only where expected and does not interrupt gameplay.
- Settings opens Privacy, Terms of Use, and Remove Ads IPA notes.
- Official Ranking preview opens without changing V1 local play.
