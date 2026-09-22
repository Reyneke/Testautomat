import 'package:flutter/material.dart';

import 'package:testautomat_proto/app_scope.dart';
import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/widgets/debug_trigger.dart';
import 'package:testautomat_proto/widgets/language_selector.dart';
import 'package:testautomat_proto/widgets/theme_selector.dart';

/// Fusszeile aller Bildschirme (E-21).
///
/// Links die Umschalter fuer Darstellung und Sprache, rechts die Debug-Angaben
/// zur aktiven Maschine. Die Werte kommen ausschliesslich aus dem `AppState`
/// (E-55) - kein hartkodierter Maschinenzustand. Der Debug-Bereich traegt
/// zugleich die verborgene Geste zum Debug-Bildschirm (E-22).
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final zustand = AppScope.of(context).zustand;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Der Wrap bricht bei zu wenig Platz um, statt die Zeile ueberlaufen
        // zu lassen (Barrierefreiheit/Zoom, E-41).
        Expanded(
          child: Wrap(
            spacing: 16,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [ThemeModeSelector(), LanguageSelector()],
          ),
        ),
        const SizedBox(width: 16),
        DebugTrigger(
          child: ValueListenableBuilder<Maschine?>(
            valueListenable: zustand.maschine,
            builder: (context, maschine, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${localizations.debugMachine}: ${maschine?.geraeteId ?? '-'}',
                  style: textTheme.bodySmall,
                ),
                Text(
                  '${localizations.debugLocation}: ${maschine?.standort ?? '-'}',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
