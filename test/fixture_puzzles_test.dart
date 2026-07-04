import 'package:flutter_test/flutter_test.dart';
import 'package:orbace_sudoku/src/features/sudoku/data/puzzle_pack_loader.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/human_ranked_solver.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_solver.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('asset catalog provides expanded UAT puzzle packs', () async {
    final catalog = await PuzzlePackLoader().load();

    expect(catalog.packs.length, greaterThanOrEqualTo(6));
    expect(catalog.puzzles.length, greaterThanOrEqualTo(100));
    expect(
      catalog.puzzles.map((puzzle) => puzzle.id).toSet().length,
      catalog.puzzles.length,
    );
  });

  test('bundled asset catalog is certified for local ranking', () async {
    final catalog = await PuzzlePackLoader().load();

    expect(
      catalog.puzzles.where((puzzle) => puzzle.rankedEligible),
      hasLength(catalog.puzzles.length),
    );
  });

  test('asset catalog has matching unique solutions', () async {
    final catalog = await PuzzlePackLoader().load();
    final solver = SudokuSolver();

    for (final puzzle in catalog.puzzles) {
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

  test('teaching asset catalog is compatible with hint solve path', () async {
    final catalog = await PuzzlePackLoader().load();
    final humanSolver = HumanRankedSolver();

    // true_extreme puzzles are deliberately beyond the teaching hint solver
    // (that's the whole point of the pack) -- excluded here the same way
    // validate_puzzle_packs.dart exempts them.
    for (final puzzle in catalog.puzzles.where(
      (puzzle) => puzzle.packId != 'true_extreme',
    )) {
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
