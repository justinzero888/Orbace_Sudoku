import 'package:flutter/material.dart';

import '../../app/ad_mob_bottom_banner.dart';
import '../../app/orbace_theme.dart';
import '../settings/settings_screen.dart';
import '../sudoku/data/puzzle_pack_loader.dart';
import '../sudoku/data/sudoku_repository.dart';
import '../sudoku/domain/daily_tea_moment.dart';
import '../sudoku/presentation/extreme_hub_screen.dart';
import '../sudoku/presentation/import_puzzle_screen.dart';
import '../sudoku/presentation/level_pack_screen.dart';
import '../sudoku/presentation/record_hall_screen.dart';
import '../sudoku/presentation/scholar_path_screen.dart';
import '../sudoku/presentation/sudoku_game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.repository});

  final SudokuRepository? repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return FutureBuilder<PuzzlePackCatalog>(
      future: _catalogFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Orbace Sudoku')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        return _HomeContent(
          repository: widget.repository,
          catalog: snapshot.requireData,
          onRefreshCatalog: _refreshCatalog,
        );
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.repository,
    required this.catalog,
    required this.onRefreshCatalog,
  });

  final SudokuRepository? repository;
  final PuzzlePackCatalog catalog;
  final VoidCallback onRefreshCatalog;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final puzzleIds = catalog.teaMomentPuzzles
        .map((puzzle) => puzzle.id)
        .toList(growable: false);
    final daily = const DailyTeaMomentSelector().forDate(
      DateTime.now(),
      puzzleIds,
    );
    final dailyPuzzle = catalog.byId(daily.puzzleId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orbace Sudoku'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      bottomNavigationBar: const AdMobBottomBanner(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Text('一局一茶', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Today\'s Tea Moment is ${dailyPuzzle.title} (${daily.dayKey}). Solve calmly, use notes, undo moves, and ask the lantern for help.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _PhaseCard(
              title: 'Tea Moment',
              subtitle: 'Start today\'s calm puzzle',
              seal: '茶',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => SudokuGameScreen(
                      repository: repository,
                      puzzle: dailyPuzzle,
                      catalog: catalog,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            if (repository != null) ...[
              _PhaseCard(
                title: 'Import Puzzle',
                subtitle: 'Paste or enter a personal Sudoku',
                seal: '入',
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          ImportPuzzleScreen(repository: repository!),
                    ),
                  );
                  onRefreshCatalog();
                },
              ),
              const SizedBox(height: 12),
              _PhaseCard(
                title: 'Record Hall',
                subtitle: '藏谱阁 · replay saved Su-Pu',
                seal: '谱',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => RecordHallScreen(
                        repository: repository!,
                        catalog: catalog,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
            _PhaseCard(
              title: 'Level Packs',
              subtitle: '${catalog.puzzles.length} puzzles loaded',
              seal: '局',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => LevelPackScreen(repository: repository),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _PhaseCard(
              title: 'Official Ranking',
              subtitle: 'Daily and global ranking events are coming soon',
              seal: '榜',
              onTap: () => _showRankingPreview(context),
            ),
            const SizedBox(height: 12),
            _PhaseCard(
              title: 'Scholar\'s Path',
              subtitle: 'Awards, replay, and local Extreme unlocks',
              seal: '學',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ScholarPathScreen(repository: repository),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _PhaseCard(
              title: 'Extreme Challenge',
              subtitle: 'Locked local no-assist challenge hub',
              seal: '極',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ExtremeHubScreen(repository: repository),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRankingPreview(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Official Ranking · Coming Soon'),
          content: const Text(
            'Daily, weekly, monthly, and annual ranking games will be account-based official events. They will use one attempt, no pause, official availability windows, server-side validation, and global leaderboards. Current local play and local ranking stay unchanged.',
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _PhaseCard extends StatelessWidget {
  const _PhaseCard({
    required this.title,
    required this.subtitle,
    required this.seal,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String seal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: OrbaceTheme.vermilion,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  seal,
                  style: textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(subtitle, style: textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
