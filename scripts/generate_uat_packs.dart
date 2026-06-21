import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_board.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_difficulty.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/human_ranked_solver.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_difficulty_rater.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_generator.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/fixture_puzzles.dart';

const String _contentVersion = '2026.06.001';
const String _generatedAt = '2026-06-21';
const String _generatorVersion = 'sudoku-pack-generator-1.1.0';
const String _validatorVersion = 'sudoku-pack-validator-1.1.0';
const String _solverVersion = 'human-solver-1.0.0';

void main() {
  final outputDir = Directory('assets/puzzles')..createSync(recursive: true);
  final random = Random(20260620);
  final generator = SudokuGenerator(random: random);
  final rater = const SudokuDifficultyRater();
  final solver = HumanRankedSolver();

  final packs = <PackPlan>[
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
      description:
          'Hard UAT puzzles focused on pair and pointing eliminations.',
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
      description:
          'Candidate ranked puzzles for future leaderboard validation.',
      count: 10,
      minimumScore: 240,
      cellsToRemove: 55,
      targetDifficulty: SudokuDifficulty.expert,
      requiredAdvancedRatio: 1,
      rankedEligible: true,
    ),
  ];

  final manifestPacks = <Map<String, Object?>>[];
  final usedPuzzleRows = <String>{};
  for (final plan in packs) {
    final puzzles = <FixturePuzzleDefinition>[];
    var advancedCount = 0;
    var attempts = 0;
    while (puzzles.length < plan.count && attempts < plan.count * 220) {
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
      final rowKey = givensRows.join();
      if (usedPuzzleRows.contains(rowKey)) {
        continue;
      }
      final advanced = _hasAdvancedTechnique(rating.requiredTechniques);
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
      if (advanced) {
        advancedCount++;
      }
      puzzles.add(
        FixturePuzzleDefinition(
          id: '${plan.id}_${(puzzles.length + 1).toString().padLeft(3, '0')}',
          title:
              '${plan.title} ${(puzzles.length + 1).toString().padLeft(2, '0')}',
          seal: plan.seal,
          packId: plan.id,
          difficulty: _bestDifficulty(plan.targetDifficulty, rating.difficulty),
          difficultyScore: max(rating.score, plan.minimumScore),
          targetTimeSeconds: _targetTimeFor(plan.targetDifficulty),
          medianTimeSeconds: _targetTimeFor(plan.targetDifficulty) + 180,
          requiredTechniques: rating.requiredTechniques,
          rankedEligible: plan.rankedEligible,
          givensRows: givensRows,
          solutionRows: _rowsFromBoard(puzzle.solution),
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
    final asset = 'assets/puzzles/${plan.id}.json';
    File(asset).writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(<String, Object?>{'schemaVersion': 1, 'contentVersion': _contentVersion, 'generatedAt': _generatedAt, 'generatorVersion': _generatorVersion, 'validatorVersion': _validatorVersion, 'solverVersion': _solverVersion, 'contentSource': 'deterministic local generator seed 20260620', 'curationStrategy': plan.curationStrategy, 'milestoneEvery': plan.milestoneEvery, 'id': plan.id, 'puzzles': curatedPuzzles.map((puzzle) => puzzle.toJson()).toList()})}\n',
    );
    manifestPacks.add(<String, Object?>{
      'id': plan.id,
      'title': plan.title,
      'subtitle': plan.subtitle,
      'seal': plan.seal,
      'description': plan.description,
      'asset': asset,
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
    '${const JsonEncoder.withIndent('  ').convert(<String, Object?>{'schemaVersion': 1, 'contentVersion': _contentVersion, 'generatedAt': _generatedAt, 'generatorVersion': _generatorVersion, 'validatorVersion': _validatorVersion, 'solverVersion': _solverVersion, 'contentSource': 'deterministic local generator seed 20260620', 'packs': manifestPacks})}\n',
  );
}

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
    this.rankedEligible = false,
    this.milestoneEvery = 10,
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
