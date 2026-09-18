import 'package:flutter/material.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/theme/app_theme.dart';

/// Umschalter zwischen *Hell*, *Dunkel* und *System*.
///
/// Bewusst kompakt (nur Icons), damit die Fußzeile auch auf schmalen Geräten
/// nicht überläuft. Die Tooltips liefern gleichzeitig das Semantik-Label für
/// Screenreader. Schreibt direkt in [AppTheme.themeModeNotifier]; die Bindung
/// an die `MaterialApp` erfolgt zentral in `main.dart`.
class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
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
            AppTheme.themeModeNotifier.value = selection.first;
          },
        );
      },
    );
  }
}
