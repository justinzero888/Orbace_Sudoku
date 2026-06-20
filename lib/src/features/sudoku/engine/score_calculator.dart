import '../domain/sudoku_difficulty.dart';
import '../domain/sudoku_score.dart';

class ScoreInput {
  const ScoreInput({
    required this.difficulty,
    required this.elapsedSeconds,
    required this.targetTimeSeconds,
    required this.errorCount,
    required this.hintNudgeCount,
    required this.hintExplanationCount,
    required this.hintRevealCount,
    required this.autoCheckEnabled,
    required this.timerEnabled,
    required this.cleanSolve,
    required this.playerSteps,
    required this.optimalSteps,
  });

  final SudokuDifficulty difficulty;
  final int elapsedSeconds;
  final int targetTimeSeconds;
  final int errorCount;
  final int hintNudgeCount;
  final int hintExplanationCount;
  final int hintRevealCount;
  final bool autoCheckEnabled;
  final bool timerEnabled;
  final bool cleanSolve;
  final int playerSteps;
  final int optimalSteps;
}

class ScoreCalculator {
  const ScoreCalculator();

  static const int scoringVersion = 1;

  SudokuScore calculate(ScoreInput input) {
    var multiplier = 1.0;
    final factors = <String>[];

    for (var i = 0; i < input.errorCount; i++) {
      multiplier *= 0.85;
    }
    if (input.errorCount > 0) {
      factors.add('${input.errorCount} error(s): x0.85 each');
    }

    for (var i = 0; i < input.hintNudgeCount; i++) {
      multiplier *= 0.95;
    }
    if (input.hintNudgeCount > 0) {
      factors.add('${input.hintNudgeCount} nudge hint(s): x0.95 each');
    }

    for (var i = 0; i < input.hintExplanationCount; i++) {
      multiplier *= 0.85;
    }
    if (input.hintExplanationCount > 0) {
      factors.add(
        '${input.hintExplanationCount} explanation hint(s): x0.85 each',
      );
    }

    for (var i = 0; i < input.hintRevealCount; i++) {
      multiplier *= 0.70;
    }
    if (input.hintRevealCount > 0) {
      factors.add('${input.hintRevealCount} reveal hint(s): x0.70 each');
    }

    if (input.autoCheckEnabled) {
      multiplier *= 0.85;
      factors.add('Auto-check enabled: x0.85');
    }

    multiplier = multiplier.clamp(0.10, 1.0);
    final base = input.difficulty.baseScore;
    final accuracyScore = (base * multiplier).round();
    final timeBonus = _timeBonus(input, base);
    final efficiencyBonus = _efficiencyBonus(input, base);
    final cleanBonus = input.cleanSolve ? (base * 0.05).round() : 0;

    return SudokuScore(
      total: accuracyScore + timeBonus + efficiencyBonus + cleanBonus,
      baseScore: base,
      accuracyMultiplier: multiplier,
      timeBonus: timeBonus,
      efficiencyBonus: efficiencyBonus,
      cleanSolveBonus: cleanBonus,
      scoringVersion: scoringVersion,
      accuracyFactors: List<String>.unmodifiable(factors),
    );
  }

  int _timeBonus(ScoreInput input, int base) {
    if (!input.timerEnabled ||
        input.elapsedSeconds <= 0 ||
        input.elapsedSeconds >= input.targetTimeSeconds) {
      return 0;
    }
    final ratio = 1 - (input.elapsedSeconds / input.targetTimeSeconds);
    return (base * 0.10 * ratio).round().clamp(0, (base * 0.10).round());
  }

  int _efficiencyBonus(ScoreInput input, int base) {
    if (input.optimalSteps <= 0 || input.playerSteps <= 0) {
      return 0;
    }
    if (input.playerSteps <= (input.optimalSteps * 1.2).ceil()) {
      return (base * 0.05).round();
    }
    return 0;
  }
}
