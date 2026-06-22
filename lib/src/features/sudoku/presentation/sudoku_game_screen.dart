import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/orbace_theme.dart';
import '../data/app_database.dart';
import '../data/sudoku_repository.dart';
import '../domain/sudoku_attempt.dart';
import '../domain/sudoku_score_class.dart';
import '../engine/human_ranked_solver.dart';
import 'fixture_puzzles.dart';
import 'game_session_controller.dart';
import 'sudoku_board_widget.dart';
import 'sudoku_number_pad.dart';
import 'sudoku_replay_screen.dart';

class SudokuGameScreen extends StatefulWidget {
  const SudokuGameScreen({super.key, this.repository, this.puzzle});

  final SudokuRepository? repository;
  final FixturePuzzleDefinition? puzzle;

  @override
  State<SudokuGameScreen> createState() => _SudokuGameScreenState();
}

class _SudokuGameScreenState extends State<SudokuGameScreen> {
  late final GameSessionController _controller;
  late final AppDatabase _database;
  late final SudokuRepository _repository;
  late final FixturePuzzleDefinition _puzzle;
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
    _puzzle = widget.puzzle ?? FixturePuzzles.defaultTeaMoment;
    _controller = GameSessionController(
      givens: _puzzle.givens,
      solution: _puzzle.solution,
      puzzleId: _puzzle.id,
      difficulty: _puzzle.difficulty,
      targetTimeSeconds: _puzzle.targetTimeSeconds,
    )..addListener(_handleControllerChanged);
    unawaited(_seedPuzzle());
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
            return LayoutBuilder(
              builder: (context, constraints) {
                final widePortrait = constraints.maxWidth >= 700;
                final contentMaxWidth = widePortrait ? 620.0 : double.infinity;
                final boardMaxWidth = widePortrait
                    ? (constraints.maxHeight * 0.52).clamp(480.0, 540.0)
                    : double.infinity;

                return Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: contentMaxWidth,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _SessionHeader(
                                controller: _controller,
                                puzzle: _puzzle,
                              ),
                              const SizedBox(height: 12),
                              Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: boardMaxWidth,
                                  ),
                                  child: SudokuBoardWidget(
                                    controller: _controller,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              SudokuNumberPad(controller: _controller),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: _showHint,
                                      icon: const Icon(
                                        Icons.light_mode_outlined,
                                      ),
                                      label: const Text('Lantern Hint'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () =>
                                          _controller.setMistakeChecking(
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
                        ),
                      ),
                    ),
                    if (_controller.paused) const _PauseOverlay(),
                  ],
                );
              },
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

  Future<void> _seedPuzzle() async {
    final solvePath = HumanRankedSolver().solve(_puzzle.givens).steps;
    await _repository.upsertPuzzle(
      fixturePuzzleRecord(
        id: _controller.puzzleId,
        givens: _puzzle.givens,
        solution: _puzzle.solution,
        solvePath: solvePath,
        difficulty: _puzzle.difficulty,
        difficultyScore: _puzzle.difficultyScore,
        targetTimeSeconds: _puzzle.targetTimeSeconds,
        medianTimeSeconds: _puzzle.medianTimeSeconds,
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
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _CompletionCertificateDialog(
          attempt: attempt,
          puzzle: _puzzle,
          repository: _repository,
          onRetry: () {
            Navigator.of(context).pop();
            _controller.resetForRetry();
            _completionShown = false;
          },
          onReplay: () {
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
          onDone: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class _CompletionCertificateDialog extends StatefulWidget {
  const _CompletionCertificateDialog({
    required this.attempt,
    required this.puzzle,
    required this.repository,
    required this.onRetry,
    required this.onReplay,
    required this.onDone,
  });

  final SudokuAttempt attempt;
  final FixturePuzzleDefinition puzzle;
  final SudokuRepository repository;
  final VoidCallback onRetry;
  final VoidCallback onReplay;
  final VoidCallback onDone;

  @override
  State<_CompletionCertificateDialog> createState() =>
      _CompletionCertificateDialogState();
}

class _CompletionCertificateDialogState
    extends State<_CompletionCertificateDialog> {
  final GlobalKey _certificateKey = GlobalKey();
  late double _rating = widget.attempt.playerDifficultyRating ?? 3.0;
  bool _ratingSaved = false;
  bool _savingRating = false;
  bool _savingCard = false;
  bool _sharingCard = false;
  String? _scoreCardPath;

  int get _hintCount =>
      widget.attempt.hintNudgeCount +
      widget.attempt.hintExplanationCount +
      widget.attempt.hintRevealCount;

  bool get _isClean =>
      widget.attempt.errorCount == 0 &&
      widget.attempt.hintNudgeCount == 0 &&
      widget.attempt.hintExplanationCount == 0 &&
      widget.attempt.hintRevealCount == 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final score = widget.attempt.score;
    final ratingLabel = _difficultyRatingLabel(_rating);

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: OrbaceTheme.ricePaper,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE6DED0)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RepaintBoundary(
                  key: _certificateKey,
                  child: _ScoreCertificateCard(
                    attempt: widget.attempt,
                    puzzle: widget.puzzle,
                    rating: _rating,
                    hintCount: _hintCount,
                    isClean: _isClean,
                  ),
                ),
                const SizedBox(height: 12),
                _CertificateSection(
                  title: 'Player Difficulty',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${_rating.toStringAsFixed(1)} / 5.0',
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              ratingLabel,
                              style: textTheme.bodyMedium?.copyWith(
                                color: OrbaceTheme.mutedInk,
                              ),
                            ),
                          ),
                          if (_savingRating)
                            const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          else if (_ratingSaved)
                            const Icon(
                              Icons.check_circle,
                              color: OrbaceTheme.celadon,
                              size: 20,
                            ),
                        ],
                      ),
                      Slider(
                        value: _rating,
                        min: 1,
                        max: 5,
                        divisions: 40,
                        label: _rating.toStringAsFixed(1),
                        onChanged: (value) {
                          setState(() {
                            _rating = double.parse(value.toStringAsFixed(1));
                            _ratingSaved = false;
                          });
                        },
                        onChangeEnd: _saveRating,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Su-Pu ID: ${widget.attempt.id}\n'
                  'Scoring v${score?.scoringVersion ?? 0} · Replay saved locally',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: OrbaceTheme.mutedInk,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    TextButton.icon(
                      onPressed: widget.onRetry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                    OutlinedButton.icon(
                      onPressed: widget.onReplay,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Replay'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _savingCard ? null : _saveScoreCard,
                      icon: _savingCard
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_alt),
                      label: const Text('Save Card'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _sharingCard ? null : _shareScoreCard,
                      icon: const Icon(Icons.ios_share),
                      label: const Text('Share Card'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _showRecordHallMessage,
                      icon: const Icon(Icons.inventory_2_outlined),
                      label: const Text('Record Hall'),
                    ),
                    FilledButton(
                      onPressed: widget.onDone,
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveRating(double value) async {
    setState(() {
      _savingRating = true;
      _ratingSaved = false;
    });
    await widget.repository.updatePlayerDifficultyRating(
      widget.attempt.id,
      value,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _savingRating = false;
      _ratingSaved = true;
    });
  }

  Future<void> _saveScoreCard() async {
    setState(() {
      _savingCard = true;
    });
    try {
      final path = await _renderScoreCardPng();
      await widget.repository.updateScoreCardImagePath(widget.attempt.id, path);
      if (!mounted) {
        return;
      }
      setState(() {
        _scoreCardPath = path;
      });
      _showMessage('Score card saved inside Orbace Sudoku.');
    } finally {
      if (mounted) {
        setState(() {
          _savingCard = false;
        });
      }
    }
  }

  Future<void> _shareScoreCard() async {
    setState(() {
      _sharingCard = true;
    });
    try {
      final path = _scoreCardPath ?? await _renderScoreCardPng();
      await widget.repository.updateScoreCardImagePath(widget.attempt.id, path);
      if (!mounted) {
        return;
      }
      setState(() {
        _scoreCardPath = path;
      });
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(path)],
          text: 'My Orbace Sudoku Su-Pu · ${widget.puzzle.title}',
          subject: 'Orbace Sudoku Solve Record',
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sharingCard = false;
        });
      }
    }
  }

  Future<String> _renderScoreCardPng() async {
    await WidgetsBinding.instance.endOfFrame;
    final boundary =
        _certificateKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) {
      throw StateError('Score card is not ready to render.');
    }
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw StateError('Could not encode score card.');
    }
    final dir = await getApplicationDocumentsDirectory();
    final cardDir = Directory(p.join(dir.path, 'score_cards'));
    if (!cardDir.existsSync()) {
      await cardDir.create(recursive: true);
    }
    final safeAttemptId = widget.attempt.id.replaceAll(
      RegExp(r'[^A-Za-z0-9_.-]'),
      '_',
    );
    final file = File(p.join(cardDir.path, '$safeAttemptId.png'));
    await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
    return file.path;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showRecordHallMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Record Hall arrives in Phase 4. This Su-Pu is saved locally.',
        ),
      ),
    );
  }
}

class _ScoreCertificateCard extends StatelessWidget {
  const _ScoreCertificateCard({
    required this.attempt,
    required this.puzzle,
    required this.rating,
    required this.hintCount,
    required this.isClean,
  });

  final SudokuAttempt attempt;
  final FixturePuzzleDefinition puzzle;
  final double rating;
  final int hintCount;
  final bool isClean;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final score = attempt.score;
    final scoreClass = attempt.scoreClass;

    return ColoredBox(
      color: OrbaceTheme.ricePaper,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CertificateSeal(label: puzzle.difficulty.chineseLabel),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Orbace Sudoku', style: textTheme.titleLarge),
                      const SizedBox(height: 2),
                      Text(
                        'Solve Record · 一局成績',
                        style: textTheme.bodyLarge?.copyWith(
                          color: OrbaceTheme.mutedInk,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Su-Pu · 数谱 saved to Record Hall',
                        style: textTheme.bodyMedium?.copyWith(
                          color: OrbaceTheme.mutedInk,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Center(
              child: Text(
                '${score?.total ?? 0}',
                style: textTheme.headlineMedium?.copyWith(
                  fontSize: 44,
                  fontWeight: FontWeight.w700,
                  color: OrbaceTheme.ink,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                _CertificateChip(
                  label:
                      '${scoreClass.label} · ${_scoreClassChinese(scoreClass)}',
                  color: _scoreClassColor(scoreClass),
                ),
                if (isClean)
                  const _CertificateChip(
                    label: 'Clean · 净谱',
                    color: OrbaceTheme.celadon,
                  ),
                _CertificateChip(
                  label:
                      '${puzzle.difficulty.label} · ${puzzle.difficulty.chineseLabel}',
                  color: OrbaceTheme.vermilion,
                ),
              ],
            ),
            const SizedBox(height: 18),
            _CertificateSection(
              title: puzzle.title,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _MetricTile(
                    label: 'Time',
                    value: _formatTime(attempt.elapsedSeconds),
                  ),
                  _MetricTile(
                    label: 'Mistakes',
                    value: '${attempt.errorCount}',
                  ),
                  _MetricTile(label: 'Hints', value: '$hintCount'),
                  _MetricTile(
                    label: 'Steps',
                    value: '${attempt.moveHistory.length}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _CertificateSection(
              title: 'Score Breakdown',
              child: Column(
                children: [
                  _BreakdownRow(
                    label: 'Base',
                    value: '${score?.baseScore ?? 0}',
                  ),
                  _BreakdownRow(
                    label: 'Accuracy',
                    value:
                        'x${(score?.accuracyMultiplier ?? 0).toStringAsFixed(2)}',
                  ),
                  _BreakdownRow(
                    label: 'Time bonus',
                    value: '+${score?.timeBonus ?? 0}',
                  ),
                  _BreakdownRow(
                    label: 'Efficiency bonus',
                    value: '+${score?.efficiencyBonus ?? 0}',
                  ),
                  _BreakdownRow(
                    label: 'Clean solve bonus',
                    value: '+${score?.cleanSolveBonus ?? 0}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _CertificateSection(
              title: 'Player Rating',
              child: _BreakdownRow(
                label: _difficultyRatingLabel(rating),
                value: '${rating.toStringAsFixed(1)} / 5.0',
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Su-Pu ID: ${attempt.id}\n'
              'Scoring v${score?.scoringVersion ?? 0} · Replay saved locally',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: OrbaceTheme.mutedInk,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CertificateSeal extends StatelessWidget {
  const _CertificateSeal({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: OrbaceTheme.vermilion,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF8E2F23), width: 2),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _CertificateChip extends StatelessWidget {
  const _CertificateChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: OrbaceTheme.ink,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _CertificateSection extends StatelessWidget {
  const _CertificateSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: OrbaceTheme.paper.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6DED0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: OrbaceTheme.mutedInk),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

String _scoreClassChinese(SudokuScoreClass scoreClass) {
  return switch (scoreClass) {
    SudokuScoreClass.official => '正谱',
    SudokuScoreClass.assisted => '习谱',
    SudokuScoreClass.retry => '重修谱',
    SudokuScoreClass.legacy => '旧谱',
  };
}

Color _scoreClassColor(SudokuScoreClass scoreClass) {
  return switch (scoreClass) {
    SudokuScoreClass.official => OrbaceTheme.celadon,
    SudokuScoreClass.assisted => const Color(0xFF2E74B5),
    SudokuScoreClass.retry => const Color(0xFF7B6BB2),
    SudokuScoreClass.legacy => OrbaceTheme.mutedInk,
  };
}

String _difficultyRatingLabel(double rating) {
  if (rating < 2) {
    return 'Gentle';
  }
  if (rating < 3) {
    return 'Steady';
  }
  if (rating < 4) {
    return 'Challenging';
  }
  if (rating < 4.7) {
    return 'Hard';
  }
  return 'Extreme';
}

class _SessionHeader extends StatelessWidget {
  const _SessionHeader({required this.controller, required this.puzzle});

  final GameSessionController controller;
  final FixturePuzzleDefinition puzzle;

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
            puzzle.seal,
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
              Text(puzzle.title, style: textTheme.titleLarge),
              const SizedBox(height: 2),
              Text(
                '${puzzle.difficulty.label}  |  '
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
