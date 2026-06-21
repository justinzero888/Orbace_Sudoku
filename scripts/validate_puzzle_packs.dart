import 'dart:convert';
import 'dart:io';

import 'package:orbace_sudoku/src/features/sudoku/engine/human_ranked_solver.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_solver.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/fixture_puzzles.dart';

void main() {
  final manifestFile = File('assets/puzzles/packs.json');
  if (!manifestFile.existsSync()) {
    stderr.writeln('Missing assets/puzzles/packs.json');
    exit(1);
  }

  final manifest =
      jsonDecode(manifestFile.readAsStringSync()) as Map<String, Object?>;
  final packs = (manifest['packs']! as List<Object?>)
      .cast<Map<String, Object?>>();
  final solver = SudokuSolver();
  final humanSolver = HumanRankedSolver();
  final seenIds = <String>{};
  final seenGivens = <String>{};
  final results = <Map<String, Object?>>[];
  final failures = <String>[];

  for (final pack in packs) {
    final packId = pack['id']! as String;
    final assetPath = pack['asset']! as String;
    final payload =
        jsonDecode(File(assetPath).readAsStringSync()) as Map<String, Object?>;
    final puzzles = (payload['puzzles']! as List<Object?>)
        .cast<Map<String, Object?>>()
        .map((json) => FixturePuzzleDefinition.fromJson(json, packId: packId))
        .toList(growable: false);

    var advancedCount = 0;
    for (final puzzle in puzzles) {
      if (!seenIds.add(puzzle.id)) {
        failures.add('Duplicate id: ${puzzle.id}');
      }
      final rowKey = puzzle.givensRows.join();
      if (!seenGivens.add(rowKey)) {
        failures.add('Duplicate givens: ${puzzle.id}');
      }
      final solutionCount = solver.countSolutions(puzzle.givens, limit: 2);
      if (solutionCount != 1) {
        failures.add('${puzzle.id} has $solutionCount solutions');
      }
      final solved = solver.solve(puzzle.givens);
      if (solved?.cells.toString() != puzzle.solution.cells.toString()) {
        failures.add('${puzzle.id} stored solution mismatch');
      }
      final humanResult = humanSolver.solve(puzzle.givens);
      if (!humanResult.solved) {
        failures.add('${puzzle.id} is not compatible with hint solver');
      }
      if (_hasAdvancedTechnique(puzzle.requiredTechniques)) {
        advancedCount++;
      }
    }

    results.add(<String, Object?>{
      'packId': packId,
      'puzzleCount': puzzles.length,
      'advancedCount': advancedCount,
    });
  }

  final reportDir = Directory('build/reports')..createSync(recursive: true);
  File('${reportDir.path}/puzzle_pack_validation.json').writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(<String, Object?>{'validatedAt': DateTime.now().toIso8601String(), 'puzzleCount': seenIds.length, 'packResults': results, 'failures': failures})}\n',
  );
  File(
    '${reportDir.path}/puzzle_pack_validation.md',
  ).writeAsStringSync(_markdownReport(seenIds.length, results, failures));

  stdout.writeln('Validated ${seenIds.length} puzzles.');
  for (final result in results) {
    stdout.writeln(
      '${result['packId']}: ${result['puzzleCount']} puzzles, '
      '${result['advancedCount']} advanced',
    );
  }
  if (failures.isNotEmpty) {
    stderr.writeln(failures.join('\n'));
    exit(1);
  }
}

bool _hasAdvancedTechnique(List<String> techniques) {
  return techniques.any(
    (technique) =>
        technique == 'naked_pair' ||
        technique == 'hidden_pair' ||
        technique == 'pointing_pair',
  );
}

String _markdownReport(
  int puzzleCount,
  List<Map<String, Object?>> results,
  List<String> failures,
) {
  final buffer = StringBuffer()
    ..writeln('# Puzzle Pack Validation')
    ..writeln()
    ..writeln('- Total puzzles: $puzzleCount')
    ..writeln('- Status: ${failures.isEmpty ? 'PASS' : 'FAIL'}')
    ..writeln()
    ..writeln('| Pack | Puzzles | Advanced |')
    ..writeln('| --- | ---: | ---: |');
  for (final result in results) {
    buffer.writeln(
      '| ${result['packId']} | ${result['puzzleCount']} | '
      '${result['advancedCount']} |',
    );
  }
  if (failures.isNotEmpty) {
    buffer
      ..writeln()
      ..writeln('## Failures');
    for (final failure in failures) {
      buffer.writeln('- $failure');
    }
  }
  return buffer.toString();
}
