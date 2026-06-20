# Orbace Sudoku

Flutter implementation of Orbace Sudoku, a calm, teaching-first Sudoku game for iOS and Android.

## Phase 0 Status

Established:

- Flutter iOS/Android project scaffold.
- `com.orbace.orbace_sudoku` package/bundle namespace from `flutter create`.
- Initial Orbace app shell.
- Ink Wash inspired theme tokens.
- Placeholder Home screen for Tea Moment, Level Packs, and Scholar's Path.
- Planned Sudoku feature module folders.
- Validation script.

## Phase 1 Status

Established:

- Sudoku board, puzzle, move, difficulty, technique, and solving-step domain models.
- Partial board validator and candidate calculator.
- Backtracking solver with unique-solution counting.
- Human-ranked solver pipeline with stored solving steps.
- MVP techniques:
  - Naked Single
  - Hidden Single
  - Naked Pair
  - Hidden Pair
  - Pointing Pair
- Difficulty rater scaffold.
- Puzzle generator scaffold with unique-solution and human-solve quality gate.
- Engine unit tests for validation, solving, techniques, human solving, and generation.

## Phase 2 Status

Established:

- Playable Tea Moment puzzle launched from Home.
- 9x9 Sudoku board widget with row, column, box, same-value, hint, and mistake highlights.
- Number pad with notes, undo, redo, and erase controls.
- Game session controller for:
  - selected cell
  - value entry
  - notes mode
  - undo/redo
  - mistake checking
  - timer ticks
  - pause overlay
  - three-tier hint escalation
  - completion detection
- Fixture puzzle and solution for UI development.
- Controller and widget tests for core Phase 2 behavior.

## Phase 3 Status

Established:

- Solve Quality Score model and calculator.
- Attempt model with score, hint-tier counts, clean-solve flag, ranked eligibility, and replay-ready move history.
- Drift database schema:
  - puzzles
  - attempts
  - current progress
- Repository mapping for puzzle upsert, attempt save, attempt history, and best attempt lookup.
- Completion flow now saves a scored attempt.
- Completion dialog shows score breakdown.
- Retry action resets the current puzzle.
- Replay screen steps through recorded moves.
- In-memory persistence tests for repository behavior.
- Replay widget smoke test.

## Phase 4 Status

Established:

- Scholar's Path award model, award engine, and progress screen.
- Daily Tea Moment selector with stable day-based puzzle assignment.
- Extreme Challenge domain service with unlock and ranked eligibility rules.
- Locked Extreme hub with Daily Extreme preview and local bests.
- Repository queries for all attempts and ranked attempts.
- Phase 4 unit tests for awards, daily selection, and Extreme eligibility.
- Home navigation smoke test for Scholar's Path and Extreme Challenge.

## Project Docs

- [PRD V3](Docs/Orbace%20Sudoku%20%E2%80%94%20PRD%20V3.md)
- [PRD V3a](Docs/Orbace%20Sudoku%20%E2%80%94%20PRD%20V3a.md)
- [Phased Implementation Plan](Docs/Orbace%20Sudoku%20%E2%80%94%20Phased%20Implementation%20Plan.md)

## Validate

```sh
scripts/run_validation.sh
```

This runs:

- `flutter pub get`
- `dart format --set-exit-if-changed lib test`
- `flutter analyze`
- `flutter test`

## Next Phase

Phase 5 should focus on tutorial depth, accessibility polish, expanded content, and release readiness.
