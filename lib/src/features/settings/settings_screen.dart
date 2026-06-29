import 'package:flutter/material.dart';

import '../../app/ad_mob_bottom_banner.dart';
import '../../app/orbace_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      bottomNavigationBar: const AdMobBottomBanner(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _SettingsHeader(),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy',
              subtitle: 'Data, ads, and local records',
              onTap: () => _showPolicy(
                context,
                title: 'Privacy',
                body:
                    'Orbace Sudoku stores gameplay progress, imported puzzles, Su-Pu records, replays, score cards, ratings, and notes locally on this device. Home and non-game screens may show AdMob banners. Active Sudoku gameplay remains ad-free. Future account and global ranking features will require a separate privacy update before launch.',
              ),
            ),
            _SettingsTile(
              icon: Icons.description_outlined,
              title: 'Terms of Use',
              subtitle: 'Current beta use and future competition rules',
              onTap: () => _showPolicy(
                context,
                title: 'Terms of Use',
                body:
                    'This beta build is for testing Orbace Sudoku gameplay and release readiness. Imported puzzles are for personal use and are not official ranking content. Future daily/global ranking games will require account registration, official event rules, server validation, and updated terms before they are enabled.',
              ),
            ),
            _SettingsTile(
              icon: Icons.block_outlined,
              title: 'Remove Ads IPA',
              subtitle: 'Planned paid/ad-free build option',
              onTap: () => _showPolicy(
                context,
                title: 'Remove Ads IPA',
                body:
                    'A remove-ads version is planned as a separate release option. This beta keeps banner ads visible on non-game screens so UAT can validate placement. Active puzzle play remains ad-free.',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPolicy(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: OrbaceTheme.ricePaper,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6DED0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Orbace Sudoku',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              'Release settings, policy notes, and upcoming ad-free options.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: OrbaceTheme.mutedInk),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: OrbaceTheme.vermilion),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
