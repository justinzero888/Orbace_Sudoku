enum SudokuScoreClass {
  official(label: 'Official'),
  assisted(label: 'Practice'),
  retry(label: 'Retry'),
  legacy(label: 'Legacy');

  const SudokuScoreClass({required this.label});

  final String label;
}
