import 'package:flutter/material.dart';

import 'src/app/ad_mob_config.dart';
import 'src/app/orbace_sudoku_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AdMobConfig.initialize();
  runApp(const OrbaceSudokuApp());
}
