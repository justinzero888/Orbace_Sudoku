class StoredSolvingStep {
  const StoredSolvingStep({
    required this.stepIndex,
    required this.techniqueId,
    required this.row,
    required this.col,
    required this.value,
    required this.highlightCellIndices,
    required this.affectedCellIndices,
    required this.explanationTemplateKey,
    required this.params,
  });

  final int stepIndex;
  final String techniqueId;
  final int row;
  final int col;
  final int? value;
  final List<int> highlightCellIndices;
  final List<int> affectedCellIndices;
  final String explanationTemplateKey;
  final Map<String, String> params;
}
