import 'package:flutter_test/flutter_test.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_score_class.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/attempt_eligibility_engine.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/score_calculator.dart';

void main() {
  const engine = AttemptEligibilityEngine();

  test('marks clean certified first attempts as official and ranked', () {
    final result = engine.evaluate(_input());

    expect(result.scoreClass, SudokuScoreClass.official);
    expect(result.rankedEligible, isTrue);
    expect(result.reasons, isEmpty);
  });

  test('marks assisted attempts as practice and not ranked', () {
    final result = engine.evaluate(
      _input(hintNudgeCount: 1, autoCheckEnabled: true),
    );

    expect(result.scoreClass, SudokuScoreClass.assisted);
    expect(result.rankedEligible, isFalse);
    expect(
      result.reasons,
      containsAll(<String>['hints_used', 'assist_enabled']),
    );
  });

  test('marks retry and later attempts as retry and not ranked', () {
    final retry = engine.evaluate(_input(isRetry: true));
    final laterAttempt = engine.evaluate(_input(attemptNumber: 2));

    expect(retry.scoreClass, SudokuScoreClass.retry);
    expect(retry.rankedEligible, isFalse);
    expect(laterAttempt.scoreClass, SudokuScoreClass.retry);
    expect(laterAttempt.reasons, contains('retry_or_later_attempt'));
  });

  test('blocks ranking for uncertified puzzle content', () {
    final result = engine.evaluate(_input(puzzleRankedEligible: false));

    expect(result.scoreClass, SudokuScoreClass.assisted);
    expect(result.rankedEligible, isFalse);
    expect(result.reasons, contains('puzzle_not_ranked'));
  });

  test(
    'blocks ranking when scoring version does not match current version',
    () {
      final result = engine.evaluate(_input(scoringVersion: 0));

      expect(result.scoreClass, SudokuScoreClass.assisted);
      expect(result.rankedEligible, isFalse);
      expect(result.reasons, contains('scoring_version_mismatch'));
    },
  );
}

AttemptEligibilityInput _input({
  bool completed = true,
  bool isRetry = false,
  int attemptNumber = 1,
  int hintNudgeCount = 0,
  int hintExplanationCount = 0,
  int hintRevealCount = 0,
  bool autoCheckEnabled = false,
  bool mistakeRevealEnabled = false,
  bool puzzleRankedEligible = true,
  int scoringVersion = ScoreCalculator.scoringVersion,
}) {
  return AttemptEligibilityInput(
    completed: completed,
    isRetry: isRetry,
    attemptNumber: attemptNumber,
    hintNudgeCount: hintNudgeCount,
    hintExplanationCount: hintExplanationCount,
    hintRevealCount: hintRevealCount,
    autoCheckEnabled: autoCheckEnabled,
    mistakeRevealEnabled: mistakeRevealEnabled,
    puzzleRankedEligible: puzzleRankedEligible,
    scoringVersion: scoringVersion,
    currentScoringVersion: ScoreCalculator.scoringVersion,
  );
}
