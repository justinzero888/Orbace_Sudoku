enum SudokuMoveType { valueEntry, noteToggle, erase, hintReveal }

class SudokuMove {
  const SudokuMove({
    required this.cellIndex,
    required this.previousValue,
    required this.nextValue,
    required this.elapsedSeconds,
    this.type = SudokuMoveType.valueEntry,
    this.noteValue,
  });

  final int cellIndex;
  final int? previousValue;
  final int? nextValue;
  final int elapsedSeconds;
  final SudokuMoveType type;
  final int? noteValue;
}
