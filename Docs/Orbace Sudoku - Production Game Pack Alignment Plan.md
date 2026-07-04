# Orbace Sudoku - Production Game Pack Alignment Plan

**Date:** 2026-07-02
**Status:** Draft production content correction plan
**Purpose:** Define how to replace the current misaligned advanced content with a 2,000-game production catalog whose level labels match the app's actual rating and player expectations.

---

## 1. Current Audit Baseline

Current generated assets total **1,900 games**:

| Content Set | Count | Current Status |
| --- | ---: | --- |
| Manifest/catalog packs | 1,800 | In `assets/puzzles/packs.json`; structurally valid |
| Standalone true Extreme pack | 100 | Generated but not yet wired into `packs.json` |

Audit files:

- `Docs/exports/all_level_alignment_audit_2026-07-02.md`
- `Docs/exports/all_level_alignment_audit_2026-07-02.csv`
- `Docs/exports/all_level_alignment_summary_2026-07-02.json`

Audit result:

| Pack | Count | Stored Level | Re-rated Result | Alignment |
| --- | ---: | --- | --- | ---: |
| Tea Moments | 180 | Beginner | 180 Beginner | 180/180 |
| Foundation | 360 | Beginner/Easy | Same | 360/360 |
| Discipline | 360 | Easy/Medium | Same | 360/360 |
| Insight | 360 | Medium | 298 Easy, 62 Medium | 62/360 |
| Mastery | 270 | Hard | 146 Easy, 123 Medium, 1 Hard | 1/270 |
| Expert Challenge | 270 | Expert | 97 Easy, 168 Medium, 5 Hard | 0/270 |
| True Extreme | 100 | Extreme | Beyond current hint solver | 100/100 |

Sudoku integrity failures: **0**.

Conclusion: the catalog is valid Sudoku content, but advanced-pack difficulty labels are not production-honest.

---

## 2. Production Catalog Target

New production target: **2,000 games**.

| Pack | Target Count | Level Standard | Production Decision |
| --- | ---: | --- | --- |
| Tea Moments | 200 | Beginner | Increase from 180 to 200 |
| Foundation | 360 | Beginner/Easy | Keep count; preserve aligned content |
| Discipline | 360 | Easy/Medium | Keep count; preserve aligned content |
| Insight | 360 | Medium | Regenerate/replace until 100% Medium-aligned |
| Mastery | 270 | Hard | Regenerate/replace until 100% Hard-aligned |
| Expert Challenge | 270 | Expert | Regenerate/replace until 100% Expert-aligned |
| True Extreme | 180 | Extreme/no-hint | Increase from 100 to 180 and wire with special validator |
| Total | 2,000 | Mixed | Production content catalog |

---

## 3. "110% Alignment" Quality Bar

For Insight, Mastery, and Expert Challenge, use a **110% candidate rule**:

1. Generate or curate **110% of the target pack count** as aligned candidates.
2. Ship only the strongest/most varied **100% target count**.
3. Keep the extra 10% as a reserve pool for replacements if duplicate, layout, UAT, or perceived-difficulty issues appear.

Candidate targets:

| Pack | Ship Count | 110% Candidate Pool | Minimum Accepted Re-rated Band |
| --- | ---: | ---: | --- |
| Insight | 360 | 396 | Medium |
| Mastery | 270 | 297 | Hard |
| Expert Challenge | 270 | 297 | Expert |

Additionally, shipped candidates should have a score cushion above the lower threshold:

| Pack | Current Score Band | Recommended Ship Floor |
| --- | --- | ---: |
| Insight | Medium = 131-180 | `>= 145` |
| Mastery | Hard = 181-240 | `>= 195` |
| Expert Challenge | Expert = >240 | `>= 260` |

This makes the label feel earned instead of barely qualifying.

---

## 4. Required Generator and Validator Changes

### A. Stop Inflating Metadata

Current generation scripts can store a puzzle as the target pack difficulty even when the solver re-rates it lower. That produced the current drift.

Required change:

- Stored `difficulty` must equal the actual re-rated difficulty for teaching packs.
- Stored `difficultyScore` must equal the actual rating score.
- A pack accepts/rejects a candidate based on actual rating, not target label.

### B. Add Pack-Specific Acceptance Gates

Teaching packs:

- Must have exactly one solution.
- Must be solvable by `HumanRankedSolver`.
- Must match the target accepted band.
- Must pass exact and structural duplicate checks.

True Extreme pack:

- Must have exactly one solution.
- Must be 24 clues or fewer unless manually approved.
- Must be unsolved by the current teaching hint solver.
- Must pass a dedicated search-complexity threshold.
- Must use no-hint/no-assist gameplay mode in app.

### C. Add Alignment Audit as a Release Gate

Before any production build with content changes:

```sh
dart run scripts/validate_puzzle_packs.dart
dart run scripts/audit_level_alignment.dart
```

Blocking thresholds:

- Sudoku integrity failures: `0`.
- Tea/Foundation/Discipline alignment: `>= 95%`.
- Insight/Mastery/Expert shipped alignment: `100%`.
- Insight/Mastery/Expert candidate reserve generated: `>= 110%` of shipped count.
- True Extreme alignment: `100%` against the no-hint standard.

---

## 5. Implementation Phases

### Phase 1 - Generator Fix

- Update production generator to stop using target difficulty as stored difficulty.
- Add acceptance filters for actual Medium, Hard, and Expert.
- Add reserve-candidate output files for Insight, Mastery, and Expert Challenge.
- Add report fields for accepted, rejected, and reserve counts.

Exit criteria:

- Generator can produce at least 396 Medium candidates, 297 Hard candidates, and 297 Expert candidates.
- Candidate report shows actual re-rated difficulty, not target-assigned difficulty.

### Phase 2 - Rebuild Teaching Packs

- Keep Tea/Foundation/Discipline unless regression is found.
- Increase Tea Moments from 180 to 200.
- Replace Insight, Mastery, and Expert Challenge with aligned candidates.
- Preserve pack IDs where possible to avoid app navigation churn.

Exit criteria:

- 1,820 teaching/regular puzzles plus 180 true Extreme = 2,000 total.
- `all_level_alignment_audit` shows Insight 360/360, Mastery 270/270, Expert Challenge 270/270.

### Phase 3 - True Extreme Integration

- Increase `true_extreme` from 100 to 180.
- Add `true_extreme` to the manifest only with a matching no-hint validator policy. V40 UAT temporarily wires the current 100-puzzle true-extreme asset as the Daily Expert source; this is not the final production count.
- Update Extreme Hub to launch a no-assist mode:
  - no hints
  - no auto-check
  - no retry ranking credit
  - no reliance on `HumanRankedSolver` solve path

Exit criteria:

- True Extreme 180/180 aligned.
- No-hint mode validated on iOS and Android.
- Level Packs and Extreme Hub show distinct Expert vs True Extreme language.

### Phase 4 - Final Catalog Sync Audit

- Verify generated puzzle assets, `assets/puzzles/packs.json`, `pubspec.yaml`, Daily Expert Challenge source selection, Level Packs counts, and exported audit files all reference the same approved production catalog.
- Confirm no stale `extreme challenge` wording remains in the app UI where the intended V1 label is `Expert Challenge`.
- Confirm the app launches Daily Expert Challenge from `true_extreme`, not the older expert candidate pack.

Exit criteria:

- App UI count equals approved catalog count.
- Daily Expert source is true-extreme.
- Release checklist and UAT log both cite the same content version and validation artifacts.

### Phase 4 - Production UAT Checkpoint

- Build IPA/AAB with content version `2026.07.aligned.001`.
- UAT focus:
  - Insight feels meaningfully harder than Discipline.
  - Mastery feels meaningfully harder than Insight.
  - Expert Challenge feels credible to expert players.
  - True Extreme is clearly no-hint/no-assist and does not promise teaching hints.

Exit criteria:

- Expert UAT signs off on perceived difficulty ladder.
- Store builds pass existing ads/privacy/signing gates.

---

## 6. Recommended Production Decision

Do not ship the current 1,800-game catalog as final production content under the current labels.

Recommended path:

1. Keep Tea Moments, Foundation, and Discipline mostly intact.
2. Regenerate Insight, Mastery, and Expert Challenge using the 110% candidate rule.
3. Add the 180-puzzle True Extreme pack only with a dedicated no-hint validation/gameplay path.
4. Ship production with a clean **2,000-game aligned catalog**.

This preserves the good early-player experience while protecting expert-player trust.
