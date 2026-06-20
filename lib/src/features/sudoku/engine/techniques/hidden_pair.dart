import 'solving_action.dart';
import 'unit_utils.dart';

class HiddenPairTechnique extends SolvingTechnique {
  const HiddenPairTechnique();

  @override
  String get id => 'hidden_pair';

  @override
  SolvingAction? findAction(_, Map<int, Set<int>> candidates) {
    for (final unit in allUnits()) {
      final cellsByValue = <int, List<int>>{};
      for (var value = 1; value <= 9; value++) {
        cellsByValue[value] = <int>[
          for (final index in unit)
            if (candidates[index]?.contains(value) ?? false) index,
        ];
      }

      for (var first = 1; first <= 8; first++) {
        for (var second = first + 1; second <= 9; second++) {
          final firstCells = cellsByValue[first]!;
          final secondCells = cellsByValue[second]!;
          if (firstCells.length != 2 ||
              secondCells.length != 2 ||
              firstCells[0] != secondCells[0] ||
              firstCells[1] != secondCells[1]) {
            continue;
          }

          final pairCells = firstCells;
          final pairValues = <int>{first, second};
          final eliminations = <int, Set<int>>{};
          for (final index in pairCells) {
            final extra = (candidates[index] ?? const <int>{}).difference(
              pairValues,
            );
            if (extra.isNotEmpty) {
              eliminations[index] = extra;
            }
          }

          if (eliminations.isNotEmpty) {
            return SolvingAction(
              techniqueId: id,
              eliminations: eliminations,
              highlightCellIndices: pairCells,
              affectedCellIndices: pairCells,
              explanationTemplateKey: 'hidden_pair',
              params: <String, String>{
                'values': '$first,$second',
                'unit': unitLabel(unit),
              },
            );
          }
        }
      }
    }

    return null;
  }
}
