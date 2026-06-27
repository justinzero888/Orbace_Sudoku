import 'package:flutter/material.dart';

import '../../../app/orbace_theme.dart';
import '../domain/sudoku_attempt.dart';
import '../engine/su_pu_compare_engine.dart';
import 'fixture_puzzles.dart';

class SuPuCompareScreen extends StatefulWidget {
  const SuPuCompareScreen({
    super.key,
    required this.puzzle,
    required this.attempts,
    required this.initialPrimary,
    required this.initialBaseline,
  });

  final FixturePuzzleDefinition puzzle;
  final List<SudokuAttempt> attempts;
  final SudokuAttempt initialPrimary;
  final SudokuAttempt initialBaseline;

  @override
  State<SuPuCompareScreen> createState() => _SuPuCompareScreenState();
}

class _SuPuCompareScreenState extends State<SuPuCompareScreen> {
  final SuPuCompareEngine _engine = const SuPuCompareEngine();
  late String _primaryId = widget.initialPrimary.id;
  late String _baselineId = widget.initialBaseline.id;

  @override
  Widget build(BuildContext context) {
    final attempts = widget.attempts
        .where((attempt) => attempt.puzzleId == widget.puzzle.id)
        .toList(growable: false);
    final primary = _attemptById(attempts, _primaryId) ?? attempts.first;
    final baseline =
        _attemptById(attempts, _baselineId) ??
        attempts.firstWhere(
          (attempt) => attempt.id != primary.id,
          orElse: () => primary,
        );
    final comparison = _engine.compare(primary: primary, baseline: baseline);

    return Scaffold(
      appBar: AppBar(title: const Text('Compare Su-Pu · 对谱')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _CompareHeader(puzzle: widget.puzzle, attempts: attempts),
            const SizedBox(height: 12),
            _AttemptPicker(
              title: 'Current Su-Pu',
              value: primary.id,
              attempts: attempts,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _primaryId = value;
                  if (_baselineId == value) {
                    _baselineId = attempts
                        .firstWhere((attempt) => attempt.id != value)
                        .id;
                  }
                });
              },
            ),
            const SizedBox(height: 10),
            _AttemptPicker(
              title: 'Compare Against',
              value: baseline.id,
              attempts: attempts
                  .where((attempt) => attempt.id != primary.id)
                  .toList(growable: false),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() => _baselineId = value);
              },
            ),
            const SizedBox(height: 14),
            _CompareSummary(comparison: comparison),
            const SizedBox(height: 14),
            _CompareTable(comparison: comparison),
            const SizedBox(height: 14),
            _CompareNote(primary: primary, baseline: baseline),
          ],
        ),
      ),
    );
  }

  SudokuAttempt? _attemptById(List<SudokuAttempt> attempts, String id) {
    for (final attempt in attempts) {
      if (attempt.id == id) {
        return attempt;
      }
    }
    return null;
  }
}

class _CompareHeader extends StatelessWidget {
  const _CompareHeader({required this.puzzle, required this.attempts});

  final FixturePuzzleDefinition puzzle;
  final List<SudokuAttempt> attempts;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: OrbaceTheme.ricePaper,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6DED0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
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
                puzzle.seal,
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
                    puzzle.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${attempts.length} completed Su-Pu · same puzzle only',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: OrbaceTheme.mutedInk,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttemptPicker extends StatelessWidget {
  const _AttemptPicker({
    required this.title,
    required this.value,
    required this.attempts,
    required this.onChanged,
  });

  final String title;
  final String value;
  final List<SudokuAttempt> attempts;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: OrbaceTheme.paper,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6DED0)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            items: [
              for (final attempt in attempts)
                DropdownMenuItem<String>(
                  value: attempt.id,
                  child: Text(
                    '$title: Attempt ${attempt.attemptNumber} · '
                    'Score ${attempt.score?.total ?? 0} · '
                    '${_formatTime(attempt.elapsedSeconds)}',
                  ),
                ),
            ],
            onChanged: attempts.length <= 1 ? null : onChanged,
          ),
        ),
      ),
    );
  }
}

class _CompareSummary extends StatelessWidget {
  const _CompareSummary({required this.comparison});

  final SuPuComparison comparison;

  @override
  Widget build(BuildContext context) {
    final scoreDelta = comparison.rows.firstWhere(
      (row) => row.label == 'Score',
    );
    final timeDelta = comparison.rows.firstWhere((row) => row.label == 'Time');
    final primary = comparison.primary;
    final baseline = comparison.baseline;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD2C6B4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('对谱 Summary', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SummaryPill(
                  label: 'Score delta',
                  value: scoreDelta.delta,
                  improved: scoreDelta.improved,
                ),
                _SummaryPill(
                  label: 'Time delta',
                  value: timeDelta.delta,
                  improved: timeDelta.improved,
                ),
                _SummaryPill(
                  label: 'Current',
                  value: 'Attempt ${primary.attemptNumber}',
                ),
                _SummaryPill(
                  label: 'Against',
                  value: 'Attempt ${baseline.attemptNumber}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CompareTable extends StatelessWidget {
  const _CompareTable({required this.comparison});

  final SuPuComparison comparison;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: OrbaceTheme.paper,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6DED0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Comparison Table',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            for (final row in comparison.rows) ...[
              _CompareRow(row: row),
              if (row != comparison.rows.last) const Divider(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _CompareRow extends StatelessWidget {
  const _CompareRow({required this.row});

  final SuPuComparisonRow row;

  @override
  Widget build(BuildContext context) {
    final deltaColor = switch (row.improved) {
      true => OrbaceTheme.celadon,
      false => OrbaceTheme.vermilion,
      null => OrbaceTheme.ink,
    };
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            row.label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(child: Text(row.primaryValue, textAlign: TextAlign.right)),
        const SizedBox(width: 10),
        Expanded(child: Text(row.baselineValue, textAlign: TextAlign.right)),
        const SizedBox(width: 10),
        SizedBox(
          width: 62,
          child: Text(
            row.delta,
            textAlign: TextAlign.right,
            style: TextStyle(color: deltaColor, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class _CompareNote extends StatelessWidget {
  const _CompareNote({required this.primary, required this.baseline});

  final SudokuAttempt primary;
  final SudokuAttempt baseline;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: OrbaceTheme.ricePaper,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6DED0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          'Compare uses completed records for this same puzzle only. '
          'Score class is preserved: ${primary.scoreClass.label} vs ${baseline.scoreClass.label}. '
          'Side-by-side synchronized replay is intentionally deferred until this table is validated in UAT.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: OrbaceTheme.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({required this.label, required this.value, this.improved});

  final String label;
  final String value;
  final bool? improved;

  @override
  Widget build(BuildContext context) {
    final color = switch (improved) {
      true => OrbaceTheme.celadon,
      false => OrbaceTheme.vermilion,
      null => OrbaceTheme.ink,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatTime(int seconds) {
  final minutes = seconds ~/ 60;
  final remaining = seconds % 60;
  return '$minutes:${remaining.toString().padLeft(2, '0')}';
}
