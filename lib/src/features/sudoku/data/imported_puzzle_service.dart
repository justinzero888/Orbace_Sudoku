import 'dart:convert';

import 'package:crypto/crypto.dart';

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
}

class ImportedPuzzleService {
  ImportedPuzzleService({
    required this.repository,
    SudokuSolver? solver,
    SudokuValidator? validator,
    HumanRankedSolver? humanSolver,
    SudokuDifficultyRater? rater,
  }) : _solver = solver ?? const SudokuSolver(),
       _validator = validator ?? const SudokuValidator(),
       _humanSolver = humanSolver ?? HumanRankedSolver(),
       _rater = rater ?? const SudokuDifficultyRater();

  final SudokuRepository repository;
  final SudokuSolver _solver;
  final SudokuValidator _validator;
  final HumanRankedSolver _humanSolver;
  final SudokuDifficultyRater _rater;

  ImportedPuzzlePreview previewFromString(
    String input, {
    String? title,
    String? sourceLabel,
    DateTime? now,
  }) {
    final givens = _parsePuzzleString(input);
    return _preview(givens, title: title, sourceLabel: sourceLabel, now: now);
  }

  ImportedPuzzlePreview previewFromCells(
    List<int?> cells, {
    String? title,
    String? sourceLabel,
    DateTime? now,
  }) {
    final givens = SudokuBoard.fromCells(cells);
    return _preview(givens, title: title, sourceLabel: sourceLabel, now: now);
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

  ImportedPuzzlePreview _preview(
    SudokuBoard givens, {
    required String? title,
    required String? sourceLabel,
    required DateTime? now,
  }) {
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

    final humanResult = _humanSolver.solve(givens);
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
}

class ImportedPuzzleException implements Exception {
  const ImportedPuzzleException(this.message);

  final String message;

  @override
  String toString() => message;
}
