# Expert Challenge Batch 1 — Progress Summary (Paused for Review)

**Date:** 2026-07-03
**Status:** Paused by request. 15 of 90 target puzzles generated. Not yet shipped to `assets/puzzles/` or merged into `packs.json` — the live catalog is untouched.
**Purpose:** Record what the first Expert Challenge generation batch has produced so far, so it can be reviewed before deciding whether to resume, adjust parameters, or ship this partial set.

---

## 1. What This Batch Is

First batch toward the eventual 270-puzzle Expert Challenge target (Production Game Pack Alignment Plan §2), scoped down to 90 puzzles (99 with the 110% reserve pool) to make generation tractable. Generated via the fixed production generator (`scripts/generate_uat_packs.dart --production --pack=extreme`), which:

- Stores the actual re-rated difficulty/score (the 2026-07-02 alignment audit's metadata-inflation bug is fixed — nothing here is a mislabeled easier puzzle).
- Requires genuine `expert` difficulty (score > 240) **and** a 260 ship-floor cushion.
- Digs specifically in the 22-24 clue window (empirically the most productive range for this target).
- Reuses the generator's own internal human-solve rather than re-solving redundantly.
- Every puzzle is solvable by `HumanRankedSolver` (singles, hidden singles, naked/hidden pair, pointing pair, and the newly added X-Wing technique) — required for the app's hint system to work on this content.

## 2. Current Yield

| Metric | Value |
| --- | ---: |
| Accepted candidates | 15 / 100 (90 ship target + 10 reserve) |
| Score range | 260 – 296 |
| Average score | 267.5 |
| Clue count range | 22 – 25 |
| Candidates using X-Wing | 11 / 15 |
| Candidates using pairs only (no X-Wing needed) | 4 / 15 |

All 15 are genuine `expert`-band, human-solver-compatible puzzles — none inflated, none borderline under 260.

## 3. Full Candidate List

| ID | Difficulty | Score | Clues | Required Techniques |
| --- | --- | ---: | ---: | --- |
| extreme_001 | expert | 264 | 24 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair |
| extreme_002 | expert | 296 | 24 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair |
| extreme_003 | expert | 267 | 24 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair, x_wing |
| extreme_004 | expert | 263 | 24 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair, x_wing |
| extreme_005 | expert | 271 | 23 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair, x_wing |
| extreme_006 | expert | 261 | 25 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair, x_wing |
| extreme_007 | expert | 264 | 22 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair |
| extreme_008 | expert | 260 | 24 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair, x_wing |
| extreme_009 | expert | 266 | 24 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair, x_wing |
| extreme_010 | expert | 278 | 22 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair, x_wing |
| extreme_011 | expert | 273 | 24 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair, x_wing |
| extreme_012 | expert | 267 | 23 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair, x_wing |
| extreme_013 | expert | 260 | 24 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair, x_wing |
| extreme_014 | expert | 261 | 24 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair, x_wing |
| extreme_015 | expert | 262 | 24 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair |

Full puzzle data (givens/solution grids, IDs match above) is preserved in the checkpoint file:

```text
build/reports/checkpoints/extreme_checkpoint.json
```

This file is not bundled into the app (outside `assets/puzzles/`) and is safe to leave in place — resuming generation will pick it up automatically and continue from candidate 16.

## 4. Effort Spent So Far

| Run | Outcome | Notes |
| --- | --- | --- |
| 1st launch | Killed after ~3.8M attempts (48 candidates reached) | Predates checkpointing — that progress was **not recoverable** and is not part of the 15 above. Yielded the real-world rate estimate (~1-in-79,000) used afterward. |
| 2nd launch (checkpointing added) | Killed after ~74 min | Produced all 15 saved candidates; checkpoint preserved them. |
| 3rd launch (resumed from checkpoint) | Ran ~57 min, stopped by request | No new candidates found in this segment — consistent with the observed rarity (gaps between hits can run tens of minutes to longer). |

Both interruptions were unpredictable process kills from the environment, not crashes or bugs — nothing in the generator itself failed.

## 5. What Remains

At the observed real yield rate (~1-in-79,000 attempts, ~5.6ms/attempt), reaching the full 100-candidate pool (90 ship + 10 reserve) from here means finding ~85 more candidates — order of magnitude **several more hours to roughly half a day** of additional single-threaded compute, with real uncertainty since this rests on a still-small sample.

## 6. Options From Here

- **Resume as-is**: relaunch `dart run scripts/generate_uat_packs.dart --production --pack=extreme`, which will pick up from candidate 16 automatically.
- **Ship a smaller batch now**: if 15 (or a slightly larger near-term batch) is enough for an interim UAT/content check, the generator could be pointed at a lower `count` to produce a shippable pack immediately from what exists, rather than waiting for the full 90.
- **Shard across cores**: split the remaining search across parallel processes (this machine has 18 logical cores) to compress the remaining wall-clock time substantially.
- **Revisit the 260 floor**: all 15 candidates found so far cluster tightly between 260-278, with one outlier at 296 — the floor is working as intended but is clearly sitting at the rare tail of what this technique set can produce, which is the main cost driver.
