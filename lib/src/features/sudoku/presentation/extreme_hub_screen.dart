import 'package:flutter/material.dart';

import '../../../app/ad_mob_bottom_banner.dart';
import '../../../app/orbace_theme.dart';
import '../data/app_database.dart';
import '../data/puzzle_pack_loader.dart';
import '../data/sudoku_repository.dart';
import '../domain/daily_random_puzzle.dart';
import '../domain/extreme_challenge.dart';
import '../domain/sudoku_attempt.dart';
import '../engine/award_engine.dart';
import 'fixture_puzzles.dart';
import 'sudoku_game_screen.dart';

class ExtremeHubScreen extends StatefulWidget {
  const ExtremeHubScreen({super.key, this.repository, this.catalog});

  final SudokuRepository? repository;
  final PuzzlePackCatalog? catalog;

  @override
  State<ExtremeHubScreen> createState() => _ExtremeHubScreenState();
}

class _ExtremeHubScreenState extends State<ExtremeHubScreen> {
  late final AppDatabase _database;
  late final SudokuRepository _repository;
  late final Future<_ExtremeHubState> _stateFuture;

  @override
  void initState() {
    super.initState();
    if (widget.repository case final repository?) {
      _repository = repository;
    } else {
      _database = AppDatabase();
      _repository = SudokuRepository(_database);
    }
    _stateFuture = _loadState();
  }

  @override
  void dispose() {
    if (widget.repository == null) {
      _database.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Extreme Challenge')),
      bottomNavigationBar: const AdMobBottomBanner(),
      body: SafeArea(
        child: FutureBuilder<_ExtremeHubState>(
          future: _stateFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final state = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              children: [
                _LockCard(unlocked: state.unlocked),
                const SizedBox(height: 12),
                _ChallengeCard(
                  unlocked: state.unlocked,
                  repository: widget.repository,
                  catalog: state.catalog,
                  puzzle: state.puzzle,
                  completedToday: state.completedToday,
                  onReturnFromGame: _refreshState,
                ),
                const SizedBox(height: 12),
                _LocalBestsCard(dailyBests: state.dailyBests),
              ],
            );
          },
        ),
      ),
    );
  }

  void _refreshState() {
    setState(() {
      _stateFuture = _loadState();
    });
  }

  Future<_ExtremeHubState> _loadState() async {
    final attempts = await _repository.allAttempts();
    final summary = const AwardEngine().evaluate(attempts);
    final catalog =
        widget.catalog ??
        await PuzzlePackLoader(repository: widget.repository).load();
    final puzzle = _resolveDailyExtremePuzzle(catalog, DateTime.now());

    final dailyAttempts = attempts
        .where(
          (attempt) =>
              attempt.completed &&
              DailyRandomPuzzle.extremeDaily.matches(attempt.puzzleId),
        )
        .toList(growable: false);
    final completedToday = dailyAttempts.any(
      (attempt) => attempt.puzzleId == puzzle.id,
    );

    final bestByDay = <DateTime, SudokuAttempt>{};
    for (final attempt in dailyAttempts) {
      final date = DailyRandomPuzzle.extremeDaily.parseDate(attempt.puzzleId);
      if (date == null) {
        continue;
      }
      final existing = bestByDay[date];
      final thisScore = attempt.score?.total ?? -1;
      final existingScore = existing?.score?.total ?? -1;
      if (existing == null || thisScore > existingScore) {
        bestByDay[date] = attempt;
      }
    }
    final dailyBests =
        bestByDay.entries.map((entry) => _DailyBest(date: entry.key, attempt: entry.value)).toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    return _ExtremeHubState(
      unlocked: summary.extremeUnlocked,
      catalog: catalog,
      puzzle: puzzle,
      completedToday: completedToday,
      dailyBests: dailyBests,
    );
  }

  FixturePuzzleDefinition _resolveDailyExtremePuzzle(
    PuzzlePackCatalog catalog,
    DateTime date,
  ) {
    final pool = catalog.trueExtremePool;
    if (pool.isNotEmpty) {
      return DailyRandomPuzzle.extremeDaily.forDate(date, pool);
    }
    // Fallback if true_extreme is ever unavailable: fall back to the
    // (undelivered) daily randomization and just serve a raw pool puzzle.
    final expertPack = catalog.packs
        .where((pack) => pack.id == 'extreme')
        .firstOrNull;
    final puzzles = expertPack?.puzzles ?? catalog.puzzles;
    if (puzzles.isEmpty) {
      return catalog.teaMomentPuzzles.first;
    }
    final dayNumber = date.difference(DateTime(2026)).inDays;
    return puzzles[dayNumber.abs() % puzzles.length];
  }
}

class _ExtremeHubState {
  const _ExtremeHubState({
    required this.unlocked,
    required this.catalog,
    required this.puzzle,
    required this.completedToday,
    required this.dailyBests,
  });

  final bool unlocked;
  final PuzzlePackCatalog catalog;
  final FixturePuzzleDefinition puzzle;
  final bool completedToday;
  final List<_DailyBest> dailyBests;
}

class _DailyBest {
  const _DailyBest({required this.date, required this.attempt});

  final DateTime date;
  final SudokuAttempt attempt;
}

class _LockCard extends StatelessWidget {
  const _LockCard({required this.unlocked});

  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              unlocked ? Icons.lock_open : Icons.lock,
              color: unlocked ? const Color(0xFF385D4A) : OrbaceTheme.vermilion,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                unlocked
                    ? 'Extreme Challenge is unlocked for local no-assist play.'
                    : 'Complete Scholar\'s Path Stage 3: Insight to unlock Extreme Challenge.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.unlocked,
    required this.repository,
    required this.catalog,
    required this.puzzle,
    required this.completedToday,
    required this.onReturnFromGame,
  });

  final bool unlocked;
  final SudokuRepository? repository;
  final PuzzlePackCatalog catalog;
  final FixturePuzzleDefinition puzzle;
  final bool completedToday;
  final VoidCallback onReturnFromGame;

  @override
  Widget build(BuildContext context) {
    const challenge = ExtremeChallengeService.dailyExtreme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              challenge.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(challenge.description),
            const SizedBox(height: 8),
            Text('Rules: no hints, no auto-check, no retries for ranking.'),
            if (completedToday) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF385D4A).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF385D4A),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'You\'ve completed today\'s Extreme Challenge. You can '
                        'play again for practice, but only your best score '
                        'counts toward Local Bests.',
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: unlocked
                  ? () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => SudokuGameScreen(
                            repository: repository,
                            puzzle: puzzle,
                            catalog: catalog,
                            noAssistMode: true,
                            isRetry: completedToday,
                          ),
                        ),
                      );
                      onReturnFromGame();
                    }
                  : null,
              icon: const Icon(Icons.bolt),
              label: Text(
                unlocked
                    ? (completedToday
                          ? 'Play Again (Practice)'
                          : 'Start Extreme Challenge')
                    : 'Locked',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocalBestsCard extends StatelessWidget {
  const _LocalBestsCard({required this.dailyBests});

  final List<_DailyBest> dailyBests;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Local Bests', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'One best score per day. Full attempt history and replays '
              'stay in Record Hall.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            if (dailyBests.isEmpty)
              const Text('No completed Extreme Challenge days yet.')
            else
              for (final best in dailyBests)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    children: [
                      Expanded(child: Text(_dayLabel(best.date))),
                      Text(
                        '${best.attempt.score?.total ?? '-'} pts',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }

  String _dayLabel(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
