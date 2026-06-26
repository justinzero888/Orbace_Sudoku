import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';

import '../domain/solving_step.dart';
import '../domain/sudoku_attempt.dart';
import '../domain/sudoku_board.dart';
import '../domain/sudoku_current_progress.dart';
import '../domain/sudoku_difficulty.dart';
import '../domain/sudoku_move.dart';
import '../domain/sudoku_puzzle.dart';
import '../domain/sudoku_score.dart';
import '../domain/sudoku_score_class.dart';
import '../presentation/fixture_puzzles.dart';
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

  Future<void> upsertImportedPuzzle({
    required String id,
    required String title,
    required SudokuBoard givens,
    required SudokuBoard solution,
    required SudokuDifficulty difficulty,
    required int difficultyScore,
    required int targetTimeSeconds,
    required int medianTimeSeconds,
    required List<String> requiredTechniques,
    required List<StoredSolvingStep> solvePath,
    String? sourceLabel,
    DateTime? now,
  }) {
    final timestamp = now ?? DateTime.now();
    return database.upsertImportedPuzzle(
      ImportedPuzzleRowsCompanion(
        id: Value(id),
        title: Value(title),
        sourceLabel: Value(_normalizedNullable(sourceLabel)),
        givensJson: Value(_encodeCells(givens.cells)),
        solutionJson: Value(_encodeCells(solution.cells)),
        difficulty: Value(difficulty.name),
        difficultyScore: Value(difficultyScore),
        targetTimeSeconds: Value(targetTimeSeconds),
        medianTimeSeconds: Value(medianTimeSeconds),
        requiredTechniquesJson: Value(jsonEncode(requiredTechniques)),
        solvePathJson: Value(_encodeSolvePath(solvePath)),
        puzzleChecksum: Value(puzzleChecksum(givens, solution)),
        createdAt: Value(timestamp),
        updatedAt: Value(timestamp),
      ),
    );
  }

  Future<List<FixturePuzzleDefinition>> importedPuzzleDefinitions() async {
    final rows = await database.allImportedPuzzles();
    return rows.map(_importedDefinitionFromRow).toList(growable: false);
  }

  Future<FixturePuzzleDefinition?> importedPuzzleDefinitionById(
    String id,
  ) async {
    final row = await database.importedPuzzleById(id);
    return row == null ? null : _importedDefinitionFromRow(row);
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
        scoreClass: Value(attempt.scoreClass.name),
        playerDifficultyRating: Value(attempt.playerDifficultyRating),
        playerDifficultyRatedAt: Value(attempt.playerDifficultyRatedAt),
        replayFavorite: Value(attempt.replayFavorite),
        replayTitle: Value(attempt.replayTitle),
        replayNotes: Value(attempt.replayNotes),
        replayHash: Value(attempt.replayHash),
        puzzleChecksum: Value(attempt.puzzleChecksum),
        contentVersion: Value(attempt.contentVersion),
        scoreCardImagePath: Value(attempt.scoreCardImagePath),
        scoreCardGeneratedAt: Value(attempt.scoreCardGeneratedAt),
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

  Future<List<SudokuAttempt>> completedAttemptsForReplayLibrary() async {
    final rows = await database.completedAttemptsForReplayLibrary();
    return rows.map(_attemptFromRow).toList(growable: false);
  }

  Future<void> saveCurrentProgress(SudokuCurrentProgress progress) {
    return database.upsertCurrentProgress(
      CurrentProgressRowsCompanion(
        puzzleId: Value(progress.puzzleId),
        valuesJson: Value(_encodeCells(progress.values)),
        notesJson: Value(_encodeNotes(progress.notes)),
        elapsedSeconds: Value(progress.elapsedSeconds),
        updatedAt: Value(progress.updatedAt),
      ),
    );
  }

  Future<SudokuCurrentProgress?> currentProgressForPuzzle(
    String puzzleId,
  ) async {
    final row = await database.currentProgressForPuzzle(puzzleId);
    return row == null ? null : _progressFromRow(row);
  }

  Future<List<SudokuCurrentProgress>> allCurrentProgress() async {
    final rows = await database.allCurrentProgress();
    return rows.map(_progressFromRow).toList(growable: false);
  }

  Future<void> deleteCurrentProgress(String puzzleId) {
    return database.deleteCurrentProgress(puzzleId);
  }

  Future<void> updatePlayerDifficultyRating(
    String attemptId,
    double rating, {
    DateTime? ratedAt,
  }) {
    if (rating < 1 || rating > 5) {
      throw ArgumentError.value(
        rating,
        'rating',
        'Player difficulty rating must be between 1.0 and 5.0.',
      );
    }
    return database.updatePlayerDifficultyRating(
      attemptId,
      double.parse(rating.toStringAsFixed(1)),
      ratedAt ?? DateTime.now(),
    );
  }

  Future<void> toggleReplayFavorite(String attemptId, bool favorite) {
    return database.updateReplayFavorite(attemptId, favorite);
  }

  Future<void> updateReplayNotes(String attemptId, String notes) {
    final normalized = notes.trim();
    return database.updateReplayNotes(
      attemptId,
      normalized.isEmpty ? null : normalized,
    );
  }

  Future<void> updateScoreCardImagePath(
    String attemptId,
    String imagePath, {
    DateTime? generatedAt,
  }) {
    return database.updateScoreCardImagePath(
      attemptId,
      imagePath,
      generatedAt ?? DateTime.now(),
    );
  }

  String puzzleChecksum(SudokuBoard givens, SudokuBoard solution) {
    return sha256
        .convert(
          utf8.encode(
            jsonEncode(<String, Object?>{
              'givens': givens.cells,
              'solution': solution.cells,
            }),
          ),
        )
        .toString();
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
      scoreClass: row.scoreClass == null
          ? SudokuScoreClass.legacy
          : SudokuScoreClass.values.byName(row.scoreClass!),
      score: score,
      moveHistory: _decodeMoves(row.moveHistoryJson),
      startedAt: row.startedAt,
      completedAt: row.completedAt,
      playerDifficultyRating: row.playerDifficultyRating,
      playerDifficultyRatedAt: row.playerDifficultyRatedAt,
      replayFavorite: row.replayFavorite,
      replayTitle: row.replayTitle,
      replayNotes: row.replayNotes,
      replayHash: row.replayHash,
      puzzleChecksum: row.puzzleChecksum,
      contentVersion: row.contentVersion,
      scoreCardImagePath: row.scoreCardImagePath,
      scoreCardGeneratedAt: row.scoreCardGeneratedAt,
    );
  }

  String _encodeCells(List<int?> cells) {
    return jsonEncode(cells);
  }

  String _encodeNotes(List<Set<int>> notes) {
    return jsonEncode([
      for (final noteSet in notes) (noteSet.toList()..sort()),
    ]);
  }

  SudokuBoard _decodeBoard(String json) {
    final decoded = jsonDecode(json) as List<dynamic>;
    return SudokuBoard.fromCells([
      for (final value in decoded) value == null ? null : value as int,
    ]);
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

  List<Set<int>> _decodeNotes(String json) {
    final decoded = jsonDecode(json) as List<dynamic>;
    return [
      for (final item in decoded)
        (item as List<dynamic>).map((value) => value as int).toSet(),
    ];
  }

  SudokuCurrentProgress _progressFromRow(CurrentProgressRow row) {
    return SudokuCurrentProgress(
      puzzleId: row.puzzleId,
      values: _decodeBoard(row.valuesJson).cells,
      notes: _decodeNotes(row.notesJson),
      elapsedSeconds: row.elapsedSeconds,
      updatedAt: row.updatedAt,
    );
  }

  FixturePuzzleDefinition _importedDefinitionFromRow(ImportedPuzzleRow row) {
    final givens = _decodeBoard(row.givensJson);
    final solution = _decodeBoard(row.solutionJson);
    return FixturePuzzleDefinition(
      id: row.id,
      title: row.title,
      seal: '入',
      packId: 'imported',
      difficulty: SudokuDifficulty.values.byName(row.difficulty),
      difficultyScore: row.difficultyScore,
      targetTimeSeconds: row.targetTimeSeconds,
      medianTimeSeconds: row.medianTimeSeconds,
      requiredTechniques: _decodeStringList(row.requiredTechniquesJson),
      rankedEligible: false,
      givensRows: _rowsFromBoard(givens),
      solutionRows: _rowsFromBoard(solution),
    );
  }

  List<String> _rowsFromBoard(SudokuBoard board) {
    return <String>[
      for (var row = 0; row < SudokuBoard.size; row++)
        [
          for (var col = 0; col < SudokuBoard.size; col++)
            board.valueAt(row, col)?.toString() ?? '0',
        ].join(),
    ];
  }

  String? _normalizedNullable(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    return normalized;
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
