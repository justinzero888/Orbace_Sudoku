import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbace_sudoku/src/features/sudoku/data/app_database.dart';
import 'package:orbace_sudoku/src/features/sudoku/data/sudoku_repository.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_difficulty.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/human_ranked_solver.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/score_calculator.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/fixture_puzzles.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/game_session_controller.dart';

void main() {
  group('ScoreCalculator', () {
    test('calculates transparent clean solve score', () {
      const calculator = ScoreCalculator();

      final score = calculator.calculate(
        const ScoreInput(
          difficulty: SudokuDifficulty.expert,
          elapsedSeconds: 900,
          targetTimeSeconds: 1200,
          errorCount: 0,
          hintNudgeCount: 0,
          hintExplanationCount: 0,
          hintRevealCount: 0,
          autoCheckEnabled: false,
          timerEnabled: true,
          cleanSolve: true,
          playerSteps: 40,
          optimalSteps: 40,
        ),
      );

      expect(score.baseScore, 16000);
      expect(score.accuracyMultiplier, 1.0);
      expect(score.timeBonus, 400);
      expect(score.efficiencyBonus, 800);
      expect(score.cleanSolveBonus, 800);
      expect(score.total, 18000);
    });

    test('penalizes errors, hint tiers, and auto-check', () {
      const calculator = ScoreCalculator();

      final score = calculator.calculate(
        const ScoreInput(
          difficulty: SudokuDifficulty.hard,
          elapsedSeconds: 1000,
          targetTimeSeconds: 960,
          errorCount: 1,
          hintNudgeCount: 1,
          hintExplanationCount: 1,
          hintRevealCount: 1,
          autoCheckEnabled: true,
          timerEnabled: true,
          cleanSolve: false,
          playerSteps: 70,
          optimalSteps: 40,
        ),
      );

      expect(score.total, lessThan(8000));
      expect(score.timeBonus, 0);
      expect(score.cleanSolveBonus, 0);
      expect(score.accuracyFactors, hasLength(5));
    });
  });

  group('SudokuRepository', () {
    late AppDatabase database;
    late SudokuRepository repository;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      repository = SudokuRepository(database);
    });

    tearDown(() async {
      await database.close();
    });

    test(
      'persists puzzle and completed attempt with score and moves',
      () async {
        final givens = FixturePuzzles.teaMomentGivens();
        final solution = FixturePuzzles.teaMomentSolution();
        final solvePath = HumanRankedSolver().solve(givens).steps;
        await repository.upsertPuzzle(
          fixturePuzzleRecord(
            id: 'tea_moment_fixture',
            givens: givens,
            solution: solution,
            solvePath: solvePath,
          ),
        );

        final controller = GameSessionController(
          givens: givens,
          solution: solution,
        );
        controller
          ..selectCell(2)
          ..enterNumber(4);
        final attempt = controller.buildAttempt();
        await repository.saveAttempt(attempt);

        final attempts = await repository.attemptsForPuzzle(
          'tea_moment_fixture',
        );

        expect(attempts, hasLength(1));
        expect(attempts.single.score, isNotNull);
        expect(attempts.single.moveHistory, hasLength(1));
        expect(attempts.single.moveHistory.single.nextValue, 4);

        controller.dispose();
      },
    );
  });
}
