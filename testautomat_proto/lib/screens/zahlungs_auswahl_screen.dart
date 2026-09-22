import 'package:flutter/material.dart';

import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/data/seed_data.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/routes.dart';
import 'package:testautomat_proto/screens/kaufablauf.dart';
import 'package:testautomat_proto/widgets/screen_shell.dart';

/// Auswahl der (simulierten) Zahlungsart (`0_Einfuehrung.md`).
///
/// Der eigentliche Zahlungsablauf mit Fortschritt, Timeout, Abbruch und Beleg
/// folgt mit U-33; hier wird die Auswahl nur weitergereicht.
class ZahlungsAuswahlScreen extends StatelessWidget {
  const ZahlungsAuswahlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final auswahl = KaufAuswahl.aus(
      ModalRoute.of(context)?.settings.arguments,
      standardParkdauerMinuten: SeedData.parktaktMinuten,
    );

    return ScreenShell(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizations.zahlungTitle,
              style: textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              localizations.formatParkdauer(auswahl.parkdauerMinuten),
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              localizations.zahlungHinweis,
              style: textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                FilledButton(
                  onPressed: () =>
                      _weiter(context, auswahl.mitZahlungsart(Zahlungsart.bar)),
                  child: Text(localizations.zahlungsartBar),
                ),
                FilledButton(
                  onPressed: () => _weiter(
                    context,
                    auswahl.mitZahlungsart(Zahlungsart.karte),
                  ),
                  child: Text(localizations.zahlungsartKarte),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.zurueck),
            ),
          ],
        ),
      ),
    );
  }

  void _weiter(BuildContext context, KaufAuswahl auswahl) {
    Navigator.of(context).pushNamed(AppRoutes.parkinfo, arguments: auswahl);
  }
}
