import '../domain/sudoku_board.dart';
import 'sudoku_validator.dart';

class SudokuSolver {
  const SudokuSolver();

  static const SudokuValidator _validator = SudokuValidator();

  SudokuBoard? solve(SudokuBoard board) {
    if (!_validator.isValidPartial(board)) {
      return null;
    }

    final state = _SearchState(board);
    return state.solve() ? state.toBoard() : null;
  }

  int countSolutions(SudokuBoard board, {int limit = 2}) {
    if (!_validator.isValidPartial(board)) {
      return 0;
    }

    final state = _SearchState(board);
    return state.countSolutions(limit);
  }

  bool hasUniqueSolution(SudokuBoard board) {
    return countSolutions(board, limit: 2) == 1;
  }
}

/// Backtracking search over bitmask candidate sets.
///
/// Rows, columns, and boxes each keep a 9-bit mask of digits already placed,
/// updated incrementally as cells are filled/unfilled. This replaces
/// rescanning all 27 peer cells (building a `Set<int>` from scratch) on every
/// candidate lookup, which was the dominant cost of the search and made
/// hand-entered, under-constrained boards slow enough to look like a hang.
class _SearchState {
  _SearchState(SudokuBoard board)
    : cells = board.toMutableCells(),
      _rowMask = List<int>.filled(SudokuBoard.size, 0),
      _colMask = List<int>.filled(SudokuBoard.size, 0),
      _boxMask = List<int>.filled(SudokuBoard.size, 0) {
    for (var index = 0; index < cells.length; index++) {
      final value = cells[index];
      if (value != null) {
        _place(index, value);
      }
    }
  }

  static const int _fullMask = 0x1FF;

  final List<int?> cells;
  final List<int> _rowMask;
  final List<int> _colMask;
  final List<int> _boxMask;

  SudokuBoard toBoard() => SudokuBoard.fromCells(cells);

  bool solve() {
    final index = _bestEmptyIndex();
    if (index == null) {
      return true;
    }

    var mask = _candidateMask(index);
    while (mask != 0) {
      final bit = mask & -mask;
      final value = _digitForBit(bit);
      mask &= ~bit;

      cells[index] = value;
      _place(index, value);
      if (solve()) {
        return true;
      }
      _unplace(index, value);
      cells[index] = null;
    }

    return false;
  }

  int countSolutions(int limit) {
    if (limit <= 0) {
      return 0;
    }

    final index = _bestEmptyIndex();
    if (index == null) {
      return 1;
    }

    var count = 0;
    var mask = _candidateMask(index);
    while (mask != 0) {
      final bit = mask & -mask;
      final value = _digitForBit(bit);
      mask &= ~bit;

      cells[index] = value;
      _place(index, value);
      count += countSolutions(limit - count);
      _unplace(index, value);
      cells[index] = null;

      if (count >= limit) {
        return count;
      }
    }

    return count;
  }

  int? _bestEmptyIndex() {
    int? bestIndex;
    var bestCandidateCount = 10;

    for (var index = 0; index < cells.length; index++) {
      if (cells[index] != null) {
        continue;
      }

      final candidateCount = _popCount(_candidateMask(index));
      if (candidateCount == 0) {
        return index;
      }
      if (candidateCount < bestCandidateCount) {
        bestCandidateCount = candidateCount;
        bestIndex = index;
        if (candidateCount == 1) {
          break;
        }
      }
    }

    return bestIndex;
  }

  int _candidateMask(int index) {
    final row = SudokuBoard.rowOf(index);
    final col = SudokuBoard.colOf(index);
    final box = SudokuBoard.boxOf(row, col);
    return _fullMask & ~(_rowMask[row] | _colMask[col] | _boxMask[box]);
  }

  void _place(int index, int value) {
    final bit = 1 << (value - 1);
    _rowMask[SudokuBoard.rowOf(index)] |= bit;
    _colMask[SudokuBoard.colOf(index)] |= bit;
    _boxMask[SudokuBoard.boxOf(SudokuBoard.rowOf(index), SudokuBoard.colOf(index))] |=
        bit;
  }

  void _unplace(int index, int value) {
    final bit = 1 << (value - 1);
    _rowMask[SudokuBoard.rowOf(index)] &= ~bit;
    _colMask[SudokuBoard.colOf(index)] &= ~bit;
    _boxMask[SudokuBoard.boxOf(SudokuBoard.rowOf(index), SudokuBoard.colOf(index))] &=
        ~bit;
  }

  static int _digitForBit(int bit) {
    var value = 1;
    var shifted = bit;
    while (shifted > 1) {
      shifted >>= 1;
      value += 1;
    }
    return value;
  }

  static int _popCount(int mask) {
    var value = mask;
    var count = 0;
    while (value != 0) {
      value &= value - 1;
      count += 1;
    }
    return count;
  }
}
