import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/ad_mob_bottom_banner.dart';
import '../../../app/orbace_theme.dart';
import '../data/puzzle_pack_loader.dart';
import '../data/score_card_store.dart';
import '../data/sudoku_repository.dart';
import '../domain/sudoku_attempt.dart';
import '../domain/sudoku_score_class.dart';
import 'fixture_puzzles.dart';
import 'su_pu_detail_screen.dart';
import 'sudoku_replay_screen.dart';

enum _RecordHallFilter { all, favorites, official, clean, extreme }

class RecordHallScreen extends StatefulWidget {
  const RecordHallScreen({
    super.key,
    required this.repository,
    required this.catalog,
  });

  final SudokuRepository repository;
  final PuzzlePackCatalog catalog;

  @override
  State<RecordHallScreen> createState() => _RecordHallScreenState();
}

class _RecordHallScreenState extends State<RecordHallScreen> {
  late Future<List<SudokuAttempt>> _attemptsFuture = _loadAttempts();
  final ScoreCardStore _scoreCardStore = const ScoreCardStore();
  _RecordHallFilter _filter = _RecordHallFilter.all;

  Future<List<SudokuAttempt>> _loadAttempts() {
    return widget.repository.completedAttemptsForReplayLibrary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record Hall')),
      bottomNavigationBar: const AdMobBottomBanner(),
      body: SafeArea(
        child: FutureBuilder<List<SudokuAttempt>>(
          future: _attemptsFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final attempts = snapshot.requireData;
            final filtered = _filteredAttempts(attempts);

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                _RecordHallHeader(attempts: attempts),
                const SizedBox(height: 14),
                _FilterBar(
                  selected: _filter,
                  onChanged: (filter) => setState(() => _filter = filter),
                ),
                const SizedBox(height: 14),
                if (attempts.isEmpty)
                  const _EmptyRecordHall()
                else if (filtered.isEmpty)
                  const _NoFilteredRecords()
                else
                  for (final attempt in filtered) ...[
                    _SuPuCard(
                      attempt: attempt,
                      puzzle: _puzzleFor(attempt),
                      onReplay: () => _openReplay(attempt),
                      onFavorite: () => _toggleFavorite(attempt),
                      onCertificate: () => _openCertificate(attempt),
                      onNotes: () => _editNotes(attempt),
                      onDetails: () => _openDetail(attempt),
                      onDelete: () => _confirmDelete(attempt),
                    ),
                    const SizedBox(height: 10),
                  ],
              ],
            );
          },
        ),
      ),
    );
  }

  List<SudokuAttempt> _filteredAttempts(List<SudokuAttempt> attempts) {
    return attempts
        .where((attempt) {
          final puzzle = _puzzleFor(attempt);
          return switch (_filter) {
            _RecordHallFilter.all => true,
            _RecordHallFilter.favorites => attempt.replayFavorite,
            _RecordHallFilter.official =>
              attempt.scoreClass == SudokuScoreClass.official,
            _RecordHallFilter.clean => attempt.cleanSolve,
            _RecordHallFilter.extreme =>
              puzzle.difficulty.name == 'extreme' ||
                  puzzle.packId == 'extreme' ||
                  attempt.scoreClass == SudokuScoreClass.official &&
                      puzzle.difficulty.label == 'Extreme',
          };
        })
        .toList(growable: false);
  }

  FixturePuzzleDefinition _puzzleFor(SudokuAttempt attempt) {
    return widget.catalog.byId(attempt.puzzleId);
  }

  void _openReplay(SudokuAttempt attempt) {
    final puzzle = _puzzleFor(attempt);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            SudokuReplayScreen(givens: puzzle.givens, attempt: attempt),
      ),
    );
  }

  Future<void> _openDetail(SudokuAttempt attempt) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SuPuDetailScreen(
          repository: widget.repository,
          catalog: widget.catalog,
          puzzle: _puzzleFor(attempt),
          initialAttempt: attempt,
        ),
      ),
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _attemptsFuture = _loadAttempts();
    });
  }

  Future<void> _toggleFavorite(SudokuAttempt attempt) async {
    await widget.repository.toggleReplayFavorite(
      attempt.id,
      !attempt.replayFavorite,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _attemptsFuture = _loadAttempts();
    });
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
                              text: 'My Orbace Sudoku Su-Pu',
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
    final controller = TextEditingController(text: attempt.replayNotes ?? '');
    final notes = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ranking Notes · 谱评'),
          content: TextField(
            controller: controller,
            autofocus: true,
            minLines: 3,
            maxLines: 6,
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(
              hintText: 'Add notes about difficulty, technique, or ranking.',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Save Notes'),
            ),
          ],
        );
      },
    );
    controller.dispose();
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

  Future<void> _confirmDelete(SudokuAttempt attempt) async {
    final puzzle = _puzzleFor(attempt);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Su-Pu?'),
          content: Text(
            'Delete "${puzzle.title}" attempt ${attempt.attemptNumber} from Record Hall? '
            'This removes the saved replay, score, notes, and local ranking record for this attempt.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }
    await widget.repository.deleteAttempt(attempt.id);
    if (!mounted) {
      return;
    }
    setState(() {
      _attemptsFuture = _loadAttempts();
    });
    _showMessage('Deleted Su-Pu from Record Hall.');
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

class _RecordHallHeader extends StatelessWidget {
  const _RecordHallHeader({required this.attempts});

  final List<SudokuAttempt> attempts;

  @override
  Widget build(BuildContext context) {
    final cleanCount = attempts.where((attempt) => attempt.cleanSolve).length;
    final officialCount = attempts
        .where((attempt) => attempt.scoreClass == SudokuScoreClass.official)
        .length;
    final favoriteCount = attempts
        .where((attempt) => attempt.replayFavorite)
        .length;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: OrbaceTheme.ricePaper,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6DED0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                    '谱',
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
                        'Record Hall',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '藏谱阁 · Your Su-Pu collection',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: OrbaceTheme.mutedInk,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StatPill(label: 'Su-Pu', value: '${attempts.length}'),
                _StatPill(label: 'Official', value: '$officialCount'),
                _StatPill(label: 'Clean', value: '$cleanCount'),
                _StatPill(label: 'Favorites', value: '$favoriteCount'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onChanged});

  final _RecordHallFilter selected;
  final ValueChanged<_RecordHallFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in _RecordHallFilter.values) ...[
            ChoiceChip(
              label: Text(_filterLabel(filter)),
              selected: selected == filter,
              onSelected: (_) => onChanged(filter),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _SuPuCard extends StatelessWidget {
  const _SuPuCard({
    required this.attempt,
    required this.puzzle,
    required this.onReplay,
    required this.onFavorite,
    required this.onCertificate,
    required this.onNotes,
    required this.onDetails,
    required this.onDelete,
  });

  final SudokuAttempt attempt;
  final FixturePuzzleDefinition puzzle;
  final VoidCallback onReplay;
  final VoidCallback onFavorite;
  final VoidCallback onCertificate;
  final VoidCallback onNotes;
  final VoidCallback onDetails;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final score = attempt.score?.total ?? 0;
    final hintCount =
        attempt.hintNudgeCount +
        attempt.hintExplanationCount +
        attempt.hintRevealCount;
    final rating = attempt.playerDifficultyRating;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onDetails,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                        Text(
                          puzzle.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${puzzle.difficulty.label} · Attempt ${attempt.attemptNumber}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: OrbaceTheme.mutedInk),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: attempt.replayFavorite
                        ? 'Remove favorite'
                        : 'Favorite',
                    onPressed: onFavorite,
                    icon: Icon(
                      attempt.replayFavorite ? Icons.star : Icons.star_border,
                      color: attempt.replayFavorite
                          ? OrbaceTheme.vermilion
                          : OrbaceTheme.mutedInk,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Badge(
                    label:
                        '${attempt.scoreClass.label} · ${_scoreClassChinese(attempt.scoreClass)}',
                  ),
                  if (attempt.cleanSolve) const _Badge(label: 'Clean · 净谱'),
                  if (rating != null)
                    _Badge(label: 'Rated ${rating.toStringAsFixed(1)}'),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Score $score · ${_formatTime(attempt.elapsedSeconds)} · '
                '${attempt.errorCount} mistakes · $hintCount hints',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(attempt.completedAt ?? attempt.startedAt),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: OrbaceTheme.mutedInk),
              ),
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
                    onPressed: onDetails,
                    icon: const Icon(Icons.manage_search),
                    label: const Text('Details'),
                  ),
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
                  OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
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
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: OrbaceTheme.paper,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE6DED0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text('$value $label'),
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

class _EmptyRecordHall extends StatelessWidget {
  const _EmptyRecordHall();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Text('Your Record Hall begins with your first completed Su-Pu.'),
      ),
    );
  }
}

class _NoFilteredRecords extends StatelessWidget {
  const _NoFilteredRecords();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Text('No Su-Pu match this filter yet.'),
      ),
    );
  }
}

String _filterLabel(_RecordHallFilter filter) {
  return switch (filter) {
    _RecordHallFilter.all => 'All',
    _RecordHallFilter.favorites => 'Favorites',
    _RecordHallFilter.official => 'Official',
    _RecordHallFilter.clean => 'Clean',
    _RecordHallFilter.extreme => 'Extreme',
  };
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

String _formatDate(DateTime date) {
  return '${date.month}/${date.day}/${date.year} '
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
}
