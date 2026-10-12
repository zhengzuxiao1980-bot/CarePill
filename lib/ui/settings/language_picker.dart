import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/controllers/settings_controller.dart';
import '../../i18n/strings.g.dart';
import '../widgets/common.dart';

/// The two language names remain readable in either language.
class LanguagePicker extends ConsumerStatefulWidget {
  const LanguagePicker({super.key});

  @override
  ConsumerState<LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends ConsumerState<LanguagePicker> {
  bool _changing = false;

  @override
  Widget build(BuildContext context) {
    Localizations.localeOf(context);
    final selected = ref.watch(settingsControllerProvider).languageCode;
    return AbsorbPointer(
      absorbing: _changing,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final locale in AppLocale.values)
            PillPalChoice(
              label: locale == AppLocale.zh
                  ? tr.common.chinese
                  : tr.common.english,
              selected: selected == locale.languageCode,
              onSelected: (_) => _change(locale),
            ),
        ],
      ),
    );
  }

  Future<void> _change(AppLocale locale) async {
    if (_changing || LocaleSettings.currentLocale == locale) return;
    setState(() => _changing = true);
    try {
      await ref.read(settingsControllerProvider.notifier).setLanguage(locale);
    } catch (error) {
      if (mounted) {
        UndoBar.show(
          context,
          message: LocaleSettings.currentLocale == locale
              ? tr.common.languageFailed
              : friendlyError(error),
        );
      }
    } finally {
      if (mounted) setState(() => _changing = false);
    }
  }
}
