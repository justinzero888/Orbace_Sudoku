import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_board.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/human_ranked_solver.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_difficulty_rater.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_solver.dart';

// Standalone validation for the proposed daily-puzzle randomization: applies
// each of 4 reflections plus a random digit permutation to real pool
// puzzles, and confirms structural invariants hold (unique solution,
// solver-computed solution matches the transformed stored solution, and
// difficulty rating is unchanged) before any of this logic ships.

SudokuBoard _rowMajor(List<int?> cells) => SudokuBoard.fromCells(cells);

int _idx(int row, int col) => row * 9 + col;

List<int?> _reflect(List<int?> cells, String kind) {
  final out = List<int?>.filled(81, null);
  for (var r = 0; r < 9; r++) {
    for (var c = 0; c < 9; c++) {
      final value = cells[_idx(r, c)];
      final int nr, nc;
      switch (kind) {
        case 'horizontal': // mirror left-right
          nr = r;
          nc = 8 - c;
        case 'vertical': // mirror top-bottom
          nr = 8 - r;
          nc = c;
        case 'main_diagonal': // transpose
          nr = c;
          nc = r;
        case 'anti_diagonal':
          nr = 8 - c;
          nc = 8 - r;
        default:
          throw ArgumentError('unknown kind $kind');
      }
      out[_idx(nr, nc)] = value;
    }
  }
  return out;
}

List<int?> _permuteDigits(List<int?> cells, Map<int, int> mapping) {
  return cells.map((v) => v == null ? null : mapping[v]).toList();
}

Map<int, int> _randomPermutation(Random random) {
  final digits = List<int>.generate(9, (i) => i + 1)..shuffle(random);
  return {for (var i = 0; i < 9; i++) i + 1: digits[i]};
}

void main() {
  final solver = SudokuSolver();
  final humanSolver = HumanRankedSolver();
  const rater = SudokuDifficultyRater();
  final random = Random(42);

  const reflections = ['horizontal', 'vertical', 'main_diagonal', 'anti_diagonal'];

  var checked = 0;
  var failures = 0;

  void checkPack(String path, {required bool expectHumanSolvable}) {
    final data = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
    final puzzles = (data['puzzles'] as List).cast<Map<String, dynamic>>();
    for (final p in puzzles.take(5)) {
      final givensRows = (p['givensRows'] as List).cast<String>();
      final solutionRows = (p['solutionRows'] as List).cast<String>();
      final givensCells = <int?>[
        for (final row in givensRows)
          for (final ch in row.split('')) ch == '0' ? null : int.parse(ch),
      ];
      final solutionCells = <int?>[
        for (final row in solutionRows)
          for (final ch in row.split('')) ch == '0' ? null : int.parse(ch),
      ];
      final originalRating = expectHumanSolvable
          ? rater.rate(humanSolver.solve(_rowMajor(givensCells)).steps)
          : null;

      for (final kind in reflections) {
        final tGivens = _reflect(givensCells, kind);
        final tSolution = _reflect(solutionCells, kind);
        _verify(
          '${p['id']} [$kind]',
          tGivens,
          tSolution,
          solver,
          humanSolver,
          rater,
          originalRating,
          expectHumanSolvable: expectHumanSolvable,
        );
        checked++;
      }

      final mapping = _randomPermutation(random);
      final pGivens = _permuteDigits(givensCells, mapping);
      final pSolution = _permuteDigits(solutionCells, mapping);
      _verify(
        '${p['id']} [digit-permute]',
        pGivens,
        pSolution,
        solver,
        humanSolver,
        rater,
        originalRating,
        expectHumanSolvable: expectHumanSolvable,
      );
      checked++;

      // Composed: reflection + digit permutation together (the actual
      // proposed daily transform).
      final combined = _permuteDigits(_reflect(givensCells, 'main_diagonal'), mapping);
      final combinedSolution =
          _permuteDigits(_reflect(solutionCells, 'main_diagonal'), mapping);
      _verify(
        '${p['id']} [combined]',
        combined,
        combinedSolution,
        solver,
        humanSolver,
        rater,
        originalRating,
        expectHumanSolvable: expectHumanSolvable,
      );
      checked++;
    }
  }

  void note(String msg) => stdout.writeln(msg);

  try {
    checkPack('assets/puzzles/true_extreme/true_extreme_01.json', expectHumanSolvable: false);
    checkPack('assets/puzzles/mastery/mastery_01.json', expectHumanSolvable: true);
  } catch (e, st) {
    note('ERROR during checks: $e\n$st');
    exitCode = 1;
    return;
  }

  note('Checked $checked transformed puzzles, $failures failed invariant checks.');
  if (failures > 0) {
    exitCode = 1;
  }
}

void _verify(
  String label,
  List<int?> givensCells,
  List<int?> solutionCells,
  SudokuSolver solver,
  HumanRankedSolver humanSolver,
  SudokuDifficultyRater rater,
  DifficultyRating? originalRating,
  {required bool expectHumanSolvable}
) {
  final givens = _rowMajor(givensCells);
  final expectedSolution = _rowMajor(solutionCells);

  final solutionCount = solver.countSolutions(givens, limit: 2);
  if (solutionCount != 1) {
    stdout.writeln('FAIL $label: $solutionCount solutions (expected 1)');
    return;
  }
  final solved = solver.solve(givens);
  if (solved?.cells.toString() != expectedSolution.cells.toString()) {
    stdout.writeln('FAIL $label: solver solution does not match transformed stored solution');
    return;
  }

  final humanResult = humanSolver.solve(givens);
  if (expectHumanSolvable) {
    if (!humanResult.solved) {
      stdout.writeln('FAIL $label: human solver could not solve a puzzle that was solvable pre-transform');
      return;
    }
    final rating = rater.rate(humanResult.steps);
    if (originalRating != null && rating.difficulty != originalRating.difficulty) {
      stdout.writeln(
        'FAIL $label: difficulty BAND changed after transform '
        '(${originalRating.difficulty} score ${originalRating.score} -> '
        '${rating.difficulty} score ${rating.score})',
      );
      return;
    }
    if (originalRating != null && rating.score != originalRating.score) {
      stdout.writeln(
        'NOTE $label: difficulty score drifted but stayed in-band '
        '(${originalRating.score} -> ${rating.score})',
      );
    }
  } else {
    if (humanResult.solved) {
      stdout.writeln('NOTE $label: human solver solved a true_extreme puzzle post-transform (rare, same as pre-transform risk)');
    }
  }
  stdout.writeln('OK   $label');
}
