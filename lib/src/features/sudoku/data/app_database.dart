import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class PuzzleRows extends Table {
  TextColumn get id => text()();
  TextColumn get givensJson => text()();
  TextColumn get solutionJson => text()();
  TextColumn get difficulty => text()();
  IntColumn get difficultyScore => integer()();
  IntColumn get targetTimeSeconds => integer()();
  IntColumn get medianTimeSeconds => integer()();
  TextColumn get requiredTechniquesJson => text()();
  TextColumn get solvePathJson => text()();
  BoolColumn get rankedEligible =>
      boolean().withDefault(const Constant(false))();
  TextColumn get challengeId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AttemptRows extends Table {
  TextColumn get id => text()();
  TextColumn get puzzleId => text()();
  BoolColumn get isRetry => boolean().withDefault(const Constant(false))();
  IntColumn get attemptNumber => integer()();
  IntColumn get elapsedSeconds => integer()();
  IntColumn get errorCount => integer()();
  IntColumn get hintNudgeCount => integer()();
  IntColumn get hintExplanationCount => integer()();
  IntColumn get hintRevealCount => integer()();
  BoolColumn get autoCheckEnabled => boolean()();
  BoolColumn get mistakeRevealEnabled => boolean()();
  BoolColumn get completed => boolean()();
  BoolColumn get cleanSolve => boolean()();
  BoolColumn get rankedEligible => boolean()();
  IntColumn get scoreTotal => integer().nullable()();
  IntColumn get scoreBase => integer().nullable()();
  RealColumn get accuracyMultiplier => real().nullable()();
  IntColumn get timeBonus => integer().nullable()();
  IntColumn get efficiencyBonus => integer().nullable()();
  IntColumn get cleanSolveBonus => integer().nullable()();
  IntColumn get scoringVersion => integer().nullable()();
  TextColumn get accuracyFactorsJson => text().nullable()();
  TextColumn get moveHistoryJson => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CurrentProgressRows extends Table {
  TextColumn get puzzleId => text()();
  TextColumn get valuesJson => text()();
  TextColumn get notesJson => text()();
  IntColumn get elapsedSeconds => integer()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {puzzleId};
}

@DriftDatabase(tables: [PuzzleRows, AttemptRows, CurrentProgressRows])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> upsertPuzzle(PuzzleRowsCompanion puzzle) {
    return into(puzzleRows).insertOnConflictUpdate(puzzle);
  }

  Future<void> insertAttempt(AttemptRowsCompanion attempt) {
    return into(attemptRows).insert(attempt);
  }

  Future<List<AttemptRow>> attemptsForPuzzle(String puzzleId) {
    return (select(attemptRows)
          ..where((row) => row.puzzleId.equals(puzzleId))
          ..orderBy([
            (row) => OrderingTerm(
              expression: row.attemptNumber,
              mode: OrderingMode.asc,
            ),
          ]))
        .get();
  }

  Future<AttemptRow?> bestAttemptForPuzzle(String puzzleId) {
    return (select(attemptRows)
          ..where(
            (row) => row.puzzleId.equals(puzzleId) & row.completed.equals(true),
          )
          ..orderBy([
            (row) => OrderingTerm(
              expression: row.scoreTotal,
              mode: OrderingMode.desc,
            ),
          ])
          ..limit(1))
        .getSingleOrNull();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'orbace_sudoku.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

String encodeJson(Object? value) => jsonEncode(value);
