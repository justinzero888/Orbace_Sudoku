import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/orbace_theme.dart';
import '../data/app_database.dart';
import '../data/sudoku_repository.dart';
import '../domain/sudoku_attempt.dart';
import '../engine/human_ranked_solver.dart';
import 'fixture_puzzles.dart';
import 'game_session_controller.dart';
import 'sudoku_board_widget.dart';
import 'sudoku_number_pad.dart';
import 'sudoku_replay_screen.dart';

class SudokuGameScreen extends StatefulWidget {
  const SudokuGameScreen({super.key, this.repository});

  final SudokuRepository? repository;

  @override
  State<SudokuGameScreen> createState() => _SudokuGameScreenState();
}

class _SudokuGameScreenState extends State<SudokuGameScreen> {
  late final GameSessionController _controller;
  late final AppDatabase _database;
  late final SudokuRepository _repository;
  Timer? _timer;
  bool _completionShown = false;
  SudokuAttempt? _lastAttempt;

  @override
  void initState() {
    super.initState();
    if (widget.repository case final repository?) {
      _repository = repository;
    } else {
      _database = AppDatabase();
      _repository = SudokuRepository(_database);
    }
    _controller = GameSessionController(
      givens: FixturePuzzles.teaMomentGivens(),
      solution: FixturePuzzles.teaMomentSolution(),
    )..addListener(_handleControllerChanged);
    unawaited(_seedFixturePuzzle());
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _controller.tick(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller
      ..removeListener(_handleControllerChanged)
      ..dispose();
    if (widget.repository == null) {
      unawaited(_database.close());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tea Moment'),
        actions: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return IconButton(
                tooltip: _controller.paused ? 'Resume' : 'Pause',
                onPressed: _controller.togglePause,
                icon: Icon(_controller.paused ? Icons.play_arrow : Icons.pause),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    _SessionHeader(controller: _controller),
                    const SizedBox(height: 12),
                    SudokuBoardWidget(controller: _controller),
                    const SizedBox(height: 18),
                    SudokuNumberPad(controller: _controller),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _showHint,
                            icon: const Icon(Icons.light_mode_outlined),
                            label: const Text('Lantern Hint'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _controller.setMistakeChecking(
                              !_controller.mistakeChecking,
                            ),
                            icon: Icon(
                              _controller.mistakeChecking
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            label: Text(
                              _controller.mistakeChecking
                                  ? 'Check On'
                                  : 'Check Off',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (_controller.paused) const _PauseOverlay(),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleControllerChanged() {
    if (_controller.completed && !_completionShown) {
      _completionShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_completeAttempt());
      });
    }
  }

  Future<void> _seedFixturePuzzle() async {
    final solvePath = HumanRankedSolver()
        .solve(FixturePuzzles.teaMomentGivens())
        .steps;
    await _repository.upsertPuzzle(
      fixturePuzzleRecord(
        id: _controller.puzzleId,
        givens: FixturePuzzles.teaMomentGivens(),
        solution: FixturePuzzles.teaMomentSolution(),
        solvePath: solvePath,
      ),
    );
  }

  Future<void> _completeAttempt() async {
    final priorAttempts = await _repository.attemptsForPuzzle(
      _controller.puzzleId,
    );
    final attempt = _controller.buildAttempt(
      attemptNumber: priorAttempts.length + 1,
    );
    await _repository.saveAttempt(attempt);
    _lastAttempt = attempt;
    if (mounted) {
      _showCompletion(attempt);
    }
  }

  void _showHint() {
    final hint = _controller.requestHint();
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(hint.title),
          content: Text(hint.message),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void _showCompletion(SudokuAttempt attempt) {
    final score = attempt.score;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Puzzle Complete'),
          content: SingleChildScrollView(
            child: Text(
              'Seal earned: 入門\n'
              'Score: ${score?.total ?? 0}\n'
              'Base: ${score?.baseScore ?? 0}\n'
              'Accuracy: x${(score?.accuracyMultiplier ?? 0).toStringAsFixed(2)}\n'
              'Time bonus: ${score?.timeBonus ?? 0}\n'
              'Efficiency bonus: ${score?.efficiencyBonus ?? 0}\n'
              'Clean solve bonus: ${score?.cleanSolveBonus ?? 0}\n'
              'Time: ${_formatTime(attempt.elapsedSeconds)}\n'
              'Mistakes: ${attempt.errorCount}\n'
              'Hints: ${attempt.hintNudgeCount + attempt.hintExplanationCount + attempt.hintRevealCount}',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _controller.resetForRetry();
                _completionShown = false;
              },
              child: const Text('Retry'),
            ),
            TextButton(
              onPressed: () {
                final replayAttempt = _lastAttempt;
                if (replayAttempt == null) {
                  return;
                }
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => SudokuReplayScreen(
                      givens: _controller.givens,
                      attempt: replayAttempt,
                    ),
                  ),
                );
              },
              child: const Text('View Replay'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Return Home'),
            ),
          ],
        );
      },
    );
  }
}

class _SessionHeader extends StatelessWidget {
  const _SessionHeader({required this.controller});

  final GameSessionController controller;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: OrbaceTheme.vermilion,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '入',
            style: textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Beginner Tea Moment', style: textTheme.titleLarge),
              const SizedBox(height: 2),
              Text(
                '${_formatTime(controller.elapsedSeconds)}  |  '
                'Mistakes ${controller.mistakeCount}  |  '
                'Hints ${controller.hintCount}',
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PauseOverlay extends StatelessWidget {
  const _PauseOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: OrbaceTheme.paper.withValues(alpha: 0.92),
        child: const Center(
          child: Text(
            'Paused',
            style: TextStyle(
              color: OrbaceTheme.ink,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

String _formatTime(int seconds) {
  final minutes = seconds ~/ 60;
  final remainder = seconds % 60;
  return '$minutes:${remainder.toString().padLeft(2, '0')}';
}
