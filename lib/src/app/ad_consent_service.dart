import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_mob_config.dart';

class AdConsentState {
  const AdConsentState({
    required this.canRequestAds,
    required this.privacyOptionsRequired,
    required this.isReady,
    required this.status,
    this.lastError,
  });

  const AdConsentState.initial()
    : canRequestAds = false,
      privacyOptionsRequired = false,
      isReady = false,
      status = ConsentStatus.unknown,
      lastError = null;

  final bool canRequestAds;
  final bool privacyOptionsRequired;
  final bool isReady;
  final ConsentStatus status;
  final String? lastError;
}

class AdConsentService {
  const AdConsentService._();

  static const String _debugGeography = String.fromEnvironment(
    'ORBACE_UMP_DEBUG_GEOGRAPHY',
  );
  static const String _debugTestDeviceIds = String.fromEnvironment(
    'ORBACE_UMP_TEST_DEVICE_IDS',
  );
  static const bool _resetConsentForTesting = bool.fromEnvironment(
    'ORBACE_UMP_RESET',
  );

  static final ValueNotifier<AdConsentState> state =
      ValueNotifier<AdConsentState>(const AdConsentState.initial());

  static Future<void> initialize() async {
    if (!AdMobConfig.isSupportedPlatform) {
      state.value = const AdConsentState(
        canRequestAds: false,
        privacyOptionsRequired: false,
        isReady: true,
        status: ConsentStatus.notRequired,
      );
      return;
    }

    await MobileAds.instance.initialize();
    if (_resetConsentForTesting) {
      await ConsentInformation.instance.reset();
    }
    final didUpdateConsentInfo = await _requestConsentInfoUpdate();
    if (didUpdateConsentInfo) {
      await _loadConsentFormIfRequired();
    }
    await _refreshState();
    _allowTestAdsAfterConsentRequestFailure();
  }

  static Future<void> showPrivacyOptionsForm() async {
    if (!AdMobConfig.isSupportedPlatform) {
      return;
    }

    final completer = Completer<void>();
    await ConsentForm.showPrivacyOptionsForm((formError) {
      if (formError != null) {
        debugPrint(
          'UMP privacy options error ${formError.errorCode}: '
          '${formError.message}',
        );
      }
      if (!completer.isCompleted) {
        completer.complete();
      }
    });
    await completer.future;
    await _refreshState();
  }

  static Future<bool> _requestConsentInfoUpdate() async {
    final completer = Completer<bool>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      _requestParameters,
      () {
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      },
      (formError) {
        _setError('UMP consent update', formError);
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      },
    );
    return completer.future;
  }

  static Future<void> _loadConsentFormIfRequired() async {
    final completer = Completer<void>();
    await ConsentForm.loadAndShowConsentFormIfRequired((formError) {
      if (formError != null) {
        _setError('UMP consent form', formError);
      }
      if (!completer.isCompleted) {
        completer.complete();
      }
    });
    await completer.future;
  }

  static Future<void> _refreshState() async {
    final canRequestAds = await ConsentInformation.instance.canRequestAds();
    final status = await ConsentInformation.instance.getConsentStatus();
    final privacyStatus = await ConsentInformation.instance
        .getPrivacyOptionsRequirementStatus();
    state.value = AdConsentState(
      canRequestAds: canRequestAds,
      privacyOptionsRequired:
          privacyStatus == PrivacyOptionsRequirementStatus.required,
      isReady: true,
      status: status,
      lastError: state.value.lastError,
    );
  }

  static ConsentRequestParameters get _requestParameters {
    final debugSettings = _debugConsentSettings;
    return ConsentRequestParameters(
      consentDebugSettings: debugSettings,
      tagForUnderAgeOfConsent: false,
    );
  }

  static ConsentDebugSettings? get _debugConsentSettings {
    final geography = switch (_debugGeography.toLowerCase()) {
      'eea' => DebugGeography.debugGeographyEea,
      'us' || 'regulated_us' => DebugGeography.debugGeographyRegulatedUsState,
      'other' => DebugGeography.debugGeographyOther,
      _ => null,
    };
    final testIds = _debugTestDeviceIds
        .split(',')
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toList(growable: false);
    if (geography == null && testIds.isEmpty) {
      return null;
    }
    return ConsentDebugSettings(
      debugGeography: geography,
      testIdentifiers: testIds.isEmpty ? null : testIds,
    );
  }

  static void _setError(String source, FormError formError) {
    final message =
        '$source error ${formError.errorCode}: ${formError.message}';
    debugPrint(message);
    state.value = AdConsentState(
      canRequestAds: state.value.canRequestAds,
      privacyOptionsRequired: state.value.privacyOptionsRequired,
      isReady: state.value.isReady,
      status: state.value.status,
      lastError: message,
    );
  }

  static void _allowTestAdsAfterConsentRequestFailure() {
    if (!AdMobConfig.usesTestAds ||
        state.value.canRequestAds ||
        state.value.lastError == null) {
      return;
    }
    state.value = AdConsentState(
      canRequestAds: true,
      privacyOptionsRequired: state.value.privacyOptionsRequired,
      isReady: state.value.isReady,
      status: state.value.status,
      lastError: state.value.lastError,
    );
  }
}
