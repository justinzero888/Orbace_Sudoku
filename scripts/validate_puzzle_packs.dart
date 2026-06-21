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
  final seenDigitNormalized = <String, String>{};
  final seenSymmetrySignature = <String, String>{};
  final seenSolutions = <String, List<String>>{};
  final results = <Map<String, Object?>>[];
  final failures = <String>[];
  final warnings = <String>[];

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
      final digitNormalizedKey = _normalizedDigitKey(puzzle.givensRows);
      final digitNormalizedMatch = seenDigitNormalized[digitNormalizedKey];
      if (digitNormalizedMatch != null) {
        failures.add(
          'Digit-remapped duplicate: ${puzzle.id} matches '
          '$digitNormalizedMatch',
        );
      } else {
        seenDigitNormalized[digitNormalizedKey] = puzzle.id;
      }
      final symmetrySignature = _symmetrySignature(puzzle.givensRows);
      final symmetryMatch = seenSymmetrySignature[symmetrySignature];
      if (symmetryMatch != null) {
        warnings.add(
          'Possible row/column/band/stack duplicate: ${puzzle.id} resembles '
          '$symmetryMatch',
        );
      } else {
        seenSymmetrySignature[symmetrySignature] = puzzle.id;
      }
      final solutionKey = _normalizedDigitKey(puzzle.solutionRows);
      final solutionMatches = seenSolutions.putIfAbsent(
        solutionKey,
        () => <String>[],
      );
      if (solutionMatches.isNotEmpty) {
        warnings.add(
          'Shared normalized solution grid: ${puzzle.id} shares pattern with '
          '${solutionMatches.first}',
        );
      }
      solutionMatches.add(puzzle.id);
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
    '${const JsonEncoder.withIndent('  ').convert(<String, Object?>{'validatedAt': DateTime.now().toIso8601String(), 'puzzleCount': seenIds.length, 'packResults': results, 'warnings': warnings, 'failures': failures})}\n',
  );
  File('${reportDir.path}/puzzle_pack_validation.md').writeAsStringSync(
    _markdownReport(seenIds.length, results, warnings, failures),
  );

  stdout.writeln('Validated ${seenIds.length} puzzles.');
  for (final result in results) {
    stdout.writeln(
      '${result['packId']}: ${result['puzzleCount']} puzzles, '
      '${result['advancedCount']} advanced',
    );
  }
  stdout.writeln('${warnings.length} duplicate-scan warnings.');
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

String _symmetrySignature(List<String> rows) {
  var best = _normalizedDigitKey(rows);
  for (final bandOrder in _permutations) {
    for (final stackOrder in _permutations) {
      final transformed = _normalizeWithinBoxes(
        _applyBandAndStackOrder(rows, bandOrder, stackOrder),
      );
      final key = _normalizedDigitKey(transformed);
      if (key.compareTo(best) < 0) {
        best = key;
      }
    }
  }
  return best;
}

List<String> _applyBandAndStackOrder(
  List<String> rows,
  List<int> bandOrder,
  List<int> stackOrder,
) {
  final rowOrder = <int>[
    for (final band in bandOrder)
      for (var offset = 0; offset < 3; offset++) band * 3 + offset,
  ];
  final colOrder = <int>[
    for (final stack in stackOrder)
      for (var offset = 0; offset < 3; offset++) stack * 3 + offset,
  ];

  return <String>[
    for (final rowIndex in rowOrder)
      [for (final colIndex in colOrder) rows[rowIndex][colIndex]].join(),
  ];
}

List<String> _normalizeWithinBoxes(List<String> rows) {
  var normalized = rows;
  for (var i = 0; i < 3; i++) {
    normalized = _sortRowsWithinBands(normalized);
    normalized = _sortColumnsWithinStacks(normalized);
  }
  return normalized;
}

List<String> _sortRowsWithinBands(List<String> rows) {
  return <String>[
    for (var band = 0; band < 3; band++)
      ...(<String>[
        for (var offset = 0; offset < 3; offset++) rows[band * 3 + offset],
      ]..sort()),
  ];
}

List<String> _sortColumnsWithinStacks(List<String> rows) {
  final colOrder = <int>[];
  for (var stack = 0; stack < 3; stack++) {
    final columns = <({int index, String value})>[
      for (var offset = 0; offset < 3; offset++)
        (
          index: stack * 3 + offset,
          value: [
            for (var row = 0; row < 9; row++) rows[row][stack * 3 + offset],
          ].join(),
        ),
    ]..sort((a, b) => a.value.compareTo(b.value));
    colOrder.addAll(columns.map((column) => column.index));
  }

  return <String>[
    for (final row in rows)
      [for (final colIndex in colOrder) row[colIndex]].join(),
  ];
}

const List<List<int>> _permutations = <List<int>>[
  <int>[0, 1, 2],
  <int>[0, 2, 1],
  <int>[1, 0, 2],
  <int>[1, 2, 0],
  <int>[2, 0, 1],
  <int>[2, 1, 0],
];

String _markdownReport(
  int puzzleCount,
  List<Map<String, Object?>> results,
  List<String> warnings,
  List<String> failures,
) {
  final buffer = StringBuffer()
    ..writeln('# Puzzle Pack Validation')
    ..writeln()
    ..writeln('- Total puzzles: $puzzleCount')
    ..writeln('- Status: ${failures.isEmpty ? 'PASS' : 'FAIL'}')
    ..writeln('- Duplicate-scan warnings: ${warnings.length}')
    ..writeln()
    ..writeln('| Pack | Puzzles | Advanced |')
    ..writeln('| --- | ---: | ---: |');
  for (final result in results) {
    buffer.writeln(
      '| ${result['packId']} | ${result['puzzleCount']} | '
      '${result['advancedCount']} |',
    );
  }
  if (warnings.isNotEmpty) {
    buffer
      ..writeln()
      ..writeln('## Duplicate-Scan Warnings');
    for (final warning in warnings) {
      buffer.writeln('- $warning');
    }
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
