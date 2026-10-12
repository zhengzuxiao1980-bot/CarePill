import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter/material.dart';

import '../shell/app_shell.dart';
import '../widgets/common.dart';

/// 隐私与免责说明（docs/03 §10、docs/09）。
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: buildPillPalAppBar(
        title: tr.about.title,
        backLocation: '/settings',
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(tr.about.dataTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(tr.about.dataBody, style: TextStyle(height: 1.6)),
          const SizedBox(height: 20),
          Text(tr.about.aiTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(tr.about.aiBody, style: TextStyle(height: 1.6)),
          const SizedBox(height: 20),
          Text(tr.barcode.title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(tr.barcode.privacy, style: TextStyle(height: 1.6)),
          const SizedBox(height: 8),
          Text(tr.barcode.sdkPrivacy, style: TextStyle(height: 1.6)),
          const SizedBox(height: 8),
          Text(tr.barcode.coverage, style: TextStyle(height: 1.6)),
          const SizedBox(height: 20),
          Text(tr.about.adviceTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(tr.about.adviceBody, style: TextStyle(height: 1.6)),
          const SizedBox(height: 20),
          Text(tr.about.remindersTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(tr.about.remindersBody, style: TextStyle(height: 1.6)),
          const SizedBox(height: 24),
          const DisclaimerFooter(),
        ],
      ),
    );
  }
}
