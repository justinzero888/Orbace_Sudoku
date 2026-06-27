import 'package:flutter_test/flutter_test.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_attempt.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_move.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_score.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_score_class.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/score_calculator.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/su_pu_compare_engine.dart';

void main() {
  const engine = SuPuCompareEngine();

  test('compares score time steps mistakes hints and score class', () {
    final comparison = engine.compare(
      primary: _attempt(
        id: 'primary',
        total: 1800,
        elapsedSeconds: 240,
        stepCount: 44,
        errorCount: 0,
        hintRevealCount: 0,
        scoreClass: SudokuScoreClass.official,
        cleanSolve: true,
        accuracyMultiplier: 1,
      ),
      baseline: _attempt(
        id: 'baseline',
        total: 1200,
        elapsedSeconds: 300,
        stepCount: 52,
        errorCount: 1,
        hintRevealCount: 1,
        scoreClass: SudokuScoreClass.assisted,
        cleanSolve: false,
        accuracyMultiplier: 0.60,
      ),
    );

    expect(_row(comparison, 'Score').delta, '+600');
    expect(_row(comparison, 'Score').improved, isTrue);
    expect(_row(comparison, 'Time').delta, '+1:00');
    expect(_row(comparison, 'Steps').delta, '+8');
    expect(_row(comparison, 'Mistakes').delta, '+1');
    expect(_row(comparison, 'Hints').delta, '+1');
    expect(_row(comparison, 'Accuracy').delta, '+40 pts');
    expect(_row(comparison, 'Score Class').delta, 'changed');
    expect(_row(comparison, 'Clean').delta, 'cleaner');
  });

  test('rejects comparison across different puzzles', () {
    expect(
      () => engine.compare(
        primary: _attempt(id: 'a', puzzleId: 'puzzle_a'),
        baseline: _attempt(id: 'b', puzzleId: 'puzzle_b'),
      ),
      throwsArgumentError,
    );
  });
}

SuPuComparisonRow _row(SuPuComparison comparison, String label) {
  return comparison.rows.firstWhere((row) => row.label == label);
}

SudokuAttempt _attempt({
  required String id,
  String puzzleId = 'puzzle',
  int total = 1000,
  int elapsedSeconds = 300,
  int stepCount = 50,
  int errorCount = 0,
  int hintRevealCount = 0,
  SudokuScoreClass scoreClass = SudokuScoreClass.official,
  bool cleanSolve = true,
  double accuracyMultiplier = 1,
}) {
  final startedAt = DateTime(2026);
  return SudokuAttempt(
    id: id,
    puzzleId: puzzleId,
    isRetry: scoreClass == SudokuScoreClass.retry,
    attemptNumber: id == 'primary' ? 2 : 1,
    elapsedSeconds: elapsedSeconds,
    errorCount: errorCount,
    hintNudgeCount: 0,
    hintExplanationCount: 0,
    hintRevealCount: hintRevealCount,
    autoCheckEnabled: false,
    mistakeRevealEnabled: false,
    completed: true,
    cleanSolve: cleanSolve,
    rankedEligible: scoreClass == SudokuScoreClass.official,
    scoreClass: scoreClass,
    score: SudokuScore(
      total: total,
      baseScore: 1000,
      accuracyMultiplier: accuracyMultiplier,
      timeBonus: 0,
      efficiencyBonus: 0,
      cleanSolveBonus: 0,
      scoringVersion: ScoreCalculator.scoringVersion,
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
    completedAt: startedAt,
    replayHash: 'hash',
    puzzleChecksum: 'checksum',
  );
}
