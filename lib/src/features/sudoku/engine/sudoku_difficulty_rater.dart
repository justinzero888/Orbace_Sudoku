import '../domain/solving_step.dart';
import '../domain/sudoku_difficulty.dart';

class DifficultyRating {
  const DifficultyRating({
    required this.difficulty,
    required this.score,
    required this.requiredTechniques,
  });

  final SudokuDifficulty difficulty;
  final int score;
  final List<String> requiredTechniques;
}

class SudokuDifficultyRater {
  const SudokuDifficultyRater();

  DifficultyRating rate(List<StoredSolvingStep> steps) {
    var score = steps.length;
    final techniques = <String>{};

    for (final step in steps) {
      techniques.add(step.techniqueId);
      score += switch (step.techniqueId) {
        'naked_single' => 1,
        'hidden_single' => 2,
        'naked_pair' => 6,
        'hidden_pair' => 8,
        'pointing_pair' => 8,
        _ => 10,
      };
    }

    final difficulty = switch (score) {
      <= 90 => SudokuDifficulty.beginner,
      <= 130 => SudokuDifficulty.easy,
      <= 180 => SudokuDifficulty.medium,
      <= 240 => SudokuDifficulty.hard,
      _ => SudokuDifficulty.expert,
    };

    return DifficultyRating(
      difficulty: difficulty,
      score: score,
      requiredTechniques: techniques.toList()..sort(),
    );
  }
}
