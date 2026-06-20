import 'sudoku_move.dart';
import 'sudoku_score.dart';

class SudokuAttempt {
  const SudokuAttempt({
    required this.id,
    required this.puzzleId,
    required this.isRetry,
    required this.attemptNumber,
    required this.elapsedSeconds,
    required this.errorCount,
    required this.hintNudgeCount,
    required this.hintExplanationCount,
    required this.hintRevealCount,
    required this.autoCheckEnabled,
    required this.mistakeRevealEnabled,
    required this.completed,
    required this.cleanSolve,
    required this.rankedEligible,
    required this.moveHistory,
    required this.startedAt,
    this.completedAt,
    this.score,
  });

  final String id;
  final String puzzleId;
  final bool isRetry;
  final int attemptNumber;
  final int elapsedSeconds;
  final int errorCount;
  final int hintNudgeCount;
  final int hintExplanationCount;
  final int hintRevealCount;
  final bool autoCheckEnabled;
  final bool mistakeRevealEnabled;
  final bool completed;
  final bool cleanSolve;
  final bool rankedEligible;
  final SudokuScore? score;
  final List<SudokuMove> moveHistory;
  final DateTime startedAt;
  final DateTime? completedAt;
}
