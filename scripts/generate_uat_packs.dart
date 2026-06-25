import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_board.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_difficulty.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/human_ranked_solver.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_difficulty_rater.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_generator.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/fixture_puzzles.dart';

const String _uatContentVersion = '2026.06.001';
const String _productionContentVersion = '2026.06.002';
const String _generatedAt = '2026-06-21';
const String _generatorVersion = 'sudoku-pack-generator-1.2.0';
const String _validatorVersion = 'sudoku-pack-validator-1.1.0';
const String _solverVersion = 'human-solver-1.0.0';
const int _productionBatchSize = 60;

void main(List<String> args) {
  final productionMode = args.contains('--production');
  final contentVersion = productionMode
      ? _productionContentVersion
      : _uatContentVersion;
  final contentSource = productionMode
      ? 'deterministic production generator seed 20260621'
      : 'deterministic UAT generator seed 20260620';
  final outputDir = Directory('assets/puzzles')..createSync(recursive: true);
  final random = Random(productionMode ? 20260621 : 20260620);
  final generator = SudokuGenerator(random: random);
  final rater = const SudokuDifficultyRater();
  final solver = HumanRankedSolver();

  final packs = productionMode ? _productionPacks : _uatPacks;

  final manifestPacks = <Map<String, Object?>>[];
  final usedPuzzleRows = <String>{};
  final usedSolutionKeys = <String>{};
  for (final plan in packs) {
    final puzzles = <FixturePuzzleDefinition>[];
    var advancedCount = 0;
    var attempts = 0;
    final maxOuterAttempts = plan.count * plan.maxAttemptMultiplier;
    while (puzzles.length < plan.count && attempts < maxOuterAttempts) {
      attempts++;
      final puzzle = generator.generatePuzzle(
        id: '${plan.id}_${(puzzles.length + 1).toString().padLeft(3, '0')}',
        cellsToRemove: plan.cellsToRemove + random.nextInt(3) - 1,
        maxAttempts: 260,
      );
      final result = solver.solve(puzzle.givens);
      if (!result.solved) {
        continue;
      }
      final rating = rater.rate(result.steps);
      final givensRows = _rowsFromBoard(puzzle.givens);
      final solutionRows = _rowsFromBoard(puzzle.solution);
      final rowKey = givensRows.join();
      if (usedPuzzleRows.contains(rowKey)) {
        continue;
      }
      final solutionKey = _normalizedDigitKey(solutionRows);
      if (usedSolutionKeys.contains(solutionKey)) {
        continue;
      }
      final advanced = _hasAdvancedTechnique(rating.requiredTechniques);
      if (advanced && !plan.allowAdvanced) {
        continue;
      }
      final neededAdvanced = (plan.count * plan.requiredAdvancedRatio).ceil();
      final canAcceptBasic =
          advancedCount >= neededAdvanced ||
          plan.requiredAdvancedRatio == 0 ||
          puzzles.length < plan.count - neededAdvanced;
      if (!advanced && !canAcceptBasic) {
        continue;
      }
      if (rating.score < plan.minimumScore && !advanced) {
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
          difficulty: _bestDifficulty(plan.targetDifficulty, rating.difficulty),
          difficultyScore: max(rating.score, plan.minimumScore),
          targetTimeSeconds: _targetTimeFor(plan.targetDifficulty),
          medianTimeSeconds: _targetTimeFor(plan.targetDifficulty) + 180,
          requiredTechniques: rating.requiredTechniques,
          rankedEligible: plan.rankedEligible,
          givensRows: givensRows,
          solutionRows: solutionRows,
        ),
      );
    }

    if (puzzles.length != plan.count) {
      stderr.writeln(
        'Generated ${puzzles.length}/${plan.count} puzzles for ${plan.id}.',
      );
      exitCode = 1;
      return;
    }

    final curatedPuzzles = _curatePuzzles(plan, puzzles);
    final assets = _writePackAssets(
      plan: plan,
      puzzles: curatedPuzzles,
      contentVersion: contentVersion,
      contentSource: contentSource,
      batched: productionMode,
    );
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
    stdout.writeln(
      '${plan.id}: ${puzzles.length} puzzles, $advancedCount advanced',
    );
  }

  File('${outputDir.path}/packs.json').writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(<String, Object?>{'schemaVersion': 1, 'contentVersion': contentVersion, 'generatedAt': _generatedAt, 'generatorVersion': _generatorVersion, 'validatorVersion': _validatorVersion, 'solverVersion': _solverVersion, 'contentSource': contentSource, 'packs': manifestPacks})}\n',
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
    title: 'Extreme Challenge',
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
    minimumScore: 145,
    cellsToRemove: 49,
    targetDifficulty: SudokuDifficulty.medium,
    requiredAdvancedRatio: 0.35,
  ),
  PackPlan(
    id: 'mastery',
    title: 'Mastery',
    subtitle: 'Hard technique practice',
    seal: '極',
    description: 'Hard puzzles for advanced human-logic practice.',
    count: 270,
    minimumScore: 185,
    cellsToRemove: 52,
    targetDifficulty: SudokuDifficulty.hard,
    requiredAdvancedRatio: 0.7,
  ),
  PackPlan(
    id: 'extreme',
    title: 'Extreme Challenge',
    subtitle: 'Ranked challenge seeds',
    seal: '榜',
    description: 'Expert challenge candidates for no-assist ranked play.',
    count: 270,
    minimumScore: 220,
    cellsToRemove: 54,
    targetDifficulty: SudokuDifficulty.expert,
    requiredAdvancedRatio: 0.9,
    rankedEligible: true,
    maxAttemptMultiplier: 520,
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
  final double requiredAdvancedRatio;
  final bool rankedEligible;
  final int milestoneEvery;
  final bool allowAdvanced;
  final int maxAttemptMultiplier;

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
        technique == 'pointing_pair',
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

SudokuDifficulty _bestDifficulty(
  SudokuDifficulty target,
  SudokuDifficulty generated,
) {
  if (generated.index > target.index) {
    return generated;
  }
  return target;
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
