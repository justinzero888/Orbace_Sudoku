# Orbace Sudoku - Game Pack Creation and Implementation Plan

**Version**: 1.0  
**Date**: 2026-06-20  
**Purpose**: Define how Orbace Sudoku creates, validates, ships, expands, and maintains puzzle packs from initial UAT content through the first 1,800 puzzles and beyond.

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

The first production content milestone is **1,800 validated puzzles**.

Recommended distribution:

| Pack Family | Difficulty | Count | Purpose |
| --- | --- | ---: | --- |
| Tea Moments | Beginner/Easy | 180 | Daily, low-friction warmups |
| Foundation | Beginner | 360 | Basic scanning, singles, confidence building |
| Discipline | Easy | 360 | Consistency, note discipline, low error rate |
| Insight | Medium | 360 | Technique learning and replay review |
| Mastery | Hard | 270 | Advanced human-logic practice |
| Extreme | Expert/Extreme | 270 | No-assist ranked challenge content |
| Total | Mixed | 1,800 | Launch-scale content library |

This mix gives enough beginner content for onboarding while reserving meaningful volume for advanced players and future competitive modes.

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

## 5. Creation Pipeline

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

### Step 5: De-Duplicate

Detect duplicates across all packs:

- Exact same givens.
- Same puzzle after digit remapping.
- Same puzzle after row/column/band/stack transformations.
- Same solution grid with only small clue differences, if near-duplicate detection is available.

For initial launch, exact duplicate detection is required. Isomorphic duplicate detection is recommended before reaching 1,800.

### Step 6: Curate Pack Ordering

Ordering should not be random.

Pack sequence should:

- Start with easier puzzles.
- Introduce techniques gradually.
- Avoid abrupt time/difficulty spikes.
- Mix clue layouts so the pack feels varied.
- Place satisfying milestone puzzles at every 10th or 20th position.

### Step 7: Assign Content Version

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

## 6. Implementation Plan

### GP-1: Move Current Fixtures Into Pack Assets

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

### GP-2: Build Real Pack Browser UI

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

### GP-3: Add Pack Progress Persistence

Goal:

Connect packs to local progress.

Deliverables:

- Repository queries:
  - completed count per pack
  - best score per puzzle
  - clean solve count per pack
  - last played puzzle per pack
- Current progress per puzzle.
- Resume puzzle from pack browser.

Acceptance criteria:

- Pack progress persists across app restart.
- Continue action resumes or starts the correct puzzle.
- Replay remains available from completed puzzle history.

### GP-4: Create 100-Puzzle UAT Content Set

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

Acceptance criteria:

- All 100 puzzles pass automated validation.
- UAT can test pack browsing, scoring, replay, awards, and Extreme lock behavior.

### GP-5: Build 1,800-Puzzle Production Library

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

### GP-6: Remote Content Readiness

Goal:

Prepare for content beyond 1,800 without forcing frequent app releases.

Deliverables:

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

Initial numeric score bands:

| Difficulty | Score Range | Notes |
| --- | ---: | --- |
| Beginner | 0-119 | Singles only |
| Easy | 120-199 | Singles + light pair usage |
| Medium | 200-319 | Pairs/pointing patterns |
| Hard | 320-499 | Multi-step pressure |
| Expert | 500-799 | Future advanced logic |
| Extreme | 800+ | Challenge curation |

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

## 15. Recommended Next Steps

1. Implement GP-1: move the current test catalog into JSON assets.
2. Implement GP-2: real pack browser UI.
3. Create validation script and report format.
4. Generate/curate a 100-puzzle UAT content set.
5. Connect pack progress to Scholar's Path and Extreme unlocks.
6. Build the 1,800-puzzle production content library.
7. Design remote content catalog for post-launch expansion.

## 16. Decision Log

| Decision | Recommendation |
| --- | --- |
| Initial delivery | Bundled JSON assets |
| First production target | 1,800 puzzles |
| Beyond 1,800 | Remote seasonal/event packs with local cache |
| Hint compatibility | Required for all non-Extreme launch puzzles |
| Extreme content | Stricter validation, ranked eligibility, no-assist rules |
| Existing puzzle edits | Avoid; retire and replace instead |
| Explanation copy | Generate in app from technique templates |

