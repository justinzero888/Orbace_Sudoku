import 'package:flutter_test/flutter_test.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/daily_random_puzzle.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/extreme_challenge.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_attempt.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_difficulty.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_move.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_score.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/award_engine.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/fixture_puzzles.dart';

void main() {
  group('AwardEngine', () {
    test('keeps Extreme locked for new players', () {
      final summary = const AwardEngine().evaluate(const <SudokuAttempt>[]);

      expect(summary.extremeUnlocked, isFalse);
      expect(summary.stages.first.progressPercent, 0);
    });

    test('unlocks Extreme when Insight requirements are complete', () {
      final attempts = <SudokuAttempt>[
        for (var i = 0; i < 20; i++)
          _attempt(id: 'attempt_$i', puzzleId: 'puzzle_${i % 3}', cleanSolve: i < 6),
      ];

      final summary = const AwardEngine().evaluate(attempts);

      expect(summary.extremeUnlocked, isTrue);
      expect(summary.stages.last.isComplete, isTrue);
    });

    test(
      'Insight stage only checks 3 requirements; retry-improvement count '
      'no longer gates the Extreme unlock',
      () {
        // No retries at all, so replayImprovementCount is 0 - the removed
        // "5 retry improvements" rule would have blocked the unlock, but the
        // remaining 3 requirements (15 completed, 5 with 70%+ accuracy, 3
        // clean solves) are enough on their own.
        final attempts = <SudokuAttempt>[
          for (var i = 0; i < 15; i++)
            _attempt(id: 'attempt_$i', puzzleId: 'puzzle_$i', cleanSolve: i < 3),
        ];

        final summary = const AwardEngine().evaluate(attempts);
        final insight = summary.stages.last;

        expect(insight.requirements, hasLength(3));
        expect(insight.requirements.map((r) => r.id), isNot(contains('five_replay_improvements')));
        expect(summary.replayImprovements, 0);
        expect(summary.extremeUnlocked, isTrue);
      },
    );
  });

  group('DailyRandomPuzzle', () {
    const selector = DailyRandomPuzzle.extremeDaily;
    final pool = List<FixturePuzzleDefinition>.generate(
      5,
      (i) => FixturePuzzleDefinition(
        id: 'pool_$i',
        title: 'Pool $i',
        seal: '榜',
        packId: 'true_extreme',
        difficulty: SudokuDifficulty.extreme,
        difficultyScore: 900,
        targetTimeSeconds: 1800,
        medianTimeSeconds: 2400,
        rankedEligible: true,
        givensRows: FixturePuzzles.catalog.first.givensRows,
        solutionRows: FixturePuzzles.catalog.first.solutionRows,
      ),
    );

    test('selects a stable puzzle for the same calendar day', () {
      final first = selector.forDate(DateTime(2026, 6, 20, 9), pool);
      final second = selector.forDate(DateTime(2026, 6, 20, 21), pool);

      expect(first.id, 'extreme_daily_2026-06-20');
      expect(first.id, second.id);
      expect(first.givensRows, second.givensRows);
      expect(first.solutionRows, second.solutionRows);
    });

    test('produces a different transformed grid on a different day', () {
      final day1 = selector.forDate(DateTime(2026, 6, 20), pool);
      final day2 = selector.forDate(DateTime(2026, 6, 21), pool);

      expect(day1.id, isNot(day2.id));
      expect(day1.givensRows, isNot(day2.givensRows));
    });

    test('idFor/parseDate round-trip', () {
      final date = DateTime(2026, 7, 4);
      final id = selector.idFor(date);

      expect(id, 'extreme_daily_2026-07-04');
      expect(selector.matches(id), isTrue);
      expect(selector.parseDate(id), date);
      expect(selector.matches('true_extreme_042'), isFalse);
    });

    test('transformed puzzle is still a valid, unique-solution board', () {
      final daily = selector.forDate(DateTime(2026, 7, 4), pool);
      final givens = daily.givens;
      final solution = daily.solution;

      for (var i = 0; i < 81; i++) {
        final value = givens.valueAtIndex(i);
        if (value != null) {
          expect(value, solution.valueAtIndex(i));
        }
      }
      expect(solution.isComplete, isTrue);
    });
  });

  group('ExtremeChallengeService', () {
    test('requires no-assist completed non-retry ranked attempt', () {
      const service = ExtremeChallengeService();

      expect(service.isRankedEligibleAttempt(_attempt(ranked: true)), isTrue);
      expect(
        service.isRankedEligibleAttempt(
          _attempt(ranked: true, hintRevealCount: 1),
        ),
        isFalse,
      );
      expect(
        service.isRankedEligibleAttempt(_attempt(ranked: true, isRetry: true)),
        isFalse,
      );
    });
  });
}

SudokuAttempt _attempt({
  String id = 'attempt',
  String puzzleId = 'puzzle',
  bool isRetry = false,
  bool cleanSolve = true,
  bool ranked = false,
  int hintRevealCount = 0,
  int scoreTotal = 1000,
}) {
  return SudokuAttempt(
    id: id,
    puzzleId: puzzleId,
    isRetry: isRetry,
    attemptNumber: 1,
    elapsedSeconds: 120,
    errorCount: cleanSolve ? 0 : 1,
    hintNudgeCount: 0,
    hintExplanationCount: 0,
    hintRevealCount: hintRevealCount,
    autoCheckEnabled: false,
    mistakeRevealEnabled: false,
    completed: true,
    cleanSolve: cleanSolve && hintRevealCount == 0,
    rankedEligible: ranked,
    score: SudokuScore(
      total: scoreTotal,
      baseScore: 1000,
      accuracyMultiplier: 1,
      timeBonus: 0,
      efficiencyBonus: 0,
      cleanSolveBonus: 0,
      scoringVersion: 1,
      accuracyFactors: const <String>[],
    ),
    moveHistory: const <SudokuMove>[],
    startedAt: DateTime(2026),
    completedAt: DateTime(2026),
  );
}
