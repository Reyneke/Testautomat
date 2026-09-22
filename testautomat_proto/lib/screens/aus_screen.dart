import 'package:flutter/material.dart';

import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/widgets/screen_shell.dart';

/// "Aus"-Bildschirm: Der Automat kann derzeit nicht verkaufen.
///
/// Wird gezeigt, wenn die Maschine nicht aktiv ist (`0_Einfuehrung.md`). Die
/// Verkaufszeit-Pruefung kommt mit U-30 dazu.
class AusScreen extends StatelessWidget {
  const AusScreen({super.key, this.onNeuLaden});

  /// Laedt die Maschinendaten erneut; ohne Callback entfaellt der Knopf.
  final VoidCallback? onNeuLaden;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return ScreenShell(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizations.ausserhalbVerkaufszeit,
              style: textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              localizations.ausserhalbVerkaufszeitHinweis,
              style: textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onNeuLaden != null) ...[
              const SizedBox(height: 32),
              FilledButton(
                onPressed: onNeuLaden,
                child: Text(localizations.neuLaden),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
