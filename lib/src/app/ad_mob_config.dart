import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobConfig {
  const AdMobConfig._();

  static const String _iOSProductionBannerUnitId =
      'ca-app-pub-7497527413129091/7584766530';
  static const String _androidProductionBannerUnitId =
      'ca-app-pub-7497527413129091/8812517487';
  static const String _testBannerUnitId =
      'ca-app-pub-3940256099942544/2435281174';

  static bool get isSupportedPlatform {
    return !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  }

  static bool get shouldShowAds {
    return isSupportedPlatform;
  }

  static String get bottomBannerUnitId {
    if (kDebugMode) {
      return _testBannerUnitId;
    }
    if (Platform.isAndroid) {
      return _androidProductionBannerUnitId;
    }
    return _iOSProductionBannerUnitId;
  }

  static Future<InitializationStatus>? initialize() {
    if (!isSupportedPlatform) {
      return null;
    }
    return MobileAds.instance.initialize();
  }
}
