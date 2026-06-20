import '../../domain/sudoku_board.dart';

List<List<int>> allUnits() {
  return <List<int>>[
    for (var row = 0; row < SudokuBoard.size; row++)
      SudokuBoard.rowIndices(row),
    for (var col = 0; col < SudokuBoard.size; col++)
      SudokuBoard.colIndices(col),
    for (var row = 0; row < SudokuBoard.size; row += SudokuBoard.boxSize)
      for (var col = 0; col < SudokuBoard.size; col += SudokuBoard.boxSize)
        SudokuBoard.boxIndicesByCell(row, col),
  ];
}

String unitLabel(List<int> unit) {
  final first = unit.first;
  final second = unit[1];
  if (SudokuBoard.rowOf(first) == SudokuBoard.rowOf(second)) {
    return 'row ${SudokuBoard.rowOf(first) + 1}';
  }
  if (SudokuBoard.colOf(first) == SudokuBoard.colOf(second)) {
    return 'column ${SudokuBoard.colOf(first) + 1}';
  }
  final box = SudokuBoard.boxOf(
    SudokuBoard.rowOf(first),
    SudokuBoard.colOf(first),
  );
  return 'box ${box + 1}';
}
