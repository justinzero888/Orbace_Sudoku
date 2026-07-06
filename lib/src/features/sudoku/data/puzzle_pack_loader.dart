import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/daily_random_puzzle.dart';
import '../presentation/fixture_puzzles.dart';
import 'sudoku_repository.dart';

class PuzzlePackCatalog {
  const PuzzlePackCatalog({
    required this.schemaVersion,
    required this.contentVersion,
    required this.generatedAt,
    required this.generatorVersion,
    required this.validatorVersion,
    required this.solverVersion,
    required this.packs,
  });

  final int schemaVersion;
  final String contentVersion;
  final String generatedAt;
  final String generatorVersion;
  final String validatorVersion;
  final String solverVersion;
  final List<PuzzlePackDefinition> packs;

  List<FixturePuzzleDefinition> get puzzles {
    return <FixturePuzzleDefinition>[for (final pack in packs) ...pack.puzzles];
  }

  /// Tea Moment is a calm, low-pressure mode, so it only draws from the
  /// easier packs (Foundation/Discipline/Insight) -- Hard and Expert puzzles
  /// are excluded to keep it approachable. See UAT feedback that folded the
  /// old standalone Tea Moments pack into Foundation.
  static const _teaMomentSourcePackIds = <String>{
    'foundation',
    'discipline',
    'insight',
  };

  List<FixturePuzzleDefinition> get teaMomentPuzzles {
    final pool = <FixturePuzzleDefinition>[
      for (final pack in packs)
        if (_teaMomentSourcePackIds.contains(pack.id)) ...pack.puzzles,
    ];
    return pool.isEmpty ? puzzles : pool;
  }

  /// True Extreme puzzles eligible for the Daily Extreme Challenge pool.
  /// Excludes true_extreme_059, which the 2026-07-02 alignment audit found
  /// is solvable by the teaching hint solver -- disqualifying it from a
  /// pack whose whole point is being beyond that solver.
  List<FixturePuzzleDefinition> get trueExtremePool {
    final pack = packs.where((pack) => pack.id == 'true_extreme').firstOrNull;
    return (pack?.puzzles ?? const <FixturePuzzleDefinition>[])
        .where((puzzle) => puzzle.id != 'true_extreme_059')
        .toList(growable: false);
  }

  /// Resolves a puzzle by id. Daily Extreme Challenge and Daily Tea Moment
  /// ids (e.g. 'extreme_daily_2026-07-04') are not stored anywhere -- they
  /// are reconstructed on demand from the date encoded in the id plus the
  /// current pool, so Record Hall/Replay/Su-Pu Detail can look up any past
  /// day's daily puzzle exactly as it was without persisting the
  /// transformed grid separately. See DailyRandomPuzzle.
  FixturePuzzleDefinition byId(String id) {
    final extremeDate = DailyRandomPuzzle.extremeDaily.parseDate(id);
    if (extremeDate != null && trueExtremePool.isNotEmpty) {
      return DailyRandomPuzzle.extremeDaily.forDate(extremeDate, trueExtremePool);
    }
    final teaDate = DailyRandomPuzzle.teaDaily.parseDate(id);
    if (teaDate != null && teaMomentPuzzles.isNotEmpty) {
      return DailyRandomPuzzle.teaDaily.forDate(teaDate, teaMomentPuzzles);
    }
    return puzzles.firstWhere(
      (puzzle) => puzzle.id == id,
      orElse: () => teaMomentPuzzles.first,
    );
  }
}

class PuzzlePackDefinition {
  const PuzzlePackDefinition({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.seal,
    required this.description,
    required this.assets,
    required this.order,
    required this.difficultyBand,
    required this.curationStrategy,
    required this.milestoneEvery,
    required this.puzzles,
    this.hidden = false,
  });

  factory PuzzlePackDefinition.fromJson(
    Map<String, Object?> json, {
    required List<FixturePuzzleDefinition> puzzles,
  }) {
    return PuzzlePackDefinition(
      id: json['id']! as String,
      title: json['title']! as String,
      subtitle: json['subtitle']! as String,
      seal: json['seal']! as String,
      description: json['description']! as String,
      assets: _assetsFromJson(json),
      order: json['order']! as int,
      difficultyBand: json['difficultyBand']! as String,
      curationStrategy: json['curationStrategy']! as String,
      milestoneEvery: json['milestoneEvery']! as int,
      puzzles: puzzles,
      hidden: json['hidden'] as bool? ?? false,
    );
  }

  final String id;
  final String title;
  final String subtitle;
  final String seal;
  final String description;
  final List<String> assets;
  final int order;
  final String difficultyBand;
  final String curationStrategy;
  final int milestoneEvery;
  final List<FixturePuzzleDefinition> puzzles;
  /// True for packs that are loaded (and available to code like the daily
  /// Extreme Challenge source resolver) but must not be shown as a
  /// browsable entry in Level Packs -- e.g. true_extreme, which is reserved
  /// for the daily no-hint challenge and final production validation.
  final bool hidden;

  String get asset => assets.first;
}

class PuzzlePackLoader {
  PuzzlePackLoader({AssetBundle? bundle, this.repository})
    : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final SudokuRepository? repository;

  Future<PuzzlePackCatalog> load() {
    return _loadFromAssets();
  }

  Future<PuzzlePackCatalog> _loadFromAssets() async {
    final manifestJson = await _bundle.loadString('assets/puzzles/packs.json');
    final manifest = jsonDecode(manifestJson) as Map<String, Object?>;
    final packItems = (manifest['packs']! as List<Object?>)
        .cast<Map<String, Object?>>();

    final packs = <PuzzlePackDefinition>[];
    for (final packItem in packItems) {
      final packId = packItem['id']! as String;
      final assets = _assetsFromJson(packItem);
      final puzzles = <FixturePuzzleDefinition>[];
      for (final asset in assets) {
        final packJson = await _bundle.loadString(asset);
        final packPayload = jsonDecode(packJson) as Map<String, Object?>;
        puzzles.addAll(
          (packPayload['puzzles']! as List<Object?>)
              .cast<Map<String, Object?>>()
              .map(
                (json) =>
                    FixturePuzzleDefinition.fromJson(json, packId: packId),
              ),
        );
      }
      packs.add(PuzzlePackDefinition.fromJson(packItem, puzzles: puzzles));
    }

    final imported = await repository?.importedPuzzleDefinitions();
    if (imported != null && imported.isNotEmpty) {
      packs.add(
        PuzzlePackDefinition(
          id: 'imported',
          title: 'Imported',
          subtitle: 'Personal puzzles',
          seal: '入',
          description:
              'Personal imported puzzles. Local play only; excluded from worldwide ranking until reviewed by Orbace.',
          assets: const <String>[],
          order: 99,
          difficultyBand: 'personal',
          curationStrategy: 'Personal import',
          milestoneEvery: 0,
          puzzles: imported,
        ),
      );
    }

    packs.sort((a, b) => a.order.compareTo(b.order));
    return PuzzlePackCatalog(
      schemaVersion: manifest['schemaVersion']! as int,
      contentVersion: manifest['contentVersion']! as String,
      generatedAt: manifest['generatedAt']! as String,
      generatorVersion: manifest['generatorVersion']! as String,
      validatorVersion: manifest['validatorVersion']! as String,
      solverVersion: manifest['solverVersion']! as String,
      packs: List<PuzzlePackDefinition>.unmodifiable(packs),
    );
  }
}

List<String> _assetsFromJson(Map<String, Object?> json) {
  final assets = json['assets'];
  if (assets != null) {
    return List<String>.unmodifiable((assets as List<Object?>).cast<String>());
  }
  return <String>[json['asset']! as String];
}
