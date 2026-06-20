import '../../domain/sudoku_board.dart';
import 'solving_action.dart';

class PointingPairTechnique extends SolvingTechnique {
  const PointingPairTechnique();

  @override
  String get id => 'pointing_pair';

  @override
  SolvingAction? findAction(_, Map<int, Set<int>> candidates) {
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
        final box = SudokuBoard.boxIndicesByCell(boxRow, boxCol);

        for (var value = 1; value <= 9; value++) {
          final cells = <int>[
            for (final index in box)
              if (candidates[index]?.contains(value) ?? false) index,
          ];
          if (cells.length < 2) {
            continue;
          }

          final rows = cells.map(SudokuBoard.rowOf).toSet();
          if (rows.length == 1) {
            final row = rows.single;
            final eliminations = <int, Set<int>>{};
            for (final index in SudokuBoard.rowIndices(row)) {
              if (box.contains(index)) {
                continue;
              }
              if (candidates[index]?.contains(value) ?? false) {
                eliminations[index] = <int>{value};
              }
            }
            if (eliminations.isNotEmpty) {
              return _action(value, cells, eliminations, 'row ${row + 1}');
            }
          }

          final cols = cells.map(SudokuBoard.colOf).toSet();
          if (cols.length == 1) {
            final col = cols.single;
            final eliminations = <int, Set<int>>{};
            for (final index in SudokuBoard.colIndices(col)) {
              if (box.contains(index)) {
                continue;
              }
              if (candidates[index]?.contains(value) ?? false) {
                eliminations[index] = <int>{value};
              }
            }
            if (eliminations.isNotEmpty) {
              return _action(value, cells, eliminations, 'column ${col + 1}');
            }
          }
        }
      }
    }

    return null;
  }

  SolvingAction _action(
    int value,
    List<int> cells,
    Map<int, Set<int>> eliminations,
    String unit,
  ) {
    return SolvingAction(
      techniqueId: id,
      eliminations: eliminations,
      highlightCellIndices: cells,
      affectedCellIndices: eliminations.keys.toList(),
      explanationTemplateKey: 'pointing_pair',
      params: <String, String>{'value': '$value', 'unit': unit},
    );
  }
}
