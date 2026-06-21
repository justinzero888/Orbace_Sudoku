import 'package:flutter_test/flutter_test.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/human_ranked_solver.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_solver.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/fixture_puzzles.dart';

void main() {
  test('fixture catalog provides multiple playable puzzles', () {
    expect(FixturePuzzles.catalog.length, greaterThanOrEqualTo(6));
    expect(
      FixturePuzzles.catalog.map((puzzle) => puzzle.id).toSet().length,
      FixturePuzzles.catalog.length,
    );
  });

  test('fixture catalog has matching unique solutions', () {
    final solver = SudokuSolver();

    for (final puzzle in FixturePuzzles.catalog) {
      expect(
        solver.countSolutions(puzzle.givens, limit: 2),
        1,
        reason: '${puzzle.id} should have one solution',
      );
      expect(
        solver.solve(puzzle.givens)?.cells,
        puzzle.solution.cells,
        reason: '${puzzle.id} should solve to its stored solution',
      );
    }
  });

  test('fixture catalog is compatible with hint solve path', () {
    final humanSolver = HumanRankedSolver();

    for (final puzzle in FixturePuzzles.catalog) {
      final result = humanSolver.solve(puzzle.givens);
      expect(
        result.solved,
        isTrue,
        reason: '${puzzle.id} should be hint-compatible',
      );
      expect(
        result.steps,
        isNotEmpty,
        reason: '${puzzle.id} should provide hint steps',
      );
    }
  });
}
