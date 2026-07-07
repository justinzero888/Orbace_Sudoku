import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/ad_mob_bottom_banner.dart';
import '../../../app/orbace_theme.dart';
import '../data/puzzle_pack_loader.dart';
import '../data/score_card_store.dart';
import '../data/sudoku_repository.dart';
import '../domain/sudoku_attempt.dart';
import '../domain/sudoku_score_class.dart';
import '../engine/local_ranking_engine.dart';
import '../engine/score_calculator.dart';
import 'fixture_puzzles.dart';
import 'solution_comments_dialog.dart';
import 'su_pu_compare_screen.dart';
import 'sudoku_game_screen.dart';
import 'sudoku_replay_screen.dart';

class SuPuDetailScreen extends StatefulWidget {
  const SuPuDetailScreen({
    super.key,
    required this.repository,
    required this.catalog,
    required this.puzzle,
    required this.initialAttempt,
  });

  final SudokuRepository repository;
  final PuzzlePackCatalog catalog;
  final FixturePuzzleDefinition puzzle;
  final SudokuAttempt initialAttempt;

  @override
  State<SuPuDetailScreen> createState() => _SuPuDetailScreenState();
}

class _SuPuDetailScreenState extends State<SuPuDetailScreen> {
  late Future<List<SudokuAttempt>> _attemptsFuture = _loadAttempts();
  final ScoreCardStore _scoreCardStore = const ScoreCardStore();
  final LocalRankingEngine _rankingEngine = const LocalRankingEngine();

  Future<List<SudokuAttempt>> _loadAttempts() async {
    final attempts = await widget.repository.attemptsForPuzzle(
      widget.puzzle.id,
    );
    return attempts.where((attempt) => attempt.completed).toList()
      ..sort((a, b) => b.attemptNumber.compareTo(a.attemptNumber));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Su-Pu Detail')),
      body: SafeArea(
        child: FutureBuilder<List<SudokuAttempt>>(
          future: _attemptsFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final attempts = snapshot.requireData;
            final localRanking = _localRanking(attempts);
            final bestOfficial = localRanking.firstOrNull?.attempt;
            final bestOverall = _bestOverall(attempts);
            final latest = attempts.isEmpty ? null : attempts.first;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                _PuzzleHeader(puzzle: widget.puzzle, attempts: attempts),
                const SizedBox(height: 12),
                _BestSummary(
                  bestOfficial: bestOfficial,
                  bestOverall: bestOverall,
                  latest: latest,
                ),
                const SizedBox(height: 14),
                _LocalRankingPanel(
                  puzzle: widget.puzzle,
                  entries: localRanking,
                  initialAttemptId: widget.initialAttempt.id,
                ),
                const SizedBox(height: 14),
                _CompareEntryPanel(
                  attempts: attempts,
                  onCompare: attempts.length < 2
                      ? null
                      : () => _openCompare(attempts),
                ),
                const SizedBox(height: 14),
                Text('Versions', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                if (attempts.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No completed Su-Pu for this puzzle yet.'),
                    ),
                  )
                else
                  for (final entry in attempts.indexed) ...[
                    _VersionCard(
                      attempt: entry.$2,
                      previous: _previousAttemptFor(entry.$2, attempts),
                      isInitial: entry.$2.id == widget.initialAttempt.id,
                      onReplay: () => _openReplay(entry.$2),
                      onCertificate: () => _openCertificate(entry.$2),
                      onNotes: () => _editNotes(entry.$2),
                    ),
                    const SizedBox(height: 10),
                  ],
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: FilledButton.icon(
                onPressed: _startRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry This Puzzle'),
              ),
            ),
          ),
          const AdMobBottomBanner(),
        ],
      ),
    );
  }

  List<LocalRankingEntry> _localRanking(List<SudokuAttempt> attempts) {
    return _rankingEngine.rank(
      attempts: attempts,
      puzzleChecksum: widget.repository.puzzleChecksum(
        widget.puzzle.givens,
        widget.puzzle.solution,
      ),
      scoringVersion: ScoreCalculator.scoringVersion,
    );
  }

  SudokuAttempt? _bestOverall(List<SudokuAttempt> attempts) {
    if (attempts.isEmpty) {
      return null;
    }
    final sorted = attempts.toList()
      ..sort((a, b) => (b.score?.total ?? 0).compareTo(a.score?.total ?? 0));
    return sorted.first;
  }

  SudokuAttempt? _previousAttemptFor(
    SudokuAttempt attempt,
    List<SudokuAttempt> attempts,
  ) {
    final older =
        attempts
            .where(
              (candidate) => candidate.attemptNumber < attempt.attemptNumber,
            )
            .toList()
          ..sort((a, b) => b.attemptNumber.compareTo(a.attemptNumber));
    return older.firstOrNull;
  }

  void _openReplay(SudokuAttempt attempt) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            SudokuReplayScreen(givens: widget.puzzle.givens, attempt: attempt),
      ),
    );
  }

  void _openCompare(List<SudokuAttempt> attempts) {
    if (attempts.length < 2) {
      _showMessage('Complete this puzzle at least twice to compare Su-Pu.');
      return;
    }
    final primary = attempts.first;
    final baseline = _previousAttemptFor(primary, attempts) ?? attempts[1];
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SuPuCompareScreen(
          puzzle: widget.puzzle,
          attempts: attempts,
          initialPrimary: primary,
          initialBaseline: baseline,
        ),
      ),
    );
  }

  Future<void> _openCertificate(SudokuAttempt attempt) async {
    final imagePath = attempt.scoreCardImagePath;
    final imageFile = imagePath == null
        ? null
        : await _scoreCardStore.resolve(imagePath);
    if (!mounted) {
      return;
    }
    if (imageFile == null) {
      _showMessage(
        'No saved card image found. Open this solve after completion and tap Save Card.',
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Saved Score Card',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(imageFile),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: Navigator.of(context).pop,
                        child: const Text('Close'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: () async {
                          await SharePlus.instance.share(
                            ShareParams(
                              files: [XFile(imageFile.path)],
                              text:
                                  'My Orbace Sudoku Su-Pu\n'
                                  'Download Orbace Sudoku free at www.orbacesudoku.com',
                              subject: 'Orbace Sudoku Solve Record',
                              sharePositionOrigin: _shareOrigin(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.ios_share),
                        label: const Text('Share'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _editNotes(SudokuAttempt attempt) async {
    final notes = await showSolutionCommentsDialog(
      context,
      initialText: attempt.replayNotes ?? '',
    );
    if (notes == null) {
      return;
    }
    await widget.repository.updateReplayNotes(attempt.id, notes);
    if (!mounted) {
      return;
    }
    setState(() {
      _attemptsFuture = _loadAttempts();
    });
  }

  void _startRetry() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SudokuGameScreen(
          repository: widget.repository,
          puzzle: widget.puzzle,
          catalog: widget.catalog,
          isRetry: true,
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Rect _shareOrigin() {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      return Rect.zero;
    }
    final origin = box.localToGlobal(Offset.zero);
    return origin & box.size;
  }
}

class _PuzzleHeader extends StatelessWidget {
  const _PuzzleHeader({required this.puzzle, required this.attempts});

  final FixturePuzzleDefinition puzzle;
  final List<SudokuAttempt> attempts;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: OrbaceTheme.ricePaper,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6DED0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: OrbaceTheme.vermilion,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                puzzle.seal,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    puzzle.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${puzzle.difficulty.label} · ${attempts.length} Su-Pu',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: OrbaceTheme.mutedInk,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BestSummary extends StatelessWidget {
  const _BestSummary({
    required this.bestOfficial,
    required this.bestOverall,
    required this.latest,
  });

  final SudokuAttempt? bestOfficial;
  final SudokuAttempt? bestOverall;
  final SudokuAttempt? latest;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _SummaryTile(label: 'Best Official', attempt: bestOfficial),
        _SummaryTile(label: 'Best Overall', attempt: bestOverall),
        _SummaryTile(label: 'Latest Su-Pu', attempt: latest),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.label, required this.attempt});

  final String label;
  final SudokuAttempt? attempt;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: OrbaceTheme.paper,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE6DED0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: OrbaceTheme.ink),
              ),
              const SizedBox(height: 6),
              Text(
                attempt == null ? 'None yet' : '${attempt!.score?.total ?? 0}',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              if (attempt != null)
                Text(
                  'Attempt ${attempt!.attemptNumber}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompareEntryPanel extends StatelessWidget {
  const _CompareEntryPanel({required this.attempts, required this.onCompare});

  final List<SudokuAttempt> attempts;
  final VoidCallback? onCompare;

  @override
  Widget build(BuildContext context) {
    final enabled = onCompare != null;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: OrbaceTheme.paper,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6DED0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.compare_arrows),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Compare Su-Pu · 对谱',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                _Badge(label: '${attempts.length} records'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              enabled
                  ? 'Compare two completed records for this same puzzle: score, time, steps, mistakes, hints, clean marker, and score class.'
                  : 'Complete this puzzle at least twice to unlock 对谱 comparison.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: OrbaceTheme.ink),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: onCompare,
                icon: const Icon(Icons.compare),
                label: const Text('Open Compare'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocalRankingPanel extends StatelessWidget {
  const _LocalRankingPanel({
    required this.puzzle,
    required this.entries,
    required this.initialAttemptId,
  });

  final FixturePuzzleDefinition puzzle;
  final List<LocalRankingEntry> entries;
  final String initialAttemptId;

  @override
  Widget build(BuildContext context) {
    final isImported = puzzle.packId == 'imported';
    final visibleEntries = entries.take(5).toList(growable: false);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: OrbaceTheme.paper,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6DED0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.leaderboard_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Local Ranking · 名谱榜',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (isImported)
                  const _Badge(label: 'Imported · 入谱')
                else
                  _Badge(label: '${entries.length} ranked'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isImported
                  ? 'Imported puzzles are personal records only. They can be replayed, rated, and shared, but are excluded from ranking.'
                  : 'Only Official · 正谱 records with the same puzzle checksum and scoring version appear here.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: OrbaceTheme.ink),
            ),
            const SizedBox(height: 12),
            if (entries.isEmpty)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFCF5),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFE6DED0)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'No ranked Su-Pu yet. Complete a built-in puzzle with no hints, no auto-check, and no retry to create one.',
                  ),
                ),
              )
            else
              for (final entry in visibleEntries) ...[
                _RankingRow(
                  entry: entry,
                  isCurrent: entry.attempt.id == initialAttemptId,
                ),
                if (entry != visibleEntries.last) const Divider(height: 14),
              ],
          ],
        ),
      ),
    );
  }
}

class _RankingRow extends StatelessWidget {
  const _RankingRow({required this.entry, required this.isCurrent});

  final LocalRankingEntry entry;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final attempt = entry.attempt;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isCurrent ? const Color(0xFFFFFCF5) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                '#${entry.rank}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            Expanded(
              child: Text(
                'Attempt ${attempt.attemptNumber}${isCurrent ? ' · Current' : ''}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
            Text(
              '${attempt.score?.total ?? 0}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(width: 12),
            Text(_formatTime(attempt.elapsedSeconds)),
          ],
        ),
      ),
    );
  }
}

class _VersionCard extends StatelessWidget {
  const _VersionCard({
    required this.attempt,
    required this.previous,
    required this.isInitial,
    required this.onReplay,
    required this.onCertificate,
    required this.onNotes,
  });

  final SudokuAttempt attempt;
  final SudokuAttempt? previous;
  final bool isInitial;
  final VoidCallback onReplay;
  final VoidCallback onCertificate;
  final VoidCallback onNotes;

  @override
  Widget build(BuildContext context) {
    final score = attempt.score?.total ?? 0;
    final hintCount =
        attempt.hintNudgeCount +
        attempt.hintExplanationCount +
        attempt.hintRevealCount;
    return Card(
      color: isInitial ? const Color(0xFFFFFCF5) : null,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Attempt ${attempt.attemptNumber}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                _Badge(
                  label:
                      '${attempt.scoreClass.label} · ${_scoreClassChinese(attempt.scoreClass)}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Metric(label: 'Score', value: '$score'),
                _Metric(
                  label: 'Time',
                  value: _formatTime(attempt.elapsedSeconds),
                ),
                _Metric(label: 'Mistakes', value: '${attempt.errorCount}'),
                _Metric(label: 'Hints', value: '$hintCount'),
                _Metric(label: 'Steps', value: '${attempt.moveHistory.length}'),
              ],
            ),
            if (previous != null) ...[
              const SizedBox(height: 10),
              Text(
                _deltaText(attempt, previous!),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: OrbaceTheme.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            if (attempt.replayNotes case final notes?
                when notes.isNotEmpty) ...[
              const SizedBox(height: 10),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: OrbaceTheme.paper,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFE6DED0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text('谱评: $notes'),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: onNotes,
                  icon: const Icon(Icons.edit_note),
                  label: const Text('Notes'),
                ),
                OutlinedButton.icon(
                  onPressed: onCertificate,
                  icon: const Icon(Icons.workspace_premium_outlined),
                  label: const Text('Certificate'),
                ),
                FilledButton.icon(
                  onPressed: onReplay,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Replay'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: OrbaceTheme.celadon.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

String _deltaText(SudokuAttempt attempt, SudokuAttempt previous) {
  final scoreDelta = (attempt.score?.total ?? 0) - (previous.score?.total ?? 0);
  final timeDelta = attempt.elapsedSeconds - previous.elapsedSeconds;
  final stepDelta = attempt.moveHistory.length - previous.moveHistory.length;
  final mistakeDelta = attempt.errorCount - previous.errorCount;
  return 'vs previous: ${_signed(scoreDelta)} score, '
      '${_signed(-timeDelta)} time, ${_signed(-stepDelta)} steps, '
      '${_signed(-mistakeDelta)} mistakes';
}

String _signed(int value) {
  if (value > 0) {
    return '+$value';
  }
  return '$value';
}

String _scoreClassChinese(SudokuScoreClass scoreClass) {
  return switch (scoreClass) {
    SudokuScoreClass.official => '正谱',
    SudokuScoreClass.assisted => '习谱',
    SudokuScoreClass.retry => '重修谱',
    SudokuScoreClass.legacy => '旧谱',
  };
}

String _formatTime(int seconds) {
  final minutes = seconds ~/ 60;
  final remaining = seconds % 60;
  return '$minutes:${remaining.toString().padLeft(2, '0')}';
}
