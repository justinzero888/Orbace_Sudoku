import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbace_sudoku/src/features/sudoku/data/app_database.dart';
import 'package:orbace_sudoku/src/features/sudoku/data/imported_puzzle_service.dart';
import 'package:orbace_sudoku/src/features/sudoku/data/score_card_store.dart';
import 'package:orbace_sudoku/src/features/sudoku/data/sudoku_repository.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_attempt.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_difficulty.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_move.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_score_class.dart';
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
        expect(attempts.single.scoreClass, SudokuScoreClass.legacy);
        expect(attempts.single.replayHash, hasLength(64));
        expect(attempts.single.puzzleChecksum, hasLength(64));
        expect(attempts.single.replayFavorite, isFalse);
        expect(attempts.single.playerDifficultyRating, isNull);
        expect(attempts.single.moveHistory, hasLength(1));
        expect(attempts.single.moveHistory.single.nextValue, 4);

        controller.dispose();
      },
    );

    test('updates replay library metadata and sorts favorites first', () async {
      final earlierCompletedAt = DateTime(2026, 1, 1, 10);
      final laterCompletedAt = DateTime(2026, 1, 2, 10);
      final ratedAt = DateTime(2026, 1, 3, 10);
      final generatedAt = DateTime(2026, 1, 4, 10);

      await repository.saveAttempt(
        _attempt(
          id: 'attempt_a',
          completedAt: earlierCompletedAt,
          startedAt: earlierCompletedAt.subtract(const Duration(minutes: 10)),
        ),
      );
      await repository.saveAttempt(
        _attempt(
          id: 'attempt_b',
          completedAt: laterCompletedAt,
          startedAt: laterCompletedAt.subtract(const Duration(minutes: 8)),
        ),
      );

      await repository.updatePlayerDifficultyRating(
        'attempt_a',
        4.26,
        ratedAt: ratedAt,
      );
      await repository.toggleReplayFavorite('attempt_a', true);
      await repository.updateScoreCardImagePath(
        'attempt_a',
        '/tmp/orbace-score-card.png',
        generatedAt: generatedAt,
      );

      final library = await repository.completedAttemptsForReplayLibrary();

      expect(library.map((attempt) => attempt.id), ['attempt_a', 'attempt_b']);
      expect(library.first.playerDifficultyRating, 4.3);
      expect(library.first.playerDifficultyRatedAt, ratedAt);
      expect(library.first.replayFavorite, isTrue);
      expect(library.first.scoreCardImagePath, '/tmp/orbace-score-card.png');
      expect(library.first.scoreCardGeneratedAt, generatedAt);
    });

    test('rejects player difficulty ratings outside the 1 to 5 scale', () {
      expect(
        () => repository.updatePlayerDifficultyRating('attempt_a', 5.1),
        throwsArgumentError,
      );
      expect(
        () => repository.updatePlayerDifficultyRating('attempt_a', 0.9),
        throwsArgumentError,
      );
    });

    test('imports a valid personal puzzle into the local catalog', () async {
      final service = ImportedPuzzleService(repository: repository);

      final preview = service.previewFromString(
        '530070000'
        '600195000'
        '098000060'
        '800060003'
        '400803001'
        '700020006'
        '060000280'
        '000419005'
        '000080079',
        title: 'Outside Source Test',
        sourceLabel: 'UAT',
        now: DateTime(2026, 6, 24, 12),
      );
      await service.save(preview);

      final imported = await repository.importedPuzzleDefinitions();

      expect(imported, hasLength(1));
      expect(imported.single.title, 'Outside Source Test');
      expect(imported.single.packId, 'imported');
      expect(imported.single.rankedEligible, isFalse);
      expect(imported.single.solutionRows.first, '534678912');
    });

    test('rejects imported puzzles with multiple solutions', () {
      final service = ImportedPuzzleService(repository: repository);

      expect(
        () => service.previewFromString(List<String>.filled(81, '0').join()),
        throwsA(isA<ImportedPuzzleException>()),
      );
    });
  });

  group('ScoreCardStore', () {
    test('uses relative score-card paths for update-safe persistence', () {
      const store = ScoreCardStore();

      expect(
        store.relativePathForAttempt('attempt:one/two'),
        'score_cards/attempt_one_two.png',
      );
    });
  });
}

SudokuAttempt _attempt({
  required String id,
  required DateTime startedAt,
  required DateTime completedAt,
}) {
  return SudokuAttempt(
    id: id,
    puzzleId: 'tea_moment_fixture',
    isRetry: false,
    attemptNumber: 1,
    elapsedSeconds: 480,
    errorCount: 0,
    hintNudgeCount: 0,
    hintExplanationCount: 0,
    hintRevealCount: 0,
    autoCheckEnabled: false,
    mistakeRevealEnabled: false,
    completed: true,
    cleanSolve: true,
    rankedEligible: false,
    scoreClass: SudokuScoreClass.official,
    moveHistory: const [
      SudokuMove(
        cellIndex: 0,
        previousValue: null,
        nextValue: 7,
        elapsedSeconds: 5,
      ),
    ],
    startedAt: startedAt,
    completedAt: completedAt,
    replayHash: 'a' * 64,
    puzzleChecksum: 'b' * 64,
  );
}
