import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/logic/parkschein_pdf.dart';
import 'package:testautomat_proto/routes.dart';
import 'package:testautomat_proto/services/beleg_download.dart';
import 'package:testautomat_proto/widgets/screen_shell.dart';

/// Beleg-Anzeige nach dem (simulierten) Kauf.
///
/// Grundlage ist der gespeicherte [Verkauf] samt Belegnummer (E-16). Der
/// Parkschein laesst sich in allen Varianten als PDF herunterladen
/// (`7_Neue_Zahlmoeglichkeiten.md`); die Ablage uebernimmt [parkscheinSpeichern]
/// bzw. die plattformuebliche Voreinstellung.
class ParkinformationScreen extends StatelessWidget {
  const ParkinformationScreen({super.key, this.parkscheinSpeichern});

  /// Test-Haken: laesst Tests die Ablage ersetzen (ohne Plattform-Plugins).
  final Future<String> Function(Uint8List bytes, String dateiname)?
  parkscheinSpeichern;

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
                    '${localizations.zahlungsart}: '
                    '${localizations.zahlungsartName(verkauf.zahlungsart)}',
              ),
              _Belegzeile(
                text:
                    '${localizations.gueltigBis}: '
                    '${_gueltigBis(localizations, verkauf)}',
              ),
              if (verkauf.kennzeichen != null)
                _Belegzeile(
                  text: '${localizations.kennzeichen}: ${verkauf.kennzeichen}',
                ),
            ],
            const SizedBox(height: 24),
            if (verkauf != null) ...[
              OutlinedButton(
                onPressed: () => _ladeHerunter(context, localizations, verkauf),
                child: Text(localizations.parkscheinHerunterladen),
              ),
              const SizedBox(height: 8),
            ],
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

  /// Erzeugt den Parkschein als PDF und uebergibt ihn an die Ablage.
  Future<void> _ladeHerunter(
    BuildContext context,
    AppLocalizations localizations,
    Verkauf verkauf,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final bytes = await parkscheinPdf(
        titel: localizations.belegTitle,
        zeilen: <ParkscheinZeile>[
          ParkscheinZeile(localizations.belegnummer, '${verkauf.belegnummer}'),
          ParkscheinZeile(
            localizations.laufendeParkdauer,
            localizations.formatParkdauer(verkauf.parkdauerMinuten),
          ),
          ParkscheinZeile(
            localizations.betrag,
            localizations.formatBetrag(verkauf.betragCent),
          ),
          ParkscheinZeile(
            localizations.zahlungsart,
            localizations.zahlungsartName(verkauf.zahlungsart),
          ),
          ParkscheinZeile(
            localizations.gueltigBis,
            _gueltigBis(localizations, verkauf),
          ),
          if (verkauf.kennzeichen != null)
            ParkscheinZeile(localizations.kennzeichen, verkauf.kennzeichen!),
        ],
      );
      final speichern = parkscheinSpeichern ?? speichereParkschein;
      final ziel = await speichern(
        bytes,
        'parkschein-${verkauf.belegnummer}.pdf',
      );
      messenger.showSnackBar(
        SnackBar(
          content: Text('${localizations.parkscheinGespeichert}: $ziel'),
        ),
      );
    } on Object catch (fehler) {
      debugPrint(fehler.toString());
      messenger.showSnackBar(
        SnackBar(content: Text(localizations.parkscheinFehler)),
      );
    }
  }

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
