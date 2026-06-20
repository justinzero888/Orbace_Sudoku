import 'package:flutter/material.dart';

import '../../../app/orbace_theme.dart';
import '../data/app_database.dart';
import '../data/sudoku_repository.dart';
import '../domain/sudoku_award.dart';
import '../engine/award_engine.dart';

class ScholarPathScreen extends StatefulWidget {
  const ScholarPathScreen({super.key, this.repository});

  final SudokuRepository? repository;

  @override
  State<ScholarPathScreen> createState() => _ScholarPathScreenState();
}

class _ScholarPathScreenState extends State<ScholarPathScreen> {
  late final AppDatabase _database;
  late final SudokuRepository _repository;
  late final Future<AwardSummary> _summaryFuture;

  @override
  void initState() {
    super.initState();
    if (widget.repository case final repository?) {
      _repository = repository;
    } else {
      _database = AppDatabase();
      _repository = SudokuRepository(_database);
    }
    _summaryFuture = _loadSummary();
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
      appBar: AppBar(title: const Text('Scholar\'s Path')),
      body: SafeArea(
        child: FutureBuilder<AwardSummary>(
          future: _summaryFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final summary = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              children: [
                _SummaryCard(summary: summary),
                const SizedBox(height: 12),
                for (final stage in summary.stages) ...[
                  _StageCard(stage: stage),
                  const SizedBox(height: 12),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Future<AwardSummary> _loadSummary() async {
    final attempts = await _repository.allAttempts();
    return const AwardEngine().evaluate(attempts);
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});

  final AwardSummary summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('學者之路', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Completed puzzles: ${summary.totalCompleted}'),
            Text('Clean solves: ${summary.cleanSolves}'),
            Text('Replay improvements: ${summary.replayImprovements}'),
            const SizedBox(height: 8),
            Text(
              summary.extremeUnlocked
                  ? 'Extreme Challenge unlocked'
                  : 'Extreme Challenge remains locked',
              style: TextStyle(
                color: summary.extremeUnlocked
                    ? const Color(0xFF385D4A)
                    : OrbaceTheme.mutedInk,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StageCard extends StatelessWidget {
  const _StageCard({required this.stage});

  final ScholarPathStage stage;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: stage.isComplete
                        ? OrbaceTheme.vermilion
                        : OrbaceTheme.celadon,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${stage.stageNumber}',
                    style: const TextStyle(
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
                        '${stage.name} (${stage.chineseName})',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(stage.unlocksDescription),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: stage.progressPercent),
            const SizedBox(height: 12),
            for (final requirement in stage.requirements)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      requirement.complete
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: requirement.complete
                          ? const Color(0xFF385D4A)
                          : OrbaceTheme.mutedInk,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(requirement.label)),
                    Text('${requirement.current}/${requirement.target}'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
