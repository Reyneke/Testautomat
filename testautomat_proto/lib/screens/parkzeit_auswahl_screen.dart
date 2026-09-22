import 'package:flutter/material.dart';

import 'package:testautomat_proto/app_scope.dart';
import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/data/seed_data.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/logic/preis.dart';
import 'package:testautomat_proto/routes.dart';
import 'package:testautomat_proto/screens/kaufablauf.dart';
import 'package:testautomat_proto/widgets/screen_shell.dart';

/// Auswahl der Parkzeit in Vier-Stunden-Schritten (`0_Einfuehrung.md`).
///
/// Schrittweite und Preis kommen aus der aktiven Preisregel (E-15/E-02): jeder
/// angefangene Takt zaehlt voll. Die Preise werden direkt am Knopf angezeigt.
class ParkzeitAuswahlScreen extends StatefulWidget {
  const ParkzeitAuswahlScreen({super.key});

  /// Angebotene Vielfache des Parktakts: 4, 8, 12 und 24 Stunden bei 240 min.
  static const List<int> taktVielfache = <int>[1, 2, 3, 6];

  @override
  State<ParkzeitAuswahlScreen> createState() => _ParkzeitAuswahlScreenState();
}

class _ParkzeitAuswahlScreenState extends State<ParkzeitAuswahlScreen> {
  Future<List<Preissetting>>? _preissettings;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _preissettings ??= AppScope.of(context).repository.getPreissettings();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return ScreenShell(
      child: FutureBuilder<List<Preissetting>>(
        future: _preissettings,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final setting = aktivesPreissetting(snapshot.data!, DateTime.now());
          final taktMinuten = setting?.taktMinuten ?? SeedData.parktaktMinuten;
          final preisProTaktCent =
              setting?.preisProTaktCent ?? SeedData.preisProTaktCent;

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  localizations.parkzeitAuswahlTitle,
                  style: textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.parkzeitAuswahlHinweis,
                  style: textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final vielfaches
                        in ParkzeitAuswahlScreen.taktVielfache)
                      FilledButton(
                        onPressed: () => _waehlen(
                          parkdauerMinuten: taktMinuten * vielfaches,
                          taktMinuten: taktMinuten,
                          preisProTaktCent: preisProTaktCent,
                        ),
                        child: Text(
                          _knopfText(
                            localizations,
                            parkdauerMinuten: taktMinuten * vielfaches,
                            taktMinuten: taktMinuten,
                            preisProTaktCent: preisProTaktCent,
                          ),
                        ),
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
          );
        },
      ),
    );
  }

  String _knopfText(
    AppLocalizations localizations, {
    required int parkdauerMinuten,
    required int taktMinuten,
    required int preisProTaktCent,
  }) {
    final betragCent = preisFuerParkdauer(
      parkdauerMinuten: parkdauerMinuten,
      taktMinuten: taktMinuten,
      preisProTaktCent: preisProTaktCent,
    );
    return '${localizations.formatParkdauer(parkdauerMinuten)} \u00b7 '
        '${localizations.formatBetrag(betragCent)}';
  }

  void _waehlen({
    required int parkdauerMinuten,
    required int taktMinuten,
    required int preisProTaktCent,
  }) {
    Navigator.of(context).pushNamed(
      AppRoutes.zahlung,
      arguments: KaufAuswahl(
        parkdauerMinuten: parkdauerMinuten,
        betragCent: preisFuerParkdauer(
          parkdauerMinuten: parkdauerMinuten,
          taktMinuten: taktMinuten,
          preisProTaktCent: preisProTaktCent,
        ),
      ),
    );
  }
}
