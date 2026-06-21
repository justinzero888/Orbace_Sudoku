import 'dart:convert';

import 'package:drift/drift.dart';

import '../domain/solving_step.dart';
import '../domain/sudoku_attempt.dart';
import '../domain/sudoku_board.dart';
import '../domain/sudoku_difficulty.dart';
import '../domain/sudoku_move.dart';
import '../domain/sudoku_puzzle.dart';
import '../domain/sudoku_score.dart';
import 'app_database.dart';

class SudokuRepository {
  const SudokuRepository(this.database);

  final AppDatabase database;

  Future<void> upsertPuzzle(SudokuPuzzle puzzle) {
    return database.upsertPuzzle(
      PuzzleRowsCompanion(
        id: Value(puzzle.id),
        givensJson: Value(_encodeCells(puzzle.givens.cells)),
        solutionJson: Value(_encodeCells(puzzle.solution.cells)),
        difficulty: Value(puzzle.difficulty.name),
        difficultyScore: Value(puzzle.difficultyScore),
        targetTimeSeconds: Value(puzzle.targetTimeSeconds),
        medianTimeSeconds: Value(puzzle.medianTimeSeconds),
        requiredTechniquesJson: Value(jsonEncode(puzzle.requiredTechniques)),
        solvePathJson: Value(_encodeSolvePath(puzzle.solvePath)),
        rankedEligible: Value(puzzle.rankedEligible),
        challengeId: Value(puzzle.challengeId),
      ),
    );
  }

  Future<void> saveAttempt(SudokuAttempt attempt) {
    final score = attempt.score;
    return database.insertAttempt(
      AttemptRowsCompanion(
        id: Value(attempt.id),
        puzzleId: Value(attempt.puzzleId),
        isRetry: Value(attempt.isRetry),
        attemptNumber: Value(attempt.attemptNumber),
        elapsedSeconds: Value(attempt.elapsedSeconds),
        errorCount: Value(attempt.errorCount),
        hintNudgeCount: Value(attempt.hintNudgeCount),
        hintExplanationCount: Value(attempt.hintExplanationCount),
        hintRevealCount: Value(attempt.hintRevealCount),
        autoCheckEnabled: Value(attempt.autoCheckEnabled),
        mistakeRevealEnabled: Value(attempt.mistakeRevealEnabled),
        completed: Value(attempt.completed),
        cleanSolve: Value(attempt.cleanSolve),
        rankedEligible: Value(attempt.rankedEligible),
        scoreTotal: Value(score?.total),
        scoreBase: Value(score?.baseScore),
        accuracyMultiplier: Value(score?.accuracyMultiplier),
        timeBonus: Value(score?.timeBonus),
        efficiencyBonus: Value(score?.efficiencyBonus),
        cleanSolveBonus: Value(score?.cleanSolveBonus),
        scoringVersion: Value(score?.scoringVersion),
        accuracyFactorsJson: Value(
          score == null ? null : jsonEncode(score.accuracyFactors),
        ),
        moveHistoryJson: Value(_encodeMoves(attempt.moveHistory)),
        startedAt: Value(attempt.startedAt),
        completedAt: Value(attempt.completedAt),
      ),
    );
  }

  Future<List<SudokuAttempt>> attemptsForPuzzle(String puzzleId) async {
    final rows = await database.attemptsForPuzzle(puzzleId);
    return rows.map(_attemptFromRow).toList(growable: false);
  }

  Future<SudokuAttempt?> bestAttemptForPuzzle(String puzzleId) async {
    final row = await database.bestAttemptForPuzzle(puzzleId);
    return row == null ? null : _attemptFromRow(row);
  }

  Future<List<SudokuAttempt>> allAttempts() async {
    final rows = await database.allAttempts();
    return rows.map(_attemptFromRow).toList(growable: false);
  }

  Future<List<SudokuAttempt>> rankedAttempts({int limit = 10}) async {
    final rows = await database.rankedAttempts(limit: limit);
    return rows.map(_attemptFromRow).toList(growable: false);
  }

  SudokuAttempt _attemptFromRow(AttemptRow row) {
    final score = row.scoreTotal == null
        ? null
        : SudokuScore(
            total: row.scoreTotal!,
            baseScore: row.scoreBase!,
            accuracyMultiplier: row.accuracyMultiplier!,
            timeBonus: row.timeBonus!,
            efficiencyBonus: row.efficiencyBonus!,
            cleanSolveBonus: row.cleanSolveBonus!,
            scoringVersion: row.scoringVersion!,
            accuracyFactors: _decodeStringList(row.accuracyFactorsJson ?? '[]'),
          );

    return SudokuAttempt(
      id: row.id,
      puzzleId: row.puzzleId,
      isRetry: row.isRetry,
      attemptNumber: row.attemptNumber,
      elapsedSeconds: row.elapsedSeconds,
      errorCount: row.errorCount,
      hintNudgeCount: row.hintNudgeCount,
      hintExplanationCount: row.hintExplanationCount,
      hintRevealCount: row.hintRevealCount,
      autoCheckEnabled: row.autoCheckEnabled,
      mistakeRevealEnabled: row.mistakeRevealEnabled,
      completed: row.completed,
      cleanSolve: row.cleanSolve,
      rankedEligible: row.rankedEligible,
      score: score,
      moveHistory: _decodeMoves(row.moveHistoryJson),
      startedAt: row.startedAt,
      completedAt: row.completedAt,
    );
  }

  String _encodeCells(List<int?> cells) {
    return jsonEncode(cells);
  }

  String _encodeSolvePath(List<StoredSolvingStep> steps) {
    return jsonEncode([
      for (final step in steps)
        <String, Object?>{
          'stepIndex': step.stepIndex,
          'techniqueId': step.techniqueId,
          'row': step.row,
          'col': step.col,
          'value': step.value,
          'highlightCellIndices': step.highlightCellIndices,
          'affectedCellIndices': step.affectedCellIndices,
          'explanationTemplateKey': step.explanationTemplateKey,
          'params': step.params,
        },
    ]);
  }

  String _encodeMoves(List<SudokuMove> moves) {
    return jsonEncode([
      for (final move in moves)
        <String, Object?>{
          'cellIndex': move.cellIndex,
          'previousValue': move.previousValue,
          'nextValue': move.nextValue,
          'elapsedSeconds': move.elapsedSeconds,
          'type': move.type.name,
          'noteValue': move.noteValue,
        },
    ]);
  }

  List<SudokuMove> _decodeMoves(String json) {
    final decoded = jsonDecode(json) as List<dynamic>;
    return [
      for (final item in decoded.cast<Map<String, dynamic>>())
        SudokuMove(
          cellIndex: item['cellIndex'] as int,
          previousValue: item['previousValue'] as int?,
          nextValue: item['nextValue'] as int?,
          elapsedSeconds: item['elapsedSeconds'] as int,
          type: SudokuMoveType.values.byName(item['type'] as String),
          noteValue: item['noteValue'] as int?,
        ),
    ];
  }

  List<String> _decodeStringList(String json) {
    return (jsonDecode(json) as List<dynamic>).cast<String>();
  }
}

SudokuPuzzle fixturePuzzleRecord({
  required String id,
  required SudokuBoard givens,
  required SudokuBoard solution,
  required List<StoredSolvingStep> solvePath,
  SudokuDifficulty difficulty = SudokuDifficulty.beginner,
  int difficultyScore = 80,
  int targetTimeSeconds = 360,
  int medianTimeSeconds = 480,
  bool rankedEligible = false,
}) {
  return SudokuPuzzle(
    id: id,
    givens: givens,
    solution: solution,
    difficulty: difficulty,
    difficultyScore: difficultyScore,
    targetTimeSeconds: targetTimeSeconds,
    medianTimeSeconds: medianTimeSeconds,
    requiredTechniques:
        solvePath.map((step) => step.techniqueId).toSet().toList()..sort(),
    solvePath: solvePath,
    rankedEligible: rankedEligible,
  );
}
