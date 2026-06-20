import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbace_sudoku/src/app/orbace_sudoku_app.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/fixture_puzzles.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/game_session_controller.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/sudoku_replay_screen.dart';

void main() {
  testWidgets('Orbace Sudoku app shell renders', (tester) async {
    await tester.pumpWidget(const OrbaceSudokuApp());

    expect(find.text('Orbace Sudoku'), findsOneWidget);
    expect(find.text('一局一茶'), findsOneWidget);
    expect(find.text('Tea Moment'), findsOneWidget);
    expect(find.text('Level Packs'), findsOneWidget);
    expect(find.text('Scholar\'s Path'), findsOneWidget);
  });

  testWidgets('Tea Moment opens playable Sudoku screen', (tester) async {
    await tester.pumpWidget(const OrbaceSudokuApp());

    await tester.tap(find.text('Tea Moment'));
    await tester.pumpAndSettle();

    expect(find.text('Beginner Tea Moment'), findsOneWidget);
    expect(find.textContaining('Mistakes 0'), findsOneWidget);
  });

  testWidgets('Replay screen renders move history', (tester) async {
    final controller = GameSessionController(
      givens: FixturePuzzles.teaMomentGivens(),
      solution: FixturePuzzles.teaMomentSolution(),
    );
    controller
      ..selectCell(2)
      ..enterNumber(4);
    final attempt = controller.buildAttempt();

    await tester.pumpWidget(
      OrbaceSudokuAppShell(
        child: SudokuReplayScreen(
          givens: FixturePuzzles.teaMomentGivens(),
          attempt: attempt,
        ),
      ),
    );

    expect(find.text('Replay'), findsOneWidget);
    expect(find.text('Step 0 of 1'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Move History'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Move History'), findsOneWidget);
    expect(find.textContaining('R1 C3 = 4'), findsOneWidget);

    controller.dispose();
  });
}

class OrbaceSudokuAppShell extends StatelessWidget {
  const OrbaceSudokuAppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: child);
  }
}
