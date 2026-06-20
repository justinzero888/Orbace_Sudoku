class DailyTeaMoment {
  const DailyTeaMoment({
    required this.date,
    required this.puzzleId,
    required this.dayKey,
  });

  final DateTime date;
  final String puzzleId;
  final String dayKey;
}

class DailyTeaMomentSelector {
  const DailyTeaMomentSelector();

  DailyTeaMoment forDate(DateTime date, List<String> puzzleIds) {
    if (puzzleIds.isEmpty) {
      throw ArgumentError.value(puzzleIds, 'puzzleIds', 'must not be empty');
    }

    final normalized = DateTime(date.year, date.month, date.day);
    final dayNumber = normalized.difference(DateTime(2026)).inDays;
    final index = dayNumber.abs() % puzzleIds.length;
    final dayKey =
        '${normalized.year.toString().padLeft(4, '0')}-'
        '${normalized.month.toString().padLeft(2, '0')}-'
        '${normalized.day.toString().padLeft(2, '0')}';
    return DailyTeaMoment(
      date: normalized,
      puzzleId: puzzleIds[index],
      dayKey: dayKey,
    );
  }
}
