import 'dart:async';

import 'package:flutter/material.dart';

import '../features/home/home_screen.dart';
import '../features/sudoku/data/app_database.dart';
import '../features/sudoku/data/sudoku_repository.dart';
import 'orbace_theme.dart';

class OrbaceSudokuApp extends StatefulWidget {
  const OrbaceSudokuApp({super.key, this.database});

  final AppDatabase? database;

  @override
  State<OrbaceSudokuApp> createState() => _OrbaceSudokuAppState();
}

class _OrbaceSudokuAppState extends State<OrbaceSudokuApp> {
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
      darkTheme: OrbaceTheme.dark(),
      home: HomeScreen(repository: _repository),
    );
  }
}
