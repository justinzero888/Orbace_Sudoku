import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'src/app/ad_consent_service.dart';
import 'src/app/orbace_sudoku_app.dart';

Future<void> main() async {
  var firebaseReady = false;

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
        firebaseReady = true;
      } catch (error, stack) {
        debugPrint(
          'Firebase initialization failed; continuing without crash '
          'reporting. $error\n$stack',
        );
      }

      runApp(const OrbaceSudokuApp());

      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_initializeAdConsent());
      });
    },
    (error, stack) {
      if (firebaseReady) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      } else {
        debugPrint(
          'Uncaught error (no crash reporting available): $error\n$stack',
        );
      }
    },
  );
}

Future<void> _initializeAdConsent() async {
  try {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    await AdConsentService.initialize();
  } catch (error, stack) {
    debugPrint('Ad consent initialization failed: $error\n$stack');
  }
}
