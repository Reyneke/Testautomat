import 'package:flutter/material.dart';

import 'package:testautomat_proto/app_scope.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';

/// Sprachauswahl zwischen Deutsch und Englisch.
///
/// Die Labels sind bewusst selbstbezeichnend und sprachunabhaengig
/// (`Deutsch` / `English`), damit die Auswahl immer verstaendlich bleibt; die
/// aktive Sprache liegt im `AppState` (E-06).
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final zustand = AppScope.of(context).zustand;

    return ValueListenableBuilder<Locale>(
      valueListenable: zustand.locale,
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
            zustand.setLocale(Locale(selection.first));
          },
        );
      },
    );
  }
}
