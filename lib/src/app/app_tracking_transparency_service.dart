import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AppTrackingTransparencyService {
  const AppTrackingTransparencyService._();

  static const MethodChannel _channel = MethodChannel(
    'com.orbace.orbace_sudoku/app_tracking_transparency',
  );

  static Future<String> requestAuthorizationIfNeeded() async {
    if (kIsWeb || !Platform.isIOS) {
      return 'notSupported';
    }
    try {
      final status = await _channel.invokeMethod<String>(
        'requestTrackingAuthorization',
      );
      return status ?? 'unknown';
    } on PlatformException catch (error, stack) {
      debugPrint('ATT request failed: ${error.code} ${error.message}\n$stack');
      return 'error';
    } on MissingPluginException catch (error, stack) {
      debugPrint('ATT bridge missing: $error\n$stack');
      return 'missingPlugin';
    }
  }

  static Future<String> authorizationStatus() async {
    if (kIsWeb || !Platform.isIOS) {
      return 'notSupported';
    }
    try {
      final status = await _channel.invokeMethod<String>(
        'trackingAuthorizationStatus',
      );
      return status ?? 'unknown';
    } on PlatformException catch (error, stack) {
      debugPrint('ATT status failed: ${error.code} ${error.message}\n$stack');
      return 'error';
    } on MissingPluginException catch (error, stack) {
      debugPrint('ATT bridge missing: $error\n$stack');
      return 'missingPlugin';
    }
  }
}
