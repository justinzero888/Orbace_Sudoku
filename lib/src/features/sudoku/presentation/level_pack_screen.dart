import 'package:flutter/material.dart';

import '../../../app/orbace_theme.dart';
import '../data/puzzle_pack_loader.dart';
import '../data/sudoku_repository.dart';
import 'fixture_puzzles.dart';
import 'sudoku_game_screen.dart';

class LevelPackScreen extends StatefulWidget {
  const LevelPackScreen({super.key, this.repository});

  final SudokuRepository? repository;

  @override
  State<LevelPackScreen> createState() => _LevelPackScreenState();
}

class _LevelPackScreenState extends State<LevelPackScreen> {
  late final Future<PuzzlePackCatalog> _catalogFuture = PuzzlePackLoader()
      .load();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Level Packs')),
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
  late final Future<Set<String>> _completedPuzzleIdsFuture =
      _loadCompletedPuzzleIds();

  Future<Set<String>> _loadCompletedPuzzleIds() async {
    final repository = widget.repository;
    if (repository == null) {
      return <String>{};
    }
    final attempts = await repository.allAttempts();
    return attempts
        .where((attempt) => attempt.completed)
        .map((attempt) => attempt.puzzleId)
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final advancedCount = widget.catalog.puzzles
        .where((puzzle) => _hasAdvancedTechnique(puzzle))
        .length;

    return FutureBuilder<Set<String>>(
      future: _completedPuzzleIdsFuture,
      builder: (context, snapshot) {
        final completedPuzzleIds = snapshot.data ?? <String>{};

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
              '${completedPuzzleIds.length} completed',
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
                completedPuzzleIds: completedPuzzleIds,
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
    required this.completedPuzzleIds,
  });

  final SudokuRepository? repository;
  final PuzzlePackCatalog catalog;
  final PuzzlePackDefinition pack;
  final Set<String> completedPuzzleIds;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
          '${pack.puzzles.length} puzzles  |  '
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
          for (final puzzle in pack.puzzles) ...[
            _PuzzleTile(
              repository: repository,
              catalog: catalog,
              puzzle: puzzle,
              completed: completedPuzzleIds.contains(puzzle.id),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _PuzzleTile extends StatelessWidget {
  const _PuzzleTile({
    required this.repository,
    required this.catalog,
    required this.puzzle,
    required this.completed,
  });

  final SudokuRepository? repository;
  final PuzzlePackCatalog catalog;
  final FixturePuzzleDefinition puzzle;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final advanced = _hasAdvancedTechnique(puzzle);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => SudokuGameScreen(
                repository: repository,
                puzzle: puzzle,
                catalog: catalog,
              ),
            ),
          );
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
                  ],
                ),
              ),
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
