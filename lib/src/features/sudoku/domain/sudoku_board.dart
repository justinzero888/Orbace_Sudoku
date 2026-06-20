class SudokuBoard {
  const SudokuBoard._(this.cells);

  factory SudokuBoard.empty() {
    return SudokuBoard._(List<int?>.filled(cellCount, null, growable: false));
  }

  factory SudokuBoard.fromCells(List<int?> cells) {
    if (cells.length != cellCount) {
      throw ArgumentError.value(cells.length, 'cells.length', 'must be 81');
    }

    for (final value in cells) {
      if (value != null && (value < 1 || value > 9)) {
        throw ArgumentError.value(value, 'cells', 'values must be 1-9 or null');
      }
    }

    return SudokuBoard._(List<int?>.unmodifiable(cells));
  }

  static const int size = 9;
  static const int boxSize = 3;
  static const int cellCount = size * size;

  final List<int?> cells;

  int? valueAt(int row, int col) => cells[index(row, col)];

  int? valueAtIndex(int index) => cells[index];

  bool get isComplete => cells.every((value) => value != null);

  SudokuBoard setValue(int row, int col, int? value) {
    return setValueAt(index(row, col), value);
  }

  SudokuBoard setValueAt(int cellIndex, int? value) {
    if (cellIndex < 0 || cellIndex >= cellCount) {
      throw RangeError.range(cellIndex, 0, cellCount - 1, 'cellIndex');
    }
    if (value != null && (value < 1 || value > 9)) {
      throw ArgumentError.value(value, 'value', 'must be 1-9 or null');
    }

    final next = cells.toList();
    next[cellIndex] = value;
    return SudokuBoard.fromCells(next);
  }

  List<int?> toMutableCells() => cells.toList();

  static int index(int row, int col) {
    if (row < 0 || row >= size) {
      throw RangeError.range(row, 0, size - 1, 'row');
    }
    if (col < 0 || col >= size) {
      throw RangeError.range(col, 0, size - 1, 'col');
    }
    return row * size + col;
  }

  static int rowOf(int index) => index ~/ size;

  static int colOf(int index) => index % size;

  static int boxOf(int row, int col) {
    return (row ~/ boxSize) * boxSize + (col ~/ boxSize);
  }

  static List<int> rowIndices(int row) {
    return List<int>.generate(size, (col) => index(row, col));
  }

  static List<int> colIndices(int col) {
    return List<int>.generate(size, (row) => index(row, col));
  }

  static List<int> boxIndicesByCell(int row, int col) {
    final startRow = (row ~/ boxSize) * boxSize;
    final startCol = (col ~/ boxSize) * boxSize;
    return <int>[
      for (var r = startRow; r < startRow + boxSize; r++)
        for (var c = startCol; c < startCol + boxSize; c++) index(r, c),
    ];
  }

  static List<int> peerIndices(int cellIndex) {
    final row = rowOf(cellIndex);
    final col = colOf(cellIndex);
    return <int>{
      ...rowIndices(row),
      ...colIndices(col),
      ...boxIndicesByCell(row, col),
    }.where((index) => index != cellIndex).toList(growable: false);
  }
}
