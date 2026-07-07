import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/ad_mob_bottom_banner.dart';
import '../../app/orbace_theme.dart';
import 'settings_screen.dart' show supportEmail;

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  late final Future<String> _guideFuture = rootBundle.loadString(
    'assets/help/user_guide.md',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help')),
      bottomNavigationBar: const AdMobBottomBanner(),
      body: SafeArea(
        child: FutureBuilder<String>(
          future: _guideFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                ..._parseGuide(context, snapshot.requireData),
                const SizedBox(height: 20),
                Text(
                  'Need more help? Contact $supportEmail',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: OrbaceTheme.mutedInk),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

final _headingPattern = RegExp(r'^(#{1,3})\s+(.*)$');

List<Widget> _parseGuide(BuildContext context, String raw) {
  final textTheme = Theme.of(context).textTheme;
  final widgets = <Widget>[];
  for (final rawLine in raw.split('\n')) {
    final line = rawLine.trimRight();
    if (line.isEmpty) {
      widgets.add(const SizedBox(height: 12));
      continue;
    }
    final heading = _headingPattern.firstMatch(line);
    if (heading != null) {
      final level = heading.group(1)!.length;
      widgets.add(
        Padding(
          padding: EdgeInsets.only(top: level == 1 ? 0 : 8, bottom: 4),
          child: Text(
            heading.group(2)!,
            style: level == 1 ? textTheme.titleLarge : textTheme.titleMedium,
          ),
        ),
      );
      continue;
    }
    widgets.add(Text(line.replaceAll('**', ''), style: textTheme.bodyMedium));
  }
  return widgets;
}
