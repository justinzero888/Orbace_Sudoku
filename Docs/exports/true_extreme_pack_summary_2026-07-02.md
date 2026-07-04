# True Extreme Pack Summary

Date: 2026-07-02

## Output Files

- Pack asset: `assets/puzzles/true_extreme/true_extreme_01.json`
- CSV export: `Docs/exports/true_extreme_pack_2026-07-02.csv`
- Audit JSON: `Docs/exports/true_extreme_pack_audit_2026-07-02.json`
- Generator script: `scripts/generate_true_extreme_pack.dart`

## Pack Standard

This pack uses a stricter standard than the current `extreme` / `Expert Challenge` pack:

- Exactly 100 puzzles.
- Each puzzle has one unique solution.
- Each puzzle has 24 or fewer clues.
- Each puzzle is intentionally beyond the current Orbace teaching hint solver.
- Each puzzle has search score >= 900 using the true-extreme audit generator.
- Each puzzle is stored with `difficulty: "extreme"`.
- Each puzzle is marked `rankedEligible: true`.

## Audit Result

- Puzzle count: 100.
- Clue range: 20-24.
- Search score range: 903-4338.
- Current human hint solver solved: 0/100.
- Content version: `2026.07.true-extreme.001`.

## Integration Status

This is a generated standalone pack, not yet wired into `assets/puzzles/packs.json`.

Reason: the current global pack validator requires every bundled pack to be solvable by `HumanRankedSolver`, while this pack is deliberately beyond that hint solver. Before loading this pack into the app, update the content validation policy so `true_extreme` uses a no-hint/extreme validation path instead of the teaching-pack validation path.

Also review the Extreme Challenge gameplay flow before release: the current UI text says no hints / no auto-check, but `ExtremeHubScreen` still launches the normal `SudokuGameScreen` without a dedicated no-assist mode flag.
