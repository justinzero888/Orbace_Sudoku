import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_difficulty.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/human_ranked_solver.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/fixture_puzzles.dart';

const int _targetCount = 100;
const int _seed = 20260702;
const String _contentVersion = '2026.07.true-extreme.001';
const String _generatedAt = '2026-07-02';
const String _generatorVersion = 'true-extreme-generator-1.0.0';
const String _validatorVersion = 'true-extreme-validator-1.0.0';
const String _solverVersion = 'search-complexity-solver-1.0.0';

void main(List<String> args) {
  final targetCount = args.isNotEmpty ? int.parse(args[0]) : _targetCount;
  final random = Random(_seed);
  final humanSolver = HumanRankedSolver();
  final puzzles = <FixturePuzzleDefinition>[];
  final audits = <Map<String, Object?>>[];
  final seenGivens = <String>{};
  final seenSolutions = <String>{};
  var attempts = 0;

  while (puzzles.length < targetCount && attempts < targetCount * 3000) {
    attempts++;
    final solution = _randomSolvedGrid(random);
    final candidate = _digExtremeCandidate(solution, random);
    if (candidate == null) {
      continue;
    }

    final givens = _rowsFromCells(candidate);
    final solutionRows = _rowsFromCells(solution);
    final givensKey = givens.join();
    final solutionKey = _normalizedDigitKey(solutionRows);
    if (!seenGivens.add(givensKey) || !seenSolutions.add(solutionKey)) {
      continue;
    }

    final humanResult = humanSolver.solve(FixturePuzzles.boardFromRows(givens));
    final searchAudit = _SearchAuditor(candidate)..solve();
    final clueCount = givensKey.replaceAll('0', '').length;
    final searchScore = _searchScore(searchAudit.nodes, clueCount);
    final accepted =
        clueCount <= 24 &&
        !humanResult.solved &&
        searchAudit.solutionCount == 1 &&
        searchScore >= 900;
    if (!accepted) {
      seenGivens.remove(givensKey);
      seenSolutions.remove(solutionKey);
      continue;
    }

    final number = puzzles.length + 1;
    final id = 'true_extreme_${number.toString().padLeft(3, '0')}';
    puzzles.add(
      FixturePuzzleDefinition(
        id: id,
        title: 'True Extreme ${number.toString().padLeft(2, '0')}',
        seal: '極',
        packId: 'true_extreme',
        difficulty: SudokuDifficulty.extreme,
        difficultyScore: searchScore,
        targetTimeSeconds: 1800,
        medianTimeSeconds: 2400,
        requiredTechniques: const <String>[
          'advanced_search',
          'beyond_current_hint_solver',
        ],
        rankedEligible: true,
        givensRows: givens,
        solutionRows: solutionRows,
      ),
    );
    audits.add(<String, Object?>{
      'id': id,
      'clues': clueCount,
      'searchNodes': searchAudit.nodes,
      'searchScore': searchScore,
      'humanSolverSolved': humanResult.solved,
      'givens': givensKey,
      'solution': solutionRows.join(),
    });

    if (puzzles.length % 10 == 0) {
      stdout.writeln(
        'Generated ${puzzles.length}/$targetCount after $attempts attempts.',
      );
    }
  }

  if (puzzles.length != targetCount) {
    stderr.writeln(
      'Generated ${puzzles.length}/$targetCount true extreme puzzles after '
      '$attempts attempts.',
    );
    exit(1);
  }

  _writePack(puzzles, audits, attempts);
}

List<int> _randomSolvedGrid(Random random) {
  final cells = List<int>.filled(81, 0);
  final rowMask = List<int>.filled(9, 0);
  final colMask = List<int>.filled(9, 0);
  final boxMask = List<int>.filled(9, 0);

  bool fill() {
    var bestIndex = -1;
    var bestMask = 0;
    var bestCount = 10;
    for (var index = 0; index < 81; index++) {
      if (cells[index] != 0) {
        continue;
      }
      final row = index ~/ 9;
      final col = index % 9;
      final box = (row ~/ 3) * 3 + col ~/ 3;
      final mask = 0x1FF & ~(rowMask[row] | colMask[col] | boxMask[box]);
      final count = _popCount(mask);
      if (count < bestCount) {
        bestIndex = index;
        bestMask = mask;
        bestCount = count;
      }
    }
    if (bestIndex == -1) {
      return true;
    }

    final digits = _digitsFromMask(bestMask)..shuffle(random);
    final row = bestIndex ~/ 9;
    final col = bestIndex % 9;
    final box = (row ~/ 3) * 3 + col ~/ 3;
    for (final digit in digits) {
      final bit = 1 << (digit - 1);
      cells[bestIndex] = digit;
      rowMask[row] |= bit;
      colMask[col] |= bit;
      boxMask[box] |= bit;
      if (fill()) {
        return true;
      }
      rowMask[row] &= ~bit;
      colMask[col] &= ~bit;
      boxMask[box] &= ~bit;
      cells[bestIndex] = 0;
    }
    return false;
  }

  if (!fill()) {
    throw StateError('Unable to generate solved grid');
  }
  return cells;
}

List<int>? _digExtremeCandidate(List<int> solution, Random random) {
  var best = solution.toList();
  var bestClues = 81;
  final preferredTargets = <int>[17, 18, 19, 20, 21, 22, 23, 24];

  for (var pass = 0; pass < 12; pass++) {
    final target = preferredTargets[random.nextInt(preferredTargets.length)];
    final cells = solution.toList();
    final indices = List<int>.generate(81, (index) => index)..shuffle(random);
    var clues = 81;

    for (final index in indices) {
      if (clues <= target) {
        break;
      }
      final previous = cells[index];
      cells[index] = 0;
      final audit = _SearchAuditor(cells, stopAfterSolutions: 2)..solve();
      if (audit.solutionCount == 1) {
        clues--;
      } else {
        cells[index] = previous;
      }
    }

    if (clues < bestClues) {
      best = cells.toList();
      bestClues = clues;
    }
    if (bestClues <= 24) {
      return best;
    }
  }

  return bestClues <= 26 ? best : null;
}

int _searchScore(int nodes, int clues) {
  return max(320, nodes ~/ 8 + (24 - clues) * 45);
}

void _writePack(
  List<FixturePuzzleDefinition> puzzles,
  List<Map<String, Object?>> audits,
  int attempts,
) {
  final outputDir = Directory('assets/puzzles/true_extreme')
    ..createSync(recursive: true);
  final asset = File('${outputDir.path}/true_extreme_01.json');
  final payload = <String, Object?>{
    'schemaVersion': 1,
    'contentVersion': _contentVersion,
    'generatedAt': _generatedAt,
    'generatorVersion': _generatorVersion,
    'validatorVersion': _validatorVersion,
    'solverVersion': _solverVersion,
    'contentSource':
        'deterministic true-extreme generator seed $_seed; unique low-clue '
        'puzzles beyond current Orbace teaching hint solver',
    'curationStrategy':
        'true extreme: unique solution, 24 or fewer clues, current human '
        'hint solver cannot complete, search score >= 900',
    'milestoneEvery': 10,
    'id': 'true_extreme',
    'puzzles': puzzles.map((puzzle) => puzzle.toJson()).toList(),
  };
  asset.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(payload)}\n',
  );

  final reportDir = Directory('Docs/exports')..createSync(recursive: true);
  File(
    '${reportDir.path}/true_extreme_pack_audit_2026-07-02.json',
  ).writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(<String, Object?>{'generatedAt': DateTime.now().toIso8601String(), 'attempts': attempts, 'puzzleCount': puzzles.length, 'minClues': audits.map((row) => row['clues']! as int).reduce(min), 'maxClues': audits.map((row) => row['clues']! as int).reduce(max), 'minSearchScore': audits.map((row) => row['searchScore']! as int).reduce(min), 'maxSearchScore': audits.map((row) => row['searchScore']! as int).reduce(max), 'puzzles': audits})}\n',
  );
  File(
    '${reportDir.path}/true_extreme_pack_2026-07-02.csv',
  ).writeAsStringSync(_csv(audits));

  stdout.writeln('Wrote ${asset.path}');
  stdout.writeln('Wrote Docs/exports/true_extreme_pack_audit_2026-07-02.json');
  stdout.writeln('Wrote Docs/exports/true_extreme_pack_2026-07-02.csv');
}

String _csv(List<Map<String, Object?>> audits) {
  final buffer = StringBuffer()
    ..writeln(
      'id,clues,search_nodes,search_score,human_solver_solved,givens_81,solution_81',
    );
  for (final row in audits) {
    buffer.writeln(
      [
        row['id'],
        row['clues'],
        row['searchNodes'],
        row['searchScore'],
        row['humanSolverSolved'],
        row['givens'],
        row['solution'],
      ].join(','),
    );
  }
  return buffer.toString();
}

List<String> _rowsFromCells(List<int> cells) {
  return <String>[
    for (var row = 0; row < 9; row++)
      [
        for (var col = 0; col < 9; col++) cells[row * 9 + col].toString(),
      ].join(),
  ];
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

List<int> _digitsFromMask(int mask) {
  final digits = <int>[];
  for (var digit = 1; digit <= 9; digit++) {
    if ((mask & (1 << (digit - 1))) != 0) {
      digits.add(digit);
    }
  }
  return digits;
}

int _popCount(int mask) {
  var value = mask;
  var count = 0;
  while (value != 0) {
    value &= value - 1;
    count++;
  }
  return count;
}

class _SearchAuditor {
  _SearchAuditor(List<int> initialCells, {this.stopAfterSolutions = 1})
    : cells = initialCells.toList(),
      _rowMask = List<int>.filled(9, 0),
      _colMask = List<int>.filled(9, 0),
      _boxMask = List<int>.filled(9, 0) {
    for (var index = 0; index < 81; index++) {
      final value = cells[index];
      if (value != 0) {
        _place(index, value);
      }
    }
  }

  final List<int> cells;
  final int stopAfterSolutions;
  final List<int> _rowMask;
  final List<int> _colMask;
  final List<int> _boxMask;
  int solutionCount = 0;
  int nodes = 0;

  void solve() {
    _search();
  }

  bool _search() {
    if (solutionCount >= stopAfterSolutions) {
      return true;
    }
    nodes++;

    final index = _bestEmptyIndex();
    if (index == -1) {
      solutionCount++;
      return solutionCount >= stopAfterSolutions;
    }

    var mask = _candidateMask(index);
    while (mask != 0) {
      final bit = mask & -mask;
      final value = _digitForBit(bit);
      mask &= ~bit;
      cells[index] = value;
      _place(index, value);
      final done = _search();
      _unplace(index, value);
      cells[index] = 0;
      if (done) {
        return true;
      }
    }
    return false;
  }

  int _bestEmptyIndex() {
    var bestIndex = -1;
    var bestCount = 10;
    for (var index = 0; index < 81; index++) {
      if (cells[index] != 0) {
        continue;
      }
      final count = _popCount(_candidateMask(index));
      if (count == 0) {
        return index;
      }
      if (count < bestCount) {
        bestIndex = index;
        bestCount = count;
        if (count == 1) {
          break;
        }
      }
    }
    return bestIndex;
  }

  int _candidateMask(int index) {
    final row = index ~/ 9;
    final col = index % 9;
    final box = (row ~/ 3) * 3 + col ~/ 3;
    return 0x1FF & ~(_rowMask[row] | _colMask[col] | _boxMask[box]);
  }

  void _place(int index, int value) {
    final bit = 1 << (value - 1);
    final row = index ~/ 9;
    final col = index % 9;
    final box = (row ~/ 3) * 3 + col ~/ 3;
    _rowMask[row] |= bit;
    _colMask[col] |= bit;
    _boxMask[box] |= bit;
  }

  void _unplace(int index, int value) {
    final bit = 1 << (value - 1);
    final row = index ~/ 9;
    final col = index % 9;
    final box = (row ~/ 3) * 3 + col ~/ 3;
    _rowMask[row] &= ~bit;
    _colMask[col] &= ~bit;
    _boxMask[box] &= ~bit;
  }

  int _digitForBit(int bit) {
    var value = 1;
    var shifted = bit;
    while (shifted > 1) {
      shifted >>= 1;
      value++;
    }
    return value;
  }
}
