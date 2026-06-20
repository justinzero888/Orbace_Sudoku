import '../domain/sudoku_board.dart';

class FixturePuzzles {
  const FixturePuzzles._();

  static SudokuBoard teaMomentGivens() {
    return _boardFromRows(<String>[
      '530070000',
      '600195000',
      '098000060',
      '800060003',
      '400803001',
      '700020006',
      '060000280',
      '000419005',
      '000080079',
    ]);
  }

  static SudokuBoard teaMomentSolution() {
    return _boardFromRows(<String>[
      '534678912',
      '672195348',
      '198342567',
      '859761423',
      '426853791',
      '713924856',
      '961537284',
      '287419635',
      '345286179',
    ]);
  }

  static SudokuBoard _boardFromRows(List<String> rows) {
    return SudokuBoard.fromCells(<int?>[
      for (final row in rows)
        for (final char in row.split('')) char == '0' ? null : int.parse(char),
    ]);
  }
}
