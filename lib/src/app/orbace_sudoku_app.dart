import 'dart:async';

import 'package:flutter/material.dart';

import '../features/home/home_screen.dart';
import '../features/sudoku/data/app_database.dart';
import '../features/sudoku/data/puzzle_pack_loader.dart';
import '../features/sudoku/data/sudoku_repository.dart';
import '../features/sudoku/presentation/level_pack_screen.dart';
import '../features/sudoku/presentation/record_hall_screen.dart';
import '../features/sudoku/presentation/sudoku_game_screen.dart';
import '../features/sudoku/presentation/import_puzzle_screen.dart';
import '../features/settings/about_screen.dart';
import '../features/settings/help_screen.dart';
import '../features/settings/settings_screen.dart';
import 'orbace_theme.dart';
import 'route_observer.dart';

class OrbaceSudokuApp extends StatefulWidget {
  const OrbaceSudokuApp({super.key, this.database});

  final AppDatabase? database;

  @override
  State<OrbaceSudokuApp> createState() => _OrbaceSudokuAppState();
}

class _OrbaceSudokuAppState extends State<OrbaceSudokuApp> {
  static const String _screenshotScreen = String.fromEnvironment(
    'ORBACE_SCREENSHOT_SCREEN',
  );

  late final AppDatabase _database;
  late final SudokuRepository _repository;

  @override
  void initState() {
    super.initState();
    _database = widget.database ?? AppDatabase();
    _repository = SudokuRepository(_database);
  }

  @override
  void dispose() {
    if (widget.database == null) {
      unawaited(_database.close());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orbace Sudoku',
      debugShowCheckedModeBanner: false,
      theme: OrbaceTheme.light(),
      themeMode: ThemeMode.light,
      navigatorObservers: [appRouteObserver],
      home: _buildInitialScreen(),
    );
  }

  Widget _buildInitialScreen() {
    return switch (_screenshotScreen) {
      'import_puzzle' => ImportPuzzleScreen(repository: _repository),
      'level_packs' => LevelPackScreen(repository: _repository),
      'game' => SudokuGameScreen(repository: _repository),
      'record_hall' => _RecordHallScreenshotScreen(repository: _repository),
      'settings' => const SettingsScreen(),
      'about' => const AboutScreen(),
      'help' => const HelpScreen(),
      _ => HomeScreen(repository: _repository),
    };
  }
}

class _RecordHallScreenshotScreen extends StatelessWidget {
  const _RecordHallScreenshotScreen({required this.repository});

  final SudokuRepository repository;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PuzzlePackCatalog>(
      future: PuzzlePackLoader(repository: repository).load(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Record Hall')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        return RecordHallScreen(
          repository: repository,
          catalog: snapshot.requireData,
        );
      },
    );
  }
}
