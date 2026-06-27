import '../domain/sudoku_attempt.dart';

class SuPuComparison {
  const SuPuComparison({
    required this.primary,
    required this.baseline,
    required this.rows,
  });

  final SudokuAttempt primary;
  final SudokuAttempt baseline;
  final List<SuPuComparisonRow> rows;
}

class SuPuComparisonRow {
  const SuPuComparisonRow({
    required this.label,
    required this.primaryValue,
    required this.baselineValue,
    required this.delta,
    required this.improved,
  });

  final String label;
  final String primaryValue;
  final String baselineValue;
  final String delta;
  final bool? improved;
}

class SuPuCompareEngine {
  const SuPuCompareEngine();

  SuPuComparison compare({
    required SudokuAttempt primary,
    required SudokuAttempt baseline,
  }) {
    if (primary.puzzleId != baseline.puzzleId) {
      throw ArgumentError.value(
        '${primary.puzzleId} vs ${baseline.puzzleId}',
        'attempts',
        'Can only compare Su-Pu for the same puzzle.',
      );
    }

    final primaryHints = _hintCount(primary);
    final baselineHints = _hintCount(baseline);
    final primaryScore = primary.score?.total ?? 0;
    final baselineScore = baseline.score?.total ?? 0;
    final primaryAccuracy = primary.score?.accuracyMultiplier;
    final baselineAccuracy = baseline.score?.accuracyMultiplier;

    return SuPuComparison(
      primary: primary,
      baseline: baseline,
      rows: <SuPuComparisonRow>[
        _higherIsBetter(
          label: 'Score',
          primary: primaryScore,
          baseline: baselineScore,
        ),
        _lowerIsBetter(
          label: 'Time',
          primary: primary.elapsedSeconds,
          baseline: baseline.elapsedSeconds,
          formatter: _formatTime,
        ),
        _lowerIsBetter(
          label: 'Steps',
          primary: primary.moveHistory.length,
          baseline: baseline.moveHistory.length,
        ),
        _lowerIsBetter(
          label: 'Mistakes',
          primary: primary.errorCount,
          baseline: baseline.errorCount,
        ),
        _lowerIsBetter(
          label: 'Hints',
          primary: primaryHints,
          baseline: baselineHints,
        ),
        SuPuComparisonRow(
          label: 'Accuracy',
          primaryValue: _formatPercent(primaryAccuracy),
          baselineValue: _formatPercent(baselineAccuracy),
          delta: _accuracyDelta(primaryAccuracy, baselineAccuracy),
          improved: primaryAccuracy == null || baselineAccuracy == null
              ? null
              : primaryAccuracy > baselineAccuracy
              ? true
              : primaryAccuracy < baselineAccuracy
              ? false
              : null,
        ),
        SuPuComparisonRow(
          label: 'Score Class',
          primaryValue: primary.scoreClass.label,
          baselineValue: baseline.scoreClass.label,
          delta: primary.scoreClass == baseline.scoreClass ? 'same' : 'changed',
          improved: null,
        ),
        SuPuComparisonRow(
          label: 'Clean',
          primaryValue: primary.cleanSolve ? 'Yes' : 'No',
          baselineValue: baseline.cleanSolve ? 'Yes' : 'No',
          delta: primary.cleanSolve == baseline.cleanSolve
              ? 'same'
              : primary.cleanSolve
              ? 'cleaner'
              : 'less clean',
          improved: primary.cleanSolve == baseline.cleanSolve
              ? null
              : primary.cleanSolve,
        ),
      ],
    );
  }

  SuPuComparisonRow _higherIsBetter({
    required String label,
    required int primary,
    required int baseline,
    String Function(int value) formatter = _formatInt,
  }) {
    final delta = primary - baseline;
    return SuPuComparisonRow(
      label: label,
      primaryValue: formatter(primary),
      baselineValue: formatter(baseline),
      delta: _signed(delta),
      improved: delta == 0 ? null : delta > 0,
    );
  }

  SuPuComparisonRow _lowerIsBetter({
    required String label,
    required int primary,
    required int baseline,
    String Function(int value) formatter = _formatInt,
  }) {
    final delta = primary - baseline;
    return SuPuComparisonRow(
      label: label,
      primaryValue: formatter(primary),
      baselineValue: formatter(baseline),
      delta: _signed(-delta),
      improved: delta == 0 ? null : delta < 0,
    );
  }

  static int _hintCount(SudokuAttempt attempt) {
    return attempt.hintNudgeCount +
        attempt.hintExplanationCount +
        attempt.hintRevealCount;
  }

  static String _accuracyDelta(double? primary, double? baseline) {
    if (primary == null || baseline == null) {
      return 'n/a';
    }
    final delta = ((primary - baseline) * 100).round();
    return '${_signed(delta)} pts';
  }

  static String _formatPercent(double? value) {
    if (value == null) {
      return 'n/a';
    }
    return '${(value * 100).round()}%';
  }

  static String _formatInt(int value) => '$value';

  static String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;
    return '$minutes:${remaining.toString().padLeft(2, '0')}';
  }

  static String _signed(int value) {
    if (value > 0) {
      return '+$value';
    }
    return '$value';
  }
}
