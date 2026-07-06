import 'dart:io';

import 'package:flutter/foundation.dart';

class AdMobConfig {
  const AdMobConfig._();

  static const String _iOSProductionBannerUnitId =
      'ca-app-pub-7497527413129091/7584766530';
  static const String _androidProductionBannerUnitId =
      'ca-app-pub-7497527413129091/8812517487';
  static const String _testBannerUnitId =
      'ca-app-pub-3940256099942544/2435281174';
  static const bool _forceTestAds = bool.fromEnvironment(
    'ORBACE_FORCE_TEST_ADS',
  );
  static const bool _hideAdsForScreenshots = bool.fromEnvironment(
    'ORBACE_HIDE_ADS_FOR_SCREENSHOTS',
  );
  static const bool _showAdLayoutPreview = bool.fromEnvironment(
    'ORBACE_AD_LAYOUT_PREVIEW',
  );

  static bool get isSupportedPlatform {
    return !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  }

  static bool get shouldShowAds {
    return isSupportedPlatform && !_hideAdsForScreenshots;
  }

  /// Renders a bordered placeholder in the ad slot while the real ad hasn't
  /// loaded yet, so the ad footprint can be reviewed before production fill
  /// starts. Opt-in only (`--dart-define=ORBACE_AD_LAYOUT_PREVIEW=true`) —
  /// never enabled in a TestFlight/App Store build.
  static bool get showAdLayoutPreview {
    return _showAdLayoutPreview && !_hideAdsForScreenshots;
  }

  static bool get usesTestAds {
    return kDebugMode || _forceTestAds;
  }

  static String get bottomBannerUnitId {
    if (usesTestAds) {
      return _testBannerUnitId;
    }
    if (Platform.isAndroid) {
      return _androidProductionBannerUnitId;
    }
    return _iOSProductionBannerUnitId;
  }

  /// Google's own sample test banner unit -- used as an explicit no-fill
  /// fallback for the *production* ad unit (see [AdMobBottomBanner]), not
  /// as the primary id. Before an app is live on the App Store/Play Store,
  /// the production unit commonly has no fill since Google can't yet
  /// validate app-ads.txt/store ownership; falling back to a real test
  /// creative keeps the banner slot showing something for layout QA. Once
  /// the production unit starts filling for real, this is never reached
  /// again -- no rebuild required.
  static String get fallbackTestBannerUnitId => _testBannerUnitId;
}
