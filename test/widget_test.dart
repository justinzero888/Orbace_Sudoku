import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbace_sudoku/src/features/home/home_screen.dart';
import 'package:orbace_sudoku/src/features/sudoku/data/puzzle_pack_loader.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/fixture_puzzles.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/game_session_controller.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/sudoku_replay_screen.dart';

void main() {
  testWidgets('Orbace Sudocoo home shell renders', (tester) async {
    final catalog = await PuzzlePackLoader().load();
    final advancedCount = catalog.puzzles
        .where(
          (puzzle) => puzzle.requiredTechniques.any(
            (technique) =>
                technique == 'naked_pair' ||
                technique == 'hidden_pair' ||
                technique == 'pointing_pair',
          ),
        )
        .length;

    await _pumpTestApp(tester);

    expect(find.text('Orbace Sudocoo'), findsOneWidget);
    expect(find.text('一局一茶 · One Puzzle, One Tea'), findsOneWidget);
    expect(find.text('Tea Moment'), findsOneWidget);
    expect(find.text('Record Hall'), findsNothing);
    expect(find.text('Import Puzzle'), findsNothing);
    expect(find.text('Level Packs'), findsOneWidget);
    expect(
      find.textContaining(
        'A calm puzzle from Beginner, Easy, or Medium, picked fresh each time.',
      ),
      findsOneWidget,
      reason: 'Tea Moment no longer names a fixed puzzle up front -- it is '
          'picked fresh at tap time',
    );
    expect(
      advancedCount,
      greaterThan(0),
      reason: 'catalog should still expose advanced puzzle metadata',
    );
    expect(
      find.textContaining('${catalog.puzzles.length} puzzles loaded'),
      findsOneWidget,
    );
  });

  testWidgets('Replay screen renders move history', (tester) async {
    final controller = GameSessionController(
      givens: FixturePuzzles.teaMomentGivens(),
      solution: FixturePuzzles.teaMomentSolution(),
    );
    controller
      ..selectCell(2)
      ..enterNumber(4)
      ..undo()
      ..toggleNotesMode()
      ..enterNumber(4)
      ..undo();
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
    expect(find.text('Step 0 of 4'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Move History'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Move History'), findsOneWidget);
    expect(find.textContaining('R1 C3 = 4'), findsOneWidget);
    expect(find.textContaining('Back R1 C3'), findsOneWidget);
    expect(find.textContaining('Note 4 at R1 C3'), findsOneWidget);
    expect(find.textContaining('Back note 4 at R1 C3'), findsOneWidget);

    controller.dispose();
  });
}

Future<void> _pumpTestApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
  await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
  await _pumpUntilFound(tester, find.text('Tea Moment'));
}

Future<void> _pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
  expect(finder, findsWidgets);
}

class OrbaceSudokuAppShell extends StatelessWidget {
  const OrbaceSudokuAppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: child);
  }
}
