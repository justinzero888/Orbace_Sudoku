import '../domain/sudoku_score_class.dart';

class AttemptEligibilityInput {
  const AttemptEligibilityInput({
    required this.completed,
    required this.isRetry,
    required this.attemptNumber,
    required this.hintNudgeCount,
    required this.hintExplanationCount,
    required this.hintRevealCount,
    required this.autoCheckEnabled,
    required this.mistakeRevealEnabled,
    required this.puzzleRankedEligible,
    required this.scoringVersion,
    required this.currentScoringVersion,
  });

  final bool completed;
  final bool isRetry;
  final int attemptNumber;
  final int hintNudgeCount;
  final int hintExplanationCount;
  final int hintRevealCount;
  final bool autoCheckEnabled;
  final bool mistakeRevealEnabled;
  final bool puzzleRankedEligible;
  final int scoringVersion;
  final int currentScoringVersion;
}

class AttemptEligibilityResult {
  const AttemptEligibilityResult({
    required this.scoreClass,
    required this.rankedEligible,
    required this.reasons,
  });

  final SudokuScoreClass scoreClass;
  final bool rankedEligible;
  final List<String> reasons;
}

class AttemptEligibilityEngine {
  const AttemptEligibilityEngine();

  AttemptEligibilityResult evaluate(AttemptEligibilityInput input) {
    final reasons = <String>[];

    if (!input.completed) {
      reasons.add('not_completed');
    }
    if (input.isRetry || input.attemptNumber > 1) {
      reasons.add('retry_or_later_attempt');
    }
    if (input.hintNudgeCount > 0 ||
        input.hintExplanationCount > 0 ||
        input.hintRevealCount > 0) {
      reasons.add('hints_used');
    }
    if (input.autoCheckEnabled || input.mistakeRevealEnabled) {
      reasons.add('assist_enabled');
    }
    if (!input.puzzleRankedEligible) {
      reasons.add('puzzle_not_ranked');
    }
    if (input.scoringVersion != input.currentScoringVersion) {
      reasons.add('scoring_version_mismatch');
    }

    final scoreClass = _scoreClassFor(input, reasons);
    final rankedEligible =
        scoreClass == SudokuScoreClass.official && reasons.isEmpty;

    return AttemptEligibilityResult(
      scoreClass: scoreClass,
      rankedEligible: rankedEligible,
      reasons: List<String>.unmodifiable(reasons),
    );
  }

  SudokuScoreClass _scoreClassFor(
    AttemptEligibilityInput input,
    List<String> reasons,
  ) {
    if (!input.completed) {
      return SudokuScoreClass.legacy;
    }
    if (input.isRetry || input.attemptNumber > 1) {
      return SudokuScoreClass.retry;
    }
    if (reasons.isEmpty) {
      return SudokuScoreClass.official;
    }
    return SudokuScoreClass.assisted;
  }
}
