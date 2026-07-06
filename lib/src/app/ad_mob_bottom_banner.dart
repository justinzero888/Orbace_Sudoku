import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_consent_service.dart';
import 'ad_mob_config.dart';
import 'orbace_theme.dart';

class AdMobBottomBanner extends StatefulWidget {
  const AdMobBottomBanner({super.key});

  @override
  State<AdMobBottomBanner> createState() => _AdMobBottomBannerState();
}

class _AdMobBottomBannerState extends State<AdMobBottomBanner> {
  // Fixed, standard banner size (smaller than the previous adaptive banner,
  // which could grow to ~15% of screen height on larger phones/tablets).
  static const AdSize _adSize = AdSize.banner;

  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _requested = false;

  @override
  void initState() {
    super.initState();
    AdConsentService.state.addListener(_handleConsentStateChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAdIfNeeded();
  }

  @override
  void dispose() {
    AdConsentService.state.removeListener(_handleConsentStateChanged);
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AdMobConfig.shouldShowAds ||
        !AdConsentService.state.value.canRequestAds) {
      return const SizedBox.shrink();
    }

    if (_isLoaded && _bannerAd != null) {
      return _AdSlot(adSize: _adSize, child: AdWidget(ad: _bannerAd!));
    }

    if (AdMobConfig.showAdLayoutPreview) {
      return _AdSlot(adSize: _adSize, child: const _AdSpacePreview());
    }

    return const SizedBox.shrink();
  }

  void _loadAdIfNeeded() {
    if (_requested ||
        !AdMobConfig.shouldShowAds ||
        !AdConsentService.state.value.canRequestAds) {
      return;
    }
    _requested = true;
    _loadBanner(AdMobConfig.bottomBannerUnitId, isFallback: false);
  }

  void _loadBanner(String unitId, {required bool isFallback}) {
    _bannerAd = BannerAd(
      adUnitId: unitId,
      size: _adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint(
            'AdMob banner failed to load (code ${error.code}, '
            '${error.domain}): ${error.message}'
            '${isFallback ? ' [fallback test ad]' : ''}',
          );
          if (!mounted) {
            return;
          }
          // The real production ad had no fill (common before the app is
          // live/approved on the store) -- fall back to a real test
          // creative once, so the slot still shows something for layout
          // QA instead of going blank. The next fresh instance of this
          // widget (e.g. navigating to a different screen) tries the
          // production ad again first, so once real fill starts this
          // fallback naturally stops being used, with no rebuild required.
          if (!isFallback && !AdMobConfig.usesTestAds) {
            _loadBanner(
              AdMobConfig.fallbackTestBannerUnitId,
              isFallback: true,
            );
            return;
          }
          setState(() {
            _isLoaded = false;
            _bannerAd = null;
          });
        },
      ),
    )..load();
  }

  void _handleConsentStateChanged() {
    if (!mounted) {
      return;
    }
    if (!AdConsentService.state.value.canRequestAds) {
      _bannerAd?.dispose();
      setState(() {
        _bannerAd = null;
        _isLoaded = false;
        _requested = false;
      });
      return;
    }
    setState(() {});
    _loadAdIfNeeded();
  }
}

class _AdSlot extends StatelessWidget {
  const _AdSlot({required this.adSize, required this.child});

  final AdSize adSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;
    return ColoredBox(
      color: OrbaceTheme.paper,
      child: SizedBox(
        height: adSize.height.toDouble() + bottomPadding,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Center(
            child: SizedBox(
              width: adSize.width.toDouble(),
              height: adSize.height.toDouble(),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _AdSpacePreview extends StatelessWidget {
  const _AdSpacePreview();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: OrbaceTheme.mutedInk.withValues(alpha: 0.08),
        border: Border.all(color: OrbaceTheme.mutedInk.withValues(alpha: 0.5)),
      ),
      child: const Center(
        child: Text(
          'Ad space (layout preview)',
          style: TextStyle(fontSize: 11, color: OrbaceTheme.mutedInk),
        ),
      ),
    );
  }
}
