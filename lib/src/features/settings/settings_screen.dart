import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/ad_consent_service.dart';
import '../../app/ad_mob_bottom_banner.dart';
import '../../app/app_tracking_transparency_service.dart';
import '../../app/orbace_theme.dart';
import 'about_screen.dart';
import 'help_screen.dart';

const supportEmail = 'support@orbacesudoku.com';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Settings'),
      ),
      bottomNavigationBar: const AdMobBottomBanner(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _SettingsHeader(),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'Data, ads, and local records',
              onTap: () => _showPolicy(
                context,
                title: 'Privacy Policy',
                body: '''Privacy Policy for Orbace Sudoku
Effective Date: June 2026

At Orbace Sudoku, we value your privacy. This Privacy Policy explains how data is handled within our application.

1. Personal Data and Cloud Storage
Orbace Sudoku does not collect, store, or transmit any personal data (such as your name, email address, or contact information) to any external servers. Your data is stored locally on your device.

2. Third-Party Advertising (Google AdMob)
To keep this application free to play, we use Google AdMob to display advertisements. To serve relevant ads and comply with global regulations, Google AdMob utilizes SDKs that may automatically collect and process certain device data, including:

Your device's Advertising Identifier (such as Apple's IDFA or Google's GAID).
IP address (used to infer general location for localized ads).
App interaction data (to track ad views and clicks).

3. User Consent (EEA, UK, and California)
We utilize Google's User Messaging Platform (UMP) to present a consent dialog to users in relevant jurisdictions (such as the European Economic Area, UK, and California). You have the right to grant, deny, or revoke your ad personalization consent at any time via the in-app settings panel.

4. Changes to This Policy
We may update our Privacy Policy from time to time. Any changes will be posted directly to this web page.

Contact Us: If you have any questions, contact us at $supportEmail.''',
              ),
            ),
            ValueListenableBuilder<AdConsentState>(
              valueListenable: AdConsentService.state,
              builder: (context, consentState, _) {
                if (!consentState.privacyOptionsRequired) {
                  return const SizedBox.shrink();
                }
                return _SettingsTile(
                  icon: Icons.tune_outlined,
                  title: 'Privacy Choices',
                  subtitle: 'Manage ad personalization consent',
                  onTap: () => AdConsentService.showPrivacyOptionsForm(),
                );
              },
            ),
            if (!kIsWeb && Platform.isIOS) const _TrackingPermissionTile(),
            _SettingsTile(
              icon: Icons.description_outlined,
              title: 'Terms of Use',
              subtitle: 'Use, content, and conduct',
              onTap: () => _showPolicy(
                context,
                title: 'Terms of Use',
                body:
                    'By using Orbace Sudoku you agree to these terms. Orbace Sudoku is published by Orbace Technologies LLC.\n\nAll puzzle content, game logic, scoring systems, and design are the intellectual property of Orbace Technologies LLC. Imported puzzles are for personal, non-commercial use only.\n\nThe app is provided as-is without warranty. Orbace Technologies LLC is not liable for data loss or device issues arising from use of the app.\n\nFor questions, contact: $supportEmail',
              ),
            ),
            _SettingsTile(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'Version and copyright information',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const AboutScreen()),
              ),
            ),
            _SettingsTile(
              icon: Icons.help_outline,
              title: 'Help',
              subtitle: 'User guide and support',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const HelpScreen()),
              ),
            ),
            _SettingsTile(
              icon: Icons.mail_outline,
              title: 'Contact Support',
              subtitle: supportEmail,
              onTap: () => _contactSupport(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _contactSupport(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: 'subject=${Uri.encodeComponent('Orbace Sudoku Support')}',
    );
    final launched = await launchUrl(uri);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Email us at $supportEmail')));
    }
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
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.62,
              maxWidth: 520,
            ),
            child: SingleChildScrollView(child: Text(body)),
          ),
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

class _TrackingPermissionTile extends StatefulWidget {
  const _TrackingPermissionTile();

  @override
  State<_TrackingPermissionTile> createState() =>
      _TrackingPermissionTileState();
}

class _TrackingPermissionTileState extends State<_TrackingPermissionTile> {
  late Future<String> _statusFuture =
      AppTrackingTransparencyService.authorizationStatus();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _statusFuture,
      builder: (context, snapshot) {
        final status = snapshot.data ?? 'checking';
        return _SettingsTile(
          icon: Icons.ads_click_outlined,
          title: 'Ad Tracking Permission',
          subtitle: _subtitleFor(status),
          onTap: () async {
            await AppTrackingTransparencyService.requestAuthorizationIfNeeded();
            if (!mounted) {
              return;
            }
            setState(() {
              _statusFuture =
                  AppTrackingTransparencyService.authorizationStatus();
            });
          },
        );
      },
    );
  }

  String _subtitleFor(String status) {
    return switch (status) {
      'notDetermined' => 'Not requested yet. Tap to request.',
      'authorized' => 'Authorized',
      'denied' => 'Denied or tracking requests are disabled',
      'restricted' => 'Restricted by device settings',
      'notSupported' => 'Not required on this device',
      'missingPlugin' => 'Native ATT bridge unavailable',
      'error' => 'Could not read status',
      _ => 'Status: $status',
    };
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
              'App policies and legal information.',
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
