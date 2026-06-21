import '../domain/sudoku_board.dart';
import '../domain/sudoku_difficulty.dart';

class FixturePuzzles {
  const FixturePuzzles._();

  static final List<FixturePuzzleDefinition> catalog =
      <FixturePuzzleDefinition>[
        FixturePuzzleDefinition(
          id: 'tea_moment_001',
          title: 'Morning Steam',
          seal: '茶',
          difficulty: SudokuDifficulty.beginner,
          difficultyScore: 80,
          targetTimeSeconds: 360,
          medianTimeSeconds: 480,
          givensRows: _transformRows(_baseGivensRows, <int, int>{
            1: 1,
            2: 2,
            3: 3,
            4: 4,
            5: 5,
            6: 6,
            7: 7,
            8: 8,
            9: 9,
          }),
          solutionRows: _transformRows(_baseSolutionRows, <int, int>{
            1: 1,
            2: 2,
            3: 3,
            4: 4,
            5: 5,
            6: 6,
            7: 7,
            8: 8,
            9: 9,
          }),
        ),
        FixturePuzzleDefinition(
          id: 'tea_moment_002',
          title: 'Paper Lantern',
          seal: '燈',
          difficulty: SudokuDifficulty.beginner,
          difficultyScore: 90,
          targetTimeSeconds: 360,
          medianTimeSeconds: 500,
          givensRows: _transformRows(_baseGivensRows, <int, int>{
            1: 2,
            2: 3,
            3: 4,
            4: 5,
            5: 6,
            6: 7,
            7: 8,
            8: 9,
            9: 1,
          }),
          solutionRows: _transformRows(_baseSolutionRows, <int, int>{
            1: 2,
            2: 3,
            3: 4,
            4: 5,
            5: 6,
            6: 7,
            7: 8,
            8: 9,
            9: 1,
          }),
        ),
        FixturePuzzleDefinition(
          id: 'level_easy_001',
          title: 'Quiet Courtyard',
          seal: '庭',
          difficulty: SudokuDifficulty.easy,
          difficultyScore: 140,
          targetTimeSeconds: 480,
          medianTimeSeconds: 660,
          givensRows: _transformRows(_baseGivensRows, <int, int>{
            1: 9,
            2: 8,
            3: 7,
            4: 6,
            5: 5,
            6: 4,
            7: 3,
            8: 2,
            9: 1,
          }),
          solutionRows: _transformRows(_baseSolutionRows, <int, int>{
            1: 9,
            2: 8,
            3: 7,
            4: 6,
            5: 5,
            6: 4,
            7: 3,
            8: 2,
            9: 1,
          }),
        ),
        FixturePuzzleDefinition(
          id: 'level_easy_002',
          title: 'Ink Stone',
          seal: '墨',
          difficulty: SudokuDifficulty.easy,
          difficultyScore: 160,
          targetTimeSeconds: 500,
          medianTimeSeconds: 690,
          givensRows: _swapRowBands(
            _transformRows(_baseGivensRows, <int, int>{
              1: 4,
              2: 6,
              3: 8,
              4: 1,
              5: 3,
              6: 5,
              7: 7,
              8: 9,
              9: 2,
            }),
          ),
          solutionRows: _swapRowBands(
            _transformRows(_baseSolutionRows, <int, int>{
              1: 4,
              2: 6,
              3: 8,
              4: 1,
              5: 3,
              6: 5,
              7: 7,
              8: 9,
              9: 2,
            }),
          ),
        ),
        FixturePuzzleDefinition(
          id: 'level_medium_001',
          title: 'Scholar Desk',
          seal: '學',
          difficulty: SudokuDifficulty.medium,
          difficultyScore: 240,
          targetTimeSeconds: 720,
          medianTimeSeconds: 960,
          givensRows: _swapStackColumns(
            _transformRows(_baseGivensRows, <int, int>{
              1: 3,
              2: 1,
              3: 9,
              4: 7,
              5: 2,
              6: 8,
              7: 5,
              8: 4,
              9: 6,
            }),
          ),
          solutionRows: _swapStackColumns(
            _transformRows(_baseSolutionRows, <int, int>{
              1: 3,
              2: 1,
              3: 9,
              4: 7,
              5: 2,
              6: 8,
              7: 5,
              8: 4,
              9: 6,
            }),
          ),
        ),
        FixturePuzzleDefinition(
          id: 'level_hard_001',
          title: 'Red Seal',
          seal: '印',
          difficulty: SudokuDifficulty.hard,
          difficultyScore: 360,
          targetTimeSeconds: 900,
          medianTimeSeconds: 1200,
          givensRows: _swapRowBands(
            _swapStackColumns(
              _transformRows(_baseGivensRows, <int, int>{
                1: 6,
                2: 9,
                3: 2,
                4: 8,
                5: 1,
                6: 3,
                7: 4,
                8: 7,
                9: 5,
              }),
            ),
          ),
          solutionRows: _swapRowBands(
            _swapStackColumns(
              _transformRows(_baseSolutionRows, <int, int>{
                1: 6,
                2: 9,
                3: 2,
                4: 8,
                5: 1,
                6: 3,
                7: 4,
                8: 7,
                9: 5,
              }),
            ),
          ),
        ),
      ];

  static FixturePuzzleDefinition get defaultTeaMoment => catalog.first;

  static FixturePuzzleDefinition byId(String id) {
    return catalog.firstWhere(
      (puzzle) => puzzle.id == id,
      orElse: () => defaultTeaMoment,
    );
  }

  static SudokuBoard teaMomentGivens() {
    return defaultTeaMoment.givens;
  }

  static SudokuBoard teaMomentSolution() {
    return defaultTeaMoment.solution;
  }

  static SudokuBoard _boardFromRows(List<String> rows) {
    return SudokuBoard.fromCells(<int?>[
      for (final row in rows)
        for (final char in row.split('')) char == '0' ? null : int.parse(char),
    ]);
  }

  static const List<String> _baseGivensRows = <String>[
    '530070000',
    '600195000',
    '098000060',
    '800060003',
    '400803001',
    '700020006',
    '060000280',
    '000419005',
    '000080079',
  ];

  static const List<String> _baseSolutionRows = <String>[
    '534678912',
    '672195348',
    '198342567',
    '859761423',
    '426853791',
    '713924856',
    '961537284',
    '287419635',
    '345286179',
  ];

  static List<String> _transformRows(
    List<String> rows,
    Map<int, int> digitMap,
  ) {
    return <String>[
      for (final row in rows)
        row.split('').map((char) {
          if (char == '0') {
            return char;
          }
          return digitMap[int.parse(char)].toString();
        }).join(),
    ];
  }

  static List<String> _swapRowBands(List<String> rows) {
    return <String>[
      ...rows.sublist(3, 6),
      ...rows.sublist(0, 3),
      ...rows.sublist(6, 9),
    ];
  }

  static List<String> _swapStackColumns(List<String> rows) {
    return <String>[
      for (final row in rows)
        row.substring(3, 6) + row.substring(0, 3) + row.substring(6, 9),
    ];
  }
}

class FixturePuzzleDefinition {
  const FixturePuzzleDefinition({
    required this.id,
    required this.title,
    required this.seal,
    required this.difficulty,
    required this.difficultyScore,
    required this.targetTimeSeconds,
    required this.medianTimeSeconds,
    required this.givensRows,
    required this.solutionRows,
  });

  final String id;
  final String title;
  final String seal;
  final SudokuDifficulty difficulty;
  final int difficultyScore;
  final int targetTimeSeconds;
  final int medianTimeSeconds;
  final List<String> givensRows;
  final List<String> solutionRows;

  SudokuBoard get givens => FixturePuzzles._boardFromRows(givensRows);

  SudokuBoard get solution => FixturePuzzles._boardFromRows(solutionRows);

  int get clueCount {
    return givensRows.join().split('').where((char) => char != '0').length;
  }
}
