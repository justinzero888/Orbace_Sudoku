import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_board.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_difficulty.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_difficulty_rater.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_generator.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/fixture_puzzles.dart';

const String _uatContentVersion = '2026.06.001';
const String _productionContentVersion = '2026.06.002';
const String _partialBatchContentVersion = '2026.07.001';
const String _generatedAt = '2026-06-21';
const String _generatorVersion = 'sudoku-pack-generator-1.2.0';
const String _validatorVersion = 'sudoku-pack-validator-1.1.0';
const String _solverVersion = 'human-solver-1.0.0';
// Keeps each batch file safely under Flutter's 50KB loadString() threshold
// (see lib/src/features/sudoku/data/puzzle_pack_loader.dart) -- above that
// size, decoding is dispatched to a background isolate via compute(),
// which never resolves inside a testWidgets fake-async clock and hangs
// widget tests indefinitely. 60 was previously fine for insight/mastery's
// per-puzzle byte size but was too tight for extreme's slightly larger
// entries (60 puzzles landed at ~52KB); 40 keeps real margin for any pack.
const int _productionBatchSize = 40;

void main(List<String> args) {
  final productionMode = args.contains('--production');
  // --pack=<id> restricts generation to a single pack and merges its result
  // into the existing packs.json instead of rewriting the whole manifest --
  // use this to add/replace one pack without touching the other five
  // already-shipped packs' asset files.
  String? packFilter;
  for (final arg in args) {
    if (arg.startsWith('--pack=')) {
      packFilter = arg.substring('--pack='.length);
    }
  }
  final contentVersion = productionMode
      ? (packFilter != null ? _partialBatchContentVersion : _productionContentVersion)
      : _uatContentVersion;
  final contentSource = productionMode
      ? (packFilter != null
            ? 'deterministic production generator seed 20260621; '
                  'single-pack batch for $packFilter'
            : 'deterministic production generator seed 20260621')
      : 'deterministic UAT generator seed 20260620';
  final outputDir = Directory('assets/puzzles')..createSync(recursive: true);
  final random = Random(productionMode ? 20260621 : 20260620);
  final generator = SudokuGenerator(random: random);
  final rater = const SudokuDifficultyRater();

  final allPacks = productionMode ? _productionPacks : _uatPacks;
  final packs = packFilter == null
      ? allPacks
      : allPacks.where((p) => p.id == packFilter).toList();
  if (packFilter != null && packs.isEmpty) {
    stderr.writeln('No pack with id "$packFilter" found.');
    exitCode = 1;
    return;
  }

  final manifestPacks = <Map<String, Object?>>[];
  final generationReports = <Map<String, Object?>>[];
  final usedPuzzleRows = <String>{};
  final usedSolutionKeys = <String>{};
  for (final plan in packs) {
    // The candidate pool target is larger than the ship count for packs that
    // request a replacement reserve (see PackPlan.reserveRatio). Every
    // candidate accepted here already satisfies the target difficulty band;
    // reserveRatio only controls how many *aligned* candidates we collect
    // before picking the best `plan.count` to ship.
    final totalTarget = (plan.count * plan.reserveRatio).ceil();
    final puzzles = <FixturePuzzleDefinition>[];
    var advancedCount = 0;
    var attempts = 0;
    var rejectedBand = 0;
    var rejectedMix = 0;
    var rejectedAdvancedNotAllowed = 0;
    var rejectedDuplicate = 0;

    // Long runs (rare target bands can take hours) are vulnerable to the
    // process getting killed by something outside this script's control.
    // Checkpoint accepted candidates periodically so a restart resumes
    // instead of losing all prior progress.
    final checkpointFile = _checkpointFileFor(plan.id);
    final checkpoint = _loadCheckpoint(checkpointFile, plan);
    if (checkpoint != null) {
      puzzles.addAll(checkpoint);
      for (final puzzle in checkpoint) {
        usedPuzzleRows.add(_rowsFromBoard(puzzle.givens).join());
        usedSolutionKeys.add(
          _normalizedDigitKey(_rowsFromBoard(puzzle.solution)),
        );
        if (_hasAdvancedTechnique(puzzle.requiredTechniques)) {
          advancedCount++;
        }
      }
      stdout.writeln(
        '${plan.id}: resumed ${puzzles.length}/$totalTarget from checkpoint '
        '${checkpointFile.path}',
      );
    }

    final maxOuterAttempts = totalTarget * plan.maxAttemptMultiplier;
    // Sample the removal depth from an explicit [min, max] window when the
    // plan sets one (see PackPlan.cellsToRemoveMin/Max), otherwise fall back
    // to the old center +/-1 jitter around plan.cellsToRemove.
    final removeMin = plan.cellsToRemoveMin ?? (plan.cellsToRemove - 1);
    final removeMax = plan.cellsToRemoveMax ?? (plan.cellsToRemove + 1);
    while (puzzles.length < totalTarget && attempts < maxOuterAttempts) {
      attempts++;
      if (attempts % 200000 == 0) {
        stdout.writeln(
          '${plan.id}: still running -- $attempts/$maxOuterAttempts attempts, '
          '${puzzles.length}/$totalTarget accepted so far',
        );
      }
      final puzzle = generator.generatePuzzle(
        id: '${plan.id}_${(puzzles.length + 1).toString().padLeft(3, '0')}',
        cellsToRemove: removeMin + random.nextInt(removeMax - removeMin + 1),
        maxAttempts: 260,
      );
      // generatePuzzle() only ever returns successfully when its internal
      // HumanRankedSolver already solved it (it throws otherwise), and it
      // stores that exact solve as puzzle.solvePath -- re-solving here would
      // just repeat the same expensive multi-step search for free.
      final rating = rater.rate(puzzle.solvePath);
      final givensRows = _rowsFromBoard(puzzle.givens);
      final solutionRows = _rowsFromBoard(puzzle.solution);
      final rowKey = givensRows.join();
      if (usedPuzzleRows.contains(rowKey)) {
        rejectedDuplicate++;
        continue;
      }
      final solutionKey = _normalizedDigitKey(solutionRows);
      if (usedSolutionKeys.contains(solutionKey)) {
        rejectedDuplicate++;
        continue;
      }
      final advanced = _hasAdvancedTechnique(rating.requiredTechniques);
      if (advanced && !plan.allowAdvanced) {
        rejectedAdvancedNotAllowed++;
        continue;
      }
      // Band acceptance is the actual re-rated difficulty, never the target
      // label. A puzzle that merely contains a pair-style step no longer
      // bypasses the score floor: both the difficulty band and the ship
      // floor must match before a candidate can be accepted.
      final bandAligned =
          rating.difficulty == plan.targetDifficulty &&
          rating.score >= plan.minimumScore;
      if (!bandAligned) {
        rejectedBand++;
        continue;
      }
      final neededAdvanced = (totalTarget * plan.requiredAdvancedRatio).ceil();
      final canAcceptBasic =
          advancedCount >= neededAdvanced ||
          plan.requiredAdvancedRatio == 0 ||
          puzzles.length < totalTarget - neededAdvanced;
      if (!advanced && !canAcceptBasic) {
        rejectedMix++;
        continue;
      }
      usedPuzzleRows.add(rowKey);
      usedSolutionKeys.add(solutionKey);
      if (advanced) {
        advancedCount++;
      }
      final nextNumber = puzzles.length + 1;
      puzzles.add(
        FixturePuzzleDefinition(
          id: '${plan.id}_${nextNumber.toString().padLeft(3, '0')}',
          title: '${plan.title} ${nextNumber.toString().padLeft(3, '0')}',
          seal: plan.seal,
          packId: plan.id,
          // Store the actual re-rated difficulty/score. Never widen these
          // toward the target label or the ship floor: that is exactly the
          // metadata inflation the 2026-07-02 alignment audit found.
          difficulty: rating.difficulty,
          difficultyScore: rating.score,
          targetTimeSeconds: _targetTimeFor(plan.targetDifficulty),
          medianTimeSeconds: _targetTimeFor(plan.targetDifficulty) + 180,
          requiredTechniques: rating.requiredTechniques,
          rankedEligible: plan.rankedEligible,
          givensRows: givensRows,
          solutionRows: solutionRows,
        ),
      );
      // Checkpoint every acceptance (cheap -- the list stays small) so an
      // unpredictable kill loses at most the time since the last accept,
      // not an arbitrary chunk of progress.
      _saveCheckpoint(checkpointFile, plan, puzzles);
      if (puzzles.length % 5 == 0) {
        stdout.writeln(
          '${plan.id}: ${puzzles.length}/$totalTarget accepted after '
          '$attempts attempts (rejected band=$rejectedBand mix=$rejectedMix '
          'advancedNotAllowed=$rejectedAdvancedNotAllowed '
          'duplicate=$rejectedDuplicate)',
        );
      }
    }

    if (puzzles.length != totalTarget) {
      stderr.writeln(
        'Generated ${puzzles.length}/$totalTarget aligned candidates for '
        '${plan.id} (ship target ${plan.count}) after $attempts attempts. '
        'Rejected: band=$rejectedBand mix=$rejectedMix '
        'advancedNotAllowed=$rejectedAdvancedNotAllowed '
        'duplicate=$rejectedDuplicate. Raise maxAttemptMultiplier or '
        'cellsToRemove for this pack.',
      );
      exitCode = 1;
      return;
    }

    // Ship the highest-scoring (most comfortably in-band, least borderline)
    // candidates and keep the remainder as a replacement reserve pool.
    final ranked = puzzles.toList()
      ..sort((a, b) => b.difficultyScore.compareTo(a.difficultyScore));
    final shipCandidates = ranked.take(plan.count).toList();
    final reserveCandidates = ranked.skip(plan.count).toList();

    final curatedPuzzles = _curatePuzzles(plan, shipCandidates);
    final assets = _writePackAssets(
      plan: plan,
      puzzles: curatedPuzzles,
      contentVersion: contentVersion,
      contentSource: contentSource,
      batched: productionMode,
    );
    if (checkpointFile.existsSync()) {
      checkpointFile.deleteSync();
    }
    manifestPacks.add(<String, Object?>{
      'id': plan.id,
      'title': plan.title,
      'subtitle': plan.subtitle,
      'seal': plan.seal,
      'description': plan.description,
      'asset': assets.first,
      'assets': assets,
      'order': manifestPacks.length,
      'difficultyBand': plan.targetDifficulty.name,
      'curationStrategy': plan.curationStrategy,
      'milestoneEvery': plan.milestoneEvery,
    });

    if (reserveCandidates.isNotEmpty) {
      _writeReservePool(
        plan: plan,
        puzzles: reserveCandidates,
        contentVersion: contentVersion,
        contentSource: contentSource,
      );
    }

    generationReports.add(<String, Object?>{
      'packId': plan.id,
      'shipTarget': plan.count,
      'candidatePoolTarget': totalTarget,
      'attempts': attempts,
      'accepted': puzzles.length,
      'shipped': shipCandidates.length,
      'reserved': reserveCandidates.length,
      'advancedInShipped': shipCandidates
          .where((p) => _hasAdvancedTechnique(p.requiredTechniques))
          .length,
      'rejectedBandMismatch': rejectedBand,
      'rejectedTechniqueMix': rejectedMix,
      'rejectedAdvancedNotAllowed': rejectedAdvancedNotAllowed,
      'rejectedDuplicate': rejectedDuplicate,
    });

    stdout.writeln(
      '${plan.id}: shipped ${shipCandidates.length}/${plan.count}, '
      'reserved ${reserveCandidates.length}, $attempts attempts '
      '(rejected band=$rejectedBand mix=$rejectedMix '
      'advancedNotAllowed=$rejectedAdvancedNotAllowed '
      'duplicate=$rejectedDuplicate)',
    );
  }

  if (packFilter != null) {
    _mergeIntoExistingManifest(
      outputDir: outputDir,
      newEntries: manifestPacks,
      contentVersion: contentVersion,
      contentSource: contentSource,
    );
  } else {
    File('${outputDir.path}/packs.json').writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(<String, Object?>{'schemaVersion': 1, 'contentVersion': contentVersion, 'generatedAt': _generatedAt, 'generatorVersion': _generatorVersion, 'validatorVersion': _validatorVersion, 'solverVersion': _solverVersion, 'contentSource': contentSource, 'packs': manifestPacks})}\n',
    );
  }

  final reportDir = Directory('build/reports')..createSync(recursive: true);
  File(
    '${reportDir.path}/generation_report_$contentVersion.json',
  ).writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(<String, Object?>{'contentVersion': contentVersion, 'generatedAt': _generatedAt, 'packs': generationReports})}\n',
  );
}

File _checkpointFileFor(String packId) {
  return File('build/reports/checkpoints/${packId}_checkpoint.json');
}

/// Loads previously-accepted candidates for [plan] if a checkpoint exists
/// and its generation parameters still match -- a checkpoint from a run
/// with different acceptance criteria (cellsToRemove window, minimumScore,
/// target difficulty) is discarded rather than resumed, since its puzzles
/// may not satisfy the current plan.
List<FixturePuzzleDefinition>? _loadCheckpoint(File file, PackPlan plan) {
  if (!file.existsSync()) {
    return null;
  }
  final data = jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
  final matches =
      data['packId'] == plan.id &&
      data['cellsToRemoveMin'] == (plan.cellsToRemoveMin ?? plan.cellsToRemove - 1) &&
      data['cellsToRemoveMax'] == (plan.cellsToRemoveMax ?? plan.cellsToRemove + 1) &&
      data['minimumScore'] == plan.minimumScore &&
      data['targetDifficulty'] == plan.targetDifficulty.name;
  if (!matches) {
    stdout.writeln(
      '${plan.id}: checkpoint at ${file.path} does not match current plan '
      'parameters -- ignoring and starting fresh.',
    );
    return null;
  }
  return (data['puzzles']! as List<Object?>)
      .cast<Map<String, Object?>>()
      .map((json) => FixturePuzzleDefinition.fromJson(json, packId: plan.id))
      .toList();
}

void _saveCheckpoint(
  File file,
  PackPlan plan,
  List<FixturePuzzleDefinition> puzzles,
) {
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(
    jsonEncode(<String, Object?>{
      'packId': plan.id,
      'cellsToRemoveMin': plan.cellsToRemoveMin ?? plan.cellsToRemove - 1,
      'cellsToRemoveMax': plan.cellsToRemoveMax ?? plan.cellsToRemove + 1,
      'minimumScore': plan.minimumScore,
      'targetDifficulty': plan.targetDifficulty.name,
      'puzzles': puzzles.map((p) => p.toJson()).toList(),
    }),
  );
}

/// Replaces matching pack entries in the existing packs.json with freshly
/// generated ones, preserving every other pack (asset files, ordering,
/// content) untouched. Also deletes the replaced pack's old batch files
/// that are no longer referenced, since each pack's assets/puzzles/ folder
/// is bundled wholesale by pubspec.yaml -- an orphaned old batch file would
/// still ship.
void _mergeIntoExistingManifest({
  required Directory outputDir,
  required List<Map<String, Object?>> newEntries,
  required String contentVersion,
  required String contentSource,
}) {
  final manifestFile = File('${outputDir.path}/packs.json');
  if (!manifestFile.existsSync()) {
    stderr.writeln(
      'No existing packs.json to merge into at ${manifestFile.path}.',
    );
    exitCode = 1;
    return;
  }
  final manifest =
      jsonDecode(manifestFile.readAsStringSync()) as Map<String, Object?>;
  final existingPacks = (manifest['packs']! as List<Object?>)
      .cast<Map<String, Object?>>();

  for (final newEntry in newEntries) {
    final id = newEntry['id'] as String;
    final existingIndex = existingPacks.indexWhere((p) => p['id'] == id);
    if (existingIndex == -1) {
      newEntry['order'] = existingPacks.length;
      existingPacks.add(newEntry);
      continue;
    }

    final oldEntry = existingPacks[existingIndex];
    final oldAssets = ((oldEntry['assets'] as List<Object?>?) ??
            <Object?>[oldEntry['asset']])
        .cast<String>()
        .toSet();
    final newAssets = (newEntry['assets']! as List<Object?>).cast<String>();
    for (final oldAsset in oldAssets.difference(newAssets.toSet())) {
      final file = File(oldAsset);
      if (file.existsSync()) {
        file.deleteSync();
        stdout.writeln('Removed stale batch file: $oldAsset');
      }
    }

    newEntry['order'] = oldEntry['order'];
    existingPacks[existingIndex] = newEntry;
  }

  manifest['packs'] = existingPacks;
  manifest['contentVersion'] = contentVersion;
  manifest['generatedAt'] = _generatedAt;
  manifest['contentSource'] = contentSource;
  manifestFile.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(manifest)}\n',
  );
  stdout.writeln('Merged ${newEntries.length} pack(s) into ${manifestFile.path}');
}

void _writeReservePool({
  required PackPlan plan,
  required List<FixturePuzzleDefinition> puzzles,
  required String contentVersion,
  required String contentSource,
}) {
  // Reserve pools are replacement candidates only. They must never live
  // under assets/puzzles/, which pubspec.yaml bundles into the app.
  final reserveDir = Directory('build/reports/reserve')
    ..createSync(recursive: true);
  final asset = '${reserveDir.path}/${plan.id}_reserve.json';
  File(asset).writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(<String, Object?>{'schemaVersion': 1, 'packId': plan.id, 'contentVersion': contentVersion, 'contentSource': contentSource, 'note': 'Replacement reserve pool, not bundled with the app.', 'puzzles': puzzles.map((puzzle) => puzzle.toJson()).toList()})}\n',
  );
}

List<String> _writePackAssets({
  required PackPlan plan,
  required List<FixturePuzzleDefinition> puzzles,
  required String contentVersion,
  required String contentSource,
  required bool batched,
}) {
  if (!batched) {
    final asset = 'assets/puzzles/${plan.id}.json';
    File(asset).writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(_packPayload(plan: plan, contentVersion: contentVersion, contentSource: contentSource, batchIndex: null, batchCount: null, puzzles: puzzles))}\n',
    );
    return <String>[asset];
  }

  final batchDir = Directory('assets/puzzles/${plan.id}')
    ..createSync(recursive: true);
  final batchCount = (puzzles.length / _productionBatchSize).ceil();
  final assets = <String>[];
  for (var batchIndex = 0; batchIndex < batchCount; batchIndex++) {
    final start = batchIndex * _productionBatchSize;
    final end = min(start + _productionBatchSize, puzzles.length);
    final asset =
        '${batchDir.path}/${plan.id}_${(batchIndex + 1).toString().padLeft(2, '0')}.json';
    File(asset).writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(_packPayload(plan: plan, contentVersion: contentVersion, contentSource: contentSource, batchIndex: batchIndex + 1, batchCount: batchCount, puzzles: puzzles.sublist(start, end)))}\n',
    );
    assets.add(asset);
  }

  File('assets/puzzles/${plan.id}.json').writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(<String, Object?>{..._packMetadata(plan: plan, contentVersion: contentVersion, contentSource: contentSource), 'batchCount': batchCount, 'assets': assets, 'puzzles': const <Object?>[]})}\n',
  );
  return assets;
}

Map<String, Object?> _packPayload({
  required PackPlan plan,
  required String contentVersion,
  required String contentSource,
  required int? batchIndex,
  required int? batchCount,
  required List<FixturePuzzleDefinition> puzzles,
}) {
  final payload = <String, Object?>{
    ..._packMetadata(
      plan: plan,
      contentVersion: contentVersion,
      contentSource: contentSource,
    ),
    'puzzles': puzzles.map((puzzle) => puzzle.toJson()).toList(),
  };
  if (batchIndex case final value?) {
    payload['batchIndex'] = value;
  }
  if (batchCount case final value?) {
    payload['batchCount'] = value;
  }
  return payload;
}

Map<String, Object?> _packMetadata({
  required PackPlan plan,
  required String contentVersion,
  required String contentSource,
}) {
  return <String, Object?>{
    'schemaVersion': 1,
    'contentVersion': contentVersion,
    'generatedAt': _generatedAt,
    'generatorVersion': _generatorVersion,
    'validatorVersion': _validatorVersion,
    'solverVersion': _solverVersion,
    'contentSource': contentSource,
    'curationStrategy': plan.curationStrategy,
    'milestoneEvery': plan.milestoneEvery,
    'id': plan.id,
  };
}

final List<PackPlan> _uatPacks = <PackPlan>[
  PackPlan(
    id: 'tea_moments',
    title: 'Tea Moments',
    subtitle: 'Daily calm practice',
    seal: '茶',
    description: 'Short warm-up puzzles for daily play and UAT smoke tests.',
    count: 10,
    minimumScore: 70,
    cellsToRemove: 42,
    targetDifficulty: SudokuDifficulty.beginner,
    requiredAdvancedRatio: 0,
  ),
  PackPlan(
    id: 'foundation',
    title: 'Foundation',
    subtitle: 'Steady classic play',
    seal: '基',
    description: 'Approachable puzzles for testing normal game flow.',
    count: 25,
    minimumScore: 95,
    cellsToRemove: 46,
    targetDifficulty: SudokuDifficulty.easy,
    requiredAdvancedRatio: 0.15,
  ),
  PackPlan(
    id: 'discipline',
    title: 'Discipline',
    subtitle: 'Medium technique practice',
    seal: '習',
    description: 'Longer puzzles that begin to require candidate management.',
    count: 25,
    minimumScore: 135,
    cellsToRemove: 49,
    targetDifficulty: SudokuDifficulty.medium,
    requiredAdvancedRatio: 0.35,
  ),
  PackPlan(
    id: 'insight',
    title: 'Insight',
    subtitle: 'Hard pattern solving',
    seal: '悟',
    description: 'Hard UAT puzzles focused on pair and pointing eliminations.',
    count: 20,
    minimumScore: 185,
    cellsToRemove: 52,
    targetDifficulty: SudokuDifficulty.hard,
    requiredAdvancedRatio: 0.7,
  ),
  PackPlan(
    id: 'mastery',
    title: 'Mastery',
    subtitle: 'Expert-level UAT checks',
    seal: '極',
    description:
        'The hardest bundled training pack before ranked Extreme play.',
    count: 10,
    minimumScore: 230,
    cellsToRemove: 54,
    targetDifficulty: SudokuDifficulty.expert,
    requiredAdvancedRatio: 0.9,
  ),
  PackPlan(
    id: 'extreme',
    title: 'Expert Challenge',
    subtitle: 'Ranked challenge seeds',
    seal: '榜',
    description: 'Candidate ranked puzzles for future leaderboard validation.',
    count: 10,
    minimumScore: 240,
    cellsToRemove: 55,
    targetDifficulty: SudokuDifficulty.expert,
    requiredAdvancedRatio: 1,
    rankedEligible: true,
  ),
];

final List<PackPlan> _productionPacks = <PackPlan>[
  PackPlan(
    id: 'tea_moments',
    title: 'Tea Moments',
    subtitle: 'Daily calm practice',
    seal: '茶',
    description: 'Daily warmups and low-friction calm solves.',
    count: 180,
    minimumScore: 70,
    cellsToRemove: 40,
    targetDifficulty: SudokuDifficulty.beginner,
    requiredAdvancedRatio: 0,
    allowAdvanced: false,
  ),
  PackPlan(
    id: 'foundation',
    title: 'Foundation',
    subtitle: 'Build scanning confidence',
    seal: '基',
    description: 'Core beginner puzzles focused on singles and clean solves.',
    count: 360,
    minimumScore: 80,
    cellsToRemove: 43,
    targetDifficulty: SudokuDifficulty.beginner,
    requiredAdvancedRatio: 0,
    allowAdvanced: false,
  ),
  PackPlan(
    id: 'discipline',
    title: 'Discipline',
    subtitle: 'Steady note discipline',
    seal: '習',
    description: 'Easy puzzles that train consistency and light candidates.',
    count: 360,
    minimumScore: 110,
    cellsToRemove: 46,
    targetDifficulty: SudokuDifficulty.easy,
    requiredAdvancedRatio: 0.1,
  ),
  PackPlan(
    id: 'insight',
    title: 'Insight',
    subtitle: 'Pattern recognition',
    seal: '悟',
    description: 'Medium puzzles focused on pairs and pointing eliminations.',
    count: 360,
    // Ship floor per Production Game Pack Alignment Plan §3 (Medium band is
    // 131-180; floor gives a cushion so the label doesn't barely qualify).
    // cellsToRemove and maxAttemptMultiplier are set from empirical yield
    // probes (2026-07-02): at 51 cells removed, ~0.2% of candidates clear
    // the actual Medium band at score>=145.
    minimumScore: 145,
    cellsToRemove: 51,
    targetDifficulty: SudokuDifficulty.medium,
    requiredAdvancedRatio: 0.35,
    maxAttemptMultiplier: 1500,
    reserveRatio: 1.1,
  ),
  PackPlan(
    id: 'mastery',
    title: 'Mastery',
    subtitle: 'Hard technique practice',
    seal: '極',
    description: 'Hard puzzles for advanced human-logic practice.',
    count: 270,
    // Ship floor per Production Game Pack Alignment Plan §3 (Hard band is
    // 181-240; raised from 185 to the recommended 195 cushion).
    // cellsToRemove raised from 52 to 55 -- at 52 the empirical Hard yield
    // (post metadata-inflation fix) was ~0/2000; 55 is the lowest setting
    // that produced a non-trivial Hard hit rate (~0.4%) in probing.
    minimumScore: 195,
    cellsToRemove: 55,
    targetDifficulty: SudokuDifficulty.hard,
    requiredAdvancedRatio: 0.7,
    maxAttemptMultiplier: 6000,
    reserveRatio: 1.1,
  ),
  PackPlan(
    id: 'extreme',
    title: 'Expert Challenge',
    subtitle: 'Ranked challenge seeds',
    seal: '榜',
    description: 'Expert challenge candidates for no-assist ranked play.',
    // First batch toward the eventual 270-puzzle target (Production Game
    // Pack Alignment Plan §2): 90 now, top up to 270 in a later batch once
    // this run's real yield is known. See notes below on why 270 in one
    // shot was an open-ended, likely multi-hour-to-multi-day commitment.
    count: 90,
    // Ship floor per Production Game Pack Alignment Plan §3 (Expert band is
    // 241+; raised from 220 -- which was below the band entirely -- to the
    // recommended 260 cushion).
    //
    // The Expert band (>240) was UNREACHABLE before the X-Wing technique
    // was added to HumanRankedSolver (2026-07-02): sampling showed a hard
    // ceiling of ~231 across cellsToRemove 49-70 with only pairs/singles.
    // With X-Wing, Expert-band hits occur but stay rare (2 hits total across
    // ~45,000 sampled attempts this session, at score 241 and 242 -- both
    // barely over the band boundary). Score>=260 specifically was never
    // observed at all in that sampling; the 260 floor may be practically
    // unreachable at this technique set's current ceiling and is worth
    // revisiting (e.g. lowering toward 241-245) if this batch under-delivers.
    //
    // cellsToRemoveMin/Max narrows digging to the 22-24 clue window, chosen
    // empirically (2026-07-02): a wider 22-27 window diluted yield to
    // 0.22%/attempt (worse than the unconstrained 0.34% baseline), while
    // 22-24 concentrated it to 0.39%/attempt. Combined with the solvePath
    // reuse below (removes a redundant second human-solve per attempt,
    // ~7.5ms -> ~5.6ms), measured throughput for the Hard>=195 proxy target
    // improved from 0.45 hits/sec to 0.71 hits/sec (~1.6x).
    //
    // 2026-07-04: lowered from 260 to 245 after the 260 floor was never
    // once observed in ~51,000 sampled attempts (only 2 hits total ever
    // cleared 241/242 at any floor). 245 keeps a real cushion above the
    // Expert band minimum (>240) while staying within a tractable
    // generation window given this solver's current technique ceiling.
    minimumScore: 245,
    cellsToRemove: 58,
    cellsToRemoveMin: 57,
    cellsToRemoveMax: 59,
    targetDifficulty: SudokuDifficulty.expert,
    requiredAdvancedRatio: 0.9,
    rankedEligible: true,
    maxAttemptMultiplier: 120000,
    reserveRatio: 1.1,
  ),
];

class PackPlan {
  const PackPlan({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.seal,
    required this.description,
    required this.count,
    required this.minimumScore,
    required this.cellsToRemove,
    required this.targetDifficulty,
    required this.requiredAdvancedRatio,
    this.rankedEligible = true,
    this.milestoneEvery = 10,
    this.allowAdvanced = true,
    this.maxAttemptMultiplier = 220,
    this.reserveRatio = 1,
    this.cellsToRemoveMin,
    this.cellsToRemoveMax,
  });

  final String id;
  final String title;
  final String subtitle;
  final String seal;
  final String description;
  final int count;
  final int minimumScore;
  final int cellsToRemove;
  final SudokuDifficulty targetDifficulty;
  /// Overrides the +/-1 jitter around [cellsToRemove] with an explicit
  /// window. Both null (default) preserves the old center +/-1 behavior.
  final int? cellsToRemoveMin;
  final int? cellsToRemoveMax;
  final double requiredAdvancedRatio;
  final bool rankedEligible;
  final int milestoneEvery;
  final bool allowAdvanced;
  final int maxAttemptMultiplier;

  /// Multiplier applied to [count] to size the aligned-candidate pool before
  /// shipping. `1.1` means "collect 110% aligned candidates, ship the
  /// strongest 100%, keep the rest as a replacement reserve."
  final double reserveRatio;

  String get curationStrategy {
    return 'ascending difficulty with stronger milestone puzzles every '
        '$milestoneEvery levels';
  }
}

List<FixturePuzzleDefinition> _curatePuzzles(
  PackPlan plan,
  List<FixturePuzzleDefinition> puzzles,
) {
  final sorted = puzzles.toList()
    ..sort((a, b) {
      final scoreCompare = a.difficultyScore.compareTo(b.difficultyScore);
      if (scoreCompare != 0) {
        return scoreCompare;
      }
      return b.clueCount.compareTo(a.clueCount);
    });

  for (
    var milestoneIndex = plan.milestoneEvery - 1;
    milestoneIndex < sorted.length;
    milestoneIndex += plan.milestoneEvery
  ) {
    final groupStart = milestoneIndex - plan.milestoneEvery + 1;
    final groupEnd = min(milestoneIndex + 1, sorted.length);
    var hardestIndex = groupStart;
    for (var index = groupStart + 1; index < groupEnd; index++) {
      if (_curationWeight(sorted[index]) >
          _curationWeight(sorted[hardestIndex])) {
        hardestIndex = index;
      }
    }
    final milestonePuzzle = sorted.removeAt(hardestIndex);
    sorted.insert(milestoneIndex, milestonePuzzle);
  }

  return <FixturePuzzleDefinition>[
    for (var index = 0; index < sorted.length; index++)
      _relabelPuzzle(plan, sorted[index], index + 1),
  ];
}

int _curationWeight(FixturePuzzleDefinition puzzle) {
  return puzzle.difficultyScore * 10 -
      puzzle.clueCount +
      (_hasAdvancedTechnique(puzzle.requiredTechniques) ? 1000 : 0);
}

FixturePuzzleDefinition _relabelPuzzle(
  PackPlan plan,
  FixturePuzzleDefinition puzzle,
  int number,
) {
  return FixturePuzzleDefinition(
    id: '${plan.id}_${number.toString().padLeft(3, '0')}',
    title: '${plan.title} ${number.toString().padLeft(2, '0')}',
    seal: puzzle.seal,
    packId: plan.id,
    difficulty: puzzle.difficulty,
    difficultyScore: puzzle.difficultyScore,
    targetTimeSeconds: puzzle.targetTimeSeconds,
    medianTimeSeconds: puzzle.medianTimeSeconds,
    requiredTechniques: puzzle.requiredTechniques,
    rankedEligible: puzzle.rankedEligible,
    givensRows: puzzle.givensRows,
    solutionRows: puzzle.solutionRows,
  );
}

List<String> _rowsFromBoard(SudokuBoard board) {
  return <String>[
    for (var row = 0; row < SudokuBoard.size; row++)
      [
        for (var col = 0; col < SudokuBoard.size; col++)
          board.valueAt(row, col)?.toString() ?? '0',
      ].join(),
  ];
}

bool _hasAdvancedTechnique(List<String> techniques) {
  return techniques.any(
    (technique) =>
        technique == 'naked_pair' ||
        technique == 'hidden_pair' ||
        technique == 'pointing_pair' ||
        technique == 'x_wing',
  );
}

String _normalizedDigitKey(List<String> rows) {
  var nextDigit = 1;
  final remap = <String, String>{'0': '0'};
  final buffer = StringBuffer();
  for (final row in rows) {
    for (final char in row.split('')) {
      remap.putIfAbsent(char, () => (nextDigit++).toString());
      buffer.write(remap[char]);
    }
  }
  return buffer.toString();
}

int _targetTimeFor(SudokuDifficulty difficulty) {
  return switch (difficulty) {
    SudokuDifficulty.beginner => 360,
    SudokuDifficulty.easy => 540,
    SudokuDifficulty.medium => 720,
    SudokuDifficulty.hard => 960,
    SudokuDifficulty.expert => 1200,
    SudokuDifficulty.extreme => 1500,
  };
}
