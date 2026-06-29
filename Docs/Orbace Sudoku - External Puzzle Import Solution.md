# Orbace Sudoku - External Puzzle Import Solution

**Version**: 1.1
**Date**: 2026-06-28
**Status**: V1 implemented for iOS UAT in build `1.0.0 (18)`; Gate 7 paste example and guided photo import beta included in build `1.0.0 (29)`

## 1. User Request

Players want to import Sudoku games from other sources easily.

The goal is convenience, but the implementation must protect product quality:

- Imported puzzles must be valid 9x9 Sudoku.
- Imported puzzles must have exactly one solution.
- Imported puzzles should not pollute official Orbace puzzle packs.
- Imported puzzles should not be eligible for worldwide ranking unless they are normalized, verified, and approved by Orbace.
- Copyright/source responsibility must remain clear: users can import for personal play, but Orbace should not redistribute third-party puzzles without rights.

## 2. Recommended V1 Scope

Implement **Personal Import** first. This is now the Build 18 UAT scope.

V1 imported puzzles should:

- Live in a separate `Imported` pack.
- Work offline.
- Be playable like normal puzzles.
- Save Su-Pu, replay, notes, rating, and score certificate locally.
- Be clearly labeled `Imported`.
- Be excluded from official/worldwide leaderboards.

Current V1 supports two input modes:

1. **Paste 81-character puzzle string**
   - Digits `1-9` for givens.
   - `0`, `.`, or `-` for blanks.
   - Example: `530070000600195000...`

2. **Manual grid entry**
   - User enters givens into a blank 9x9 grid.
   - App validates after entry.

Gate 7 V1 production-readiness additions:

1. **Paste example UX**
   - The `Paste 81-character puzzle string` input should show a valid example string as placeholder or helper text.
   - Recommended example: `530070000600195000098000060800060003400803001700020006060000280000419005000080079`
   - The example should help UAT users test import without reading a separate help document.
   - Status: included in build `1.0.0 (29)` with a `Use Example String` CTA.

2. **Take a Picture of Sudoku**
   - Add a third import method for camera/photo import.
   - User can take a photo or select an image of a Sudoku puzzle.
   - Build `1.0.0 (29)` shows the selected image beside a manual correction grid, then runs the same validation pipeline.
   - Automated grid detection/OCR is not included yet; it remains a follow-on if UAT confirms the guided photo workflow is valuable.
   - Photo-imported puzzles remain personal/imported and not ranked.

Camera import is valuable, but it adds camera/photo permissions, OCR/grid detection, correction UX, and more UAT risk. It should be accepted into V1 only if it can pass validation and review/correction reliably enough for product launch.

## 3. Validation Pipeline

Every imported puzzle must pass:

1. Normalize input to 81 cells.
2. Reject invalid characters.
3. Reject contradictory givens.
4. Count solutions.
5. Accept only exactly one solution.
6. Run human-ranked solver.
7. Assign approximate difficulty and target time.
8. Generate puzzle checksum.
9. Save as personal/imported puzzle.

If validation fails, show a precise message:

- `This puzzle has a conflict in row 4.`
- `This puzzle has more than one solution.`
- `This puzzle has no valid solution.`
- `Please enter exactly 81 cells.`

## 4. Data Model Recommendation

Do not modify the 1,800 production catalog.

Added a separate table in schema version 3:

```text
ImportedPuzzleRows
- id
- title
- sourceLabel nullable
- givensJson
- solutionJson
- difficulty
- difficultyScore
- targetTimeSeconds
- requiredTechniquesJson
- solvePathJson
- puzzleChecksum
- createdAt
- updatedAt
```

Imported puzzle IDs should be namespaced:

```text
imported_YYYYMMDD_HHMMSS_checksum8
```

Attempts can continue to reference `puzzleId`. The repository/catalog layer should resolve imported puzzle IDs from the imported table before falling back to bundled assets.

## 5. UX Flow

Entry point:

- Home → Import Puzzle
- Level Packs → Import action
- Level Packs → Imported pack after at least one imported puzzle exists

Flow:

1. Tap `Import Puzzle`.
2. Choose `Paste String`, `Manual Entry`, or `Take a Picture`.
3. Enter puzzle.
4. Tap `Validate`.
5. App shows:
   - Difficulty estimate.
   - Clue count.
   - Required techniques.
   - `Personal puzzle. Not ranked.`
6. User taps `Save & Play`.

Imported puzzle list:

- Title.
- Created date.
- Difficulty.
- Completion status.
- Replay/Record Hall status after solve.

## 6. Ranking and Score Rules

Imported puzzles can receive local scores and Su-Pu certificates, but:

- Score class can still be `Official` locally if no assists are used.
- Ranked eligibility must be false by default.
- Worldwide leaderboard eligibility must be false.
- Certificates should include `Imported Puzzle` label.

Reason: the same puzzle must be checksum-matched and trusted before global comparison is fair.

## 7. Future Enhancements

Post-V1:

- Import from common web formats.
- QR/deep-link Su-Pu import.
- Community puzzle submission queue.
- Orbace review/approval pipeline for promoted imported puzzles.
- Duplicate detection against existing Orbace catalog.

## 8. Recommendation

Implement import after the current UAT bug-fix batch and before backend leaderboards.

Implemented phases:

1. Paste 81-character string import.
2. Manual grid import.
3. Imported puzzle list and replay integration through the local `Imported` pack.

Next recommended phase:

1. Add edit/delete for imported puzzles.
2. Add duplicate detection against the official catalog.
3. Add paste input example/help text.
4. Add camera/photo import if Gate 7 UAT accepts the additional OCR/correction risk for V1.
