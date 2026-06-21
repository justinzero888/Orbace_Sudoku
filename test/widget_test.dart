import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:orbace_sudoku/src/app/orbace_sudoku_app.dart';
import 'package:orbace_sudoku/src/features/sudoku/data/app_database.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/fixture_puzzles.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/game_session_controller.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/sudoku_replay_screen.dart';

void main() {
  testWidgets('Orbace Sudoku app shell renders', (tester) async {
    await _pumpTestApp(tester);

    expect(find.text('Orbace Sudoku'), findsOneWidget);
    expect(find.text('一局一茶'), findsOneWidget);
    expect(find.text('Tea Moment'), findsOneWidget);
    expect(find.text('Level Packs'), findsOneWidget);
    expect(find.text('Scholar\'s Path'), findsOneWidget);
  });

  testWidgets('Tea Moment opens playable Sudoku screen', (tester) async {
    await _pumpTestApp(tester);

    await tester.tap(find.text('Tea Moment'));
    await tester.pumpAndSettle();

    expect(find.text('Tea Moment'), findsOneWidget);
    expect(find.textContaining('Mistakes 0'), findsOneWidget);
  });

  testWidgets('Level Packs opens test puzzle catalog', (tester) async {
    await _pumpTestApp(tester);

    await tester.tap(find.text('Level Packs'));
    await tester.pumpAndSettle();

    expect(find.text('6 test puzzles loaded'), findsOneWidget);
    expect(find.text('Morning Steam'), findsOneWidget);
    expect(find.text('Paper Lantern'), findsOneWidget);

    await tester.tap(find.text('Paper Lantern'));
    await tester.pumpAndSettle();

    expect(find.text('Paper Lantern'), findsOneWidget);
    expect(find.textContaining('Beginner'), findsOneWidget);
  });

  testWidgets('Scholar Path and Extreme Hub open from Home', (tester) async {
    await _pumpTestApp(tester);

    await tester.tap(find.text('Scholar\'s Path'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Scholar\'s Path'), findsWidgets);

    await tester.pageBack();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('Extreme Challenge'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Extreme Challenge'), findsWidgets);
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

Future<void> _pumpTestApp(WidgetTester tester) async {
  final database = AppDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  await tester.pumpWidget(OrbaceSudokuApp(database: database));
}

class OrbaceSudokuAppShell extends StatelessWidget {
  const OrbaceSudokuAppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: child);
  }
}
