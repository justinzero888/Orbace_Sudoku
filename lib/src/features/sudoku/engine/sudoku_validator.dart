import '../domain/sudoku_board.dart';

class SudokuValidator {
  const SudokuValidator();

  bool isValidPartial(SudokuBoard board) {
    for (var row = 0; row < SudokuBoard.size; row++) {
      if (!_unitIsValid(SudokuBoard.rowIndices(row), board)) {
        return false;
      }
    }

    for (var col = 0; col < SudokuBoard.size; col++) {
      if (!_unitIsValid(SudokuBoard.colIndices(col), board)) {
        return false;
      }
    }

    for (
      var boxRow = 0;
      boxRow < SudokuBoard.size;
      boxRow += SudokuBoard.boxSize
    ) {
      for (
        var boxCol = 0;
        boxCol < SudokuBoard.size;
        boxCol += SudokuBoard.boxSize
      ) {
        if (!_unitIsValid(
          SudokuBoard.boxIndicesByCell(boxRow, boxCol),
          board,
        )) {
          return false;
        }
      }
    }

    return true;
  }

  bool isSolved(SudokuBoard board) {
    return board.isComplete && isValidPartial(board);
  }

  Set<int> candidatesFor(SudokuBoard board, int cellIndex) {
    if (board.valueAtIndex(cellIndex) != null) {
      return const <int>{};
    }

    final used = <int>{};
    for (final peerIndex in SudokuBoard.peerIndices(cellIndex)) {
      final value = board.valueAtIndex(peerIndex);
      if (value != null) {
        used.add(value);
      }
    }

    return <int>{
      for (var value = 1; value <= 9; value++)
        if (!used.contains(value)) value,
    };
  }

  Map<int, Set<int>> candidateMap(SudokuBoard board) {
    return <int, Set<int>>{
      for (var index = 0; index < SudokuBoard.cellCount; index++)
        if (board.valueAtIndex(index) == null)
          index: candidatesFor(board, index),
    };
  }

  bool _unitIsValid(List<int> indices, SudokuBoard board) {
    final seen = <int>{};
    for (final index in indices) {
      final value = board.valueAtIndex(index);
      if (value == null) {
        continue;
      }
      if (!seen.add(value)) {
        return false;
      }
    }
    return true;
  }
}
