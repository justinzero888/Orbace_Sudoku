import 'solving_action.dart';
import 'unit_utils.dart';

class NakedPairTechnique extends SolvingTechnique {
  const NakedPairTechnique();

  @override
  String get id => 'naked_pair';

  @override
  SolvingAction? findAction(_, Map<int, Set<int>> candidates) {
    for (final unit in allUnits()) {
      final pairCells = <String, List<int>>{};

      for (final index in unit) {
        final values = candidates[index];
        if (values == null || values.length != 2) {
          continue;
        }
        final key = (values.toList()..sort()).join(',');
        pairCells.putIfAbsent(key, () => <int>[]).add(index);
      }

      for (final entry in pairCells.entries) {
        if (entry.value.length != 2) {
          continue;
        }

        final pairValues = entry.key.split(',').map(int.parse).toSet();
        final eliminations = <int, Set<int>>{};
        for (final index in unit) {
          if (entry.value.contains(index)) {
            continue;
          }
          final overlap =
              candidates[index]?.intersection(pairValues) ?? const <int>{};
          if (overlap.isNotEmpty) {
            eliminations[index] = overlap;
          }
        }

        if (eliminations.isNotEmpty) {
          return SolvingAction(
            techniqueId: id,
            eliminations: eliminations,
            highlightCellIndices: entry.value,
            affectedCellIndices: eliminations.keys.toList(),
            explanationTemplateKey: 'naked_pair',
            params: <String, String>{
              'values': entry.key,
              'unit': unitLabel(unit),
            },
          );
        }
      }
    }

    return null;
  }
}
