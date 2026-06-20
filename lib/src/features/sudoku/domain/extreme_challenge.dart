import 'sudoku_attempt.dart';

class ExtremeChallenge {
  const ExtremeChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.puzzleId,
    required this.unlockRequirement,
  });

  final String id;
  final String title;
  final String description;
  final String puzzleId;
  final String unlockRequirement;
}

class ExtremeEligibility {
  const ExtremeEligibility({required this.unlocked, required this.reason});

  final bool unlocked;
  final String reason;
}

class ExtremeChallengeService {
  const ExtremeChallengeService();

  static const ExtremeChallenge dailyExtreme = ExtremeChallenge(
    id: 'daily_extreme_local',
    title: 'Daily Extreme',
    description: 'A local no-assist challenge for qualified players.',
    puzzleId: 'extreme_local_fixture',
    unlockRequirement: 'Complete Scholar\'s Path Stage 3: Insight',
  );

  bool isRankedEligibleAttempt(SudokuAttempt attempt) {
    return attempt.completed &&
        !attempt.isRetry &&
        attempt.hintNudgeCount == 0 &&
        attempt.hintExplanationCount == 0 &&
        attempt.hintRevealCount == 0 &&
        !attempt.autoCheckEnabled &&
        !attempt.mistakeRevealEnabled &&
        attempt.rankedEligible;
  }
}
