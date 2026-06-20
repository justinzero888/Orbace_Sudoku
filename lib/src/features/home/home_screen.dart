import 'package:flutter/material.dart';

import '../../app/orbace_theme.dart';
import '../sudoku/data/sudoku_repository.dart';
import '../sudoku/domain/daily_tea_moment.dart';
import '../sudoku/presentation/extreme_hub_screen.dart';
import '../sudoku/presentation/scholar_path_screen.dart';
import '../sudoku/presentation/sudoku_game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.repository});

  final SudokuRepository? repository;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final daily = const DailyTeaMomentSelector().forDate(
      DateTime.now(),
      const <String>['tea_moment_fixture'],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Orbace Sudoku')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Text('一局一茶', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Today\'s Tea Moment is ${daily.dayKey}. Solve calmly, use notes, undo moves, and ask the lantern for help.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _PhaseCard(
              title: 'Tea Moment',
              subtitle: 'Start the Phase 2 playable puzzle',
              seal: '茶',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => SudokuGameScreen(repository: repository),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            const _PhaseCard(
              title: 'Level Packs',
              subtitle: '入門, 小成, 貫通, 精深, 入神',
              seal: '局',
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
