# Orbace Sudoku - Level Assignment, Validation, and Scoring Logic

**Version**: 1.0
**Date**: 2026-06-26
**Purpose**: Define how Orbace Sudoku assigns puzzle levels, validates catalog quality, scores play, and determines fair local ranking eligibility for the current V1 product baseline.

## 1. Current Baseline

| Area | Current Baseline |
| --- | --- |
| Catalog size | 1,800 bundled puzzles |
| Content version | `2026.06.003` |
| Asset structure | `assets/puzzles/packs.json` plus 31 batch files |
| Current iOS UAT build | `1.0.0 (21)` |
| Current Android closed-test build | `1.0.0 (12)` |
| Local ranking state | Enabled for bundled catalog; disabled for imported puzzles |
| Scoring version | `1` |

This document is the working contract for V1 content quality and scoring. Any future change to difficulty assignment, score formula, ranked eligibility, or validation gates must update this document and the related tests.

## 2. Level Assignment Model

Orbace Sudoku uses two related but distinct difficulty signals:

| Signal | Source | Purpose |
| --- | --- | --- |
| Engine difficulty | Human-solver solve path and technique weights | Assign objective catalog level and target time |
| Player difficulty rating | User input on completed certificate | Capture lived difficulty for calibration and future recommendation |

The engine difficulty remains the V1 source of truth for pack placement and scoring. Player ratings are stored as product feedback and can tune V2 recommendations, future pack ordering, and difficulty bands after enough attempts exist.

## 3. Difficulty Bands and Base Scores

| Difficulty | Product Label | Base Score | Target Time |
| --- | --- | ---: | ---: |
| Beginner | Beginner | 1,000 | 6 min |
| Easy | Easy | 2,000 | 9 min |
| Medium | Medium | 4,000 | 12 min |
| Hard | Hard | 8,000 | 16 min |
| Expert | Expert | 16,000 | 20 min |
| Extreme | Extreme | 32,000 | 25 min |

Base score is intentionally exponential. A strong Expert solve should outrank an easy puzzle even when the easy puzzle is solved quickly, because the game should reward real Sudoku mastery rather than only speed.

## 4. Engine Difficulty Score

The current engine rating starts with solve-path length, then adds technique weights:

| Technique | Weight |
| --- | ---: |
| Naked Single | 1 |
| Hidden Single | 2 |
| Naked Pair | 6 |
| Hidden Pair | 8 |
| Pointing Pair | 8 |
| Unknown / future technique | 10 |

Current difficulty-score bands:

| Difficulty | Score Band |
| --- | ---: |
| Beginner | `<= 90` |
| Easy | `91-130` |
| Medium | `131-180` |
| Hard | `181-240` |
| Expert | `> 240` |

Extreme is currently a product pack designation for no-assist challenge content. In V1, Extreme should be treated as a stricter challenge lane, not merely a different solver-score threshold. Long term, Extreme should require stronger technique coverage, larger expert UAT sample size, and leaderboard anti-cheat controls.

## 5. Pack Assignment Criteria

| Pack | Count | Level Intent | Assignment Criteria |
| --- | ---: | --- | --- |
| Tea Moments | 180 | Short warmups | Beginner/Easy target, low technique burden, fast completion |
| Foundation | 360 | Core confidence | Beginner target, scanning and singles |
| Discipline | 360 | Consistency | Easy target, note discipline, low error expectation |
| Insight | 360 | Technique growth | Medium target, clear path into pair/pointing logic |
| Mastery | 270 | Advanced practice | Hard target, higher solve-path density |
| Extreme | 270 | No-assist challenge | Expert/Extreme target, local ranking candidate |

Ordering rules:

- Sort mostly easier-to-harder inside each pack.
- Avoid abrupt difficulty-score drops greater than 35 and spikes greater than 90 without manual review.
- Put stronger milestone puzzles at recurring milestones so pack progress feels intentional.
- Mix clue layouts and technique profiles to avoid repetitive play.

## 6. Validation Gates

Every bundled catalog release must pass these gates before a UAT or store build:

| Gate | Criteria | Blocking? |
| --- | --- | --- |
| Schema validation | Manifest and puzzle JSON parse against current schema | Yes |
| ID uniqueness | Every puzzle ID unique across catalog | Yes |
| Givens validity | No row/column/box conflict in starting grid | Yes |
| Stored solution validity | Solution is complete and valid | Yes |
| Unique solution | Puzzle has exactly one solution | Yes |
| Human-solver compatibility | Stored solve path works with supported hint engine | Yes for launch packs |
| Duplicate givens | No exact duplicate starting grids | Yes |
| Structural duplicate scan | No duplicate normalized/isomorphic patterns without explicit approval | Yes for launch catalog |
| Difficulty ordering | No unexplained severe drops/spikes inside pack order | Review required |
| Performance smoke | App launches and pack browser remains responsive | Yes before release candidate |

Current result for content version `2026.06.003`: 1,800 puzzles, 0 duplicate-scan warnings.

## 7. Score Formula

V1 scoring is transparent and deterministic.

```text
base = difficulty.baseScore
accuracyMultiplier = penalties clamped between 0.10 and 1.00
accuracyScore = round(base * accuracyMultiplier)
timeBonus = up to 10% of base
efficiencyBonus = 5% of base when player steps <= 120% of optimal steps
cleanSolveBonus = 5% of base when no mistakes and no hints
total = accuracyScore + timeBonus + efficiencyBonus + cleanSolveBonus
```

Penalty parameters:

| Event | Multiplier |
| --- | ---: |
| Mistake | `x0.85` each |
| Nudge hint | `x0.95` each |
| Explanation hint | `x0.85` each |
| Reveal hint | `x0.70` each |
| Auto-check enabled | `x0.85` |

Bonus parameters:

| Bonus | Criteria | Max |
| --- | --- | ---: |
| Time bonus | Timer enabled and elapsed time below target time | 10% of base |
| Efficiency bonus | Player step count is at most 120% of optimal solve steps | 5% of base |
| Clean solve bonus | No mistakes and no hints | 5% of base |

## 8. Score Class and Ranking Eligibility

The score can still be shown for practice, but ranking eligibility is stricter.

| Score Class | When Used | Ranked? |
| --- | --- | --- |
| Official | Completed first attempt, no hints, no assist, rankable puzzle, current scoring version | Yes |
| Assisted | Completed with hints, auto-check, mistake reveal, non-rankable puzzle, or scoring mismatch | No |
| Retry | Retry or attempt number greater than 1 | No |
| Legacy | Incomplete or pre-current record | No |

Blocking reason codes:

- `not_completed`
- `retry_or_later_attempt`
- `hints_used`
- `assist_enabled`
- `puzzle_not_ranked`
- `scoring_version_mismatch`

Local ranking sort order:

1. Highest score.
2. Faster elapsed time.
3. Fewer move-history steps.
4. Earlier completion date.

Only attempts with the same puzzle checksum and same scoring version can be compared in local ranking.

## 9. Imported Puzzle Policy

Imported puzzles are valuable for player utility but must stay personal in V1.

Rules:

- Imported puzzles can be played, scored, replayed, saved, and shown in Record Hall.
- Imported puzzles are labeled personal/non-ranked on certificates.
- Imported puzzles are excluded from local official ranking and future worldwide ranking unless Orbace later reviews, signs, and publishes them as official content.
- Imported puzzle validation must still require a valid grid and exactly one solution.

## 10. Calibration Plan

V1 should keep the scoring formula stable during UAT unless a real fairness defect is found. Calibration should focus on labels and targets first.

Recommended calibration inputs:

- Expert UAT feedback on Mastery and Extreme difficulty credibility.
- Player difficulty rating distribution by puzzle.
- Median solve time by puzzle and pack.
- Mistake/hint frequency by puzzle.
- Retry rate and abandonment rate once progress/resume exists.

Possible post-UAT adjustments:

- Move individual puzzles between packs.
- Adjust target times by pack or level.
- Retire or replace outlier puzzles.
- Add stronger technique support before expanding Extreme.
- Version any formula change as `scoringVersion = 2` and keep old scores auditable.

## 11. Product Principles

- Fairness matters more than maximum score drama.
- Ranking must be explainable from stored attempt data.
- A player should understand why a score is Official, Assisted, Retry, or Legacy.
- Imported and official content must be clearly labeled.
- Future paid/downloadable packs need the same validation and checksum discipline as bundled packs.
