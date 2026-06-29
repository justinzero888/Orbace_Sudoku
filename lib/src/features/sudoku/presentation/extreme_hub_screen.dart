import 'package:flutter/material.dart';

import '../../../app/ad_mob_bottom_banner.dart';
import '../../../app/orbace_theme.dart';
import '../data/app_database.dart';
import '../data/sudoku_repository.dart';
import '../domain/extreme_challenge.dart';
import '../engine/award_engine.dart';

class ExtremeHubScreen extends StatefulWidget {
  const ExtremeHubScreen({super.key, this.repository});

  final SudokuRepository? repository;

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
                _ChallengeCard(unlocked: state.unlocked),
                const SizedBox(height: 12),
                _LocalBestsCard(state: state),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<_ExtremeHubState> _loadState() async {
    final attempts = await _repository.allAttempts();
    final summary = const AwardEngine().evaluate(attempts);
    final ranked = await _repository.rankedAttempts();
    return _ExtremeHubState(
      unlocked: summary.extremeUnlocked,
      rankedAttemptCount: ranked.length,
      bestScore: ranked.isEmpty ? null : ranked.first.score?.total,
    );
  }
}

class _ExtremeHubState {
  const _ExtremeHubState({
    required this.unlocked,
    required this.rankedAttemptCount,
    required this.bestScore,
  });

  final bool unlocked;
  final int rankedAttemptCount;
  final int? bestScore;
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
                    ? 'Extreme is unlocked for local no-assist challenges.'
                    : 'Complete Scholar\'s Path Stage 3: Insight to unlock Extreme.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({required this.unlocked});

  final bool unlocked;

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
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: unlocked ? () {} : null,
              icon: const Icon(Icons.bolt),
              label: Text(unlocked ? 'Start Local Extreme' : 'Locked'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocalBestsCard extends StatelessWidget {
  const _LocalBestsCard({required this.state});

  final _ExtremeHubState state;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Local Bests', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Ranked attempts: ${state.rankedAttemptCount}'),
            Text('Best score: ${state.bestScore ?? 'No ranked score yet'}'),
          ],
        ),
      ),
    );
  }
}
