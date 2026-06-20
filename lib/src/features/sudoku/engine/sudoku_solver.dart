import '../domain/sudoku_board.dart';
import 'sudoku_validator.dart';

class SudokuSolver {
  const SudokuSolver();

  static const SudokuValidator _validator = SudokuValidator();

  SudokuBoard? solve(SudokuBoard board) {
    if (!_validator.isValidPartial(board)) {
      return null;
    }

    final cells = board.toMutableCells();
    final solved = _solveCells(cells);
    return solved ? SudokuBoard.fromCells(cells) : null;
  }

  int countSolutions(SudokuBoard board, {int limit = 2}) {
    if (!_validator.isValidPartial(board)) {
      return 0;
    }

    final cells = board.toMutableCells();
    return _countSolutions(cells, limit: limit);
  }

  bool hasUniqueSolution(SudokuBoard board) {
    return countSolutions(board, limit: 2) == 1;
  }

  bool _solveCells(List<int?> cells) {
    final emptyIndex = _bestEmptyIndex(cells);
    if (emptyIndex == null) {
      return true;
    }

    for (final value in _candidatesForCells(cells, emptyIndex)) {
      cells[emptyIndex] = value;
      if (_solveCells(cells)) {
        return true;
      }
      cells[emptyIndex] = null;
    }

    return false;
  }

  int _countSolutions(List<int?> cells, {required int limit}) {
    if (limit <= 0) {
      return 0;
    }

    final emptyIndex = _bestEmptyIndex(cells);
    if (emptyIndex == null) {
      return 1;
    }

    var count = 0;
    for (final value in _candidatesForCells(cells, emptyIndex)) {
      cells[emptyIndex] = value;
      count += _countSolutions(cells, limit: limit - count);
      cells[emptyIndex] = null;

      if (count >= limit) {
        return count;
      }
    }

    return count;
  }

  int? _bestEmptyIndex(List<int?> cells) {
    int? bestIndex;
    var bestCandidateCount = 10;

    for (var index = 0; index < cells.length; index++) {
      if (cells[index] != null) {
        continue;
      }

      final candidateCount = _candidatesForCells(cells, index).length;
      if (candidateCount == 0) {
        return index;
      }
      if (candidateCount < bestCandidateCount) {
        bestCandidateCount = candidateCount;
        bestIndex = index;
      }
    }

    return bestIndex;
  }

  List<int> _candidatesForCells(List<int?> cells, int cellIndex) {
    final row = SudokuBoard.rowOf(cellIndex);
    final col = SudokuBoard.colOf(cellIndex);
    final used = <int>{};

    for (final index in SudokuBoard.rowIndices(row)) {
      final value = cells[index];
      if (value != null) {
        used.add(value);
      }
    }

    for (final index in SudokuBoard.colIndices(col)) {
      final value = cells[index];
      if (value != null) {
        used.add(value);
      }
    }

    for (final index in SudokuBoard.boxIndicesByCell(row, col)) {
      final value = cells[index];
      if (value != null) {
        used.add(value);
      }
    }

    return <int>[
      for (var value = 1; value <= 9; value++)
        if (!used.contains(value)) value,
    ];
  }
}
