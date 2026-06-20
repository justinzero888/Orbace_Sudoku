import '../../domain/sudoku_board.dart';
import '../../domain/solving_step.dart';

class SolvingAction {
  const SolvingAction({
    required this.techniqueId,
    required this.highlightCellIndices,
    required this.affectedCellIndices,
    required this.explanationTemplateKey,
    required this.params,
    this.placementIndex,
    this.placementValue,
    this.eliminations = const <int, Set<int>>{},
  });

  final String techniqueId;
  final int? placementIndex;
  final int? placementValue;
  final Map<int, Set<int>> eliminations;
  final List<int> highlightCellIndices;
  final List<int> affectedCellIndices;
  final String explanationTemplateKey;
  final Map<String, String> params;

  bool get placesValue => placementIndex != null && placementValue != null;

  bool get eliminatesCandidates =>
      eliminations.values.any((set) => set.isNotEmpty);

  StoredSolvingStep toStoredStep(int stepIndex) {
    final index = placementIndex ?? affectedCellIndices.first;
    return StoredSolvingStep(
      stepIndex: stepIndex,
      techniqueId: techniqueId,
      row: SudokuBoard.rowOf(index),
      col: SudokuBoard.colOf(index),
      value: placementValue,
      highlightCellIndices: List<int>.unmodifiable(highlightCellIndices),
      affectedCellIndices: List<int>.unmodifiable(affectedCellIndices),
      explanationTemplateKey: explanationTemplateKey,
      params: Map<String, String>.unmodifiable(params),
    );
  }
}

abstract class SolvingTechnique {
  const SolvingTechnique();

  String get id;

  SolvingAction? findAction(SudokuBoard board, Map<int, Set<int>> candidates);
}
