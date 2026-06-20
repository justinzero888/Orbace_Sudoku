import 'package:flutter/material.dart';

import '../features/home/home_screen.dart';
import 'orbace_theme.dart';

class OrbaceSudokuApp extends StatelessWidget {
  const OrbaceSudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orbace Sudoku',
      debugShowCheckedModeBanner: false,
      theme: OrbaceTheme.light(),
      darkTheme: OrbaceTheme.dark(),
      home: const HomeScreen(),
    );
  }
}
