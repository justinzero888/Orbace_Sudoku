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
  BannerAd? _bannerAd;
  AdSize? _adSize;
  bool _isLoaded = false;
  int? _lastWidth;

  @override
  void initState() {
    super.initState();
    AdConsentService.state.addListener(_handleConsentStateChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAdForCurrentWidth();
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
        !AdConsentService.state.value.canRequestAds ||
        !_isLoaded ||
        _bannerAd == null) {
      return const SizedBox.shrink();
    }

    final adSize = _adSize;
    if (adSize == null) {
      return const SizedBox.shrink();
    }

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
              child: AdWidget(ad: _bannerAd!),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadAdForCurrentWidth() async {
    if (!AdMobConfig.shouldShowAds ||
        !AdConsentService.state.value.canRequestAds) {
      return;
    }

    final width = MediaQuery.sizeOf(context).width.truncate();
    if (width <= 0 || width == _lastWidth) {
      return;
    }

    _lastWidth = width;
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
    if (!mounted || size == null) {
      return;
    }

    await _bannerAd?.dispose();
    setState(() {
      _adSize = size;
      _isLoaded = false;
      _bannerAd = BannerAd(
        adUnitId: AdMobConfig.bottomBannerUnitId,
        size: size,
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
            if (!mounted) {
              return;
            }
            setState(() {
              _isLoaded = false;
              _bannerAd = null;
            });
          },
        ),
      )..load();
    });
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
      });
      return;
    }
    _lastWidth = null;
    _loadAdForCurrentWidth();
  }
}
