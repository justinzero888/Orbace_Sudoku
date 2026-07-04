import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbace_sudoku/src/app/orbace_sudoku_app.dart';
import 'package:orbace_sudoku/src/features/sudoku/data/app_database.dart';
import 'package:orbace_sudoku/src/features/sudoku/data/puzzle_pack_loader.dart';
import 'package:orbace_sudoku/src/features/sudoku/data/sudoku_repository.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/daily_random_puzzle.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_attempt.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_move.dart';
import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_score.dart';

void main() {
  testWidgets(
    'tapping Start Extreme Challenge after unlock loads an extreme pack puzzle',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = SudokuRepository(database);

      // Same shape as the unit-tested "unlocks Extreme" scenario in
      // test/phase4_awards_extreme_test.dart: 20 completed attempts, 6 clean.
      for (var i = 0; i < 20; i++) {
        await repository.saveAttempt(
          _attempt(id: 'seed_$i', cleanSolve: i < 6),
        );
      }

      final catalog = await PuzzlePackLoader(repository: repository).load();
      final extremePackIds = catalog.packs
          .firstWhere((p) => p.id == 'true_extreme')
          .puzzles
          .where((p) => p.id != 'true_extreme_059')
          .map((p) => p.id)
          .toSet();
      expect(
        extremePackIds,
        isNotEmpty,
        reason: 'true_extreme pack must have puzzles',
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
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.text('Extreme Challenge is unlocked for local no-assist play.'),
        findsOneWidget,
        reason:
            'AwardEngine should report Extreme Challenge unlocked for this seed data',
      );

      final startButton = find.text('Start Extreme Challenge');
      expect(startButton, findsOneWidget);

      await tester.tap(startButton);
      await tester.pump();
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      // THE BUG: this used to be onPressed: () {} — nothing would happen and
      // we'd still be on the ExtremeHubScreen. Confirm real navigation occurred.
      expect(
        find.text('Start Extreme Challenge'),
        findsNothing,
        reason: 'should have navigated away from the hub screen',
      );

      // Confirm a real game board loaded: mistakes counter + today's
      // deterministic daily-transformed title, not the silent
      // teaMomentPuzzles.first fallback ('Morning Steam').
      expect(find.textContaining('Mistakes 0'), findsOneWidget);
      expect(find.text('Morning Steam'), findsNothing);

      final todaysDaily = DailyRandomPuzzle.extremeDaily.forDate(
        DateTime.now(),
        catalog.trueExtremePool,
      );
      expect(
        find.text(todaysDaily.title),
        findsOneWidget,
        reason:
            'expected the loaded game screen to show today\'s Daily Extreme title',
      );

      // No-assist mode: hints and auto-check are hidden during play.
      expect(find.text('Lantern Hint'), findsNothing);
      expect(find.textContaining('Check On'), findsNothing);
      expect(find.textContaining('Check Off'), findsNothing);
      expect(
        find.textContaining('No-assist mode'),
        findsOneWidget,
        reason: 'should show the no-assist notice instead of hint/check controls',
      );
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
