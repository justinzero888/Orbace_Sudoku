import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import '../domain/sudoku_board.dart';
import '../domain/sudoku_difficulty.dart';
import '../engine/human_ranked_solver.dart';
import '../engine/sudoku_difficulty_rater.dart';
import '../engine/sudoku_solver.dart';
import '../engine/sudoku_validator.dart';
import 'sudoku_repository.dart';

class ImportedPuzzlePreview {
  const ImportedPuzzlePreview({
    required this.id,
    required this.title,
    required this.givens,
    required this.solution,
    required this.difficulty,
    required this.difficultyScore,
    required this.targetTimeSeconds,
    required this.medianTimeSeconds,
    required this.requiredTechniques,
    required this.humanSolvable,
    this.sourceLabel,
  });

  final String id;
  final String title;
  final SudokuBoard givens;
  final SudokuBoard solution;
  final SudokuDifficulty difficulty;
  final int difficultyScore;
  final int targetTimeSeconds;
  final int medianTimeSeconds;
  final List<String> requiredTechniques;
  final bool humanSolvable;
  final String? sourceLabel;

  /// Applies an edited title/source note (e.g. from the Save & Play sheet)
  /// without re-running validation -- neither affects the puzzle's id or
  /// checksum. A blank title falls back to the existing (system-generated)
  /// one rather than saving an empty title; a blank source note clears it.
  ImportedPuzzlePreview copyWith({String? title, String? sourceLabel}) {
    final trimmedTitle = title?.trim();
    final resolvedTitle = (trimmedTitle == null || trimmedTitle.isEmpty)
        ? this.title
        : trimmedTitle;
    return ImportedPuzzlePreview(
      id: id,
      title: resolvedTitle,
      givens: givens,
      solution: solution,
      difficulty: difficulty,
      difficultyScore: difficultyScore,
      targetTimeSeconds: targetTimeSeconds,
      medianTimeSeconds: medianTimeSeconds,
      requiredTechniques: requiredTechniques,
      humanSolvable: humanSolvable,
      sourceLabel: _normalizedNullable(sourceLabel),
    );
  }
}

class ImportedPuzzleService {
  ImportedPuzzleService({required this.repository, HumanRankedSolver? humanSolver})
    : _humanSolver = humanSolver ?? HumanRankedSolver();

  final SudokuRepository repository;
  final HumanRankedSolver _humanSolver;

  /// Runs the puzzle solve/rating pipeline on a background isolate. A
  /// hand-entered grid can be far less constrained than a curated puzzle, and
  /// the brute-force solver's runtime is exponential in the worst case, so
  /// this must never run on the UI isolate — doing so previously froze input
  /// dispatch long enough for Android to treat the app as unresponsive.
  Future<ImportedPuzzlePreview> previewFromString(
    String input, {
    String? title,
    String? sourceLabel,
    DateTime? now,
  }) {
    return compute(
      _buildPreviewFromString,
      _StringPreviewRequest(
        input: input,
        title: title,
        sourceLabel: sourceLabel,
        now: now,
      ),
    );
  }

  Future<ImportedPuzzlePreview> previewFromCells(
    List<int?> cells, {
    String? title,
    String? sourceLabel,
    DateTime? now,
  }) {
    return compute(
      _buildPreviewFromCells,
      _CellsPreviewRequest(
        cells: cells,
        title: title,
        sourceLabel: sourceLabel,
        now: now,
      ),
    );
  }

  Future<void> save(ImportedPuzzlePreview preview) {
    return repository.upsertImportedPuzzle(
      id: preview.id,
      title: preview.title,
      sourceLabel: preview.sourceLabel,
      givens: preview.givens,
      solution: preview.solution,
      difficulty: preview.difficulty,
      difficultyScore: preview.difficultyScore,
      targetTimeSeconds: preview.targetTimeSeconds,
      medianTimeSeconds: preview.medianTimeSeconds,
      requiredTechniques: preview.requiredTechniques,
      solvePath: _humanSolver.solve(preview.givens).steps,
    );
  }
}

const int _minimumUniquePuzzleGivens = 17;
const SudokuSolver _solver = SudokuSolver();
const SudokuValidator _validator = SudokuValidator();
const SudokuDifficultyRater _rater = SudokuDifficultyRater();

class _StringPreviewRequest {
  const _StringPreviewRequest({
    required this.input,
    required this.title,
    required this.sourceLabel,
    required this.now,
  });

  final String input;
  final String? title;
  final String? sourceLabel;
  final DateTime? now;
}

class _CellsPreviewRequest {
  const _CellsPreviewRequest({
    required this.cells,
    required this.title,
    required this.sourceLabel,
    required this.now,
  });

  final List<int?> cells;
  final String? title;
  final String? sourceLabel;
  final DateTime? now;
}

ImportedPuzzlePreview _buildPreviewFromString(_StringPreviewRequest request) {
  final givens = _parsePuzzleString(request.input);
  return _preview(
    givens,
    title: request.title,
    sourceLabel: request.sourceLabel,
    now: request.now,
  );
}

ImportedPuzzlePreview _buildPreviewFromCells(_CellsPreviewRequest request) {
  final givens = SudokuBoard.fromCells(request.cells);
  return _preview(
    givens,
    title: request.title,
    sourceLabel: request.sourceLabel,
    now: request.now,
  );
}

ImportedPuzzlePreview _preview(
  SudokuBoard givens, {
  required String? title,
  required String? sourceLabel,
  required DateTime? now,
}) {
  final givenCount = givens.cells.whereType<int>().length;
  if (givenCount < _minimumUniquePuzzleGivens) {
    throw ImportedPuzzleException(
      'Enter at least $_minimumUniquePuzzleGivens givens before validation. '
      'A standard Sudoku needs 17 or more clues to have a unique solution.',
    );
  }

  if (!_validator.isValidPartial(givens)) {
    throw const ImportedPuzzleException(
      'This puzzle has conflicting givens. Check rows, columns, and boxes.',
    );
  }

  final solutionCount = _solver.countSolutions(givens, limit: 2);
  if (solutionCount == 0) {
    throw const ImportedPuzzleException('This puzzle has no valid solution.');
  }
  if (solutionCount > 1) {
    throw const ImportedPuzzleException(
      'This puzzle has more than one solution.',
    );
  }

  final solution = _solver.solve(givens);
  if (solution == null) {
    throw const ImportedPuzzleException('This puzzle could not be solved.');
  }

  final humanSolver = HumanRankedSolver();
  final humanResult = humanSolver.solve(givens);
  final rating = humanResult.solved
      ? _rater.rate(humanResult.steps)
      : const DifficultyRating(
          difficulty: SudokuDifficulty.extreme,
          score: 320,
          requiredTechniques: <String>['advanced'],
        );
  final checksum = _checksum(givens, solution);
  final normalizedTitle = title?.trim();
  final createdAt = now ?? DateTime.now();

  return ImportedPuzzlePreview(
    id: 'imported_${_dateToken(createdAt)}_${checksum.substring(0, 8)}',
    title: normalizedTitle == null || normalizedTitle.isEmpty
        ? 'Imported ${checksum.substring(0, 6).toUpperCase()}'
        : normalizedTitle,
    sourceLabel: _normalizedNullable(sourceLabel),
    givens: givens,
    solution: solution,
    difficulty: rating.difficulty,
    difficultyScore: rating.score,
    targetTimeSeconds: _targetTimeFor(rating.difficulty),
    medianTimeSeconds: (_targetTimeFor(rating.difficulty) * 1.3).round(),
    requiredTechniques: rating.requiredTechniques,
    humanSolvable: humanResult.solved,
  );
}

SudokuBoard _parsePuzzleString(String input) {
  final normalized = input
      .replaceAll(RegExp(r'\s'), '')
      .replaceAll(RegExp(r'[-.]'), '0');
  if (normalized.length != SudokuBoard.cellCount) {
    throw ImportedPuzzleException(
      'Please enter exactly 81 cells. Current entry has ${normalized.length}.',
    );
  }
  if (!RegExp(r'^[0-9]+$').hasMatch(normalized)) {
    throw const ImportedPuzzleException(
      'Use digits 1-9 for givens and 0, dot, or dash for blanks.',
    );
  }

  return SudokuBoard.fromCells(<int?>[
    for (final char in normalized.split(''))
      char == '0' ? null : int.parse(char),
  ]);
}

String _checksum(SudokuBoard givens, SudokuBoard solution) {
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

String _dateToken(DateTime value) {
  String two(int part) => part.toString().padLeft(2, '0');
  return '${value.year}${two(value.month)}${two(value.day)}_'
      '${two(value.hour)}${two(value.minute)}${two(value.second)}';
}

int _targetTimeFor(SudokuDifficulty difficulty) {
  return switch (difficulty) {
    SudokuDifficulty.beginner => 360,
    SudokuDifficulty.easy => 480,
    SudokuDifficulty.medium => 720,
    SudokuDifficulty.hard => 960,
    SudokuDifficulty.expert => 1200,
    SudokuDifficulty.extreme => 1800,
  };
}

String? _normalizedNullable(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }
  return normalized;
}

class ImportedPuzzleException implements Exception {
  const ImportedPuzzleException(this.message);

  final String message;

  @override
  String toString() => message;
}
