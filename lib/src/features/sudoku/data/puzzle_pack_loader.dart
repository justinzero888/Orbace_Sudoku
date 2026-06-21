import 'dart:convert';

import 'package:flutter/services.dart';

import '../presentation/fixture_puzzles.dart';

class PuzzlePackCatalog {
  const PuzzlePackCatalog({required this.packs});

  final List<PuzzlePackDefinition> packs;

  List<FixturePuzzleDefinition> get puzzles {
    return <FixturePuzzleDefinition>[for (final pack in packs) ...pack.puzzles];
  }

  List<FixturePuzzleDefinition> get teaMomentPuzzles {
    final teaPack = packs.where((pack) => pack.id == 'tea_moments').firstOrNull;
    return teaPack?.puzzles ?? puzzles;
  }

  FixturePuzzleDefinition byId(String id) {
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
    required this.asset,
    required this.order,
    required this.puzzles,
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
      asset: json['asset']! as String,
      order: json['order']! as int,
      puzzles: puzzles,
    );
  }

  final String id;
  final String title;
  final String subtitle;
  final String seal;
  final String description;
  final String asset;
  final int order;
  final List<FixturePuzzleDefinition> puzzles;

  int get advancedPuzzleCount {
    return puzzles
        .where(
          (puzzle) => puzzle.requiredTechniques.any(
            (technique) =>
                technique == 'naked_pair' ||
                technique == 'hidden_pair' ||
                technique == 'pointing_pair',
          ),
        )
        .length;
  }
}

class PuzzlePackLoader {
  PuzzlePackLoader({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

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
      final asset = packItem['asset']! as String;
      final packJson = await _bundle.loadString(asset);
      final packPayload = jsonDecode(packJson) as Map<String, Object?>;
      final puzzles = (packPayload['puzzles']! as List<Object?>)
          .cast<Map<String, Object?>>()
          .map(
            (json) => FixturePuzzleDefinition.fromJson(
              json,
              packId: packItem['id']! as String,
            ),
          )
          .toList(growable: false);
      packs.add(PuzzlePackDefinition.fromJson(packItem, puzzles: puzzles));
    }

    packs.sort((a, b) => a.order.compareTo(b.order));
    return PuzzlePackCatalog(
      packs: List<PuzzlePackDefinition>.unmodifiable(packs),
    );
  }
}
