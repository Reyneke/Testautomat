import 'package:flutter/material.dart';

import 'package:testautomat_proto/data/seed_data.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/routes.dart';
import 'package:testautomat_proto/screens/kaufablauf.dart';
import 'package:testautomat_proto/widgets/screen_shell.dart';

/// Parkinformation vor der Verabschiedung (`0_Einfuehrung.md`).
///
/// Zeigt die gewaehlte Parkdauer (und mit U-33 den Beleg). Der Betrag kommt mit
/// der Preisbildung aus U-31 dazu.
class ParkinformationScreen extends StatelessWidget {
  const ParkinformationScreen({super.key});

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
              localizations.parkinfoTitle,
              style: textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(localizations.laufendeParkdauer, style: textTheme.titleMedium),
            Text(
              localizations.formatParkdauer(auswahl.parkdauerMinuten),
              style: textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text(
              localizations.parkinfoBelegHinweis,
              style: textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.verabschiedung, arguments: auswahl),
              child: Text(localizations.weiter),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.zurueck),
            ),
          ],
        ),
      ),
    );
  }
}
