import 'package:flutter_test/flutter_test.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_board.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_current_progress.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_score_class.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/fixture_puzzles.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/game_session_controller.dart';

void main() {
  late GameSessionController controller;

  setUp(() {
    controller = GameSessionController(
      givens: FixturePuzzles.teaMomentGivens(),
      solution: FixturePuzzles.teaMomentSolution(),
    );
  });

  tearDown(() {
    controller.dispose();
  });

  test('enters value into selected editable cell', () {
    final index = SudokuBoard.index(0, 2);

    controller.selectCell(index);
    controller.enterNumber(4);

    expect(controller.valueAt(index), 4);
    expect(controller.canUndo, isTrue);
  });

  test('does not edit givens', () {
    final index = SudokuBoard.index(0, 0);

    controller.selectCell(index);
    controller.enterNumber(9);

    expect(controller.valueAt(index), 5);
    expect(controller.canUndo, isFalse);
  });

  test('toggles notes without changing cell value', () {
    final index = SudokuBoard.index(0, 2);

    controller.selectCell(index);
    controller.toggleNotesMode();
    controller.enterNumber(4);

    expect(controller.valueAt(index), isNull);
    expect(controller.notesAt(index), <int>{4});
  });

  test('undo and redo restore entered value', () {
    final index = SudokuBoard.index(0, 2);

    controller.selectCell(index);
    controller.enterNumber(4);
    controller.undo();

    expect(controller.valueAt(index), isNull);
    expect(controller.canRedo, isTrue);

    controller.redo();

    expect(controller.valueAt(index), 4);
  });

  test('undo appends value back action to replay history', () {
    final index = SudokuBoard.index(0, 2);

    controller.selectCell(index);
    controller.enterNumber(4);
    controller.undo();

    expect(controller.moveHistory, hasLength(2));
    expect(controller.moveHistory.last.type.name, 'valueBack');
    expect(controller.moveHistory.last.cellIndex, index);
    expect(controller.moveHistory.last.nextValue, isNull);
  });

  test('undo appends note back action to replay history', () {
    final index = SudokuBoard.index(0, 2);

    controller.selectCell(index);
    controller.toggleNotesMode();
    controller.enterNumber(4);
    controller.undo();

    expect(controller.moveHistory, hasLength(2));
    expect(controller.moveHistory.last.type.name, 'noteBack');
    expect(controller.moveHistory.last.cellIndex, index);
    expect(controller.moveHistory.last.noteValue, 4);
  });

  test('hint escalates and selects target cell', () {
    final first = controller.requestHint();
    final second = controller.requestHint();
    final third = controller.requestHint();

    expect(first.tier, 1);
    expect(second.tier, 2);
    expect(third.tier, 3);
    expect(controller.hintTargetIndex, isNotNull);
    expect(controller.selectedIndex, controller.hintTargetIndex);
  });

  test('buildAttempt uses ranked eligibility engine for official attempts', () {
    final rankedController = GameSessionController(
      givens: FixturePuzzles.teaMomentGivens(),
      solution: FixturePuzzles.teaMomentSolution(),
      puzzleRankedEligible: true,
    );
    addTearDown(rankedController.dispose);
    rankedController.setMistakeChecking(false);

    for (var index = 0; index < SudokuBoard.cellCount; index++) {
      if (rankedController.isGiven(index)) {
        continue;
      }
      rankedController
        ..selectCell(index)
        ..enterNumber(FixturePuzzles.teaMomentSolution().valueAtIndex(index)!);
    }

    final attempt = rankedController.buildAttempt();

    expect(attempt.completed, isTrue);
    expect(attempt.scoreClass, SudokuScoreClass.official);
    expect(attempt.rankedEligible, isTrue);
  });

  test('restores values notes and elapsed time from current progress', () {
    final index = SudokuBoard.index(0, 2);
    final restoredController = GameSessionController(
      givens: FixturePuzzles.teaMomentGivens(),
      solution: FixturePuzzles.teaMomentSolution(),
      initialProgress: SudokuCurrentProgress(
        puzzleId: 'tea_moment_fixture',
        values: [
          for (var cell = 0; cell < SudokuBoard.cellCount; cell++)
            cell == index
                ? 4
                : FixturePuzzles.teaMomentGivens().valueAtIndex(cell),
        ],
        notes: [
          for (var cell = 0; cell < SudokuBoard.cellCount; cell++)
            cell == SudokuBoard.index(0, 3) ? <int>{1, 2} : <int>{},
        ],
        elapsedSeconds: 123,
        updatedAt: DateTime(2026, 6, 26, 10),
      ),
    );
    addTearDown(restoredController.dispose);

    expect(restoredController.valueAt(index), 4);
    expect(restoredController.notesAt(SudokuBoard.index(0, 3)), <int>{1, 2});
    expect(restoredController.elapsedSeconds, 123);
    expect(restoredController.hasUnsavedProgress, isTrue);

    final progress = restoredController.buildCurrentProgress(
      updatedAt: DateTime(2026, 6, 26, 11),
    );

    expect(progress.values[index], 4);
    expect(progress.notes[SudokuBoard.index(0, 3)], <int>{1, 2});
    expect(progress.elapsedSeconds, 123);
  });
}
