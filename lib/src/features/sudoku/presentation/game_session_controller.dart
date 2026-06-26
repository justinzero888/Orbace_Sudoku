import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import '../domain/sudoku_board.dart';
import '../domain/sudoku_attempt.dart';
import '../domain/sudoku_current_progress.dart';
import '../domain/sudoku_difficulty.dart';
import '../domain/sudoku_move.dart';
import '../domain/solving_step.dart';
import '../engine/attempt_eligibility_engine.dart';
import '../engine/human_ranked_solver.dart';
import '../engine/score_calculator.dart';
import '../engine/sudoku_validator.dart';

class GameSessionController extends ChangeNotifier {
  GameSessionController({
    required SudokuBoard givens,
    required this.solution,
    this.puzzleId = 'tea_moment_fixture',
    this.difficulty = SudokuDifficulty.beginner,
    this.targetTimeSeconds = 360,
    this.puzzleRankedEligible = false,
    this.contentVersion,
    SudokuCurrentProgress? initialProgress,
    HumanRankedSolver? humanSolver,
    this.scoreCalculator = const ScoreCalculator(),
    this.eligibilityEngine = const AttemptEligibilityEngine(),
  }) : _givens = givens,
       _humanSolver = humanSolver ?? HumanRankedSolver(),
       _values = givens.toMutableCells(),
       _notes = List<Set<int>>.generate(
         SudokuBoard.cellCount,
         (_) => <int>{},
         growable: false,
       ) {
    _solvePath = _humanSolver.solve(_givens).steps;
    if (initialProgress != null) {
      _restoreProgress(initialProgress);
    }
  }

  final SudokuBoard _givens;
  final SudokuBoard solution;
  final String puzzleId;
  final SudokuDifficulty difficulty;
  final int targetTimeSeconds;
  final bool puzzleRankedEligible;
  final String? contentVersion;
  final HumanRankedSolver _humanSolver;
  final ScoreCalculator scoreCalculator;
  final AttemptEligibilityEngine eligibilityEngine;
  static const SudokuValidator _validator = SudokuValidator();
  final List<int?> _values;
  final List<Set<int>> _notes;
  final List<SudokuMove> _undoStack = <SudokuMove>[];
  final List<SudokuMove> _redoStack = <SudokuMove>[];
  final List<SudokuMove> _moveHistory = <SudokuMove>[];
  late final List<StoredSolvingStep> _solvePath;

  int? _selectedIndex;
  bool _notesMode = false;
  bool _mistakeChecking = true;
  bool _paused = false;
  bool _completed = false;
  int _elapsedSeconds = 0;
  int _mistakeCount = 0;
  int _hintCount = 0;
  int _hintNudgeCount = 0;
  int _hintExplanationCount = 0;
  int _hintRevealCount = 0;
  int _hintTier = 0;
  int? _hintTargetIndex;
  DateTime _startedAt = DateTime.now();

  SudokuBoard get givens => _givens;
  List<int?> get values => List<int?>.unmodifiable(_values);
  List<Set<int>> get notes => List<Set<int>>.unmodifiable(
    _notes.map((set) => Set<int>.unmodifiable(set)),
  );
  int? get selectedIndex => _selectedIndex;
  bool get notesMode => _notesMode;
  bool get mistakeChecking => _mistakeChecking;
  bool get paused => _paused;
  bool get completed => _completed;
  int get elapsedSeconds => _elapsedSeconds;
  int get mistakeCount => _mistakeCount;
  int get hintCount => _hintCount;
  int get hintNudgeCount => _hintNudgeCount;
  int get hintExplanationCount => _hintExplanationCount;
  int get hintRevealCount => _hintRevealCount;
  int get hintTier => _hintTier;
  int? get hintTargetIndex => _hintTargetIndex;
  List<SudokuMove> get moveHistory =>
      List<SudokuMove>.unmodifiable(_moveHistory);
  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;
  bool get hasUnsavedProgress {
    if (_completed) {
      return false;
    }
    for (var index = 0; index < SudokuBoard.cellCount; index++) {
      if (_givens.valueAtIndex(index) == null && _values[index] != null) {
        return true;
      }
      if (_notes[index].isNotEmpty) {
        return true;
      }
    }
    return _elapsedSeconds > 0;
  }

  bool isGiven(int index) => _givens.valueAtIndex(index) != null;

  bool isEditable(int index) => !isGiven(index) && !_completed;

  int? valueAt(int index) => _values[index];

  Set<int> notesAt(int index) => Set<int>.unmodifiable(_notes[index]);

  bool isRelatedToSelection(int index) {
    final selected = _selectedIndex;
    if (selected == null || selected == index) {
      return false;
    }
    return SudokuBoard.rowOf(index) == SudokuBoard.rowOf(selected) ||
        SudokuBoard.colOf(index) == SudokuBoard.colOf(selected) ||
        SudokuBoard.boxOf(SudokuBoard.rowOf(index), SudokuBoard.colOf(index)) ==
            SudokuBoard.boxOf(
              SudokuBoard.rowOf(selected),
              SudokuBoard.colOf(selected),
            );
  }

  bool hasSameValueAsSelection(int index) {
    final selected = _selectedIndex;
    if (selected == null || selected == index) {
      return false;
    }
    final selectedValue = _values[selected];
    return selectedValue != null && _values[index] == selectedValue;
  }

  bool isIncorrect(int index) {
    final value = _values[index];
    return _mistakeChecking &&
        value != null &&
        value != solution.valueAtIndex(index);
  }

  void selectCell(int index) {
    if (index < 0 || index >= SudokuBoard.cellCount) {
      throw RangeError.range(index, 0, SudokuBoard.cellCount - 1, 'index');
    }
    _selectedIndex = index;
    _hintTier = 0;
    _hintTargetIndex = null;
    notifyListeners();
  }

  void toggleNotesMode() {
    _notesMode = !_notesMode;
    notifyListeners();
  }

  void setMistakeChecking(bool enabled) {
    _mistakeChecking = enabled;
    notifyListeners();
  }

  void togglePause() {
    _paused = !_paused;
    notifyListeners();
  }

  void tick() {
    if (!_paused && !_completed) {
      _elapsedSeconds++;
      notifyListeners();
    }
  }

  void enterNumber(int value) {
    final selected = _selectedIndex;
    if (selected == null || value < 1 || value > 9 || !isEditable(selected)) {
      return;
    }

    if (_notesMode) {
      if (_notes[selected].contains(value)) {
        _notes[selected].remove(value);
      } else {
        _notes[selected].add(value);
      }
      _recordMove(
        SudokuMove(
          cellIndex: selected,
          previousValue: null,
          nextValue: null,
          elapsedSeconds: _elapsedSeconds,
          type: SudokuMoveType.noteToggle,
          noteValue: value,
        ),
      );
      notifyListeners();
      return;
    }

    final previous = _values[selected];
    if (previous == value) {
      return;
    }

    _values[selected] = value;
    _notes[selected].clear();
    _removeNoteFromPeers(selected, value);
    _recordMove(
      SudokuMove(
        cellIndex: selected,
        previousValue: previous,
        nextValue: value,
        elapsedSeconds: _elapsedSeconds,
        type: SudokuMoveType.valueEntry,
      ),
    );

    if (value != solution.valueAtIndex(selected)) {
      _mistakeCount++;
    }

    _hintTier = 0;
    _hintTargetIndex = null;
    _completed = _validator.isSolved(SudokuBoard.fromCells(_values));
    notifyListeners();
  }

  void eraseSelected() {
    final selected = _selectedIndex;
    if (selected == null || !isEditable(selected)) {
      return;
    }

    final previous = _values[selected];
    if (previous == null && _notes[selected].isEmpty) {
      return;
    }

    final previousNotes = Set<int>.from(_notes[selected]);
    _values[selected] = null;
    _notes[selected].clear();
    if (previous != null) {
      _recordMove(
        SudokuMove(
          cellIndex: selected,
          previousValue: previous,
          nextValue: null,
          elapsedSeconds: _elapsedSeconds,
          type: SudokuMoveType.erase,
        ),
      );
    } else {
      for (final noteValue in previousNotes) {
        _recordMove(
          SudokuMove(
            cellIndex: selected,
            previousValue: null,
            nextValue: null,
            elapsedSeconds: _elapsedSeconds,
            type: SudokuMoveType.noteToggle,
            noteValue: noteValue,
          ),
        );
      }
    }
    _completed = false;
    notifyListeners();
  }

  void undo() {
    if (_undoStack.isEmpty) {
      return;
    }
    final move = _undoStack.removeLast();
    _applyUndo(move);
    _redoStack.add(move);
    _moveHistory.add(_backMoveFor(move));
    _completed = false;
    notifyListeners();
  }

  void redo() {
    if (_redoStack.isEmpty) {
      return;
    }
    final move = _redoStack.removeLast();
    _applyRedo(move);
    _undoStack.add(move);
    _completed = _validator.isSolved(SudokuBoard.fromCells(_values));
    notifyListeners();
  }

  HintResult requestHint() {
    if (_completed || _solvePath.isEmpty) {
      return const HintResult(
        tier: 0,
        title: 'No hint available',
        message: 'This puzzle is already complete.',
      );
    }

    final step = _solvePath.firstWhere((step) {
      final cellIndex = SudokuBoard.index(step.row, step.col);
      return _values[cellIndex] == null;
    }, orElse: () => _solvePath.first);
    final target = SudokuBoard.index(step.row, step.col);

    if (_hintTargetIndex != target) {
      _hintTargetIndex = target;
      _hintTier = 0;
    }

    _hintTier = (_hintTier + 1).clamp(1, 3);
    _hintCount++;
    _selectedIndex = target;
    switch (_hintTier) {
      case 1:
        _hintNudgeCount++;
      case 2:
        _hintExplanationCount++;
      case 3:
        _hintRevealCount++;
    }

    if (_hintTier == 3 && step.value != null && isEditable(target)) {
      final previous = _values[target];
      _values[target] = step.value;
      _notes[target].clear();
      _removeNoteFromPeers(target, step.value!);
      _recordMove(
        SudokuMove(
          cellIndex: target,
          previousValue: previous,
          nextValue: step.value,
          elapsedSeconds: _elapsedSeconds,
          type: SudokuMoveType.hintReveal,
        ),
      );
      _completed = _validator.isSolved(SudokuBoard.fromCells(_values));
    }

    notifyListeners();

    return HintResult(
      tier: _hintTier,
      title: switch (_hintTier) {
        1 => 'Gentle nudge',
        2 => _techniqueTitle(step.techniqueId),
        _ => 'Reveal',
      },
      message: switch (_hintTier) {
        1 => 'Look closely at row ${step.row + 1}, column ${step.col + 1}.',
        2 =>
          '${_techniqueTitle(step.techniqueId)} can place ${step.value ?? 'a value'} here.',
        _ =>
          'Placed ${step.value} in row ${step.row + 1}, column ${step.col + 1}.',
      },
    );
  }

  void _removeNoteFromPeers(int cellIndex, int value) {
    for (final peer in SudokuBoard.peerIndices(cellIndex)) {
      _notes[peer].remove(value);
    }
  }

  String _techniqueTitle(String id) {
    return switch (id) {
      'naked_single' => 'Naked Single',
      'hidden_single' => 'Hidden Single',
      'naked_pair' => 'Naked Pair',
      'hidden_pair' => 'Hidden Pair',
      'pointing_pair' => 'Pointing Pair',
      _ => 'Technique',
    };
  }

  SudokuAttempt buildAttempt({bool isRetry = false, int attemptNumber = 1}) {
    final cleanSolve = _mistakeCount == 0 && _hintCount == 0;
    final score = scoreCalculator.calculate(
      ScoreInput(
        difficulty: difficulty,
        elapsedSeconds: _elapsedSeconds,
        targetTimeSeconds: targetTimeSeconds,
        errorCount: _mistakeCount,
        hintNudgeCount: _hintNudgeCount,
        hintExplanationCount: _hintExplanationCount,
        hintRevealCount: _hintRevealCount,
        autoCheckEnabled: _mistakeChecking,
        timerEnabled: true,
        cleanSolve: cleanSolve,
        playerSteps: _undoStack.length,
        optimalSteps: _solvePath.length,
      ),
    );
    final eligibility = eligibilityEngine.evaluate(
      AttemptEligibilityInput(
        completed: _completed,
        isRetry: isRetry,
        attemptNumber: attemptNumber,
        hintNudgeCount: _hintNudgeCount,
        hintExplanationCount: _hintExplanationCount,
        hintRevealCount: _hintRevealCount,
        autoCheckEnabled: _mistakeChecking,
        mistakeRevealEnabled: _mistakeChecking,
        puzzleRankedEligible: puzzleRankedEligible,
        scoringVersion: score.scoringVersion,
        currentScoringVersion: ScoreCalculator.scoringVersion,
      ),
    );

    return SudokuAttempt(
      id: '${puzzleId}_${_startedAt.microsecondsSinceEpoch}',
      puzzleId: puzzleId,
      isRetry: isRetry,
      attemptNumber: attemptNumber,
      elapsedSeconds: _elapsedSeconds,
      errorCount: _mistakeCount,
      hintNudgeCount: _hintNudgeCount,
      hintExplanationCount: _hintExplanationCount,
      hintRevealCount: _hintRevealCount,
      autoCheckEnabled: _mistakeChecking,
      mistakeRevealEnabled: _mistakeChecking,
      completed: _completed,
      cleanSolve: cleanSolve,
      rankedEligible: eligibility.rankedEligible,
      scoreClass: eligibility.scoreClass,
      score: score,
      moveHistory: moveHistory,
      startedAt: _startedAt,
      completedAt: _completed ? DateTime.now() : null,
      replayHash: _replayHash(),
      puzzleChecksum: _puzzleChecksum(),
      contentVersion: contentVersion,
    );
  }

  SudokuCurrentProgress buildCurrentProgress({DateTime? updatedAt}) {
    return SudokuCurrentProgress(
      puzzleId: puzzleId,
      values: List<int?>.unmodifiable(_values),
      notes: List<Set<int>>.unmodifiable(
        _notes.map((noteSet) => Set<int>.unmodifiable(noteSet)),
      ),
      elapsedSeconds: _elapsedSeconds,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  String _puzzleChecksum() {
    return sha256
        .convert(
          utf8.encode(
            jsonEncode(<String, Object?>{
              'givens': _givens.cells,
              'solution': solution.cells,
            }),
          ),
        )
        .toString();
  }

  String _replayHash() {
    return sha256
        .convert(
          utf8.encode(
            jsonEncode(<String, Object?>{
              'puzzleId': puzzleId,
              'puzzleChecksum': _puzzleChecksum(),
              'moves': [
                for (final move in _moveHistory)
                  <String, Object?>{
                    'cellIndex': move.cellIndex,
                    'previousValue': move.previousValue,
                    'nextValue': move.nextValue,
                    'elapsedSeconds': move.elapsedSeconds,
                    'type': move.type.name,
                    'noteValue': move.noteValue,
                  },
              ],
            }),
          ),
        )
        .toString();
  }

  void resetForRetry() {
    _values
      ..clear()
      ..addAll(_givens.toMutableCells());
    for (final noteSet in _notes) {
      noteSet.clear();
    }
    _undoStack.clear();
    _redoStack.clear();
    _moveHistory.clear();
    _selectedIndex = null;
    _notesMode = false;
    _paused = false;
    _completed = false;
    _elapsedSeconds = 0;
    _mistakeCount = 0;
    _hintCount = 0;
    _hintNudgeCount = 0;
    _hintExplanationCount = 0;
    _hintRevealCount = 0;
    _hintTier = 0;
    _hintTargetIndex = null;
    _startedAt = DateTime.now();
    notifyListeners();
  }

  void _restoreProgress(SudokuCurrentProgress progress) {
    if (progress.values.length == SudokuBoard.cellCount) {
      for (var index = 0; index < SudokuBoard.cellCount; index++) {
        final given = _givens.valueAtIndex(index);
        _values[index] = given ?? progress.values[index];
      }
    }

    if (progress.notes.length == SudokuBoard.cellCount) {
      for (var index = 0; index < SudokuBoard.cellCount; index++) {
        _notes[index]
          ..clear()
          ..addAll(
            progress.notes[index].where((value) => value >= 1 && value <= 9),
          );
      }
    }

    _elapsedSeconds = progress.elapsedSeconds < 0 ? 0 : progress.elapsedSeconds;
    _completed = _validator.isSolved(SudokuBoard.fromCells(_values));
  }

  void _recordMove(SudokuMove move) {
    _undoStack.add(move);
    _moveHistory.add(move);
    _redoStack.clear();
  }

  SudokuMove _backMoveFor(SudokuMove move) {
    return SudokuMove(
      cellIndex: move.cellIndex,
      previousValue: move.nextValue,
      nextValue: move.previousValue,
      elapsedSeconds: _elapsedSeconds,
      type: move.type == SudokuMoveType.noteToggle
          ? SudokuMoveType.noteBack
          : SudokuMoveType.valueBack,
      noteValue: move.noteValue,
    );
  }

  void _applyUndo(SudokuMove move) {
    switch (move.type) {
      case SudokuMoveType.noteToggle:
      case SudokuMoveType.noteBack:
        final noteValue = move.noteValue;
        if (noteValue != null) {
          if (_notes[move.cellIndex].contains(noteValue)) {
            _notes[move.cellIndex].remove(noteValue);
          } else {
            _notes[move.cellIndex].add(noteValue);
          }
        }
        break;
      case SudokuMoveType.valueEntry:
      case SudokuMoveType.erase:
      case SudokuMoveType.hintReveal:
      case SudokuMoveType.valueBack:
        _values[move.cellIndex] = move.previousValue;
        break;
    }
  }

  void _applyRedo(SudokuMove move) {
    switch (move.type) {
      case SudokuMoveType.noteToggle:
      case SudokuMoveType.noteBack:
        final noteValue = move.noteValue;
        if (noteValue != null) {
          if (_notes[move.cellIndex].contains(noteValue)) {
            _notes[move.cellIndex].remove(noteValue);
          } else {
            _notes[move.cellIndex].add(noteValue);
          }
        }
        break;
      case SudokuMoveType.valueEntry:
      case SudokuMoveType.erase:
      case SudokuMoveType.hintReveal:
      case SudokuMoveType.valueBack:
        _values[move.cellIndex] = move.nextValue;
        break;
    }
  }
}

class HintResult {
  const HintResult({
    required this.tier,
    required this.title,
    required this.message,
  });

  final int tier;
  final String title;
  final String message;
}
