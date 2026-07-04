import '../../domain/sudoku_board.dart';
import 'solving_action.dart';

/// X-Wing: if a candidate value is confined to exactly two cells in each of
/// two rows, and those cells share the same two columns (or the symmetric
/// case with rows/columns swapped), the value can be eliminated from every
/// other cell in those two columns (or rows).
class XWingTechnique extends SolvingTechnique {
  const XWingTechnique();

  @override
  String get id => 'x_wing';

  @override
  SolvingAction? findAction(_, Map<int, Set<int>> candidates) {
    for (var value = 1; value <= 9; value++) {
      final rowAction = _findInLines(
        value: value,
        primaryIndices: SudokuBoard.rowIndices,
        secondaryOf: SudokuBoard.colOf,
        secondaryIndices: SudokuBoard.colIndices,
        unitLabel: 'columns',
        candidates: candidates,
      );
      if (rowAction != null) {
        return rowAction;
      }

      final colAction = _findInLines(
        value: value,
        primaryIndices: SudokuBoard.colIndices,
        secondaryOf: SudokuBoard.rowOf,
        secondaryIndices: SudokuBoard.rowIndices,
        unitLabel: 'rows',
        candidates: candidates,
      );
      if (colAction != null) {
        return colAction;
      }
    }
    return null;
  }

  SolvingAction? _findInLines({
    required int value,
    required List<int> Function(int) primaryIndices,
    required int Function(int) secondaryOf,
    required List<int> Function(int) secondaryIndices,
    required String unitLabel,
    required Map<int, Set<int>> candidates,
  }) {
    final linesWithPair = <int, List<int>>{};
    for (var line = 0; line < SudokuBoard.size; line++) {
      final cells = <int>[
        for (final index in primaryIndices(line))
          if (candidates[index]?.contains(value) ?? false) index,
      ];
      if (cells.length == 2) {
        linesWithPair[line] = cells;
      }
    }

    final lineIds = linesWithPair.keys.toList();
    for (var i = 0; i < lineIds.length; i++) {
      for (var j = i + 1; j < lineIds.length; j++) {
        final cellsA = linesWithPair[lineIds[i]]!;
        final cellsB = linesWithPair[lineIds[j]]!;
        final secondaryA = cellsA.map(secondaryOf).toSet();
        final secondaryB = cellsB.map(secondaryOf).toSet();
        if (secondaryA.length != 2 ||
            secondaryA.difference(secondaryB).isNotEmpty) {
          continue;
        }

        final cornerCells = <int>{...cellsA, ...cellsB};
        final eliminations = <int, Set<int>>{};
        for (final secondary in secondaryA) {
          for (final index in secondaryIndices(secondary)) {
            if (cornerCells.contains(index)) {
              continue;
            }
            if (candidates[index]?.contains(value) ?? false) {
              eliminations[index] = <int>{value};
            }
          }
        }

        if (eliminations.isNotEmpty) {
          return SolvingAction(
            techniqueId: id,
            eliminations: eliminations,
            highlightCellIndices: cornerCells.toList(),
            affectedCellIndices: eliminations.keys.toList(),
            explanationTemplateKey: 'x_wing',
            params: <String, String>{'value': '$value', 'unit': unitLabel},
          );
        }
      }
    }
    return null;
  }
}
