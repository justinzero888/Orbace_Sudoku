import 'package:flutter_test/flutter_test.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/daily_tea_moment.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/extreme_challenge.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_attempt.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_move.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_score.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/award_engine.dart';

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

  group('DailyTeaMomentSelector', () {
    test('selects stable puzzle for same day', () {
      const selector = DailyTeaMomentSelector();
      final first = selector.forDate(DateTime(2026, 6, 20, 9), const <String>[
        'a',
        'b',
        'c',
      ]);
      final second = selector.forDate(DateTime(2026, 6, 20, 21), const <String>[
        'a',
        'b',
        'c',
      ]);

      expect(first.dayKey, '2026-06-20');
      expect(first.puzzleId, second.puzzleId);
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
