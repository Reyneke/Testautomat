import 'package:flutter/material.dart';

import 'package:testautomat_proto/app_scope.dart';
import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/data/seed_data.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/routes.dart';
import 'package:testautomat_proto/screens/kaufablauf.dart';
import 'package:testautomat_proto/widgets/screen_shell.dart';

/// Auswahl der Parkzeit in Vier-Stunden-Schritten (`0_Einfuehrung.md`).
///
/// Die Schrittweite kommt aus der Preisregel (`preissetting.takt_minuten`, ueber
/// [AppScope]); die Preisbildung folgt mit U-31.
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
          final taktMinuten = snapshot.data!.isEmpty
              ? SeedData.parktaktMinuten
              : snapshot.data!.first.taktMinuten;

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
                        onPressed: () => _waehlen(taktMinuten * vielfaches),
                        child: Text(
                          localizations.formatParkdauer(
                            taktMinuten * vielfaches,
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

  void _waehlen(int parkdauerMinuten) {
    Navigator.of(context).pushNamed(
      AppRoutes.zahlung,
      arguments: KaufAuswahl(parkdauerMinuten: parkdauerMinuten),
    );
  }
}
