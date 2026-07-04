import 'sudoku_board.dart';

/// One of the 4 reflections of a 9x9 grid that preserve Sudoku validity
/// (band/stack membership and box structure survive each of these intact).
enum BoardReflection { horizontal, vertical, mainDiagonal, antiDiagonal }

/// Applies a reflection plus a 1-9 digit relabeling to a [SudokuBoard].
/// Both operations preserve solution uniqueness and solvability -- verified
/// empirically in scripts/verify_board_transforms.dart against real pool
/// puzzles before this was wired into daily puzzle selection.
class SudokuBoardTransform {
  const SudokuBoardTransform({required this.reflection, required this.digitMap});

  final BoardReflection reflection;

  /// Bijection from each digit 1-9 to its replacement digit 1-9.
  final Map<int, int> digitMap;

  SudokuBoard apply(SudokuBoard board) {
    final reflected = _reflect(board.toMutableCells(), reflection);
    final remapped = _remapDigits(reflected, digitMap);
    return SudokuBoard.fromCells(remapped);
  }

  static List<int?> _reflect(List<int?> cells, BoardReflection kind) {
    final out = List<int?>.filled(SudokuBoard.cellCount, null);
    for (var row = 0; row < SudokuBoard.size; row++) {
      for (var col = 0; col < SudokuBoard.size; col++) {
        final value = cells[SudokuBoard.index(row, col)];
        final int newRow;
        final int newCol;
        switch (kind) {
          case BoardReflection.horizontal:
            newRow = row;
            newCol = 8 - col;
          case BoardReflection.vertical:
            newRow = 8 - row;
            newCol = col;
          case BoardReflection.mainDiagonal:
            newRow = col;
            newCol = row;
          case BoardReflection.antiDiagonal:
            newRow = 8 - col;
            newCol = 8 - row;
        }
        out[SudokuBoard.index(newRow, newCol)] = value;
      }
    }
    return out;
  }

  static List<int?> _remapDigits(List<int?> cells, Map<int, int> digitMap) {
    return cells.map((value) => value == null ? null : digitMap[value]).toList();
  }
}
