class SudokuScore {
  const SudokuScore({
    required this.total,
    required this.baseScore,
    required this.accuracyMultiplier,
    required this.timeBonus,
    required this.efficiencyBonus,
    required this.cleanSolveBonus,
    required this.scoringVersion,
    required this.accuracyFactors,
  });

  final int total;
  final int baseScore;
  final double accuracyMultiplier;
  final int timeBonus;
  final int efficiencyBonus;
  final int cleanSolveBonus;
  final int scoringVersion;
  final List<String> accuracyFactors;
}
