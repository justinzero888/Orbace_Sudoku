enum SudokuDifficulty {
  beginner(label: 'Beginner', chineseLabel: '入門', baseScore: 1000),
  easy(label: 'Easy', chineseLabel: '小成', baseScore: 2000),
  medium(label: 'Medium', chineseLabel: '貫通', baseScore: 4000),
  hard(label: 'Hard', chineseLabel: '精深', baseScore: 8000),
  expert(label: 'Expert', chineseLabel: '入神', baseScore: 16000),
  extreme(label: 'Extreme', chineseLabel: '極致', baseScore: 32000);

  const SudokuDifficulty({
    required this.label,
    required this.chineseLabel,
    required this.baseScore,
  });

  final String label;
  final String chineseLabel;
  final int baseScore;
}
