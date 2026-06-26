import 'package:flutter/material.dart';

import '../../../app/orbace_theme.dart';
import '../data/puzzle_pack_loader.dart';
import '../data/sudoku_repository.dart';
import '../domain/sudoku_attempt.dart';
import '../domain/sudoku_current_progress.dart';
import '../domain/sudoku_score_class.dart';
import 'fixture_puzzles.dart';
import 'import_puzzle_screen.dart';
import 'sudoku_game_screen.dart';

class LevelPackScreen extends StatefulWidget {
  const LevelPackScreen({super.key, this.repository});

  final SudokuRepository? repository;

  @override
  State<LevelPackScreen> createState() => _LevelPackScreenState();
}

class _LevelPackScreenState extends State<LevelPackScreen> {
  late Future<PuzzlePackCatalog> _catalogFuture = _loadCatalog();

  Future<PuzzlePackCatalog> _loadCatalog() {
    return PuzzlePackLoader(repository: widget.repository).load();
  }

  void _refreshCatalog() {
    setState(() {
      _catalogFuture = _loadCatalog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Level Packs'),
        actions: [
          if (widget.repository != null)
            IconButton(
              tooltip: 'Import Puzzle',
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        ImportPuzzleScreen(repository: widget.repository!),
                  ),
                );
                _refreshCatalog();
              },
              icon: const Icon(Icons.input),
            ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<PuzzlePackCatalog>(
          future: _catalogFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return _PackBrowser(
              repository: widget.repository,
              catalog: snapshot.requireData,
            );
          },
        ),
      ),
    );
  }
}

class _PackBrowser extends StatefulWidget {
  const _PackBrowser({required this.repository, required this.catalog});

  final SudokuRepository? repository;
  final PuzzlePackCatalog catalog;

  @override
  State<_PackBrowser> createState() => _PackBrowserState();
}

class _PackBrowserState extends State<_PackBrowser> {
  late Future<_PackProgressSummary> _progressFuture = _loadProgressSummary();

  Future<_PackProgressSummary> _loadProgressSummary() async {
    final repository = widget.repository;
    if (repository == null) {
      return _PackProgressSummary.empty();
    }
    final attempts = await repository.allAttempts();
    final currentProgress = await repository.allCurrentProgress();
    return _PackProgressSummary.from(attempts, currentProgress);
  }

  void _refreshProgress() {
    setState(() {
      _progressFuture = _loadProgressSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final advancedCount = widget.catalog.puzzles
        .where((puzzle) => _hasAdvancedTechnique(puzzle))
        .length;

    return FutureBuilder<_PackProgressSummary>(
      future: _progressFuture,
      builder: (context, snapshot) {
        final progress = snapshot.data ?? _PackProgressSummary.empty();

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            Text(
              '${widget.catalog.puzzles.length} puzzles loaded',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Content ${widget.catalog.contentVersion}  |  Curated ${widget.catalog.generatedAt}',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              '$advancedCount puzzles require pair or pointing techniques',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              '${progress.completedPuzzleIds.length} completed'
              '${progress.currentProgressByPuzzleId.isEmpty ? '' : '  |  ${progress.currentProgressByPuzzleId.length} in progress'}',
              style: textTheme.bodyMedium?.copyWith(
                color: OrbaceTheme.mutedInk,
              ),
            ),
            const SizedBox(height: 14),
            for (final pack in widget.catalog.packs) ...[
              _PackSection(
                repository: widget.repository,
                catalog: widget.catalog,
                pack: pack,
                progress: progress,
                onProgressChanged: _refreshProgress,
              ),
              const SizedBox(height: 12),
            ],
          ],
        );
      },
    );
  }
}

class _PackSection extends StatelessWidget {
  const _PackSection({
    required this.repository,
    required this.catalog,
    required this.pack,
    required this.progress,
    required this.onProgressChanged,
  });

  final SudokuRepository? repository;
  final PuzzlePackCatalog catalog;
  final PuzzlePackDefinition pack;
  final _PackProgressSummary progress;
  final VoidCallback onProgressChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final completedCount = pack.puzzles
        .where((puzzle) => progress.completedPuzzleIds.contains(puzzle.id))
        .length;
    final continuePuzzle = _continuePuzzle();
    final nextUnsolvedPuzzle = _nextUnsolvedPuzzle();

    return Card(
      child: ExpansionTile(
        initiallyExpanded: pack.id == 'tea_moments' || pack.id == 'mastery',
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        leading: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: OrbaceTheme.vermilion,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            pack.seal,
            style: textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        title: Text(pack.title, style: textTheme.titleLarge),
        subtitle: Text(
          '$completedCount/${pack.puzzles.length} completed  |  '
          '${pack.advancedPuzzleCount} advanced',
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
              child: Text(pack.description, style: textTheme.bodyMedium),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: continuePuzzle == null
                        ? null
                        : () => _openPuzzle(
                            context,
                            continuePuzzle,
                            progress.currentProgressByPuzzleId[continuePuzzle
                                .id],
                          ),
                    icon: const Icon(Icons.play_circle_outline),
                    label: const Text('Continue'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: nextUnsolvedPuzzle == null
                        ? null
                        : () => _openPuzzle(context, nextUnsolvedPuzzle, null),
                    icon: const Icon(Icons.skip_next),
                    label: const Text('Next Unsolved'),
                  ),
                ),
              ],
            ),
          ),
          for (final puzzle in pack.puzzles) ...[
            _PuzzleTile(
              repository: repository,
              catalog: catalog,
              puzzle: puzzle,
              progress: progress,
              onProgressChanged: onProgressChanged,
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  FixturePuzzleDefinition? _continuePuzzle() {
    final inProgress =
        pack.puzzles
            .where(
              (puzzle) =>
                  progress.currentProgressByPuzzleId.containsKey(puzzle.id),
            )
            .toList()
          ..sort((a, b) {
            final aProgress = progress.currentProgressByPuzzleId[a.id]!;
            final bProgress = progress.currentProgressByPuzzleId[b.id]!;
            return bProgress.updatedAt.compareTo(aProgress.updatedAt);
          });
    return inProgress.isEmpty ? null : inProgress.first;
  }

  FixturePuzzleDefinition? _nextUnsolvedPuzzle() {
    for (final puzzle in pack.puzzles) {
      if (!progress.completedPuzzleIds.contains(puzzle.id)) {
        return puzzle;
      }
    }
    return null;
  }

  Future<void> _openPuzzle(
    BuildContext context,
    FixturePuzzleDefinition puzzle,
    SudokuCurrentProgress? currentProgress,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SudokuGameScreen(
          repository: repository,
          puzzle: puzzle,
          catalog: catalog,
          initialProgress: currentProgress,
        ),
      ),
    );
    onProgressChanged();
  }
}

class _PuzzleTile extends StatelessWidget {
  const _PuzzleTile({
    required this.repository,
    required this.catalog,
    required this.puzzle,
    required this.progress,
    required this.onProgressChanged,
  });

  final SudokuRepository? repository;
  final PuzzlePackCatalog catalog;
  final FixturePuzzleDefinition puzzle;
  final _PackProgressSummary progress;
  final VoidCallback onProgressChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final advanced = _hasAdvancedTechnique(puzzle);
    final completed = progress.completedPuzzleIds.contains(puzzle.id);
    final currentProgress = progress.currentProgressByPuzzleId[puzzle.id];
    final bestAttempt = progress.bestAttemptByPuzzleId[puzzle.id];
    final bestScore = bestAttempt?.score?.total;
    final hasOfficial = progress.officialPuzzleIds.contains(puzzle.id);
    final hasClean = progress.cleanPuzzleIds.contains(puzzle.id);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => SudokuGameScreen(
                repository: repository,
                puzzle: puzzle,
                catalog: catalog,
                initialProgress: currentProgress,
              ),
            ),
          );
          onProgressChanged();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 38,
                child: Text(
                  puzzle.seal,
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge?.copyWith(
                    color: OrbaceTheme.vermilion,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(puzzle.title, style: textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      '${puzzle.difficulty.label}  |  '
                      '${puzzle.clueCount} givens  |  '
                      'Target ${_formatMinutes(puzzle.targetTimeSeconds)}',
                      style: textTheme.bodyMedium,
                    ),
                    if (bestScore != null || currentProgress != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 2,
                          children: [
                            if (bestScore != null)
                              Text(
                                'Best $bestScore',
                                style: textTheme.bodySmall?.copyWith(
                                  color: OrbaceTheme.ink,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            if (hasOfficial)
                              Text(
                                'Official',
                                style: textTheme.bodySmall?.copyWith(
                                  color: OrbaceTheme.vermilion,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            if (hasClean)
                              Text(
                                'Clean',
                                style: textTheme.bodySmall?.copyWith(
                                  color: OrbaceTheme.celadon,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            if (currentProgress != null)
                              Text(
                                'In progress ${_formatMinutes(currentProgress.elapsedSeconds)}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: OrbaceTheme.mutedInk,
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (currentProgress != null)
                const Tooltip(
                  message: 'In progress',
                  child: Icon(
                    Icons.play_circle_fill,
                    color: OrbaceTheme.vermilion,
                    size: 22,
                  ),
                ),
              if (currentProgress != null) const SizedBox(width: 8),
              if (completed)
                const Tooltip(
                  message: 'Completed',
                  child: Icon(
                    Icons.check_circle,
                    color: OrbaceTheme.celadon,
                    size: 22,
                  ),
                ),
              if (completed) const SizedBox(width: 8),
              if (advanced)
                Tooltip(
                  message: puzzle.requiredTechniques.join(', '),
                  child: const Icon(Icons.auto_awesome, size: 20),
                ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

bool _hasAdvancedTechnique(FixturePuzzleDefinition puzzle) {
  return puzzle.requiredTechniques.any(
    (technique) =>
        technique == 'naked_pair' ||
        technique == 'hidden_pair' ||
        technique == 'pointing_pair',
  );
}

String _formatMinutes(int seconds) {
  final minutes = (seconds / 60).round();
  return '${minutes}m';
}

class _PackProgressSummary {
  const _PackProgressSummary({
    required this.completedPuzzleIds,
    required this.officialPuzzleIds,
    required this.cleanPuzzleIds,
    required this.bestAttemptByPuzzleId,
    required this.currentProgressByPuzzleId,
  });

  factory _PackProgressSummary.empty() {
    return const _PackProgressSummary(
      completedPuzzleIds: <String>{},
      officialPuzzleIds: <String>{},
      cleanPuzzleIds: <String>{},
      bestAttemptByPuzzleId: <String, SudokuAttempt>{},
      currentProgressByPuzzleId: <String, SudokuCurrentProgress>{},
    );
  }

  factory _PackProgressSummary.from(
    List<SudokuAttempt> attempts,
    List<SudokuCurrentProgress> currentProgress,
  ) {
    final completedPuzzleIds = <String>{};
    final officialPuzzleIds = <String>{};
    final cleanPuzzleIds = <String>{};
    final bestAttemptByPuzzleId = <String, SudokuAttempt>{};

    for (final attempt in attempts.where((attempt) => attempt.completed)) {
      completedPuzzleIds.add(attempt.puzzleId);
      if (attempt.scoreClass == SudokuScoreClass.official) {
        officialPuzzleIds.add(attempt.puzzleId);
      }
      if (attempt.cleanSolve) {
        cleanPuzzleIds.add(attempt.puzzleId);
      }

      final currentBest = bestAttemptByPuzzleId[attempt.puzzleId];
      if (currentBest == null || _isBetterAttempt(attempt, currentBest)) {
        bestAttemptByPuzzleId[attempt.puzzleId] = attempt;
      }
    }

    return _PackProgressSummary(
      completedPuzzleIds: completedPuzzleIds,
      officialPuzzleIds: officialPuzzleIds,
      cleanPuzzleIds: cleanPuzzleIds,
      bestAttemptByPuzzleId: bestAttemptByPuzzleId,
      currentProgressByPuzzleId: {
        for (final progress in currentProgress) progress.puzzleId: progress,
      },
    );
  }

  final Set<String> completedPuzzleIds;
  final Set<String> officialPuzzleIds;
  final Set<String> cleanPuzzleIds;
  final Map<String, SudokuAttempt> bestAttemptByPuzzleId;
  final Map<String, SudokuCurrentProgress> currentProgressByPuzzleId;

  static bool _isBetterAttempt(SudokuAttempt a, SudokuAttempt b) {
    final scoreCompare = (a.score?.total ?? 0).compareTo(b.score?.total ?? 0);
    if (scoreCompare != 0) {
      return scoreCompare > 0;
    }
    final timeCompare = a.elapsedSeconds.compareTo(b.elapsedSeconds);
    if (timeCompare != 0) {
      return timeCompare < 0;
    }
    return a.startedAt.isBefore(b.startedAt);
  }
}
