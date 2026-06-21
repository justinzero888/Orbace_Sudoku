import 'dart:convert';
import 'dart:io';
import 'dart:math';

const int _batchSize = 60;

void main() {
  final manifestFile = File('assets/puzzles/packs.json');
  final manifest =
      jsonDecode(manifestFile.readAsStringSync()) as Map<String, Object?>;
  final packs = (manifest['packs']! as List<Object?>)
      .cast<Map<String, Object?>>();
  final updatedPacks = <Map<String, Object?>>[];

  for (final pack in packs) {
    final packId = pack['id']! as String;
    final sourceAsset = pack['asset']! as String;
    final sourcePayload =
        jsonDecode(File(sourceAsset).readAsStringSync())
            as Map<String, Object?>;
    final puzzles = (sourcePayload['puzzles']! as List<Object?>)
        .cast<Map<String, Object?>>();
    if (puzzles.isEmpty && pack['assets'] != null) {
      updatedPacks.add(pack);
      continue;
    }

    final batchDir = Directory('assets/puzzles/$packId')
      ..createSync(recursive: true);
    final batchCount = (puzzles.length / _batchSize).ceil();
    final assets = <String>[];
    for (var batchIndex = 0; batchIndex < batchCount; batchIndex++) {
      final start = batchIndex * _batchSize;
      final end = min(start + _batchSize, puzzles.length);
      final asset =
          '${batchDir.path}/${packId}_${(batchIndex + 1).toString().padLeft(2, '0')}.json';
      final payload = Map<String, Object?>.from(sourcePayload)
        ..['batchIndex'] = batchIndex + 1
        ..['batchCount'] = batchCount
        ..['puzzles'] = puzzles.sublist(start, end);
      File(asset).writeAsStringSync(
        '${const JsonEncoder.withIndent('  ').convert(payload)}\n',
      );
      assets.add(asset);
    }

    File(sourceAsset).writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(<String, Object?>{for (final entry in sourcePayload.entries)
        if (entry.key != 'puzzles') entry.key: entry.value, 'batchCount': batchCount, 'assets': assets, 'puzzles': const <Object?>[]})}\n',
    );

    updatedPacks.add(<String, Object?>{
      ...pack,
      'asset': assets.first,
      'assets': assets,
    });
    stdout.writeln('$packId: ${puzzles.length} puzzles in $batchCount batches');
  }

  manifestFile.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(<String, Object?>{...manifest, 'packs': updatedPacks})}\n',
  );
}
