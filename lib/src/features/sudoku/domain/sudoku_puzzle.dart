import 'sudoku_board.dart';
import 'sudoku_difficulty.dart';
import 'solving_step.dart';

class SudokuPuzzle {
  const SudokuPuzzle({
    required this.id,
    required this.givens,
    required this.solution,
    required this.difficulty,
    required this.difficultyScore,
    required this.targetTimeSeconds,
    required this.medianTimeSeconds,
    required this.requiredTechniques,
    required this.solvePath,
    required this.rankedEligible,
    this.challengeId,
  });

  final String id;
  final SudokuBoard givens;
  final SudokuBoard solution;
  final SudokuDifficulty difficulty;
  final int difficultyScore;
  final int targetTimeSeconds;
  final int medianTimeSeconds;
  final List<String> requiredTechniques;
  final List<StoredSolvingStep> solvePath;
  final bool rankedEligible;
  final String? challengeId;
}
