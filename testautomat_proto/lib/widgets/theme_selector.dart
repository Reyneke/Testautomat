import 'package:flutter/material.dart';

import 'package:testautomat_proto/app_scope.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';

/// Umschalter zwischen *Hell*, *Dunkel* und *System*.
///
/// Bewusst kompakt (nur Icons), damit die Fusszeile auch auf schmalen Geraeten
/// nicht ueberlaeuft. Die Tooltips liefern gleichzeitig das Semantik-Label fuer
/// Screenreader. Schreibt in den `AppState`; die Bindung an die `MaterialApp`
/// erfolgt zentral in `main.dart` (E-06).
class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final zustand = AppScope.of(context).zustand;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: zustand.themeMode,
      builder: (context, themeMode, _) {
        return SegmentedButton<ThemeMode>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment<ThemeMode>(
              value: ThemeMode.light,
              icon: const Icon(Icons.light_mode),
              tooltip: localizations.themeLight,
            ),
            ButtonSegment<ThemeMode>(
              value: ThemeMode.dark,
              icon: const Icon(Icons.dark_mode),
              tooltip: localizations.themeDark,
            ),
            ButtonSegment<ThemeMode>(
              value: ThemeMode.system,
              icon: const Icon(Icons.brightness_auto),
              tooltip: localizations.themeSystem,
            ),
          ],
          selected: {themeMode},
          onSelectionChanged: (selection) {
            zustand.themeMode.value = selection.first;
          },
        );
      },
    );
  }
}
