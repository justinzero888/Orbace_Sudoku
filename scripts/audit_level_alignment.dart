import 'dart:convert';
import 'dart:io';

import 'package:orbace_sudoku/src/features/sudoku/domain/sudoku_difficulty.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/human_ranked_solver.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_difficulty_rater.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_solver.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/fixture_puzzles.dart';

const String _auditDate = '2026-07-02';

void main() {
  final packs = _loadManifestPacks();
  if (!packs.any((pack) => pack.id == 'true_extreme')) {
    final trueExtreme = _loadStandalonePack(
      id: 'true_extreme',
      title: 'True Extreme',
      difficultyBand: 'extreme',
      assetPath: 'assets/puzzles/true_extreme/true_extreme_01.json',
    );
    packs.add(trueExtreme);
  }

  final report = _auditPacks(packs);
  final outputDir = Directory('Docs/exports')..createSync(recursive: true);
  File(
    '${outputDir.path}/all_level_alignment_audit_$_auditDate.md',
  ).writeAsStringSync(_markdown(report));
  File(
    '${outputDir.path}/all_level_alignment_audit_$_auditDate.csv',
  ).writeAsStringSync(_csv(report.rows));
  File(
    '${outputDir.path}/all_level_alignment_summary_$_auditDate.json',
  ).writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(report.toJson())}\n',
  );

  stdout.writeln('Audited ${report.totalPuzzles} puzzles.');
  for (final pack in report.packs) {
    stdout.writeln(
      '${pack.id}: ${pack.count} puzzles, stored=${pack.storedDifficultyCounts}, '
      'rerated=${pack.reratedDifficultyCounts}, integrityFailures=${pack.integrityFailures.length}',
    );
  }
  stdout.writeln('Wrote Docs/exports/all_level_alignment_audit_$_auditDate.md');
  stdout.writeln(
    'Wrote Docs/exports/all_level_alignment_audit_$_auditDate.csv',
  );
}

List<_PackInput> _loadManifestPacks() {
  final manifest =
      jsonDecode(File('assets/puzzles/packs.json').readAsStringSync())
          as Map<String, Object?>;
  final packItems = (manifest['packs']! as List<Object?>)
      .cast<Map<String, Object?>>();
  final packs = <_PackInput>[];
  for (final pack in packItems) {
    final packId = pack['id']! as String;
    final assets = (pack['assets']! as List<Object?>).cast<String>();
    final puzzles = <FixturePuzzleDefinition>[];
    for (final asset in assets) {
      final payload =
          jsonDecode(File(asset).readAsStringSync()) as Map<String, Object?>;
      puzzles.addAll(
        (payload['puzzles']! as List<Object?>).cast<Map<String, Object?>>().map(
          (json) => FixturePuzzleDefinition.fromJson(json, packId: packId),
        ),
      );
    }
    packs.add(
      _PackInput(
        id: packId,
        title: pack['title']! as String,
        difficultyBand: pack['difficultyBand']! as String,
        assets: assets,
        puzzles: puzzles,
        expectsHumanSolver: packId != 'true_extreme',
      ),
    );
  }
  return packs;
}

_PackInput _loadStandalonePack({
  required String id,
  required String title,
  required String difficultyBand,
  required String assetPath,
}) {
  final payload =
      jsonDecode(File(assetPath).readAsStringSync()) as Map<String, Object?>;
  return _PackInput(
    id: id,
    title: title,
    difficultyBand: difficultyBand,
    assets: <String>[assetPath],
    puzzles: (payload['puzzles']! as List<Object?>)
        .cast<Map<String, Object?>>()
        .map((json) => FixturePuzzleDefinition.fromJson(json, packId: id))
        .toList(),
    expectsHumanSolver: false,
  );
}

_AuditReport _auditPacks(List<_PackInput> inputs) {
  final solver = SudokuSolver();
  final humanSolver = HumanRankedSolver();
  const rater = SudokuDifficultyRater();
  final packReports = <_PackReport>[];
  final rows = <_PuzzleAuditRow>[];

  for (final input in inputs) {
    final packRows = <_PuzzleAuditRow>[];
    final integrityFailures = <String>[];
    for (final puzzle in input.puzzles) {
      final solutionCount = solver.countSolutions(puzzle.givens, limit: 2);
      final solved = solver.solve(puzzle.givens);
      final storedSolutionMatches =
          solved?.cells.toString() == puzzle.solution.cells.toString();
      final humanResult = humanSolver.solve(puzzle.givens);
      final rating = humanResult.solved ? rater.rate(humanResult.steps) : null;
      final reratedDifficulty = rating?.difficulty.name ?? 'beyond_hint_solver';
      final reratedScore = rating?.score;
      final clueCount = puzzle.clueCount;

      if (solutionCount != 1) {
        integrityFailures.add('${puzzle.id}: solutionCount=$solutionCount');
      }
      if (!storedSolutionMatches) {
        integrityFailures.add('${puzzle.id}: stored solution mismatch');
      }
      if (input.expectsHumanSolver && !humanResult.solved) {
        integrityFailures.add('${puzzle.id}: human solver did not solve');
      }
      if (!input.expectsHumanSolver && humanResult.solved) {
        integrityFailures.add(
          '${puzzle.id}: true extreme solved by hint solver',
        );
      }
      if (!input.expectsHumanSolver && clueCount > 24) {
        integrityFailures.add(
          '${puzzle.id}: true extreme has $clueCount clues',
        );
      }

      final row = _PuzzleAuditRow(
        packId: input.id,
        packTitle: input.title,
        expectedBand: input.difficultyBand,
        id: puzzle.id,
        storedDifficulty: puzzle.difficulty.name,
        storedScore: puzzle.difficultyScore,
        reratedDifficulty: reratedDifficulty,
        reratedScore: reratedScore,
        clueCount: clueCount,
        humanSolved: humanResult.solved,
        solutionCount: solutionCount,
        requiredTechniques: puzzle.requiredTechniques,
        aligned: _isAligned(input, puzzle, reratedDifficulty, reratedScore),
      );
      packRows.add(row);
      rows.add(row);
    }

    packReports.add(_PackReport.fromRows(input, packRows, integrityFailures));
  }

  return _AuditReport(packs: packReports, rows: rows);
}

bool _isAligned(
  _PackInput input,
  FixturePuzzleDefinition puzzle,
  String reratedDifficulty,
  int? reratedScore,
) {
  if (!input.expectsHumanSolver) {
    return puzzle.difficulty == SudokuDifficulty.extreme &&
        reratedDifficulty == 'beyond_hint_solver' &&
        puzzle.clueCount <= 24 &&
        puzzle.difficultyScore >= 900;
  }
  return puzzle.difficulty.name == reratedDifficulty;
}

String _markdown(_AuditReport report) {
  final buffer = StringBuffer()
    ..writeln('# Orbace Sudoku Level Alignment Audit')
    ..writeln()
    ..writeln('Date: $_auditDate')
    ..writeln()
    ..writeln('## Executive Summary')
    ..writeln()
    ..writeln('- Total current puzzle assets audited: ${report.totalPuzzles}.')
    ..writeln('- Manifest/catalog puzzles: ${report.manifestPuzzleCount}.')
    ..writeln('- Standalone true extreme puzzles: ${report.trueExtremeCount}.')
    ..writeln('- Sudoku integrity failures: ${report.integrityFailureCount}.')
    ..writeln(
      '- Teaching-pack exact level alignment: ${report.teachingAlignedCount}/${report.teachingPuzzleCount}.',
    )
    ..writeln(
      '- True-extreme alignment: ${report.trueExtremeAlignedCount}/${report.trueExtremeCount}.',
    )
    ..writeln()
    ..writeln('## Pack Summary')
    ..writeln()
    ..writeln(
      '| Pack | Expected Band | Count | Stored Difficulty Counts | Re-rated Counts | Score Range | Clue Range | Aligned | Integrity Failures |',
    )
    ..writeln('| --- | --- | ---: | --- | --- | --- | --- | ---: | ---: |');

  for (final pack in report.packs) {
    buffer.writeln(
      '| ${pack.title} (`${pack.id}`) | ${pack.difficultyBand} | '
      '${pack.count} | ${_formatMap(pack.storedDifficultyCounts)} | '
      '${_formatMap(pack.reratedDifficultyCounts)} | ${pack.scoreRange} | '
      '${pack.clueRange} | ${pack.alignedCount}/${pack.count} | '
      '${pack.integrityFailures.length} |',
    );
  }

  buffer
    ..writeln()
    ..writeln('## Interpretation')
    ..writeln()
    ..writeln(
      '- The original 1,800 manifest puzzles remain valid Sudoku content, but their stored difficulty bands are frequently inflated versus the current app rater.',
    )
    ..writeln(
      '- The new `true_extreme` pack is not in `assets/puzzles/packs.json` yet, but it brings the total current generated game assets to 1,900.',
    )
    ..writeln(
      '- `true_extreme` aligns with a no-hint extreme standard: stored as Extreme, 20-24 clues, unique solution, and not solvable by the current teaching hint solver.',
    )
    ..writeln()
    ..writeln('## Required Product Decisions')
    ..writeln()
    ..writeln(
      '1. Decide whether Level Packs should display stored/generated bands or current-rater bands.',
    )
    ..writeln(
      '2. Add a dedicated no-hint/extreme validator before wiring `true_extreme` into the app manifest.',
    )
    ..writeln(
      '3. Update generation scripts so stored `difficulty` and `difficultyScore` are never artificially raised above the actual audit result for teaching packs.',
    );

  final failures = report.packs
      .where((pack) => pack.integrityFailures.isNotEmpty)
      .expand(
        (pack) =>
            pack.integrityFailures.map((failure) => '- ${pack.id}: $failure'),
      )
      .toList();
  if (failures.isNotEmpty) {
    buffer
      ..writeln()
      ..writeln('## Integrity Failures')
      ..writeln()
      ..writeln(failures.join('\n'));
  }

  return buffer.toString();
}

String _csv(List<_PuzzleAuditRow> rows) {
  final buffer = StringBuffer()
    ..writeln(
      'pack_id,pack_title,expected_band,puzzle_id,stored_difficulty,stored_score,rerated_difficulty,rerated_score,clues,human_solved,solution_count,aligned,required_techniques',
    );
  for (final row in rows) {
    buffer.writeln(
      [
        row.packId,
        row.packTitle,
        row.expectedBand,
        row.id,
        row.storedDifficulty,
        row.storedScore,
        row.reratedDifficulty,
        row.reratedScore ?? '',
        row.clueCount,
        row.humanSolved,
        row.solutionCount,
        row.aligned,
        row.requiredTechniques.join('|'),
      ].map(_csvCell).join(','),
    );
  }
  return buffer.toString();
}

String _csvCell(Object? value) {
  final text = value.toString();
  if (!text.contains(',') && !text.contains('"') && !text.contains('\n')) {
    return text;
  }
  return '"${text.replaceAll('"', '""')}"';
}

String _formatMap(Map<String, int> values) {
  if (values.isEmpty) {
    return '-';
  }
  return values.entries
      .map((entry) => '${entry.key}: ${entry.value}')
      .join(', ');
}

class _PackInput {
  const _PackInput({
    required this.id,
    required this.title,
    required this.difficultyBand,
    required this.assets,
    required this.puzzles,
    required this.expectsHumanSolver,
  });

  final String id;
  final String title;
  final String difficultyBand;
  final List<String> assets;
  final List<FixturePuzzleDefinition> puzzles;
  final bool expectsHumanSolver;
}

class _PackReport {
  _PackReport.fromRows(
    _PackInput input,
    List<_PuzzleAuditRow> rows,
    this.integrityFailures,
  ) : id = input.id,
      title = input.title,
      difficultyBand = input.difficultyBand,
      count = rows.length,
      alignedCount = rows.where((row) => row.aligned).length,
      storedDifficultyCounts = _counts(rows.map((row) => row.storedDifficulty)),
      reratedDifficultyCounts = _counts(
        rows.map((row) => row.reratedDifficulty),
      ),
      scoreRange = _range(rows.map((row) => row.storedScore)),
      clueRange = _range(rows.map((row) => row.clueCount));

  final String id;
  final String title;
  final String difficultyBand;
  final int count;
  final int alignedCount;
  final Map<String, int> storedDifficultyCounts;
  final Map<String, int> reratedDifficultyCounts;
  final String scoreRange;
  final String clueRange;
  final List<String> integrityFailures;
}

class _PuzzleAuditRow {
  const _PuzzleAuditRow({
    required this.packId,
    required this.packTitle,
    required this.expectedBand,
    required this.id,
    required this.storedDifficulty,
    required this.storedScore,
    required this.reratedDifficulty,
    required this.reratedScore,
    required this.clueCount,
    required this.humanSolved,
    required this.solutionCount,
    required this.requiredTechniques,
    required this.aligned,
  });

  final String packId;
  final String packTitle;
  final String expectedBand;
  final String id;
  final String storedDifficulty;
  final int storedScore;
  final String reratedDifficulty;
  final int? reratedScore;
  final int clueCount;
  final bool humanSolved;
  final int solutionCount;
  final List<String> requiredTechniques;
  final bool aligned;
}

class _AuditReport {
  const _AuditReport({required this.packs, required this.rows});

  final List<_PackReport> packs;
  final List<_PuzzleAuditRow> rows;

  int get totalPuzzles => rows.length;
  int get trueExtremeCount => packs
      .where((pack) => pack.id == 'true_extreme')
      .fold(0, (sum, pack) => sum + pack.count);
  int get manifestPuzzleCount => totalPuzzles - trueExtremeCount;
  int get integrityFailureCount =>
      packs.fold(0, (sum, pack) => sum + pack.integrityFailures.length);
  int get teachingPuzzleCount =>
      rows.where((row) => row.packId != 'true_extreme').length;
  int get teachingAlignedCount =>
      rows.where((row) => row.packId != 'true_extreme' && row.aligned).length;
  int get trueExtremeAlignedCount =>
      rows.where((row) => row.packId == 'true_extreme' && row.aligned).length;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'date': _auditDate,
      'totalPuzzles': totalPuzzles,
      'manifestPuzzleCount': manifestPuzzleCount,
      'trueExtremeCount': trueExtremeCount,
      'integrityFailureCount': integrityFailureCount,
      'teachingAlignedCount': teachingAlignedCount,
      'teachingPuzzleCount': teachingPuzzleCount,
      'trueExtremeAlignedCount': trueExtremeAlignedCount,
      'packs': [
        for (final pack in packs)
          <String, Object?>{
            'id': pack.id,
            'title': pack.title,
            'difficultyBand': pack.difficultyBand,
            'count': pack.count,
            'alignedCount': pack.alignedCount,
            'storedDifficultyCounts': pack.storedDifficultyCounts,
            'reratedDifficultyCounts': pack.reratedDifficultyCounts,
            'scoreRange': pack.scoreRange,
            'clueRange': pack.clueRange,
            'integrityFailureCount': pack.integrityFailures.length,
          },
      ],
    };
  }
}

Map<String, int> _counts(Iterable<String> values) {
  final counts = <String, int>{};
  for (final value in values) {
    counts.update(value, (count) => count + 1, ifAbsent: () => 1);
  }
  return counts;
}

String _range(Iterable<int> values) {
  final list = values.toList();
  if (list.isEmpty) {
    return '-';
  }
  list.sort();
  return '${list.first}-${list.last}';
}
