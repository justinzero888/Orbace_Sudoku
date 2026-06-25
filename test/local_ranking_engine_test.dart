import 'package:flutter_test/flutter_test.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_attempt.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_move.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_score.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_score_class.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/local_ranking_engine.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/score_calculator.dart';

void main() {
  const engine = LocalRankingEngine();

  test('filters to ranked official attempts for same checksum and version', () {
    final ranking = engine.rank(
      attempts: [
        _attempt(id: 'practice', scoreClass: SudokuScoreClass.assisted),
        _attempt(id: 'retry', scoreClass: SudokuScoreClass.retry),
        _attempt(id: 'not_ranked', rankedEligible: false),
        _attempt(id: 'wrong_checksum', checksum: 'other'),
        _attempt(id: 'wrong_version', scoringVersion: 0),
        _attempt(id: 'ranked', total: 1200),
      ],
      puzzleChecksum: 'checksum',
      scoringVersion: ScoreCalculator.scoringVersion,
    );

    expect(ranking, hasLength(1));
    expect(ranking.single.rank, 1);
    expect(ranking.single.attempt.id, 'ranked');
  });

  test('sorts by score, then time, steps, and completion date', () {
    final ranking = engine.rank(
      attempts: [
        _attempt(
          id: 'later',
          total: 1200,
          elapsedSeconds: 300,
          stepCount: 50,
          completedAt: DateTime(2026, 1, 2),
        ),
        _attempt(id: 'higher_score', total: 1400, elapsedSeconds: 500),
        _attempt(id: 'faster', total: 1200, elapsedSeconds: 240),
        _attempt(
          id: 'fewer_steps',
          total: 1200,
          elapsedSeconds: 300,
          stepCount: 40,
        ),
      ],
      puzzleChecksum: 'checksum',
      scoringVersion: ScoreCalculator.scoringVersion,
    );

    expect(
      ranking.map((entry) => '${entry.rank}:${entry.attempt.id}'),
      <String>['1:higher_score', '2:faster', '3:fewer_steps', '4:later'],
    );
  });
}

SudokuAttempt _attempt({
  required String id,
  int total = 1000,
  int elapsedSeconds = 300,
  int stepCount = 50,
  bool completed = true,
  bool rankedEligible = true,
  SudokuScoreClass scoreClass = SudokuScoreClass.official,
  String checksum = 'checksum',
  int scoringVersion = ScoreCalculator.scoringVersion,
  DateTime? completedAt,
}) {
  final startedAt = DateTime(2026);
  return SudokuAttempt(
    id: id,
    puzzleId: 'puzzle',
    isRetry: scoreClass == SudokuScoreClass.retry,
    attemptNumber: 1,
    elapsedSeconds: elapsedSeconds,
    errorCount: 0,
    hintNudgeCount: 0,
    hintExplanationCount: 0,
    hintRevealCount: 0,
    autoCheckEnabled: false,
    mistakeRevealEnabled: false,
    completed: completed,
    cleanSolve: true,
    rankedEligible: rankedEligible,
    scoreClass: scoreClass,
    score: SudokuScore(
      total: total,
      baseScore: 1000,
      accuracyMultiplier: 1,
      timeBonus: 0,
      efficiencyBonus: 0,
      cleanSolveBonus: 0,
      scoringVersion: scoringVersion,
      accuracyFactors: const <String>[],
    ),
    moveHistory: [
      for (var index = 0; index < stepCount; index++)
        SudokuMove(
          cellIndex: index % 81,
          previousValue: null,
          nextValue: 1,
          elapsedSeconds: index,
        ),
    ],
    startedAt: startedAt,
    completedAt: completedAt ?? startedAt,
    replayHash: 'hash',
    puzzleChecksum: checksum,
  );
}
