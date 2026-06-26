class SudokuCurrentProgress {
  const SudokuCurrentProgress({
    required this.puzzleId,
    required this.values,
    required this.notes,
    required this.elapsedSeconds,
    required this.updatedAt,
  });

  final String puzzleId;
  final List<int?> values;
  final List<Set<int>> notes;
  final int elapsedSeconds;
  final DateTime updatedAt;
}
