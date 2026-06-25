import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ScoreCardStore {
  const ScoreCardStore();

  static const String directoryName = 'score_cards';

  Future<Directory> directory() async {
    final documents = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(documents.path, directoryName));
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  String fileNameForAttempt(String attemptId) {
    final safeAttemptId = attemptId.replaceAll(RegExp(r'[^A-Za-z0-9_.-]'), '_');
    return '$safeAttemptId.png';
  }

  String relativePathForAttempt(String attemptId) {
    return p.join(directoryName, fileNameForAttempt(attemptId));
  }

  Future<File> fileForAttempt(String attemptId) async {
    final dir = await directory();
    return File(p.join(dir.path, fileNameForAttempt(attemptId)));
  }

  Future<File?> resolve(String storedPath) async {
    if (storedPath.trim().isEmpty) {
      return null;
    }

    final direct = File(storedPath);
    if (storedPath.startsWith('/') && direct.existsSync()) {
      return direct;
    }

    final documents = await getApplicationDocumentsDirectory();
    final relative = File(p.join(documents.path, storedPath));
    if (relative.existsSync()) {
      return relative;
    }

    final migrated = File(
      p.join(documents.path, directoryName, p.basename(storedPath)),
    );
    if (migrated.existsSync()) {
      return migrated;
    }

    return null;
  }
}
