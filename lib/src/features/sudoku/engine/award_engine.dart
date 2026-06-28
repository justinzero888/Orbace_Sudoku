import '../domain/sudoku_attempt.dart';
import '../domain/sudoku_award.dart';

class AwardEngine {
  const AwardEngine();

  AwardSummary evaluate(List<SudokuAttempt> attempts) {
    final completed = attempts.completedAttempts.toList(growable: false);
    final mediumPlus = completed.length;
    final cleanSolves = attempts.cleanSolveCount;
    final noHintSolves = completed.where(_hasNoHints).length;
    final hardQuality = completed
        .where((attempt) => (attempt.score?.accuracyMultiplier ?? 0) >= 0.80)
        .length;
    final expertQuality = completed
        .where((attempt) => (attempt.score?.accuracyMultiplier ?? 0) >= 0.70)
        .length;
    final replayImprovements = attempts.replayImprovementCount;

    final foundation = ScholarPathStage(
      id: ScholarStageId.foundation,
      name: 'Foundation',
      chineseName: '基礎',
      stageNumber: 1,
      unlocksDescription:
          'Unlocks Hard mastery goals and advanced score badges',
      requirements: <AwardRequirement>[
        AwardRequirement(
          id: 'complete_10',
          label: 'Complete 10 puzzles',
          current: mediumPlus,
          target: 10,
        ),
        AwardRequirement(
          id: 'three_no_hint',
          label: 'Complete 3 puzzles with no hints',
          current: noHintSolves,
          target: 3,
        ),
        AwardRequirement(
          id: 'first_clean',
          label: 'Earn a clean solve',
          current: cleanSolves,
          target: 1,
        ),
      ],
    );

    final discipline = ScholarPathStage(
      id: ScholarStageId.discipline,
      name: 'Discipline',
      chineseName: '自律',
      stageNumber: 2,
      unlocksDescription: 'Unlocks Expert mastery goals',
      requirements: <AwardRequirement>[
        AwardRequirement(
          id: 'complete_20',
          label: 'Complete 20 puzzles',
          current: completed.length,
          target: 20,
        ),
        AwardRequirement(
          id: 'five_quality',
          label: 'Complete 5 puzzles with 80%+ accuracy',
          current: hardQuality,
          target: 5,
        ),
        AwardRequirement(
          id: 'three_clean',
          label: 'Complete 3 clean solves',
          current: cleanSolves,
          target: 3,
        ),
      ],
    );

    final insight = ScholarPathStage(
      id: ScholarStageId.insight,
      name: 'Insight',
      chineseName: '悟性',
      stageNumber: 3,
      unlocksDescription: 'Unlocks local Extreme Challenge',
      requirements: <AwardRequirement>[
        AwardRequirement(
          id: 'complete_15_expert_proxy',
          label: 'Complete 15 mastery puzzles',
          current: completed.length,
          target: 15,
        ),
        AwardRequirement(
          id: 'five_70_accuracy',
          label: 'Complete 5 puzzles with 70%+ accuracy',
          current: expertQuality,
          target: 5,
        ),
        AwardRequirement(
          id: 'three_clean_expert_proxy',
          label: 'Complete 3 puzzles with zero errors and zero hints',
          current: cleanSolves,
          target: 3,
        ),
        AwardRequirement(
          id: 'five_replay_improvements',
          label:
              'Complete 5 retry solves with a higher score than your previous best for that puzzle',
          current: replayImprovements,
          target: 5,
        ),
      ],
    );

    final stages = <ScholarPathStage>[foundation, discipline, insight];
    return AwardSummary(
      stages: stages,
      extremeUnlocked: insight.isComplete,
      totalCompleted: completed.length,
      cleanSolves: cleanSolves,
      replayImprovements: replayImprovements,
    );
  }

  bool _hasNoHints(SudokuAttempt attempt) {
    return attempt.hintNudgeCount == 0 &&
        attempt.hintExplanationCount == 0 &&
        attempt.hintRevealCount == 0;
  }
}
