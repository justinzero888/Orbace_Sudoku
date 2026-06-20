import 'dart:math';

import '../domain/sudoku_board.dart';
import '../domain/sudoku_difficulty.dart';
import '../domain/sudoku_puzzle.dart';
import 'human_ranked_solver.dart';
import 'sudoku_difficulty_rater.dart';
import 'sudoku_solver.dart';

class SudokuGenerator {
  SudokuGenerator({Random? random, HumanRankedSolver? humanSolver})
    : _random = random ?? Random(),
      _humanSolver = humanSolver ?? HumanRankedSolver();

  final Random _random;
  static const SudokuSolver _solver = SudokuSolver();
  final HumanRankedSolver _humanSolver;
  static const SudokuDifficultyRater _difficultyRater = SudokuDifficultyRater();

  SudokuBoard generateSolvedBoard() {
    final pattern = <int?>[
      for (var row = 0; row < SudokuBoard.size; row++)
        for (var col = 0; col < SudokuBoard.size; col++)
          ((row * 3 + row ~/ 3 + col) % 9) + 1,
    ];

    final digits = List<int>.generate(9, (index) => index + 1)
      ..shuffle(_random);
    final remapped = <int?>[for (final value in pattern) digits[value! - 1]];

    final rows = _shuffledBands();
    final cols = _shuffledBands();
    final shuffled = List<int?>.filled(SudokuBoard.cellCount, null);

    for (var row = 0; row < SudokuBoard.size; row++) {
      for (var col = 0; col < SudokuBoard.size; col++) {
        shuffled[SudokuBoard.index(row, col)] =
            remapped[SudokuBoard.index(rows[row], cols[col])];
      }
    }

    return SudokuBoard.fromCells(shuffled);
  }

  SudokuPuzzle generatePuzzle({
    required String id,
    int cellsToRemove = 42,
    int maxAttempts = 240,
  }) {
    final solution = generateSolvedBoard();
    var puzzleCells = solution.toMutableCells();
    final indices = List<int>.generate(SudokuBoard.cellCount, (index) => index)
      ..shuffle(_random);

    var removed = 0;
    var attempts = 0;
    for (final index in indices) {
      if (removed >= cellsToRemove || attempts >= maxAttempts) {
        break;
      }
      attempts++;

      final previous = puzzleCells[index];
      puzzleCells[index] = null;
      final candidate = SudokuBoard.fromCells(puzzleCells);
      if (_solver.hasUniqueSolution(candidate)) {
        removed++;
      } else {
        puzzleCells[index] = previous;
      }
    }

    var givens = SudokuBoard.fromCells(puzzleCells);
    var humanResult = _humanSolver.solve(givens);

    // Phase 1 safety: if random removal creates a puzzle outside the MVP
    // technique set, restore givens until the stored solve path is available.
    for (final index in indices.reversed) {
      if (humanResult.solved) {
        break;
      }
      if (puzzleCells[index] == null) {
        puzzleCells[index] = solution.valueAtIndex(index);
        givens = SudokuBoard.fromCells(puzzleCells);
        humanResult = _humanSolver.solve(givens);
      }
    }

    if (!humanResult.solved) {
      throw StateError('Unable to generate a human-solvable puzzle');
    }

    final rating = _difficultyRater.rate(humanResult.steps);
    return SudokuPuzzle(
      id: id,
      givens: givens,
      solution: solution,
      difficulty: rating.difficulty,
      difficultyScore: rating.score,
      targetTimeSeconds: _targetTimeFor(rating.difficulty),
      medianTimeSeconds: _targetTimeFor(rating.difficulty) + 120,
      requiredTechniques: rating.requiredTechniques,
      solvePath: humanResult.steps,
      rankedEligible: false,
    );
  }

  List<int> _shuffledBands() {
    final bands = <List<int>>[
      <int>[0, 1, 2],
      <int>[3, 4, 5],
      <int>[6, 7, 8],
    ]..shuffle(_random);

    return <int>[
      for (final band in bands..forEach((band) => band.shuffle(_random)))
        ...band,
    ];
  }

  int _targetTimeFor(SudokuDifficulty difficulty) {
    return switch (difficulty.name) {
      'beginner' => 360,
      'easy' => 540,
      'medium' => 720,
      'hard' => 960,
      'expert' => 1200,
      _ => 1500,
    };
  }
}
