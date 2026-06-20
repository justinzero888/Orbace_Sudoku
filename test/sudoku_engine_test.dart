import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_board.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/human_ranked_solver.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_generator.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_solver.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_validator.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/techniques/hidden_pair.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/techniques/hidden_single.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/techniques/naked_pair.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/techniques/naked_single.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/techniques/pointing_pair.dart';

void main() {
  group('SudokuBoard', () {
    test('maps row and column to stable index', () {
      expect(SudokuBoard.index(0, 0), 0);
      expect(SudokuBoard.index(8, 8), 80);
      expect(SudokuBoard.rowOf(73), 8);
      expect(SudokuBoard.colOf(73), 1);
      expect(SudokuBoard.boxOf(4, 7), 5);
    });
  });

  group('SudokuValidator', () {
    const validator = SudokuValidator();

    test('accepts a valid partial puzzle', () {
      expect(validator.isValidPartial(_classicPuzzle()), isTrue);
    });

    test('rejects duplicate row values', () {
      final invalid = _classicPuzzle().setValue(0, 2, 5);

      expect(validator.isValidPartial(invalid), isFalse);
    });

    test('calculates candidates for an empty cell', () {
      final index = SudokuBoard.index(0, 2);

      expect(validator.candidatesFor(_classicPuzzle(), index), <int>{1, 2, 4});
    });
  });

  group('SudokuSolver', () {
    const solver = SudokuSolver();

    test('solves a known puzzle', () {
      final solved = solver.solve(_classicPuzzle());

      expect(solved, isNotNull);
      expect(solved!.cells, _classicSolution().cells);
    });

    test('counts one solution for known puzzle', () {
      expect(solver.countSolutions(_classicPuzzle()), 1);
      expect(solver.hasUniqueSolution(_classicPuzzle()), isTrue);
    });

    test('detects multiple solutions for empty board', () {
      expect(solver.countSolutions(SudokuBoard.empty(), limit: 2), 2);
    });
  });

  group('Human techniques', () {
    test('detects naked single', () {
      final action = const NakedSingleTechnique().findAction(
        SudokuBoard.empty(),
        <int, Set<int>>{
          0: <int>{7},
        },
      );

      expect(action, isNotNull);
      expect(action!.techniqueId, 'naked_single');
      expect(action.placementIndex, 0);
      expect(action.placementValue, 7);
    });

    test('detects hidden single', () {
      final action = const HiddenSingleTechnique().findAction(
        SudokuBoard.empty(),
        <int, Set<int>>{
          0: <int>{1, 2},
          1: <int>{1, 2, 5},
          2: <int>{1, 2},
        },
      );

      expect(action, isNotNull);
      expect(action!.techniqueId, 'hidden_single');
      expect(action.placementIndex, 1);
      expect(action.placementValue, 5);
    });

    test('detects naked pair eliminations', () {
      final action = const NakedPairTechnique().findAction(
        SudokuBoard.empty(),
        <int, Set<int>>{
          0: <int>{1, 2},
          1: <int>{1, 2},
          2: <int>{1, 2, 3},
        },
      );

      expect(action, isNotNull);
      expect(action!.techniqueId, 'naked_pair');
      expect(action.eliminations[2], <int>{1, 2});
    });

    test('detects hidden pair eliminations', () {
      final action = const HiddenPairTechnique().findAction(
        SudokuBoard.empty(),
        <int, Set<int>>{
          0: <int>{1, 2, 3},
          1: <int>{1, 2, 4},
          2: <int>{3, 4, 5},
        },
      );

      expect(action, isNotNull);
      expect(action!.techniqueId, 'hidden_pair');
      expect(action.eliminations[0], <int>{3});
      expect(action.eliminations[1], <int>{4});
    });

    test('detects pointing pair eliminations', () {
      final action = const PointingPairTechnique().findAction(
        SudokuBoard.empty(),
        <int, Set<int>>{
          0: <int>{4},
          1: <int>{4, 6},
          5: <int>{2, 4},
        },
      );

      expect(action, isNotNull);
      expect(action!.techniqueId, 'pointing_pair');
      expect(action.eliminations[5], <int>{4});
    });
  });

  group('HumanRankedSolver', () {
    test('solves known puzzle with stored steps', () {
      final result = HumanRankedSolver().solve(_classicPuzzle());

      expect(result.solved, isTrue);
      expect(result.board.cells, _classicSolution().cells);
      expect(result.steps, isNotEmpty);
      expect(result.steps.first.stepIndex, 0);
    });
  });

  group('SudokuGenerator', () {
    test('generates unique human-solvable puzzle', () {
      final generator = SudokuGenerator(random: Random(7));
      final puzzle = generator.generatePuzzle(
        id: 'phase1_fixture',
        cellsToRemove: 28,
      );

      expect(const SudokuSolver().hasUniqueSolution(puzzle.givens), isTrue);
      expect(HumanRankedSolver().solve(puzzle.givens).solved, isTrue);
      expect(puzzle.solvePath, isNotEmpty);
      expect(puzzle.requiredTechniques, isNotEmpty);
    });
  });
}

SudokuBoard _classicPuzzle() {
  return _boardFromRows(<String>[
    '530070000',
    '600195000',
    '098000060',
    '800060003',
    '400803001',
    '700020006',
    '060000280',
    '000419005',
    '000080079',
  ]);
}

SudokuBoard _classicSolution() {
  return _boardFromRows(<String>[
    '534678912',
    '672195348',
    '198342567',
    '859761423',
    '426853791',
    '713924856',
    '961537284',
    '287419635',
    '345286179',
  ]);
}

SudokuBoard _boardFromRows(List<String> rows) {
  return SudokuBoard.fromCells(<int?>[
    for (final row in rows)
      for (final char in row.split('')) char == '0' ? null : int.parse(char),
  ]);
}
