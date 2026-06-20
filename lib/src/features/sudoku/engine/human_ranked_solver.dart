import '../domain/sudoku_board.dart';
import '../domain/solving_step.dart';
import 'sudoku_validator.dart';
import 'techniques/hidden_pair.dart';
import 'techniques/hidden_single.dart';
import 'techniques/naked_pair.dart';
import 'techniques/naked_single.dart';
import 'techniques/pointing_pair.dart';
import 'techniques/solving_action.dart';

class HumanSolveResult {
  const HumanSolveResult({
    required this.solved,
    required this.board,
    required this.steps,
  });

  final bool solved;
  final SudokuBoard board;
  final List<StoredSolvingStep> steps;
}

class HumanRankedSolver {
  HumanRankedSolver({List<SolvingTechnique>? techniques, this.maxSteps = 1000})
    : _techniques =
          techniques ??
          const <SolvingTechnique>[
            NakedSingleTechnique(),
            HiddenSingleTechnique(),
            NakedPairTechnique(),
            HiddenPairTechnique(),
            PointingPairTechnique(),
          ];

  static const SudokuValidator _validator = SudokuValidator();
  final List<SolvingTechnique> _techniques;
  final int maxSteps;

  HumanSolveResult solve(SudokuBoard initialBoard) {
    if (!_validator.isValidPartial(initialBoard)) {
      return HumanSolveResult(
        solved: false,
        board: initialBoard,
        steps: const <StoredSolvingStep>[],
      );
    }

    var board = initialBoard;
    final steps = <StoredSolvingStep>[];
    final eliminated = <int, Set<int>>{};

    for (var stepIndex = 0; stepIndex < maxSteps; stepIndex++) {
      if (_validator.isSolved(board)) {
        return HumanSolveResult(
          solved: true,
          board: board,
          steps: List<StoredSolvingStep>.unmodifiable(steps),
        );
      }

      final candidates = _candidateMap(board, eliminated);
      if (candidates.values.any((set) => set.isEmpty)) {
        return HumanSolveResult(
          solved: false,
          board: board,
          steps: List<StoredSolvingStep>.unmodifiable(steps),
        );
      }

      SolvingAction? action;
      for (final technique in _techniques) {
        action = technique.findAction(board, candidates);
        if (action != null) {
          break;
        }
      }

      if (action == null) {
        return HumanSolveResult(
          solved: false,
          board: board,
          steps: List<StoredSolvingStep>.unmodifiable(steps),
        );
      }

      steps.add(action.toStoredStep(steps.length));

      if (action.placesValue) {
        board = board.setValueAt(action.placementIndex!, action.placementValue);
        eliminated.remove(action.placementIndex);
        continue;
      }

      if (action.eliminatesCandidates) {
        for (final entry in action.eliminations.entries) {
          final values = eliminated.putIfAbsent(entry.key, () => <int>{});
          values.addAll(entry.value);
        }
      }
    }

    return HumanSolveResult(
      solved: false,
      board: board,
      steps: List<StoredSolvingStep>.unmodifiable(steps),
    );
  }

  Map<int, Set<int>> _candidateMap(
    SudokuBoard board,
    Map<int, Set<int>> eliminated,
  ) {
    final base = _validator.candidateMap(board);
    return <int, Set<int>>{
      for (final entry in base.entries)
        entry.key: entry.value.difference(
          eliminated[entry.key] ?? const <int>{},
        ),
    };
  }
}
