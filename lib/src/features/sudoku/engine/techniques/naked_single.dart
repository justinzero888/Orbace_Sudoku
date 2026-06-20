import '../../domain/sudoku_board.dart';
import 'solving_action.dart';

class NakedSingleTechnique extends SolvingTechnique {
  const NakedSingleTechnique();

  @override
  String get id => 'naked_single';

  @override
  SolvingAction? findAction(SudokuBoard board, Map<int, Set<int>> candidates) {
    final ordered = candidates.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    for (final entry in ordered) {
      if (entry.value.length == 1) {
        final value = entry.value.single;
        return SolvingAction(
          techniqueId: id,
          placementIndex: entry.key,
          placementValue: value,
          highlightCellIndices: <int>[
            entry.key,
            ...SudokuBoard.peerIndices(entry.key),
          ],
          affectedCellIndices: <int>[entry.key],
          explanationTemplateKey: 'naked_single',
          params: <String, String>{'value': '$value'},
        );
      }
    }

    return null;
  }
}
