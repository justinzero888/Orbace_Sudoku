# Orbace Sudoku - External Puzzle Import Solution

**Version**: 1.0
**Date**: 2026-06-24
**Status**: Proposed solution before implementation

## 1. User Request

Players want to import Sudoku games from other sources easily.

The goal is convenience, but the implementation must protect product quality:

- Imported puzzles must be valid 9x9 Sudoku.
- Imported puzzles must have exactly one solution.
- Imported puzzles should not pollute official Orbace puzzle packs.
- Imported puzzles should not be eligible for worldwide ranking unless they are normalized, verified, and approved by Orbace.
- Copyright/source responsibility must remain clear: users can import for personal play, but Orbace should not redistribute third-party puzzles without rights.

## 2. Recommended V1 Scope

Implement **Personal Import** first.

V1 imported puzzles should:

- Live in a separate `Imported` pack.
- Work offline.
- Be playable like normal puzzles.
- Save Su-Pu, replay, notes, rating, and score certificate locally.
- Be clearly labeled `Imported`.
- Be excluded from official/worldwide leaderboards.

V1 should support two input modes:

1. **Paste 81-character puzzle string**
   - Digits `1-9` for givens.
   - `0`, `.`, or `-` for blanks.
   - Example: `530070000600195000...`

2. **Manual grid entry**
   - User enters givens into a blank 9x9 grid.
   - App validates after entry.

OCR/photo import should be deferred. It is attractive, but it adds ML/OCR error handling, camera/photo permissions, and more UAT risk.

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

Add a separate table in a future schema version:

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

- Home → Level Packs → Imported
- Later: Home → Import Puzzle

Flow:

1. Tap `Import Puzzle`.
2. Choose `Paste String` or `Manual Entry`.
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

- Camera/photo OCR import.
- Import from common web formats.
- QR/deep-link Su-Pu import.
- Community puzzle submission queue.
- Orbace review/approval pipeline for promoted imported puzzles.
- Duplicate detection against existing Orbace catalog.

## 8. Recommendation

Implement import after the current UAT bug-fix batch and before backend leaderboards.

Recommended phases:

1. Paste 81-character string import.
2. Manual grid import.
3. Imported puzzle list and replay integration.
4. OCR/photo import only after V1 import is stable.

