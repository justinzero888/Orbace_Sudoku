# Orbace Sudoku — Phased Implementation Plan

**Version**: 1.0  
**Date**: 2026-06-20  
**Source PRD**: `Orbace Sudoku — PRD V3.md`  
**Platform**: Flutter for iOS and Android  
**Planning Assumption**: Greenfield Flutter app unless an existing app shell is selected before implementation.

---

## 1. Implementation Strategy

Orbace Sudoku should be built engine-first. The human-ranked solver and stored solve paths are the foundation for hints, difficulty quality, replay, scoring, awards, and Extreme integrity.

The build should proceed in three layers:

1. **Correctness layer**: board model, solver, validator, generator, stored solving steps.
2. **Playable layer**: board UI, input, notes, hints, completion, persistence.
3. **Mastery layer**: scoring, replay, awards, Extreme, polish, release readiness.

Do not start with visual polish or leaderboard integration. The product depends on deterministic puzzle quality.

---

## 2. Phase Overview

| Phase | Timeline | Primary Goal | Release Gate |
|---|---:|---|---|
| Phase 0 | Week 0 | Project setup and technical decisions | App runs on iOS/Android skeleton |
| Phase 1 | Weeks 1-4 | Sudoku engine foundation | Solver/generator tests pass |
| Phase 2 | Weeks 5-8 | Playable board MVP | One puzzle playable to completion |
| Phase 3 | Weeks 9-12 | Level packs, scoring, replay | 1,800 puzzles validated and replay works |
| Phase 4 | Weeks 13-16 | Awards, Extreme, Daily | Scholar's Path and local Extreme work |
| Phase 5 | Weeks 17-20 | Tutorial, polish, release readiness | Store-ready MVP candidate |
| Phase 6 | Post-MVP | Native platform competition | Game Center / Play Games live |
| Phase 7 | Future | Worldwide leaderboard | Orbace backend live |

---

## 3. Phase 0: Project Setup

### Goal

Create the technical foundation for a maintainable Flutter app and lock early decisions that affect architecture.

### Deliverables

- Flutter project scaffold.
- App package name and bundle identifiers.
- Initial routing/app shell.
- Theme foundation for Ink Wash default.
- Basic CI or local validation script.
- Test folders and conventions.
- Persistence decision finalized.
- Content generation script location finalized.

### Recommended Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.5.3
  drift: ^2.20.0
  sqlite3_flutter_libs: ^0.5.24
  path_provider: ^2.1.5
  path: ^1.9.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  drift_dev: ^2.20.0
  build_runner: ^2.4.0
```

Exact package versions should be refreshed at implementation time.

### Acceptance Criteria

- App launches on iOS simulator and Android emulator.
- Unit test command runs.
- App has placeholder Home screen.
- Project structure matches planned feature module layout.

### Risks

- Drift setup can slow early work if build runner is not configured cleanly.
- If schedule is tight, use in-memory repositories in Phase 1 and introduce Drift in Phase 3.

---

## 4. Phase 1: Engine Foundation

### Goal

Build a reliable Sudoku engine that can generate, validate, solve, and explain puzzles.

### Deliverables

#### Domain Models

- `SudokuBoard`
- `SudokuCell`
- `SudokuPuzzle`
- `SudokuMove`
- `SudokuAttempt`
- `SudokuDifficulty`
- `StoredSolvingStep`
- `TechniqueDefinition`

#### Engine

- Backtracking solver.
- Unique-solution validator.
- Human-ranked solver.
- Technique registry.
- MVP techniques:
  - Naked Single
  - Hidden Single
  - Naked Pair
  - Hidden Pair
  - Pointing Pair
- Step logger.
- Difficulty rater.
- Basic puzzle generator.
- Quality gate.

#### Tests

- Valid puzzle solves to expected solution.
- Invalid row/column/box puzzles rejected.
- Multi-solution puzzles rejected.
- Each MVP technique detected with fixture puzzle.
- Human-ranked solver produces deterministic step order.
- Quality gate rejects puzzles requiring unsupported techniques.

### Engineering Notes

- Use a backtracking solver for correctness and uniqueness.
- Use the human-ranked solver for explanations and difficulty.
- Store solving steps as compact data, not full prose.
- Explanation text should be generated from templates at runtime.

### Acceptance Criteria

- Generate valid 9x9 puzzles with unique solutions.
- Every accepted puzzle has a full stored human-logic solve path.
- Solver tests are deterministic.
- Generator can produce at least 10 valid puzzles per difficulty in development mode.

### Cut Line

If generation speed is too slow, ship with a smaller internal seed set during development and optimize generation before Phase 3.

---

## 5. Phase 2: Playable Board MVP

### Goal

Create the core playable Sudoku experience before adding broad content or progression.

### Deliverables

#### Screens

- Home screen placeholder.
- Game board screen.
- Completion screen placeholder.

#### Board Interaction

- Tap cell to select.
- Row/column/box highlights.
- Same-number highlight.
- Given vs player-entered styling.
- Number pad input.
- Notes mode.
- Erase.
- Undo/redo.
- Pause/resume.
- Completion detection.

#### Assistance

- Mistake checking setting.
- Timer hidden by default.
- Hint lantern button.
- Tier 1 nudge.
- Tier 2 technique explanation.
- Tier 3 reveal.
- Hint usage tracking.

#### Persistence

- Save in-progress puzzle.
- Restore after app restart.
- Store move history for the current attempt.

### Acceptance Criteria

- A fixture puzzle can be started, played, hinted, completed, and scored.
- Given cells are not editable.
- Notes mode works without corrupting values.
- Undo/redo restores values and notes correctly.
- Hint escalation works within a session.
- Progress survives app restart.

### QA Focus

- Accidental tap behavior.
- Small phone layout.
- Tablet board sizing.
- Highlight readability.
- Hint overlay clarity.

### Cut Line

If Phase 2 runs long, keep Tier 2 explanation as a static template with highlighted cells. Fully animated highlight sequences can move to Phase 5.

---

## 6. Phase 3: Level Packs, Scoring, Replay

### Goal

Turn the playable board into a real product loop with many validated levels, score feedback, and replay.

### Deliverables

#### Content Pipeline

- Bulk puzzle generation script.
- Quality validator.
- Export format for puzzle library.
- Drift tables for puzzles and packs.
- Import script or asset loader.
- 1,800 standard puzzles:
  - Beginner: 200
  - Easy: 300
  - Medium: 500
  - Hard: 500
  - Expert: 300

#### Level UX

- Level pack screen.
- Difficulty tabs.
- Completion seals.
- Pack progress indicators.
- Continue puzzle entry.

#### Scoring

- Solve Quality Score calculator.
- Accuracy multiplier.
- Clean solve bonus.
- Optional timer bonus.
- Efficiency bonus.
- Score breakdown UI.
- Personal best per puzzle.
- Best score/time per difficulty.

#### Replay

- Attempt history per puzzle.
- View replay of completed attempt.
- Playback controls:
  - play/pause
  - step forward/back
  - speed
- Move list.
- Player vs optimal mode toggle.
- Retry puzzle creates new attempt.
- Retry never ranked eligible.

### Acceptance Criteria

- 1,800 puzzles generated and validated.
- 100% of shipped puzzles have unique solutions and solve paths.
- Completion screen shows transparent score breakdown.
- Replay accurately reconstructs a completed attempt.
- Retry creates a separate attempt and preserves prior attempts.
- Personal best updates only when improved.

### QA Focus

- Database load time.
- Replay accuracy across notes, errors, hints, undo/redo.
- Score stability for repeated identical scenarios.
- Difficulty distribution sanity.

### Cut Line

If schedule is tight:

- Ship replay with step-forward/back and 1x playback only.
- Move optimal-path comparison to Phase 5.
- Keep efficiency bonus hidden until replay data is verified.

---

## 7. Phase 4: Awards, Extreme, Daily

### Goal

Build the mastery progression loop and daily habit loop.

### Deliverables

#### Scholar's Path

- Award engine.
- Stage requirement tracking.
- Stage progress bars.
- Seal collection.
- Stage unlock notifications.
- Stages:
  - Foundation
  - Discipline
  - Insight

#### Daily Puzzle

- Tea Moment entry point.
- Deterministic daily puzzle selection.
- Days-present streak.
- Daily completion state.

#### Extreme Challenge

- Locked Extreme Hub.
- Unlock requirement display.
- Stage 3 unlock logic.
- 50 curated local Extreme puzzles.
- No-assist rules enforcement.
- Local Extreme bests board.
- Ranked eligibility flags.

### Acceptance Criteria

- Scholar's Path stages update from real attempts.
- Extreme remains locked until Insight is complete.
- Extreme unlocks reliably after requirements are met.
- Assisted Extreme attempts are marked unranked.
- Local Extreme leaderboard excludes retries and assisted attempts.
- Daily puzzle appears reliably and does not change during the day.

### QA Focus

- Edge cases around partial progress.
- Replay improvement requirements.
- Timezone behavior for daily puzzle.
- Offline behavior.
- Local leaderboard filtering.

### Cut Line

If Phase 4 runs long:

- Keep Extreme as locked preview in MVP and ship local Extreme in the first update.
- Do not cut Scholar's Path entirely; it is central to the PRD.

---

## 8. Phase 5: Tutorial, Polish, Release Readiness

### Goal

Make the app understandable, calm, visually distinctive, accessible, and store-ready.

### Deliverables

#### Onboarding

- Guided first-time tutorial.
- One Beginner puzzle with step-by-step instruction.
- Explanation of notes.
- Explanation of three-tier hints.
- Explanation of score as feedback, not judgment.

#### Visual Polish

- Ink Wash theme finalized.
- Celadon theme unlockable.
- Seal completion animation.
- Solar Terms pack presentation.
- High-contrast theme.
- Dark/low-light validation.

#### Accessibility

- Screen-reader cell labels.
- Screen-reader board navigation.
- Large text support.
- 44pt minimum touch targets.
- Color-independent state indicators.
- Optional haptics off by default.
- Timer off by default.

#### Release

- App icon.
- Launch screen.
- Store screenshots.
- Store listing copy.
- Privacy labels / data disclosure planning.
- iOS and Android release validation.

### Acceptance Criteria

- First-time user can complete tutorial without prior Sudoku knowledge.
- No known board input bugs.
- No active-play ads or interruptions.
- All MVP success metrics are instrumentable.
- App passes smoke tests on:
  - iPhone
  - iPad
  - Android phone
  - Android tablet

### Cut Line

If release pressure is high:

- Ship one polished theme plus high-contrast mode.
- Move Celadon theme to first update.
- Keep ambient sound out of MVP.

---

## 9. Phase 6: Native Platform Competition

### Goal

Add platform-native achievements and leaderboards after MVP proves the core loop.

### Deliverables

- Game Center achievements.
- Game Center leaderboards.
- Google Play Games achievements.
- Google Play Games leaderboards.
- Platform-specific Daily/Weekly Extreme rankings.
- Ranked submission validation on client.

### Acceptance Criteria

- iOS ranked scores submit to Game Center.
- Android ranked scores submit to Google Play Games.
- Assisted attempts are never submitted.
- Retry attempts are never submitted.
- Leaderboard labels match challenge type and cadence.

### Notes

This phase does not create one worldwide leaderboard. iOS and Android rankings remain platform-native unless Phase 7 backend exists.

---

## 10. Phase 7: Worldwide Competition Backend

### Goal

Create true cross-platform worldwide rankings for official Extreme challenges.

### Deliverables

- Orbace player identity.
- Anonymous or signed-in account model.
- Server-issued challenge IDs.
- Ranked score submission endpoint.
- Score-bound validation.
- Impossible-time rejection.
- App version and scoring version validation.
- Weekly worldwide leaderboard.
- Basic moderation / abuse controls.

### Acceptance Criteria

- iOS and Android users appear on one leaderboard.
- Scores include challenge ID, scoring version, assist flags, and platform.
- Invalid or impossible submissions are rejected.
- Offline completions remain local-only.

### Notes

Do not begin this phase until retention and Extreme usage justify backend cost.

---

## 11. Critical Dependencies

| Dependency | Needed By | Why It Matters |
|---|---|---|
| Human-ranked solver | Hints, difficulty, replay, content QA | Foundation of product promise |
| Stored solve paths | Hints, replay, difficulty validation | Enables deterministic teaching |
| Attempt model | Scoring, replay, awards, Extreme | Central event record |
| Scoring calculator | Awards, personal bests, Extreme | Must be stable before beta |
| Puzzle metadata | Level packs, rankings, difficulty | Prevents future migrations |
| Drift schema | Content, attempts, awards | Required before large content import |
| Theme tokens | Board, hints, accessibility | Avoids UI rework |

---

## 12. MVP Definition

MVP is complete when the app includes:

- Playable classic 9x9 Sudoku.
- 1,800 standard validated puzzles.
- Three-tier hint system.
- Local progress persistence.
- Solve Quality Score breakdown.
- Replay viewer and retry flow.
- Scholar's Path stages 1-3.
- Daily Tea Moment puzzle.
- First Solar Terms pack.
- Locked and unlockable local Extreme Challenge.
- 50 curated Extreme puzzles.
- Local Extreme bests board.
- Ink Wash theme.
- Accessibility baseline.
- No active-play ads.

---

## 13. Recommended Ticket Breakdown

### Engine Tickets

- Define board/puzzle/move models.
- Implement row/column/box validation.
- Implement backtracking solver.
- Implement unique-solution counter.
- Implement Naked Single.
- Implement Hidden Single.
- Implement Naked Pair.
- Implement Hidden Pair.
- Implement Pointing Pair.
- Implement human-ranked solver pipeline.
- Implement step logger.
- Implement difficulty rater.
- Implement generator.
- Implement generation quality gate.

### App Tickets

- Create app shell and routing.
- Build theme token system.
- Build board widget.
- Build number pad.
- Build notes mode.
- Build undo/redo.
- Build hint overlay.
- Build completion screen.
- Build level pack screen.
- Build replay screen.
- Build awards screen.
- Build Extreme Hub.
- Build settings screen.

### Data Tickets

- Define Drift schema.
- Create puzzle repository.
- Create progress repository.
- Create attempt repository.
- Create award repository.
- Create challenge repository.
- Build content importer.
- Build content validation report.

### QA Tickets

- Solver fixture suite.
- Technique fixture suite.
- Score fixture suite.
- Replay fixture suite.
- Accessibility audit.
- Device smoke test matrix.
- Level database load test.

---

## 14. Go / No-Go Gates

### Alpha Gate

- Engine tests pass.
- One puzzle playable to completion.
- Hint system works on fixture puzzle.
- Score breakdown appears.

### Beta Gate

- 1,800 puzzles loaded.
- Replay and retry stable.
- Scholar's Path works.
- Daily puzzle works.
- No known data loss bugs.

### Release Candidate Gate

- Accessibility baseline passes.
- Store assets complete.
- iOS and Android smoke tests pass.
- No known board input bugs.
- No active-play interruptions.
- MVP content counts met.

---

## 15. Highest-Risk Items

| Risk | Phase | Mitigation |
|---|---:|---|
| Human-ranked solver takes longer than expected | 1 | Build technique fixtures first; ship five techniques only |
| 1,800 puzzle generation too slow | 3 | Generate offline; parallelize later; allow curated seed imports |
| Replay with undo/notes is complex | 3 | Treat move history as canonical event stream from Phase 2 |
| Scoring feels unfair | 3 | Use transparent breakdown and beta tuning |
| Scholar's Path gates feel too hard | 4 | Tune thresholds with beta data |
| Extreme integrity gets murky | 4 | Local-only MVP; platform/worldwide later |
| Cultural layer feels cosmetic | 5 | Integrate into completion, difficulty, daily, and packs |

---

## 16. Immediate Next Steps

1. Create Flutter project scaffold.
2. Implement board, puzzle, and move models.
3. Build solver fixtures for each MVP technique.
4. Implement backtracking solver and validator.
5. Implement first two human techniques before generator work.
6. Build a tiny fixture app screen only after engine tests are passing.

The first implementation milestone should be a command-line or unit-test verified engine, not a polished UI.
