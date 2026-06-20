import 'sudoku_attempt.dart';

enum ScholarStageId { foundation, discipline, insight }

class AwardRequirement {
  const AwardRequirement({
    required this.id,
    required this.label,
    required this.current,
    required this.target,
  });

  final String id;
  final String label;
  final int current;
  final int target;

  bool get complete => current >= target;

  double get progress => target == 0 ? 1 : (current / target).clamp(0, 1);
}

class ScholarPathStage {
  const ScholarPathStage({
    required this.id,
    required this.name,
    required this.chineseName,
    required this.stageNumber,
    required this.requirements,
    required this.unlocksDescription,
  });

  final ScholarStageId id;
  final String name;
  final String chineseName;
  final int stageNumber;
  final List<AwardRequirement> requirements;
  final String unlocksDescription;

  bool get isComplete =>
      requirements.every((requirement) => requirement.complete);

  double get progressPercent {
    if (requirements.isEmpty) {
      return 1;
    }
    final total = requirements.fold<double>(
      0,
      (sum, requirement) => sum + requirement.progress,
    );
    return total / requirements.length;
  }
}

class AwardSummary {
  const AwardSummary({
    required this.stages,
    required this.extremeUnlocked,
    required this.totalCompleted,
    required this.cleanSolves,
    required this.replayImprovements,
  });

  final List<ScholarPathStage> stages;
  final bool extremeUnlocked;
  final int totalCompleted;
  final int cleanSolves;
  final int replayImprovements;
}

extension SudokuAttemptAwardMetrics on Iterable<SudokuAttempt> {
  Iterable<SudokuAttempt> get completedAttempts {
    return where((attempt) => attempt.completed);
  }

  int get cleanSolveCount {
    return completedAttempts.where((attempt) => attempt.cleanSolve).length;
  }

  int get replayImprovementCount {
    final bestByPuzzle = <String, int>{};
    var improvements = 0;
    for (final attempt in completedAttempts) {
      final score = attempt.score?.total ?? 0;
      final previousBest = bestByPuzzle[attempt.puzzleId] ?? -1;
      if (attempt.isRetry && score > previousBest) {
        improvements++;
      }
      if (score > previousBest) {
        bestByPuzzle[attempt.puzzleId] = score;
      }
    }
    return improvements;
  }
}
