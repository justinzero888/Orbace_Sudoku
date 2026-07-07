import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbace_sudoku/src/app/orbace_sudoku_app.dart';
import 'package:orbace_sudoku/src/features/sudoku/data/app_database.dart';
import 'package:orbace_sudoku/src/features/sudoku/data/puzzle_pack_loader.dart';
import 'package:orbace_sudoku/src/features/sudoku/data/sudoku_repository.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/daily_random_puzzle.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_attempt.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_board.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_move.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_score.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/sudoku_number_pad.dart';

void main() {
  testWidgets(
    'Local Bests refreshes immediately after finishing the Extreme Challenge',
    (tester) async {
      tester.view.physicalSize = const Size(1170, 2900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = SudokuRepository(database);

      for (var i = 0; i < 20; i++) {
        await repository.saveAttempt(_attempt(id: 'seed_$i', cleanSolve: i < 6));
      }

      final catalog = await PuzzlePackLoader(repository: repository).load();
      final todaysDaily = DailyRandomPuzzle.extremeDaily.forDate(
        DateTime.now(),
        catalog.trueExtremePool,
      );

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      await tester.pumpWidget(OrbaceSudokuApp(database: database));
      await _pumpUntilFound(tester, find.text('Tea Moment'));

      await tester.scrollUntilVisible(
        find.text('Extreme Challenge'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Extreme Challenge'));
      await tester.pumpAndSettle();

      expect(find.text('No completed Extreme Challenge days yet.'), findsOneWidget);

      await tester.tap(find.text('Start Extreme Challenge'));
      await tester.pumpAndSettle();

      expect(find.text(todaysDaily.title), findsOneWidget);

      final boardCells = find.descendant(
        of: find.byType(GridView),
        matching: find.byType(GestureDetector),
      );
      expect(boardCells, findsNWidgets(SudokuBoard.cellCount));

      final numberPad = find.byType(SudokuNumberPad);
      Finder digitButton(int value) =>
          find.descendant(of: numberPad, matching: find.text('$value'));

      for (var index = 0; index < SudokuBoard.cellCount; index++) {
        if (todaysDaily.givens.valueAtIndex(index) != null) {
          continue;
        }
        await tester.tap(boardCells.at(index));
        await tester.pump();
        await tester.tap(digitButton(todaysDaily.solution.valueAtIndex(index)!));
        await tester.pump();
      }

      await tester.pumpAndSettle();

      expect(find.text('Done'), findsOneWidget);
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Back on the Extreme Hub: Local Bests must already reflect today's
      // finished run with no extra navigation needed to trigger a refresh.
      expect(find.text('Start Extreme Challenge'), findsNothing);
      expect(
        find.text('No completed Extreme Challenge days yet.'),
        findsNothing,
      );
      expect(find.textContaining('pts'), findsOneWidget);
    },
  );
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

SudokuAttempt _attempt({required String id, bool cleanSolve = true}) {
  return SudokuAttempt(
    id: id,
    puzzleId: 'puzzle_$id',
    isRetry: false,
    attemptNumber: 1,
    elapsedSeconds: 120,
    errorCount: cleanSolve ? 0 : 1,
    hintNudgeCount: 0,
    hintExplanationCount: 0,
    hintRevealCount: cleanSolve ? 0 : 1,
    autoCheckEnabled: false,
    mistakeRevealEnabled: false,
    completed: true,
    cleanSolve: cleanSolve,
    rankedEligible: false,
    score: const SudokuScore(
      total: 1000,
      baseScore: 1000,
      accuracyMultiplier: 1,
      timeBonus: 0,
      efficiencyBonus: 0,
      cleanSolveBonus: 0,
      scoringVersion: 1,
      accuracyFactors: <String>[],
    ),
    moveHistory: const <SudokuMove>[],
    startedAt: DateTime(2026),
    completedAt: DateTime(2026),
  );
}
