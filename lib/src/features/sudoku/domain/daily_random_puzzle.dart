import 'dart:math';

import '../presentation/fixture_puzzles.dart';
import 'sudoku_board.dart';
import 'sudoku_board_transform.dart';

/// Produces a deterministic, per-calendar-day transformed puzzle drawn from
/// a small fixed pool (e.g. the 100 True Extreme puzzles), so a finite pool
/// can serve a visually-fresh daily puzzle indefinitely without repeating,
/// while remaining a valid Sudoku with unchanged solvability/uniqueness.
///
/// The transform (one of 4 reflections + a digit relabeling) is derived
/// purely from the calendar date and a feature-specific salt, so the exact
/// same puzzle is reconstructible for any past date given the same pool --
/// that's what lets Record Hall/Replay/Su-Pu Detail look up historic daily
/// attempts by id alone, without persisting the transformed grid anywhere.
///
/// Combinatorics: pool.length x 4 reflections x 9! digit permutations, e.g.
/// 100 x 4 x 362,880 = ~145M distinct visual variants for a 100-puzzle pool
/// -- won't meaningfully repeat within the app's lifetime.
class DailyRandomPuzzle {
  const DailyRandomPuzzle({
    required this.idPrefix,
    required this.titlePrefix,
    required this.featureSalt,
  });

  /// Single source of truth for the Daily Extreme Challenge transform --
  /// used both where the puzzle is generated (ExtremeHubScreen) and where
  /// it's reconstructed by id for historic lookups (PuzzlePackCatalog.byId).
  static const extremeDaily = DailyRandomPuzzle(
    idPrefix: 'extreme_daily',
    titlePrefix: 'Daily Extreme',
    featureSalt: 0x45585452,
  );

  /// Same as [extremeDaily] but for the Tea Moment daily puzzle.
  static const teaDaily = DailyRandomPuzzle(
    idPrefix: 'tea_daily',
    titlePrefix: 'Daily Tea Moment',
    featureSalt: 0x54454100,
  );

  /// e.g. 'extreme_daily' / 'tea_daily'. Becomes the puzzleId recorded on
  /// attempts, e.g. 'extreme_daily_2026-07-04'.
  final String idPrefix;

  /// e.g. 'Daily Extreme' / 'Daily Tea Moment'.
  final String titlePrefix;

  /// Decorrelates this feature's transform seed from any other daily
  /// feature that might derive a seed from the same date.
  final int featureSalt;

  static final DateTime _epoch = DateTime(2026);

  String idFor(DateTime date) => '${idPrefix}_${_dayKey(date)}';

  /// True if [id] looks like one of this feature's daily ids (regardless of
  /// whether the date within it is valid/parseable).
  bool matches(String id) => id.startsWith('${idPrefix}_');

  /// Extracts the calendar date encoded in a daily id, or null if [id]
  /// doesn't match this feature's prefix or isn't a well-formed date.
  DateTime? parseDate(String id) {
    if (!matches(id)) {
      return null;
    }
    final key = id.substring(idPrefix.length + 1);
    final parts = key.split('-');
    if (parts.length != 3) {
      return null;
    }
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) {
      return null;
    }
    return DateTime(year, month, day);
  }

  /// Builds the deterministic transformed puzzle for [date] from [pool].
  /// Calling this again for the same date and pool always reproduces the
  /// identical puzzle.
  FixturePuzzleDefinition forDate(
    DateTime date,
    List<FixturePuzzleDefinition> pool,
  ) {
    if (pool.isEmpty) {
      throw ArgumentError.value(pool, 'pool', 'must not be empty');
    }
    final normalized = DateTime(date.year, date.month, date.day);
    final dayNumber = normalized.difference(_epoch).inDays;
    final base = pool[dayNumber.abs() % pool.length];

    final random = Random(Object.hash(dayNumber, featureSalt));
    final reflection =
        BoardReflection.values[random.nextInt(BoardReflection.values.length)];
    final shuffledDigits = List<int>.generate(9, (i) => i + 1)
      ..shuffle(random);
    final digitMap = <int, int>{
      for (var i = 0; i < 9; i++) i + 1: shuffledDigits[i],
    };
    final transform = SudokuBoardTransform(
      reflection: reflection,
      digitMap: digitMap,
    );

    return FixturePuzzleDefinition(
      id: idFor(normalized),
      title: '$titlePrefix · ${_dayKey(normalized)}',
      seal: base.seal,
      packId: base.packId,
      difficulty: base.difficulty,
      difficultyScore: base.difficultyScore,
      targetTimeSeconds: base.targetTimeSeconds,
      medianTimeSeconds: base.medianTimeSeconds,
      requiredTechniques: base.requiredTechniques,
      rankedEligible: base.rankedEligible,
      givensRows: _rowsFromBoard(transform.apply(base.givens)),
      solutionRows: _rowsFromBoard(transform.apply(base.solution)),
    );
  }

  static String _dayKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  static List<String> _rowsFromBoard(SudokuBoard board) {
    return <String>[
      for (var row = 0; row < SudokuBoard.size; row++)
        [
          for (var col = 0; col < SudokuBoard.size; col++)
            board.valueAt(row, col)?.toString() ?? '0',
        ].join(),
    ];
  }
}
