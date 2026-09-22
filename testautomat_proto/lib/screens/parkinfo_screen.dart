import 'package:flutter/material.dart';

import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/routes.dart';
import 'package:testautomat_proto/widgets/screen_shell.dart';

/// Beleg-Anzeige nach dem (simulierten) Kauf (E-51).
///
/// Zeigt den Parkschein als Anzeige - kein PDF und kein Druck. Grundlage ist der
/// gespeicherte [Verkauf] samt Belegnummer (E-16).
class ParkinformationScreen extends StatelessWidget {
  const ParkinformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final argumente = ModalRoute.of(context)?.settings.arguments;
    final verkauf = argumente is Verkauf ? argumente : null;

    return ScreenShell(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizations.belegTitle,
              style: textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (verkauf == null)
              Text(
                localizations.parkinfoBelegHinweis,
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              )
            else ...[
              _Belegzeile(
                text: '${localizations.belegnummer}: ${verkauf.belegnummer}',
              ),
              _Belegzeile(
                text:
                    '${localizations.laufendeParkdauer}: '
                    '${localizations.formatParkdauer(verkauf.parkdauerMinuten)}',
              ),
              _Belegzeile(
                text:
                    '${localizations.betrag}: '
                    '${localizations.formatBetrag(verkauf.betragCent)}',
              ),
              _Belegzeile(
                text:
                    '${localizations.zahlungsart}: ${_zahlungsart(localizations, verkauf)}',
              ),
              _Belegzeile(
                text:
                    '${localizations.gueltigBis}: ${_gueltigBis(localizations, verkauf)}',
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.verabschiedung),
              child: Text(localizations.weiter),
            ),
          ],
        ),
      ),
    );
  }

  String _zahlungsart(AppLocalizations localizations, Verkauf verkauf) =>
      verkauf.zahlungsart == Zahlungsart.bar
      ? localizations.zahlungsartBar
      : localizations.zahlungsartKarte;

  String _gueltigBis(AppLocalizations localizations, Verkauf verkauf) {
    final ende = verkauf.timestamp
        .add(Duration(minutes: verkauf.parkdauerMinuten))
        .toLocal();
    return '${localizations.formatDate(ende)}, '
        '${localizations.formatTime(ende)}';
  }
}

/// Eine Zeile des Belegs.
class _Belegzeile extends StatelessWidget {
  const _Belegzeile({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
