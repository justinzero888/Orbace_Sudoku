import 'package:flutter/material.dart';

import 'src/app/ad_consent_service.dart';
import 'src/app/orbace_sudoku_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdConsentService.initialize();
  runApp(const OrbaceSudokuApp());
}
