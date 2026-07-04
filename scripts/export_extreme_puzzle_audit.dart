import 'dart:convert';
import 'dart:io';

import 'package:orbace_sudoku/src/features/sudoku/engine/human_ranked_solver.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_difficulty_rater.dart';
import 'package:orbace_sudoku/src/features/sudoku/engine/sudoku_solver.dart';
import 'package:orbace_sudoku/src/features/sudoku/presentation/fixture_puzzles.dart';

void main(List<String> args) {
  final packId = args.isEmpty ? 'extreme' : args[0];
  final outputSlug = args.length >= 2 ? args[1] : packId;
  final manifestFile = File('assets/puzzles/packs.json');
  if (!manifestFile.existsSync()) {
    stderr.writeln('Missing assets/puzzles/packs.json');
    exit(1);
  }

  final manifest =
      jsonDecode(manifestFile.readAsStringSync()) as Map<String, Object?>;
  final pack = (manifest['packs']! as List<Object?>)
      .cast<Map<String, Object?>>()
      .firstWhere((pack) => pack['id'] == packId);
  final assetPaths = (pack['assets']! as List<Object?>).cast<String>();

  final solver = SudokuSolver();
  final humanSolver = HumanRankedSolver();
  const rater = SudokuDifficultyRater();
  final rows = <_ExtremeAuditRow>[];
  final integrityFailures = <String>[];
  final classificationMismatches = <String>[];

  for (final assetPath in assetPaths) {
    final payload =
        jsonDecode(File(assetPath).readAsStringSync()) as Map<String, Object?>;
    final puzzles = (payload['puzzles']! as List<Object?>)
        .cast<Map<String, Object?>>()
        .map((json) => FixturePuzzleDefinition.fromJson(json, packId: packId));

    for (final puzzle in puzzles) {
      final solutionCount = solver.countSolutions(puzzle.givens, limit: 2);
      final solved = solver.solve(puzzle.givens);
      final humanResult = humanSolver.solve(puzzle.givens);
      final rating = rater.rate(humanResult.steps);
      final techniqueCounts = <String, int>{};
      for (final step in humanResult.steps) {
        techniqueCounts.update(
          step.techniqueId,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }

      if (solutionCount != 1) {
        integrityFailures.add(
          '${puzzle.id}: expected one solution, got $solutionCount',
        );
      }
      if (solved?.cells.toString() != puzzle.solution.cells.toString()) {
        integrityFailures.add('${puzzle.id}: stored solution mismatch');
      }
      if (!humanResult.solved) {
        integrityFailures.add(
          '${puzzle.id}: human-ranked solver could not solve',
        );
      }
      if (rating.difficulty != puzzle.difficulty) {
        classificationMismatches.add(
          '${puzzle.id}: stored difficulty ${puzzle.difficulty.name} '
          'does not match re-rated ${rating.difficulty.name}',
        );
      }
      if (rating.score != puzzle.difficultyScore) {
        classificationMismatches.add(
          '${puzzle.id}: stored score ${puzzle.difficultyScore} '
          'does not match re-rated ${rating.score}',
        );
      }

      rows.add(
        _ExtremeAuditRow(
          id: puzzle.id,
          title: puzzle.title,
          assetPath: assetPath,
          givenString: puzzle.givensRows.join(),
          solutionString: puzzle.solutionRows.join(),
          clueCount: puzzle.clueCount,
          storedDifficulty: puzzle.difficulty.name,
          storedScore: puzzle.difficultyScore,
          reratedDifficulty: rating.difficulty.name,
          reratedScore: rating.score,
          humanSolved: humanResult.solved,
          solutionCount: solutionCount,
          stepCount: humanResult.steps.length,
          requiredTechniques: puzzle.requiredTechniques,
          techniqueCounts: techniqueCounts,
          rankedEligible: puzzle.rankedEligible,
          reason: _reasonFor(
            puzzle.requiredTechniques,
            rating.difficulty.name,
            rating.score,
          ),
        ),
      );
    }
  }

  rows.sort((a, b) {
    final scoreCompare = b.reratedScore.compareTo(a.reratedScore);
    if (scoreCompare != 0) {
      return scoreCompare;
    }
    return a.id.compareTo(b.id);
  });

  final reportDir = Directory('Docs/exports')..createSync(recursive: true);
  final csvFile = File(
    '${reportDir.path}/${outputSlug}_puzzle_audit_2026-07-02.csv',
  );
  final mdFile = File(
    '${reportDir.path}/${outputSlug}_puzzle_audit_2026-07-02.md',
  );

  csvFile.writeAsStringSync(_csv(rows));
  mdFile.writeAsStringSync(
    _markdown(
      rows,
      integrityFailures,
      classificationMismatches,
      pack,
      assetPaths,
    ),
  );

  stdout.writeln('Audited ${rows.length} ${pack['title']} puzzles.');
  stdout.writeln('Wrote ${csvFile.path}');
  stdout.writeln('Wrote ${mdFile.path}');
  stdout.writeln('${integrityFailures.length} integrity failures.');
  stdout.writeln(
    '${classificationMismatches.length} classification mismatches.',
  );
  stdout.writeln(_summary(rows));

  if (integrityFailures.isNotEmpty) {
    stderr.writeln(integrityFailures.join('\n'));
    exit(1);
  }
}

String _reasonFor(
  List<String> techniques,
  String reratedDifficulty,
  int reratedScore,
) {
  final advanced = techniques
      .where(
        (technique) =>
            technique == 'naked_pair' ||
            technique == 'hidden_pair' ||
            technique == 'pointing_pair',
      )
      .toList();
  if (reratedScore > 240) {
    return 'Re-rated above Expert threshold by current solver score.';
  }
  if (advanced.isEmpty) {
    return 'Only single techniques are recorded by the current human solver.';
  }
  return 'Requires ${advanced.join(', ')}; current rater classifies the puzzle '
      'as $reratedDifficulty with score $reratedScore.';
}

String _summary(List<_ExtremeAuditRow> rows) {
  final byDifficulty = <String, int>{};
  var minScore = rows.first.reratedScore;
  var maxScore = rows.first.reratedScore;
  var totalScore = 0;
  var advancedCount = 0;
  for (final row in rows) {
    byDifficulty.update(
      row.reratedDifficulty,
      (count) => count + 1,
      ifAbsent: () => 1,
    );
    minScore = row.reratedScore < minScore ? row.reratedScore : minScore;
    maxScore = row.reratedScore > maxScore ? row.reratedScore : maxScore;
    totalScore += row.reratedScore;
    if (row.requiredTechniques.any(
      (technique) =>
          technique == 'naked_pair' ||
          technique == 'hidden_pair' ||
          technique == 'pointing_pair',
    )) {
      advancedCount++;
    }
  }
  final average = totalScore / rows.length;
  return 'Re-rated difficulty counts: $byDifficulty; score range: '
      '$minScore-$maxScore; average score: ${average.toStringAsFixed(1)}; '
      'advanced-technique puzzles: $advancedCount/${rows.length}.';
}

String _csv(List<_ExtremeAuditRow> rows) {
  final buffer = StringBuffer()
    ..writeln(
      [
        'id',
        'title',
        'asset',
        'givens_81',
        'solution_81',
        'clues',
        'stored_difficulty',
        'stored_score',
        'rerated_difficulty',
        'rerated_score',
        'human_solved',
        'solution_count',
        'step_count',
        'required_techniques',
        'technique_counts',
        'ranked_eligible',
        'audit_reason',
      ].join(','),
    );
  for (final row in rows) {
    buffer.writeln(
      [
        row.id,
        row.title,
        row.assetPath,
        row.givenString,
        row.solutionString,
        row.clueCount,
        row.storedDifficulty,
        row.storedScore,
        row.reratedDifficulty,
        row.reratedScore,
        row.humanSolved,
        row.solutionCount,
        row.stepCount,
        row.requiredTechniques.join('|'),
        row.techniqueCounts.entries
            .map((entry) => '${entry.key}:${entry.value}')
            .join('|'),
        row.rankedEligible,
        row.reason,
      ].map(_csvCell).join(','),
    );
  }
  return buffer.toString();
}

String _markdown(
  List<_ExtremeAuditRow> rows,
  List<String> integrityFailures,
  List<String> classificationMismatches,
  Map<String, Object?> pack,
  List<String> assetPaths,
) {
  final title = pack['title']! as String;
  final buffer = StringBuffer()
    ..writeln('# $title Puzzle Audit')
    ..writeln()
    ..writeln('Date: 2026-07-02')
    ..writeln()
    ..writeln('## Source')
    ..writeln()
    ..writeln('- Manifest pack id: `${pack['id']}`')
    ..writeln('- Manifest title: `$title`')
    ..writeln('- Manifest difficultyBand: `${pack['difficultyBand']}`')
    ..writeln('- Assets:')
    ..writeln(assetPaths.map((path) => '  - `$path`').join('\n'))
    ..writeln()
    ..writeln('## Summary')
    ..writeln()
    ..writeln('- ${_summary(rows)}')
    ..writeln('- Integrity failures: ${integrityFailures.length}')
    ..writeln(
      '- Difficulty classification mismatches: ${classificationMismatches.length}',
    )
    ..writeln(
      '- Current app logic does not produce `SudokuDifficulty.extreme`; '
      'the difficulty rater only maps scores above 240 to `expert`.',
    )
    ..writeln()
    ..writeln('## Puzzles')
    ..writeln()
    ..writeln(
      '| ID | Clues | Stored | Re-rated | Score | Steps | Techniques | 81-cell givens | Audit reason |',
    )
    ..writeln('| --- | ---: | --- | --- | ---: | ---: | --- | --- | --- |');

  for (final row in rows) {
    buffer.writeln(
      '| ${row.id} | ${row.clueCount} | ${row.storedDifficulty} | '
      '${row.reratedDifficulty} | ${row.reratedScore} | ${row.stepCount} | '
      '${row.requiredTechniques.join(', ')} | `${row.givenString}` | '
      '${row.reason} |',
    );
  }

  if (integrityFailures.isNotEmpty) {
    buffer
      ..writeln()
      ..writeln('## Integrity Failures')
      ..writeln()
      ..writeln(integrityFailures.map((failure) => '- $failure').join('\n'));
  }

  if (classificationMismatches.isNotEmpty) {
    buffer
      ..writeln()
      ..writeln('## Classification Mismatches')
      ..writeln()
      ..writeln(
        classificationMismatches.map((mismatch) => '- $mismatch').join('\n'),
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

class _ExtremeAuditRow {
  const _ExtremeAuditRow({
    required this.id,
    required this.title,
    required this.assetPath,
    required this.givenString,
    required this.solutionString,
    required this.clueCount,
    required this.storedDifficulty,
    required this.storedScore,
    required this.reratedDifficulty,
    required this.reratedScore,
    required this.humanSolved,
    required this.solutionCount,
    required this.stepCount,
    required this.requiredTechniques,
    required this.techniqueCounts,
    required this.rankedEligible,
    required this.reason,
  });

  final String id;
  final String title;
  final String assetPath;
  final String givenString;
  final String solutionString;
  final int clueCount;
  final String storedDifficulty;
  final int storedScore;
  final String reratedDifficulty;
  final int reratedScore;
  final bool humanSolved;
  final int solutionCount;
  final int stepCount;
  final List<String> requiredTechniques;
  final Map<String, int> techniqueCounts;
  final bool rankedEligible;
  final String reason;
}
