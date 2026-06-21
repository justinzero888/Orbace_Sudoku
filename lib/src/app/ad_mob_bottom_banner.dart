import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAdForCurrentWidth();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AdMobConfig.shouldShowAds || !_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    final adSize = _adSize;
    if (adSize == null) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      top: false,
      child: ColoredBox(
        color: OrbaceTheme.paper,
        child: Center(
          child: SizedBox(
            width: adSize.width.toDouble(),
            height: adSize.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          ),
        ),
      ),
    );
  }

  Future<void> _loadAdForCurrentWidth() async {
    if (!AdMobConfig.shouldShowAds) {
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
}
