# Orbace Sudoku Level Alignment Audit

Date: 2026-07-02

## Executive Summary

- Total current puzzle assets audited: 1900.
- Manifest/catalog puzzles: 1800.
- Standalone true extreme puzzles: 100.
- Sudoku integrity failures: 1.
- Teaching-pack exact level alignment: 1800/1800.
- True-extreme alignment: 99/100.

## Pack Summary

| Pack | Expected Band | Count | Stored Difficulty Counts | Re-rated Counts | Score Range | Clue Range | Aligned | Integrity Failures |
| --- | --- | ---: | --- | --- | --- | --- | ---: | ---: |
| Tea Moments (`tea_moments`) | beginner | 180 | beginner: 180 | beginner: 180 | 78-86 | 40-42 | 180/180 | 0 |
| Foundation (`foundation`) | beginner | 360 | beginner: 353, easy: 7 | beginner: 353, easy: 7 | 82-97 | 37-40 | 360/360 | 0 |
| Discipline (`discipline`) | easy | 360 | easy: 346, medium: 14 | easy: 346, medium: 14 | 110-159 | 34-38 | 360/360 | 0 |
| Insight (`insight`) | medium | 360 | medium: 360 | medium: 360 | 145-180 | 29-34 | 360/360 | 0 |
| Mastery (`mastery`) | hard | 270 | hard: 270 | hard: 270 | 196-240 | 25-30 | 270/270 | 0 |
| Expert Challenge (`extreme`) | expert | 270 | expert: 270 | expert: 270 | 246-296 | 22-29 | 270/270 | 0 |
| True Extreme (`true_extreme`) | extreme | 100 | extreme: 100 | beyond_hint_solver: 99, hard: 1 | 903-4338 | 20-24 | 99/100 | 1 |

## Interpretation

- The original 1,800 manifest puzzles remain valid Sudoku content, but their stored difficulty bands are frequently inflated versus the current app rater.
- The new `true_extreme` pack is not in `assets/puzzles/packs.json` yet, but it brings the total current generated game assets to 1,900.
- `true_extreme` aligns with a no-hint extreme standard: stored as Extreme, 20-24 clues, unique solution, and not solvable by the current teaching hint solver.

## Required Product Decisions

1. Decide whether Level Packs should display stored/generated bands or current-rater bands.
2. Add a dedicated no-hint/extreme validator before wiring `true_extreme` into the app manifest.
3. Update generation scripts so stored `difficulty` and `difficultyScore` are never artificially raised above the actual audit result for teaching packs.

## Integrity Failures

- true_extreme: true_extreme_059: true extreme solved by hint solver
