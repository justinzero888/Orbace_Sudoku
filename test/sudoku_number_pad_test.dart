import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/fixture_puzzles.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/game_session_controller.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/sudoku_number_pad.dart';

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

  Future<void> pumpPad(WidgetTester tester, {required bool showAssist}) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SudokuNumberPad(
            controller: controller,
            showAssistControls: showAssist,
            onHint: () {},
          ),
        ),
      ),
    );
  }

  testWidgets('numbers are split 1-5 / 6-9 + erase across two rows', (
    tester,
  ) async {
    await pumpPad(tester, showAssist: true);

    for (var value = 1; value <= 9; value++) {
      expect(find.text('$value'), findsOneWidget);
    }
    expect(find.byIcon(Icons.backspace_outlined), findsOneWidget);
  });

  testWidgets('assist controls show Hint and Check toggle in the tool row', (
    tester,
  ) async {
    await pumpPad(tester, showAssist: true);

    expect(find.byTooltip('Notes'), findsOneWidget);
    expect(find.byTooltip('Lantern Hint'), findsOneWidget);
    expect(find.byTooltip('Undo'), findsOneWidget);
    expect(find.byTooltip('Redo'), findsOneWidget);
    expect(find.byTooltip('Check On'), findsOneWidget);
  });

  testWidgets('no-assist mode hides Hint and Check toggle', (tester) async {
    await pumpPad(tester, showAssist: false);

    expect(find.byTooltip('Notes'), findsOneWidget);
    expect(find.byTooltip('Undo'), findsOneWidget);
    expect(find.byTooltip('Redo'), findsOneWidget);
    expect(find.byTooltip('Lantern Hint'), findsNothing);
    expect(find.byTooltip('Check Off'), findsNothing);
    expect(find.byTooltip('Check On'), findsNothing);
  });

  testWidgets('tapping a number pad digit enters it into the selected cell', (
    tester,
  ) async {
    controller.selectCell(2);
    await pumpPad(tester, showAssist: true);

    await tester.tap(find.text('7'));
    await tester.pump();

    expect(controller.valueAt(2), 7);
  });
}
