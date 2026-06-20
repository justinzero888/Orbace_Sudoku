import 'package:flutter/material.dart';

import '../../app/orbace_theme.dart';
import '../sudoku/presentation/sudoku_game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Orbace Sudoku')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Text('一局一茶', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'A playable Tea Moment is ready. Solve calmly, use notes, undo moves, and ask the lantern for help.',
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
                    builder: (_) => const SudokuGameScreen(),
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
            const _PhaseCard(
              title: 'Scholar\'s Path',
              subtitle: 'Awards, replay, and local Extreme unlocks',
              seal: '學',
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
