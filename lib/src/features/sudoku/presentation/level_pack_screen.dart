import 'package:flutter/material.dart';

import '../../../app/orbace_theme.dart';
import '../data/sudoku_repository.dart';
import '../domain/sudoku_difficulty.dart';
import 'fixture_puzzles.dart';
import 'sudoku_game_screen.dart';

class LevelPackScreen extends StatelessWidget {
  const LevelPackScreen({super.key, this.repository});

  final SudokuRepository? repository;

  @override
  Widget build(BuildContext context) {
    final grouped = <SudokuDifficulty, List<FixturePuzzleDefinition>>{
      for (final difficulty in SudokuDifficulty.values)
        difficulty: FixturePuzzles.catalog
            .where((puzzle) => puzzle.difficulty == difficulty)
            .toList(growable: false),
    }..removeWhere((_, puzzles) => puzzles.isEmpty);

    return Scaffold(
      appBar: AppBar(title: const Text('Level Packs')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            Text(
              '${FixturePuzzles.catalog.length} test puzzles loaded',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            for (final entry in grouped.entries) ...[
              _DifficultyHeader(difficulty: entry.key),
              const SizedBox(height: 8),
              for (final puzzle in entry.value) ...[
                _PuzzleCard(repository: repository, puzzle: puzzle),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _DifficultyHeader extends StatelessWidget {
  const _DifficultyHeader({required this.difficulty});

  final SudokuDifficulty difficulty;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${difficulty.chineseLabel} ${difficulty.label}',
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

class _PuzzleCard extends StatelessWidget {
  const _PuzzleCard({required this.repository, required this.puzzle});

  final SudokuRepository? repository;
  final FixturePuzzleDefinition puzzle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) =>
                  SudokuGameScreen(repository: repository, puzzle: puzzle),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
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
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(puzzle.title, style: textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      '${puzzle.clueCount} givens  |  '
                      'Target ${_formatMinutes(puzzle.targetTimeSeconds)}',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatMinutes(int seconds) {
  final minutes = (seconds / 60).round();
  return '${minutes}m';
}
