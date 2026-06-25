import '../domain/sudoku_attempt.dart';
import '../domain/sudoku_score_class.dart';

class LocalRankingEntry {
  const LocalRankingEntry({required this.rank, required this.attempt});

  final int rank;
  final SudokuAttempt attempt;
}

class LocalRankingEngine {
  const LocalRankingEngine();

  List<LocalRankingEntry> rank({
    required List<SudokuAttempt> attempts,
    required String puzzleChecksum,
    required int scoringVersion,
  }) {
    final ranked =
        attempts
            .where(
              (attempt) =>
                  attempt.completed &&
                  attempt.rankedEligible &&
                  attempt.scoreClass == SudokuScoreClass.official &&
                  attempt.score != null &&
                  attempt.puzzleChecksum == puzzleChecksum &&
                  attempt.score!.scoringVersion == scoringVersion,
            )
            .toList()
          ..sort(_compareAttempts);

    return <LocalRankingEntry>[
      for (final (index, attempt) in ranked.indexed)
        LocalRankingEntry(rank: index + 1, attempt: attempt),
    ];
  }

  int _compareAttempts(SudokuAttempt a, SudokuAttempt b) {
    final scoreCompare = (b.score?.total ?? 0).compareTo(a.score?.total ?? 0);
    if (scoreCompare != 0) {
      return scoreCompare;
    }

    final timeCompare = a.elapsedSeconds.compareTo(b.elapsedSeconds);
    if (timeCompare != 0) {
      return timeCompare;
    }

    final stepCompare = a.moveHistory.length.compareTo(b.moveHistory.length);
    if (stepCompare != 0) {
      return stepCompare;
    }

    final aDate = a.completedAt ?? a.startedAt;
    final bDate = b.completedAt ?? b.startedAt;
    return aDate.compareTo(bDate);
  }
}
