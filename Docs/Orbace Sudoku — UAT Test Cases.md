# Orbace Sudoku — UAT Test Cases

**Version**: 1.0  
**Date**: 2026-06-20  
**Scope**: Manual user acceptance testing for simulator/emulator and later device validation

---

## 1. UAT Strategy

UAT should validate the user-facing promise from the PRD:

> Calm Sudoku play, teaching-oriented hints, replayable improvement, transparent scoring, and a path toward mastery.

Before Phase 4, run the smoke subset: UAT-001 through UAT-012.

For Phase 5 release-candidate validation, run all cases.

---

## 2. Test Environment

| Environment | Required Before Phase 4 | Required Before Release |
|---|---:|---:|
| iOS Simulator phone | Yes | Yes |
| iOS Simulator tablet | Preferred | Yes |
| Android Emulator phone | Yes | Yes |
| Android Emulator tablet | Preferred | Yes |
| Real iPhone | No | Yes |
| Real Android phone | No | Yes |

Record for each run:

- Tester
- Date
- Git commit hash
- Flutter version
- Device/emulator
- OS version
- Pass/fail
- Notes/screenshots for failures

---

## 3. Smoke Test Cases

### UAT-001 — App Launch

**Goal**: Confirm app opens to the Orbace home screen.

Steps:

1. Install and launch the app.
2. Observe the home screen.

Expected:

- App does not crash.
- `Orbace Sudoku` title appears.
- `一局一茶` appears.
- Tea Moment, Level Packs, and Scholar's Path cards appear.

### UAT-002 — Start Tea Moment

**Goal**: Confirm the playable puzzle opens.

Steps:

1. Tap `Tea Moment`.

Expected:

- Tea Moment game screen opens.
- `Beginner Tea Moment` appears.
- Sudoku board appears as a 9x9 grid.
- Number pad appears.

### UAT-003 — Select Cell

**Goal**: Confirm board selection and highlights.

Steps:

1. Tap an empty cell.

Expected:

- Selected cell is highlighted.
- Related row, column, and box are subtly highlighted.
- No layout shift occurs.

### UAT-004 — Enter Value

**Goal**: Confirm number input works.

Steps:

1. Select an empty editable cell.
2. Tap a number.

Expected:

- Number appears in the selected cell.
- Given cells remain visually distinct.
- Undo becomes available.

### UAT-005 — Prevent Editing Givens

**Goal**: Confirm given cells cannot be changed.

Steps:

1. Select a given cell.
2. Tap a different number.

Expected:

- Given cell value does not change.
- No error dialog appears.

### UAT-006 — Notes Mode

**Goal**: Confirm notes can be toggled.

Steps:

1. Select an empty cell.
2. Tap Notes tool.
3. Tap a number.

Expected:

- Number appears as a small candidate note.
- Main cell value remains empty.

### UAT-007 — Undo/Redo

**Goal**: Confirm move history works.

Steps:

1. Enter a number in an editable cell.
2. Tap Undo.
3. Tap Redo.

Expected:

- Undo clears the entered number.
- Redo restores it.

### UAT-008 — Erase

**Goal**: Confirm erase clears player input.

Steps:

1. Enter a number in an editable cell.
2. Tap Erase.

Expected:

- Player-entered number is removed.
- Given cells are not erasable.

### UAT-009 — Mistake Checking Toggle

**Goal**: Confirm mistake checking can be toggled.

Steps:

1. Tap `Check On`.
2. Confirm label changes.
3. Tap again.

Expected:

- Label toggles between `Check On` and `Check Off`.
- App remains responsive.

### UAT-010 — Lantern Hint

**Goal**: Confirm hint interaction works.

Steps:

1. Tap `Lantern Hint`.
2. Read hint dialog.
3. Dismiss.
4. Tap hint again.

Expected:

- Hint dialog appears.
- First hint is a gentle nudge.
- Later hint escalates toward technique/reveal.
- Target cell is selected/highlighted.

### UAT-011 — Pause

**Goal**: Confirm pause overlay works.

Steps:

1. Tap pause icon in app bar.
2. Tap resume icon.

Expected:

- Pause overlay appears.
- Resume returns to board.
- No board values are lost.

### UAT-012 — Replay Screen Smoke

**Goal**: Confirm replay screen can render move history after completion or test fixture.

Steps:

1. Complete or use a saved attempt.
2. Open `View Replay`.
3. Step forward.

Expected:

- Replay screen appears.
- Board renders.
- Move history appears.
- Next/Back controls update replay step.

---

## 4. Phase 3 Product Loop Test Cases

### UAT-013 — Completion Score Breakdown

**Goal**: Confirm completion produces transparent score.

Steps:

1. Complete a puzzle.
2. Observe completion dialog.

Expected:

- Score appears.
- Base score appears.
- Accuracy multiplier appears.
- Time, mistakes, and hints appear.

### UAT-014 — Retry

**Goal**: Confirm retry starts a fresh attempt.

Steps:

1. Complete a puzzle.
2. Tap Retry.

Expected:

- Board resets to original givens.
- Timer resets.
- Mistakes and hints reset.
- Previous attempt is not overwritten.

### UAT-015 — Attempt Persistence

**Goal**: Confirm attempts persist locally.

Steps:

1. Complete a puzzle.
2. Close app.
3. Reopen app.

Expected:

- No crash.
- Attempt data remains available where surfaced.

Note:

- The current UI does not yet expose an attempt history screen. Until that is added, validate with logs/tests.

---

## 5. Phase 4 Test Cases

### UAT-016 — Scholar's Path Locked State

Expected:

- Scholar's Path shows stage requirements.
- Progress indicators are visible.
- No leaderboard pressure appears for casual users.

### UAT-017 — Award Progress

Expected:

- Completing qualifying puzzles advances award progress.
- Stage unlock does not trigger early.

### UAT-018 — Extreme Locked Hub

Expected:

- Extreme entry point is visible but locked.
- Unlock requirements are clear.
- Payment is not offered as an unlock path.

### UAT-019 — Local Extreme Eligibility

Expected:

- Assisted attempts are marked unranked.
- No-hint, no-auto-check attempts can be locally ranked.

---

## 6. Phase 5 Release Candidate Test Cases

### UAT-020 — Tutorial

Expected:

- First-time player can complete tutorial.
- Notes and hints are introduced clearly.

### UAT-021 — Accessibility Baseline

Expected:

- Screen reader labels identify row, column, value, given/player state.
- All controls are reachable.
- Text remains readable with large text setting.

### UAT-022 — Small Screen Layout

Expected:

- Board and number pad fit.
- Text does not overlap.
- Controls remain at least 44pt.

### UAT-023 — Tablet Layout

Expected:

- Board remains centered and stable.
- UI does not stretch awkwardly.

### UAT-024 — Offline Play

Expected:

- App launches offline.
- Existing local puzzle can be played.
- Local attempts save offline.

### UAT-025 — Calm Experience Check

Expected:

- No active-play ads.
- No urgent sounds.
- Timer is not pressure-forward.
- Error feedback is gentle.

---

## 7. Defect Severity

| Severity | Definition | Example |
|---|---|---|
| Blocker | Prevents app launch or core play | App crashes on Tea Moment |
| High | Breaks core Sudoku behavior | Given cells editable |
| Medium | Degrades expected workflow | Replay opens but step labels wrong |
| Low | Cosmetic or wording issue | Minor spacing issue |

---

## 8. Signoff Template

```text
UAT Run:
Tester:
Date:
Commit:
Environment:
Cases Run:
Passed:
Failed:
Blockers:
Decision: Pass / Conditional Pass / Fail
Notes:
```
