import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../app/ad_mob_bottom_banner.dart';
import '../../app/orbace_theme.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late final Future<PackageInfo> _packageInfoFuture =
      PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      bottomNavigationBar: const AdMobBottomBanner(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Orbace Sudocoo',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'A free light version of Orbace Sudoku. Also play on web at '
                'www.orbacesudoku.com',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: OrbaceTheme.mutedInk),
              ),
              const SizedBox(height: 12),
              FutureBuilder<PackageInfo>(
                future: _packageInfoFuture,
                builder: (context, snapshot) {
                  final info = snapshot.data;
                  final label = info == null
                      ? 'Version...'
                      : 'Version ${info.version} (${info.buildNumber})';
                  return Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: OrbaceTheme.mutedInk,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                '© 2026 Orbace Technologies LLC. All rights reserved.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: OrbaceTheme.mutedInk),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
