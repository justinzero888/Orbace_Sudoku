# Orbace Sudoku - Game Pack Creation and Implementation Plan

**Version**: 1.2
**Date**: 2026-06-26
**Purpose**: Define how Orbace Sudoku creates, validates, ships, expands, and maintains puzzle packs from initial UAT content through the first 1,800 puzzles and beyond.

## Current Status - 2026-06-26

The current iOS UAT build includes the locally validated 1,800-puzzle launch catalog. The earlier 100-puzzle UAT pack is now historical context only.

Current implemented content state:

| Area | Status | Notes |
| --- | --- | --- |
| Bundled JSON pack assets | Complete | App loads puzzle content from `assets/puzzles/` instead of hardcoded fixtures. |
| Launch catalog puzzle count | Complete for UAT | 1,800 bundled puzzles are loaded from 31 batch files referenced by `assets/puzzles/packs.json`. |
| Content version metadata | Complete | Current launch catalog content version: `2026.06.003`. |
| Validation and duplicate scan | Complete | Correctness, stored solution, unique-solution, human-solver, ID uniqueness, and duplicate/isomorphic scan pass with 0 warnings. |
| Advanced coverage | Superseded by 2026-07-02 audit | Insight/Mastery/Expert Challenge stored difficulty labels do not match actual solver-rated difficulty (62/360, 1/270, 0/270 aligned respectively). See Production Game Pack Alignment Plan for the correction plan. |
| Local ranking certification | Complete for bundled catalog | Bundled catalog puzzles are marked rankable for local ranking; imported puzzles remain personal/non-ranked. |
| Pack progress and resume UX | Started | Completion markers, best-score surfacing, clean/official markers, Continue/Next Unsolved, and in-progress resume are implemented for local validation. Simulator smoke and UAT build are still needed before Gate 2 is complete. |
| Remote content readiness | Future phase | Planned after bundled production content and launch store flows are stable. |

Recent build checkpoints:

| Build | Platform | Purpose | Content Count | Status |
| --- | --- | --- | ---: | --- |
| `1.0.0 (8)` | iOS IPA | 100-puzzle UAT pack with harder content | 100 | Built |
| `1.0.0 (8)` | Android AAB | Android release bundle for current UAT content | 100 | Built |
| `1.0.0 (9)` | iOS IPA | Stronger selected-cell highlight plus curated/versioned UAT content | 100 | Built |
| `1.0.0 (11)` | iOS IPA | First 1,800-puzzle TestFlight catalog | 1,800 | Built after duplicate-warning cleanup |
| `1.0.0 (12)` | Android AAB | Android closed-test candidate with 1,800 puzzles | 1,800 | Signed and ready for Google Play closed testing upload |
| `1.0.0 (21)` | iOS IPA | Current iOS UAT baseline with local ranking and imported labels | 1,800 | Built and locally validated |

Terminology note:

- **Pipeline Step 6: Curate Pack Ordering** means ordering whatever content set currently exists.
- **Pipeline Step 7: Assign Content Version** means versioning whatever content set currently exists.
- For the current baseline, Pipeline Steps 1-7 are complete for the bundled 1,800-puzzle catalog. Remaining pack work is product UX, Android parity refresh, store readiness, and future remote expansion.

Duplicate-warning root cause and resolution:

- The production generator creates solved boards from one canonical Sudoku pattern, then randomizes digit labels plus valid row/column band permutations.
- At 1,800-puzzle scale, this can create different clue layouts that still share the same normalized solved-grid pattern after digit relabeling.
- The validator flagged 38 later puzzles with shared normalized solution grids in content version `2026.06.002`.
- Content version `2026.06.003` replaces those later duplicate-pattern puzzles using the same pack rules while rejecting already-used givens and normalized solution patterns.
- Current validation result: 1,800 puzzles, 0 duplicate-scan warnings.

Related reference:

- `Docs/Orbace Sudoku - Level Assignment Validation and Scoring Logic.md` defines launch-level assignment, validation criteria, and score parameters.
- `Docs/Orbace Sudoku - Production Game Pack Alignment Plan.md` defines the 2026-07-02 alignment audit findings and the correction plan for Insight, Mastery, Expert Challenge, and True Extreme content.

## 1. Goals

Orbace Sudoku needs a content system that supports:

- Many puzzle levels without app-code churn.
- Reliable difficulty and uniqueness.
- Hints and replay based on stored human-logic solve paths.
- Progression through Tea Moments, Level Packs, Scholar's Path, and Extreme Challenge.
- Future content beyond the initial 1,800 puzzles.
- Local-first bundled packs at launch, with a path to remote seasonal/event packs later.

The pack system should make puzzle content feel curated, not dumped. Players should sense progression, mastery, and cultural tone, even though every underlying puzzle is still a Sudoku grid.

## 2. Product Content Strategy

### Initial Content Target

The original production content milestone was **1,800 validated puzzles**. After the 2026-07-02 level-alignment audit, the recommended production target is now **2,000 validated and level-aligned puzzles**.

Recommended distribution:

| Pack Family | Difficulty | Count | Purpose |
| --- | --- | ---: | --- |
| Tea Moments | Beginner/Easy | 200 | Daily, low-friction warmups |
| Foundation | Beginner | 360 | Basic scanning, singles, confidence building |
| Discipline | Easy | 360 | Consistency, note discipline, low error rate |
| Insight | Medium | 360 | Technique learning and replay review; must be 100% Medium-aligned |
| Mastery | Hard | 270 | Advanced human-logic practice; must be 100% Hard-aligned |
| Expert Challenge | Expert | 270 | Expert-level no-assist candidate content; must be 100% Expert-aligned |
| True Extreme | Extreme | 180 | No-hint/no-assist extreme content with separate validator |
| Total | Mixed | 2,000 | Launch-scale content library |

This mix gives enough beginner content for onboarding while reserving meaningful volume for advanced players and future competitive modes. Insight, Mastery, and Expert Challenge should be built from 110% candidate pools: generate 396 Medium, 297 Hard, and 297 Expert candidates, then ship the best aligned 360/270/270 and keep the remaining 10% as replacement reserve.

### Beyond 1,800

After the first 1,800 puzzles, content should expand through a content pipeline rather than hardcoded app updates.

Long-term content sources:

- **Seasonal packs**: quarterly themed content, 90-180 puzzles per season.
- **Daily Tea Moments**: generated from a rotating local or remote pool.
- **Weekly Extreme Challenges**: high-integrity ranked puzzle sets.
- **Event packs**: Lunar New Year, summer challenge, expert invitational, etc.
- **Technique packs**: focused practice for Hidden Pair, Pointing Pair, X-Wing, etc.
- **Player skill lanes**: adaptive recommendations based on mistakes, hints, and replay behavior.

Scale target after launch:

| Horizon | Total Puzzle Library | Delivery Model |
| --- | ---: | --- |
| MVP/TestFlight | 30-100 | Bundled app assets |
| Launch Candidate | 1,800 | Bundled app assets with versioned manifest |
| 6 months post-launch | 3,000-5,000 | Bundled base + remote seasonal packs |
| 12 months post-launch | 8,000-12,000 | Remote pack catalog + local cache |
| Long term | 25,000+ | Generated/curated pipeline with server-side validation |

## 3. Pack Types

### Tea Moments

Short daily-style puzzles.

Rules:

- Beginner/Easy only at launch.
- Target time: 3-8 minutes.
- Gentle hint compatibility required.
- Can repeat after a long cycle, but not within 90 days once daily history is implemented.

### Foundation

Basic learning pack.

Rules:

- Beginner puzzles.
- Must be solvable with Naked Single and Hidden Single.
- Minimal need for notes.
- Useful for onboarding and first-week retention.

### Discipline

Consistency and accuracy pack.

Rules:

- Easy puzzles.
- Light notes encouraged.
- Designed to train clean solves, time control, and low error rate.

### Insight

Technique growth pack.

Rules:

- Medium puzzles.
- Requires stored human solve path.
- Should expose at least one named technique beyond singles when possible.
- Replay review should be useful.

### Mastery

Advanced practice pack.

Rules:

- Hard puzzles.
- Longer target time.
- Higher score potential.
- Should prepare players for Extreme.

### Extreme

Locked competitive challenge pack.

Rules:

- Expert/Extreme puzzles.
- No hints, no auto-check, no retries for ranked score.
- Local ranking first; worldwide ranking later.
- Must pass stricter uniqueness and anti-ambiguity validation.

## 4. Data Model

### Pack Manifest

File:

```text
assets/puzzles/packs.json
```

Shape:

```json
{
  "schemaVersion": 1,
  "contentVersion": "2026.06.001",
  "packs": [
    {
      "id": "foundation",
      "title": "Foundation",
      "chineseTitle": "入門",
      "description": "Build calm confidence with essential Sudoku patterns.",
      "family": "foundation",
      "difficultyRange": ["beginner"],
      "displayOrder": 10,
      "unlockRule": {
        "type": "always"
      },
      "asset": "assets/puzzles/foundation.json"
    }
  ]
}
```

### Puzzle File

Example:

```json
{
  "schemaVersion": 1,
  "packId": "foundation",
  "contentVersion": "2026.06.001",
  "puzzles": [
    {
      "id": "foundation_000001",
      "title": "Quiet Start",
      "difficulty": "beginner",
      "difficultyScore": 82,
      "givens": "530070000600195000098000060800060003400803001700020006060000280000419005000080079",
      "solution": "534678912672195348198342567859761423426853791713924856961537284287419635345286179",
      "targetTimeSeconds": 360,
      "medianTimeSeconds": 480,
      "requiredTechniques": ["hidden_single", "naked_single"],
      "rankedEligible": false,
      "tags": ["onboarding", "tea_moment_eligible"]
    }
  ]
}
```

### Stored Solve Path

There are two options:

1. **Precompute and store solve path in JSON**
   - Faster app startup.
   - Larger content files.
   - More stable hint behavior across app versions.

2. **Compute solve path during content import**
   - Smaller content files.
   - Easy to regenerate after solver improvements.
   - Requires careful app performance testing.

Recommended for 1,800 launch puzzles:

- Store puzzle metadata and required techniques in JSON.
- Compute solve path during first local import and persist to Drift.
- For Extreme and daily challenge packs, consider precomputing solve paths in the content pipeline for deterministic integrity.

## 5. Repeatable Content Creation Pipeline

This pipeline is repeated for every content set:

- Current 100-puzzle UAT pack.
- Future 1,800-puzzle production launch library.
- Future remote seasonal/event packs.

Completing a pipeline step means the step has been applied to the currently scoped content set, not that all future content volume has been created.

### Step 1: Generate Candidate Puzzles

Inputs:

- Difficulty target.
- Technique constraints.
- Minimum givens / maximum givens.
- Symmetry preference, if desired.
- Target solve length.
- Target time range.

Candidate generation methods:

- In-house generator from Phase 1 engine.
- External curated public-domain seed sources, only if license is clear.
- Manual expert-created puzzles.
- Hybrid approach: generated candidates reviewed by automated quality gates.

### Step 2: Validate Correctness

Every candidate must pass:

- 81-character givens string.
- 81-character solution string.
- Givens contain only digits 0-9 or dot equivalent during import.
- Solution contains digits 1-9 only.
- Givens match solution at all non-empty cells.
- Givens are a valid partial Sudoku board.
- Puzzle has exactly one solution.
- Solver result equals stored solution.

### Step 3: Validate Human Logic

Every launch puzzle should pass:

- Human-ranked solver can solve the puzzle.
- Solve path is deterministic.
- Required techniques are known by the app.
- Hint system can produce at least one meaningful next step.
- Difficulty score falls within the declared difficulty band.

Technique gates by difficulty:

| Difficulty | Allowed/Expected Techniques |
| --- | --- |
| Beginner | Naked Single, Hidden Single |
| Easy | Singles, Naked Pair |
| Medium | Singles, Pairs, Pointing Pair |
| Hard | Singles, Pairs, Pointing Pair, future advanced techniques |
| Expert | Advanced techniques, once implemented |
| Extreme | Advanced logic or strict challenge curation |

If a candidate requires an unsupported technique, either:

- Reject it for launch.
- Reclassify it as future content.
- Add the technique to the engine and hint system before shipping it.

### Step 4: Rate Difficulty

Difficulty rating should combine:

- Max technique difficulty.
- Number of solving steps.
- Branching pressure / candidate density.
- Number of givens.
- Human solver path complexity.
- Expected target time.
- Empirical player data once available.

Rating output:

- `difficulty`: user-facing bucket.
- `difficultyScore`: internal numeric score.
- `targetTimeSeconds`: scoring target.
- `medianTimeSeconds`: expected typical player time.

### Pipeline Step 5: De-Duplicate

Detect duplicates across all packs:

- Exact same givens.
- Same puzzle after digit remapping.
- Same puzzle after row/column/band/stack transformations.
- Same solution grid with only small clue differences, if near-duplicate detection is available.

Current UAT status:

- Implemented for the 1,800-puzzle launch catalog.
- Current content version: `2026.06.003`.
- Current report: 1,800 puzzles validated with 0 duplicate-scan warnings.

For production launch, exact duplicate detection and isomorphic/structural duplicate detection remain required for every future catalog or remote-pack release.

### Pipeline Step 6: Curate Pack Ordering

Ordering should not be random.

Pack sequence should:

- Start with easier puzzles.
- Introduce techniques gradually.
- Avoid abrupt time/difficulty spikes.
- Mix clue layouts so the pack feels varied.
- Place satisfying milestone puzzles at every 10th or 20th position.

Current UAT status:

- Implemented for the 1,800-puzzle launch catalog.
- Current ordering uses easier-to-harder pack sequencing with stronger milestone puzzles.
- UAT should continue to spot-check perceived difficulty, especially in Mastery and Extreme, because expert trust depends on level labels feeling earned.

### Pipeline Step 7: Assign Content Version

Every pack release must have:

- `schemaVersion`
- `contentVersion`
- generated timestamp
- generator/validator version
- content source record

Example:

```text
contentVersion = 2026.06.001
validatorVersion = sudoku-pack-validator-1.0.0
solverVersion = human-solver-1.0.0
```

Current UAT status:

- Implemented for the 1,800-puzzle launch catalog.
- Current content version: `2026.06.003`.
- Future content packs must receive a new content version after generation, duplicate scan, ordering, and validation pass.

## 6. Implementation Plan and Validation Checkpoints

### GP-1: Move Current Fixtures Into Pack Assets

Status: **Complete for UAT**

Goal:

Replace hardcoded Dart fixture catalog with bundled JSON assets.

Deliverables:

- `assets/puzzles/packs.json`
- `assets/puzzles/tea_moments.json`
- `assets/puzzles/foundation.json`
- Asset registration in `pubspec.yaml`.
- `PuzzlePack`, `PuzzleDefinition`, and `PuzzlePackManifest` domain models.
- `PuzzlePackLoader` that reads JSON assets.
- Tests for parsing and validation.

Acceptance criteria:

- Current test puzzles load from JSON.
- Level Packs screen uses loaded assets.
- Tea Moment selector uses loaded Tea Moment pool.
- Existing gameplay still works.

Validation checkpoint:

- Local validation required.
- TestFlight checkpoint completed through builds `1.0.0 (8)` and `1.0.0 (9)`.

### GP-2: Build Real Pack Browser UI

Status: **Complete for UAT foundation, partial for full product**

Goal:

Replace the simple UAT list with a scalable pack/puzzle browser.

Deliverables:

- Pack cards with:
  - title
  - Chinese title
  - difficulty range
  - completion count
  - best score
  - lock state
- Puzzle list per pack.
- Continue / Next Unsolved action.
- Puzzle detail row with best score, clean-solve marker, and replay availability.

Acceptance criteria:

- Testers can browse packs and choose puzzles.
- Completed puzzles show progress.
- Locked packs are visible but not playable.

Current implemented scope:

- Pack browser loads the 1,800-puzzle bundled launch catalog.
- Pack browser displays content version/date and advanced-puzzle count.
- Completed-game markers and completed counts are implemented.
- Best-score surfacing, clean/official markers, and continue/next-unsolved actions are still pending.

Validation checkpoint:

- TestFlight checkpoint completed for basic pack browsing.
- Another TestFlight checkpoint is required after pack progress and continue/resume behavior are added.

### GP-3: Add Pack Progress Persistence

Status: **Started - current progress and resume implemented for local validation**

Goal:

Connect packs to local progress.

Deliverables:

- Repository queries:
  - completed count per pack. Complete.
  - best score per puzzle. Complete.
  - clean solve count per pack. Complete.
  - last played puzzle per pack. Complete through current-progress timestamps.
- Current progress per puzzle. Complete for values, notes, and elapsed time.
- Resume puzzle from pack browser. Complete through Continue and in-progress puzzle rows.

Acceptance criteria:

- Pack progress persists across app restart.
- Continue action resumes or starts the correct puzzle.
- Replay remains available from completed puzzle history.

Validation checkpoint:

- Local persistence tests pass.
- Full local validation passes.
- Simulator smoke test still required before marking Gate 2 complete for UAT.
- TestFlight checkpoint recommended because this affects normal user navigation and replay access.

### GP-4: Create 100-Puzzle UAT Content Set

Status: **Complete**

Goal:

Give UAT testers enough puzzle variety before full 1,800 content generation.

Recommended distribution:

| Pack | Count |
| --- | ---: |
| Tea Moments | 10 |
| Foundation | 30 |
| Discipline | 30 |
| Insight | 20 |
| Extreme | 10 |
| Total | 100 |

Actual current distribution:

| Pack | Count | Advanced |
| --- | ---: | ---: |
| Tea Moments | 10 | 0 |
| Foundation | 25 | 4 |
| Discipline | 25 | 25 |
| Insight | 20 | 20 |
| Mastery | 10 | 10 |
| Extreme | 10 | 10 |
| Total | 100 | 69 |

Acceptance criteria:

- All 100 puzzles pass automated validation.
- UAT can test pack browsing, scoring, replay, awards, and Extreme lock behavior.

Validation checkpoint:

- Local validation complete.
- TestFlight checkpoint complete with build `1.0.0 (9)`.
- UAT should specifically test harder packs, selected-cell highlight, and content version visibility.

### GP-5: Production Content Readiness for 1,800 Puzzles

Status: **Complete for structural/integrity validation of the 1,800-puzzle UAT baseline. Difficulty-label alignment is superseded by the 2026-07-02 audit — see Production Game Pack Alignment Plan.**

Important clarification:

GP-5 is the phase that creates the 1,800-puzzle production catalog. It is separate from Pipeline Step 5, which is duplicate detection.

Goal:

Generate and validate launch-scale content.

Deliverables:

- 1,800 puzzle JSON files or partitioned pack files.
- Automated generator/validator script.
- Content report:
  - count by difficulty
  - technique distribution
  - average givens
  - average solve steps
  - duplicate scan results
  - validation pass/fail summary
- App import performance test.

Acceptance criteria:

- 100% unique-solution pass.
- 100% human-solver compatibility for non-Extreme launch puzzles.
- All IDs unique.
- No exact duplicate givens.
- App startup/import remains acceptable on older iPhones.

Current baseline status:

- Content version: `2026.06.003`.
- Candidate count: 1,800 puzzles.
- Asset layout: 31 batch files referenced by `assets/puzzles/packs.json`.
- Pack distribution:
  - Tea Moments: 180
  - Foundation: 360
  - Discipline: 360
  - Insight: 360
  - Mastery: 270
  - Extreme: 270
- Validator status: PASS for schema, stored solution, unique solution, human-solver compatibility, ID uniqueness, and duplicate/isomorphic scan.
- Duplicate-scan status: 0 warnings after replacing the 38 duplicate-pattern candidates from `2026.06.002`.
- Production approval status: approved for UAT and local ranking certification on Sudoku-integrity grounds only (0 integrity failures). Difficulty labels for Insight, Mastery, and Expert Challenge are not production-honest per the 2026-07-02 alignment audit (62/360, 1/270, 0/270 aligned) and must be regenerated before final production shipment — see Production Game Pack Alignment Plan.

Validation checkpoint:

- Local validation required before any TestFlight:
  - schema validation
  - unique solution
  - human-solver compatibility
  - duplicate/isomorphic scan
  - difficulty and technique distribution report
  - curated ordering report
- Simulator performance smoke test required:
  - app launch
  - pack browser load
  - first puzzle launch
  - memory and startup time on older-device simulator profile
- TestFlight checkpoint required after local validation passes.
- UAT focus:
  - content volume feels manageable
  - difficulty ramp is credible
  - no obvious repeated layouts
  - hard/expert content satisfies expert-player expectations

### GP-6: Launch Candidate Content Integration

Status: **Partially complete; merged into Production Readiness Gate 2**

Goal:

Integrate the 1,800-puzzle library into app flows without hurting app performance or user clarity.

Deliverables:

- Content import/version tracking in local persistence. Complete for current bundled assets.
- Pack progress queries against full production content. Partially complete for completed IDs/counts.
- Continue / next unsolved / recently played behavior.
- Optional lazy import or compact in-memory manifest strategy if startup slows. Not currently required by local validation, but should remain an option if device testing shows launch lag.
- Updated UAT cases for 1,800-puzzle browsing.

Acceptance criteria:

- App opens quickly with 1,800 bundled puzzles.
- Pack browser remains responsive.
- Existing attempts/replays survive content-version changes.
- Daily Tea Moment selection uses the correct pool.

Validation checkpoint:

- Local validation required.
- Simulator smoke and performance test required.
- TestFlight checkpoint required.

### GP-7: Remote Content Readiness

Status: **Future phase, V1 hook recommended**

Goal:

Prepare for content beyond 1,800 without forcing frequent app releases.

Deliverables:

- V1 "More Packs" / "Coming Soon" hook in Level Packs after the website landing page exists.
- Remote pack manifest schema.
- Content download/cache design.
- Version compatibility rules.
- Signed manifest or checksum validation.
- Fallback behavior when offline.
- Content retirement/deprecation strategy.

Acceptance criteria:

- App can display bundled content offline.
- App can later discover newer packs remotely.
- Remote pack cannot break older app versions.

Validation checkpoint:

- Design review first.
- Local mocked remote-catalog tests.
- TestFlight checkpoint only after app behavior changes are visible, such as download/cache/offline fallback.

## 7. Technical Architecture

### Bundled Content

Bundled JSON should be treated as seed content.

Flow:

1. App starts.
2. Read bundled manifest.
3. Check local content version.
4. Import missing/new puzzles into Drift.
5. Pack browser reads from repository.

### Local Database

Current Drift database should eventually store:

- `packs`
- `puzzles`
- `attempts`
- `current_progress`
- `pack_progress` or derived pack progress queries
- `content_imports`

Current `puzzles` table may be enough for early GP phases, but pack metadata likely needs either:

- New `pack_rows` table, or
- Pack metadata held in JSON assets while puzzle rows store `packId`.

Recommended:

- Add `pack_rows` and `content_import_rows` before 1,800 launch content.

### Asset File Size

1,800 puzzles in compact JSON should be manageable.

Approximate sizes:

- Givens + solution + metadata only: 1-3 KB per puzzle.
- 1,800 puzzles: roughly 2-6 MB uncompressed.
- With precomputed solve paths: potentially 8-25 MB depending on path detail.

Recommendation:

- Keep content compact.
- Avoid storing verbose explanation prose per puzzle.
- Store technique IDs and parameters, generate copy in app.

## 8. Validation Tooling

Create a local script:

```text
scripts/validate_puzzle_packs.dart
```

Validation checks:

- JSON schema validity.
- Pack IDs unique.
- Puzzle IDs unique.
- All referenced pack IDs exist.
- Givens and solution format.
- Givens match solution.
- Unique solution.
- Human solver compatibility.
- Required techniques supported.
- Difficulty score in expected band.
- Duplicate givens.
- Content version present.

Output:

```text
build/reports/puzzle_pack_validation.json
build/reports/puzzle_pack_validation.md
```

The Markdown report should be human-readable for content review.

## 9. Difficulty Bands

Actual numeric score bands, as implemented in `SudokuDifficultyRater` (`lib/src/features/sudoku/engine/sudoku_difficulty_rater.dart`):

| Difficulty | Score Range | Notes |
| --- | ---: | --- |
| Beginner | 0-90 | Singles only |
| Easy | 91-130 | Singles + light pair usage |
| Medium | 131-180 | Pairs/pointing patterns |
| Hard | 181-240 | Multi-step pressure |
| Expert | 241+ | Advanced logic |

These are the bands teaching-pack content (Tea Moments through Expert Challenge) must be validated against. An earlier draft of this table (200-319 / 320-499 / 500-799 / 800+) did not match the shipped rater; that documentation drift is one contributor to the mislabeled-difficulty findings in the 2026-07-02 alignment audit — see Production Game Pack Alignment Plan.

Extreme is not a higher bucket on this same score scale. `SudokuDifficultyRater` has no Extreme output. A puzzle only qualifies as True Extreme when `HumanRankedSolver` fails to solve it at all (reported as `beyond_hint_solver`), combined with a separate high-clue-count/search-complexity score used only by the True Extreme generator (current True Extreme score range: 903-4338 — a different scale than the teaching-pack scores above). Do not compare True Extreme `difficultyScore` values against this table.

These bands should be tuned after UAT data.

## 10. Unlock Rules

Packs should support unlock rules.

Examples:

```json
{ "type": "always" }
```

```json
{
  "type": "complete_pack",
  "packId": "foundation",
  "requiredCompleted": 30
}
```

```json
{
  "type": "award_stage",
  "stageId": "insight"
}
```

```json
{
  "type": "score_threshold",
  "packId": "discipline",
  "minimumAverageScore": 2500
}
```

For launch:

- Tea Moments: always unlocked.
- Foundation: always unlocked.
- Discipline: unlocked after light Foundation progress.
- Insight: unlocked after Discipline progress.
- Mastery: unlocked after Insight progress.
- Extreme: unlocked through Scholar's Path Stage 3.

## 11. Content Lifecycle

### Additive Updates

New content should be additive:

- New pack ID.
- New puzzle IDs.
- New content version.

Avoid modifying existing puzzle givens/solutions once shipped, because attempts and scores reference puzzle IDs.

### Corrections

If a shipped puzzle has a defect:

- Mark puzzle as retired.
- Hide it from new play.
- Keep historical attempts readable.
- Add replacement puzzle with a new ID.

### Remote Retirement

Remote manifest should support:

```json
{
  "retiredPuzzleIds": ["foundation_000123"],
  "retiredPackIds": []
}
```

The app should never delete local attempts when retiring content.

## 12. Beyond 1,800: Remote and Seasonal Content

### Remote Catalog

Remote catalog should include:

- latest content manifest version
- pack list
- download URLs
- checksums
- minimum app version
- release notes

Example:

```json
{
  "schemaVersion": 1,
  "catalogVersion": "2027.01.001",
  "minimumAppVersion": "1.2.0",
  "packs": [
    {
      "id": "season_2027_lunar_new_year",
      "title": "Lantern Season",
      "contentVersion": "2027.01.001",
      "url": "https://content.orbace.com/sudoku/packs/season_2027_lunar_new_year.json",
      "sha256": "..."
    }
  ]
}
```

### Content Signing

Before remote packs are used for ranked or paid content, add:

- SHA-256 checksum validation.
- Optional signature validation.
- Server-side validation report archived per content release.

### Player Experience

Remote content should appear as:

- New seasonal pack cards.
- Daily Tea Moment expanded pools.
- Weekly Extreme events.
- Technique practice collections.

Do not overwhelm the player with thousands of puzzles at once. Use pack curation, progress, and recommendations.

## 13. Operational Workflow

### Content Producer Workflow

1. Generate candidate puzzles.
2. Run validator.
3. Review validation report.
4. Reject or repair invalid candidates.
5. Assign pack ordering.
6. Generate content version.
7. Commit JSON assets and validation report.
8. QA import and gameplay.
9. Ship in app or remote catalog.

### Developer Workflow

1. Pull latest content branch.
2. Run:

```sh
scripts/run_validation.sh
dart run scripts/validate_puzzle_packs.dart
```

3. Build app.
4. Smoke test:
   - pack browser
   - puzzle launch
   - completion
   - replay
   - progress
   - daily selector

### QA Workflow

1. Verify count by pack.
2. Play samples from each difficulty.
3. Confirm hints do not break.
4. Confirm replay works.
5. Confirm progress/lock states.
6. Confirm retired content behavior when applicable.

## 14. Risks and Mitigations

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Generator creates boring near-duplicates | Content feels repetitive | Duplicate/isomorphic checks, curated ordering |
| Difficulty labels feel wrong | Expert players lose trust | UAT calibration, telemetry later |
| Unsupported techniques block hints | Hint system fails | Human-solver compatibility gate |
| 1,800 import is slow | Poor first launch | Lazy import, precomputed metadata, progress indicator |
| Remote content breaks old app | Bad UX | minimum app version and schema version gates |
| Shipped puzzle has defect | Trust loss | Retire puzzle, keep attempts, release replacement ID |
| Huge library overwhelms players | Low engagement | Pack curation, next unsolved, recommendations |

## 15. Recommended Next Phases

### Next Phase A: UAT Feedback Polish

Status: **In progress**

Scope:

- Continue addressing visual/gameplay feedback from TestFlight.
- Current iOS UAT candidate: `1.0.0 (21)`.
- Current Android closed-test candidate: `1.0.0 (12)`, behind current iOS feature baseline.
- Keep using the 1,800-puzzle catalog for UAT unless a specific regression requires a smaller diagnostic build.

Validation:

- Local validation for every code/content change.
- TestFlight checkpoint when visual/gameplay changes need tester confirmation.

### Next Phase B: Pack Progress and Resume

Status: **Recommended next implementation phase**

Scope:

- Completed count per pack.
- Best score per puzzle.
- Continue / next unsolved.
- Resume in-progress puzzle from pack browser.
- Replay access from completed puzzle rows.
- V1 More Packs / Coming Soon hook if `orbacesudoku.com` has a suitable destination page.

Validation:

- Unit tests for repository progress queries.
- Widget tests for pack browser progress states.
- Simulator smoke test.
- TestFlight checkpoint required.

### Next Phase C: 1,800-Puzzle Production Library

Status: **Complete for current UAT baseline**

Scope:

- Maintain the full 1,800-puzzle library.
- Re-run the repeatable content pipeline for every future catalog change:
  - generate
  - validate correctness
  - validate human logic
  - rate difficulty
  - de-duplicate
  - curate ordering
  - assign new content version
- Produce a content report for review.

Validation:

- Full local content validation is required before any app build that changes content.
- Performance/import smoke test is required when content volume or asset layout changes.
- TestFlight checkpoint is required after any material catalog change.

### Next Phase D: Launch Candidate Integration

Status: **Partially complete; continue through Production Readiness Gates 2, 4, 5A, and 5B**

Scope:

- Ensure app startup and pack browsing remain fast with production content volume.
- Finish pack progress and resume behavior.
- Refresh Android AAB from the current iOS feature baseline.
- Run iOS IPA/TestFlight and Android AAB/Google Play upload gates explicitly.
- Tune daily Tea Moment pool and pack unlock pacing.
- Update UAT test cases for the full catalog.

Validation:

- Local tests.
- Simulator performance validation.
- TestFlight checkpoint required.

### Next Phase E: Remote Content Readiness

Status: **Future**

Scope:

- Add a lightweight V1 "More Packs" hook only after the website/page is ready.
- Remote manifest schema.
- Download/cache behavior.
- Checksums/signing.
- Offline fallback.
- Content retirement/deprecation.

Validation:

- Design review first.
- Mocked local remote-catalog tests.
- TestFlight checkpoint only after user-visible remote content behavior exists.

## 16. Decision Log

| Decision | Recommendation |
| --- | --- |
| Initial delivery | Bundled JSON assets |
| First production target | 1,800 puzzles (superseded 2026-07-02: 2,000 level-aligned puzzles — see Production Game Pack Alignment Plan) |
| Beyond 1,800 | Remote seasonal/event packs with local cache |
| Hint compatibility | Required for all non-Extreme launch puzzles |
| Extreme content | Stricter validation, ranked eligibility, no-assist rules |
| Existing puzzle edits | Avoid; retire and replace instead |
| Explanation copy | Generate in app from technique templates |
