import 'package:flutter/material.dart';
import 'package:testautomat_proto/l10n/app_locale.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';

/// Sprachauswahl zwischen Deutsch und Englisch.
///
/// Die Labels sind bewusst selbstbezeichnend und sprachunabhängig
/// (`Deutsch` / `English`), damit die Auswahl immer verständlich bleibt.
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return ValueListenableBuilder<Locale>(
      valueListenable: AppLocale.notifier,
      builder: (context, locale, _) {
        return SegmentedButton<String>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment<String>(
              value: 'de',
              label: const Text('Deutsch'),
              tooltip: localizations.languageGerman,
            ),
            ButtonSegment<String>(
              value: 'en',
              label: const Text('English'),
              tooltip: localizations.languageEnglish,
            ),
          ],
          selected: {locale.languageCode},
          onSelectionChanged: (selection) {
            AppLocale.setLocale(Locale(selection.first));
          },
        );
      },
    );
  }
}
