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
          packId: 'tea_moments',
          difficulty: SudokuDifficulty.beginner,
          difficultyScore: 80,
          targetTimeSeconds: 360,
          medianTimeSeconds: 480,
          requiredTechniques: const <String>['hidden_single', 'naked_single'],
          givensRows: _transformRows(_baseGivensRows, _identityDigitMap),
          solutionRows: _transformRows(_baseSolutionRows, _identityDigitMap),
        ),
        FixturePuzzleDefinition(
          id: 'tea_moment_002',
          title: 'Paper Lantern',
          seal: '燈',
          packId: 'tea_moments',
          difficulty: SudokuDifficulty.beginner,
          difficultyScore: 90,
          targetTimeSeconds: 360,
          medianTimeSeconds: 500,
          requiredTechniques: const <String>['hidden_single', 'naked_single'],
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

  static SudokuBoard boardFromRows(List<String> rows) {
    return SudokuBoard.fromCells(<int?>[
      for (final row in rows)
        for (final char in row.split('')) char == '0' ? null : int.parse(char),
    ]);
  }

  static const Map<int, int> _identityDigitMap = <int, int>{
    1: 1,
    2: 2,
    3: 3,
    4: 4,
    5: 5,
    6: 6,
    7: 7,
    8: 8,
    9: 9,
  };

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
    this.packId,
    this.requiredTechniques = const <String>[],
    this.rankedEligible = false,
  });

  factory FixturePuzzleDefinition.fromJson(
    Map<String, Object?> json, {
    required String packId,
  }) {
    return FixturePuzzleDefinition(
      id: json['id']! as String,
      title: json['title']! as String,
      seal: json['seal']! as String,
      packId: packId,
      difficulty: SudokuDifficulty.values.byName(json['difficulty']! as String),
      difficultyScore: json['difficultyScore']! as int,
      targetTimeSeconds: json['targetTimeSeconds']! as int,
      medianTimeSeconds: json['medianTimeSeconds']! as int,
      requiredTechniques: (json['requiredTechniques']! as List<Object?>)
          .cast<String>(),
      rankedEligible: json['rankedEligible'] as bool? ?? false,
      givensRows: (json['givensRows']! as List<Object?>).cast<String>(),
      solutionRows: (json['solutionRows']! as List<Object?>).cast<String>(),
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'title': title,
      'seal': seal,
      'difficulty': difficulty.name,
      'difficultyScore': difficultyScore,
      'targetTimeSeconds': targetTimeSeconds,
      'medianTimeSeconds': medianTimeSeconds,
      'requiredTechniques': requiredTechniques,
      'rankedEligible': rankedEligible,
      'givensRows': givensRows,
      'solutionRows': solutionRows,
    };
  }

  final String id;
  final String title;
  final String seal;
  final String? packId;
  final SudokuDifficulty difficulty;
  final int difficultyScore;
  final int targetTimeSeconds;
  final int medianTimeSeconds;
  final List<String> requiredTechniques;
  final bool rankedEligible;
  final List<String> givensRows;
  final List<String> solutionRows;

  SudokuBoard get givens => FixturePuzzles.boardFromRows(givensRows);

  SudokuBoard get solution => FixturePuzzles.boardFromRows(solutionRows);

  int get clueCount {
    return givensRows.join().split('').where((char) => char != '0').length;
  }
}
