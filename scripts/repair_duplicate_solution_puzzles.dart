import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_board.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_difficulty.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/human_ranked_solver.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_difficulty_rater.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_generator.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/fixture_puzzles.dart';

const String _repairedContentVersion = '2026.06.003';
const String _repairedContentSource =
    'deterministic production generator seed 20260621; duplicate-solution '
    'repair seed 20260622';

void main() {
  final manifestFile = File('assets/puzzles/packs.json');
  final manifest =
      jsonDecode(manifestFile.readAsStringSync()) as Map<String, Object?>;
  final packs = (manifest['packs']! as List<Object?>)
      .cast<Map<String, Object?>>();

  final loadedPuzzles = <_LoadedPuzzle>[];
  final packPayloads = <String, Map<String, Object?>>{};
  for (final pack in packs) {
    final packId = pack['id']! as String;
    for (final asset in _assetPathsForPack(pack)) {
      final payload =
          jsonDecode(File(asset).readAsStringSync()) as Map<String, Object?>;
      packPayloads[asset] = payload;
      final puzzleItems = (payload['puzzles']! as List<Object?>)
          .cast<Map<String, Object?>>();
      for (var index = 0; index < puzzleItems.length; index++) {
        loadedPuzzles.add(
          _LoadedPuzzle(
            packId: packId,
            asset: asset,
            index: index,
            json: puzzleItems[index],
            puzzle: FixturePuzzleDefinition.fromJson(
              puzzleItems[index],
              packId: packId,
            ),
          ),
        );
      }
    }
  }

  final duplicateTargets = _findDuplicateTargets(loadedPuzzles);
  stdout.writeln(
    'Found ${duplicateTargets.length} duplicate normalized solution targets.',
  );
  if (duplicateTargets.isEmpty) {
    return;
  }

  final usedGivens = <String>{};
  final usedSolutions = <String>{};
  final targetIds = duplicateTargets.map((target) => target.puzzle.id).toSet();
  for (final loaded in loadedPuzzles) {
    if (targetIds.contains(loaded.puzzle.id)) {
      continue;
    }
    usedGivens.add(loaded.puzzle.givensRows.join());
    usedSolutions.add(_normalizedDigitKey(loaded.puzzle.solutionRows));
  }

  final generator = SudokuGenerator(random: Random(20260622));
  final solver = HumanRankedSolver();
  final rater = const SudokuDifficultyRater();

  for (final target in duplicateTargets) {
    final plan = _productionPlanById[target.packId]!;
    final original = target.puzzle;
    var attempts = 0;
    FixturePuzzleDefinition? replacement;
    while (replacement == null && attempts < plan.maxRepairAttempts) {
      attempts++;
      final generated = generator.generatePuzzle(
        id: original.id,
        cellsToRemove: plan.cellsToRemove + attempts % 3 - 1,
        maxAttempts: 300,
      );
      final result = solver.solve(generated.givens);
      if (!result.solved) {
        continue;
      }
      final rating = rater.rate(result.steps);
      final givensRows = _rowsFromBoard(generated.givens);
      final solutionRows = _rowsFromBoard(generated.solution);
      final givensKey = givensRows.join();
      final solutionKey = _normalizedDigitKey(solutionRows);
      if (usedGivens.contains(givensKey) ||
          usedSolutions.contains(solutionKey)) {
        continue;
      }
      final advanced = _hasAdvancedTechnique(rating.requiredTechniques);
      if (advanced && !plan.allowAdvanced) {
        continue;
      }
      if (_hasAdvancedTechnique(original.requiredTechniques) && !advanced) {
        continue;
      }
      // Band acceptance is the actual re-rated difficulty, never the target
      // label -- matches the generator fix in generate_uat_packs.dart.
      if (rating.difficulty != plan.targetDifficulty ||
          rating.score < plan.minimumScore) {
        continue;
      }

      usedGivens.add(givensKey);
      usedSolutions.add(solutionKey);
      replacement = FixturePuzzleDefinition(
        id: original.id,
        title: original.title,
        seal: original.seal,
        packId: original.packId,
        difficulty: rating.difficulty,
        difficultyScore: rating.score,
        targetTimeSeconds: _targetTimeFor(plan.targetDifficulty),
        medianTimeSeconds: _targetTimeFor(plan.targetDifficulty) + 180,
        requiredTechniques: rating.requiredTechniques,
        rankedEligible: original.rankedEligible,
        givensRows: givensRows,
        solutionRows: solutionRows,
      );
    }

    if (replacement == null) {
      stderr.writeln(
        'Could not repair ${original.id} after $attempts attempts',
      );
      exitCode = 1;
      return;
    }

    final payload = packPayloads[target.asset]!;
    final puzzleItems = (payload['puzzles']! as List<Object?>)
        .cast<Map<String, Object?>>();
    puzzleItems[target.index] = replacement.toJson();
    stdout.writeln('Repaired ${original.id} in $attempts attempts.');
  }

  manifest['contentVersion'] = _repairedContentVersion;
  manifest['contentSource'] = _repairedContentSource;
  manifestFile.writeAsStringSync('${_pretty(manifest)}\n');

  for (final pack in packs) {
    final packIndexFile = File('assets/puzzles/${pack['id']}.json');
    if (packIndexFile.existsSync()) {
      final indexPayload =
          jsonDecode(packIndexFile.readAsStringSync()) as Map<String, Object?>;
      _updateMetadata(indexPayload);
      packIndexFile.writeAsStringSync('${_pretty(indexPayload)}\n');
    }
  }

  for (final entry in packPayloads.entries) {
    final payload = entry.value;
    _updateMetadata(payload);
    File(entry.key).writeAsStringSync('${_pretty(payload)}\n');
  }
}

List<_LoadedPuzzle> _findDuplicateTargets(List<_LoadedPuzzle> puzzles) {
  final seenSolutions = <String, _LoadedPuzzle>{};
  final duplicateTargets = <_LoadedPuzzle>[];
  for (final loaded in puzzles) {
    final solutionKey = _normalizedDigitKey(loaded.puzzle.solutionRows);
    final existing = seenSolutions[solutionKey];
    if (existing != null) {
      duplicateTargets.add(loaded);
    } else {
      seenSolutions[solutionKey] = loaded;
    }
  }
  return duplicateTargets;
}

void _updateMetadata(Map<String, Object?> payload) {
  payload['contentVersion'] = _repairedContentVersion;
  payload['contentSource'] = _repairedContentSource;
}

List<String> _assetPathsForPack(Map<String, Object?> pack) {
  final assets = pack['assets'];
  if (assets != null) {
    return (assets as List<Object?>).cast<String>();
  }
  return <String>[pack['asset']! as String];
}

String _pretty(Object? value) {
  return const JsonEncoder.withIndent('  ').convert(value);
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

final Map<String, _RepairPlan> _productionPlanById = <String, _RepairPlan>{
  'tea_moments': _RepairPlan(
    cellsToRemove: 40,
    minimumScore: 70,
    targetDifficulty: SudokuDifficulty.beginner,
    allowAdvanced: false,
  ),
  'foundation': _RepairPlan(
    cellsToRemove: 43,
    minimumScore: 80,
    targetDifficulty: SudokuDifficulty.beginner,
    allowAdvanced: false,
  ),
  'discipline': _RepairPlan(
    cellsToRemove: 46,
    minimumScore: 110,
    targetDifficulty: SudokuDifficulty.easy,
  ),
  // cellsToRemove values match the tuned production plans in
  // generate_uat_packs.dart (2026-07-02 empirical yield probes).
  'insight': _RepairPlan(
    cellsToRemove: 51,
    minimumScore: 145,
    targetDifficulty: SudokuDifficulty.medium,
    maxRepairAttempts: 8000,
  ),
  'mastery': _RepairPlan(
    cellsToRemove: 55,
    minimumScore: 195,
    targetDifficulty: SudokuDifficulty.hard,
    maxRepairAttempts: 20000,
  ),
  'extreme': _RepairPlan(
    cellsToRemove: 58,
    minimumScore: 260,
    targetDifficulty: SudokuDifficulty.expert,
    maxRepairAttempts: 40000,
  ),
};

class _RepairPlan {
  const _RepairPlan({
    required this.cellsToRemove,
    required this.minimumScore,
    required this.targetDifficulty,
    this.allowAdvanced = true,
    this.maxRepairAttempts = 4000,
  });

  final int cellsToRemove;
  final int minimumScore;
  final SudokuDifficulty targetDifficulty;
  final bool allowAdvanced;
  final int maxRepairAttempts;
}

class _LoadedPuzzle {
  const _LoadedPuzzle({
    required this.packId,
    required this.asset,
    required this.index,
    required this.json,
    required this.puzzle,
  });

  final String packId;
  final String asset;
  final int index;
  final Map<String, Object?> json;
  final FixturePuzzleDefinition puzzle;
}
