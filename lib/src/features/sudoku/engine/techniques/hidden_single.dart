import 'solving_action.dart';
import 'unit_utils.dart';

class HiddenSingleTechnique extends SolvingTechnique {
  const HiddenSingleTechnique();

  @override
  String get id => 'hidden_single';

  @override
  SolvingAction? findAction(_, Map<int, Set<int>> candidates) {
    for (final unit in allUnits()) {
      for (var value = 1; value <= 9; value++) {
        final possibleCells = <int>[
          for (final index in unit)
            if (candidates[index]?.contains(value) ?? false) index,
        ];

        if (possibleCells.length == 1) {
          return SolvingAction(
            techniqueId: id,
            placementIndex: possibleCells.single,
            placementValue: value,
            highlightCellIndices: unit,
            affectedCellIndices: possibleCells,
            explanationTemplateKey: 'hidden_single',
            params: <String, String>{
              'value': '$value',
              'unit': unitLabel(unit),
            },
          );
        }
      }
    }

    return null;
  }
}
