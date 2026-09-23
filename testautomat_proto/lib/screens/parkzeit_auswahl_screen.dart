import 'package:flutter/material.dart';

import 'package:testautomat_proto/app_scope.dart';
import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/data/seed_data.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/logic/doppelkauf.dart';
import 'package:testautomat_proto/logic/kennzeichen.dart';
import 'package:testautomat_proto/logic/preis.dart';
import 'package:testautomat_proto/routes.dart';
import 'package:testautomat_proto/screens/kaufablauf.dart';
import 'package:testautomat_proto/widgets/fortschritts_anzeige.dart';
import 'package:testautomat_proto/widgets/screen_shell.dart';

/// Auswahl von Parkzone, Parkzeit und optionalem Kennzeichen.
///
/// Reihenfolge aus `7_Neue_Zahlmoeglichkeiten.md`: Der Nutzer waehlt zuerst die
/// Zone und danach die Parkzeit; ein Zonenwechsel verwirft die gewaehlte
/// Parkzeit und verlangt eine neue Angabe. Erst „Weiter“ fuehrt zur Zahlung –
/// dabei wird ein Doppelkauf auf dasselbe, noch gueltige Kennzeichen abgelehnt.
/// Schrittweite und Preis kommen aus der aktiven Preisregel (E-15/E-02).
class ParkzeitAuswahlScreen extends StatefulWidget {
  const ParkzeitAuswahlScreen({super.key, this.jetzt});

  /// Zeitbasis fuer die Doppelkauf-Pruefung; Tests setzen sie fest.
  final DateTime? jetzt;

  /// Angebotene Vielfache des Parktakts: 4, 8, 12 und 24 Stunden bei 240 min.
  static const List<int> taktVielfache = <int>[1, 2, 3, 6];

  @override
  State<ParkzeitAuswahlScreen> createState() => _ParkzeitAuswahlScreenState();
}

/// Preisregel und Parkzonen des Bildschirms (eine Ladequelle).
class _ParkzeitDaten {
  const _ParkzeitDaten({required this.preissettings, required this.zonen});

  final List<Preissetting> preissettings;
  final List<Parkzone> zonen;
}

class _ParkzeitAuswahlScreenState extends State<ParkzeitAuswahlScreen> {
  final TextEditingController _kennzeichen = TextEditingController();

  Future<_ParkzeitDaten>? _daten;
  Parkzone? _zone;
  int? _parkdauerMinuten;
  String? _fehlermeldung;
  bool _pruefeLaeuft = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _daten ??= _lade();
  }

  @override
  void dispose() {
    _kennzeichen.dispose();
    super.dispose();
  }

  Future<_ParkzeitDaten> _lade() async {
    final repository = AppScope.of(context).repository;
    final preissettings = await repository.getPreissettings();
    final zonen = await repository.getParkzonen();
    return _ParkzeitDaten(preissettings: preissettings, zonen: zonen);
  }

  /// Zonenwechsel verwirft die gewaehlte Parkzeit (Anforderung).
  void _waehleZone(Parkzone zone) {
    setState(() {
      _zone = zone;
      _parkdauerMinuten = null;
      _fehlermeldung = null;
    });
  }

  void _waehleParkdauer(int minuten) {
    setState(() {
      _parkdauerMinuten = minuten;
      _fehlermeldung = null;
    });
  }

  Future<void> _weiter(
    AppLocalizations localizations, {
    required int taktMinuten,
    required int preisProTaktCent,
  }) async {
    final zone = _zone;
    final parkdauer = _parkdauerMinuten;
    if (zone == null || parkdauer == null || _pruefeLaeuft) {
      return;
    }

    final eingabe = _kennzeichen.text.trim();
    final kennzeichen = eingabe.isEmpty
        ? null
        : normalisiereKennzeichen(eingabe);
    if (kennzeichen != null && !istGueltigesKennzeichen(kennzeichen)) {
      setState(() => _fehlermeldung = localizations.kennzeichenUngueltig);
      return;
    }

    setState(() {
      _pruefeLaeuft = true;
      _fehlermeldung = null;
    });

    final repository = AppScope.of(context).repository;
    final jetzt = widget.jetzt ?? DateTime.now();
    if (kennzeichen != null) {
      final verkaeufe = await repository.getVerkaeufeZuKennzeichen(kennzeichen);
      if (aktivesTicket(verkaeufe, kennzeichen, jetzt) != null) {
        if (!mounted) {
          return;
        }
        setState(() {
          _pruefeLaeuft = false;
          _fehlermeldung = localizations.kennzeichenDoppelkauf;
        });
        return;
      }
    }

    if (!mounted) {
      return;
    }
    setState(() => _pruefeLaeuft = false);
    Navigator.of(context).pushNamed(
      AppRoutes.zahlung,
      arguments: KaufAuswahl(
        parkdauerMinuten: parkdauer,
        betragCent: preisFuerParkdauer(
          parkdauerMinuten: parkdauer,
          taktMinuten: taktMinuten,
          preisProTaktCent: preisProTaktCent,
        ),
        parkzone: zone,
        kennzeichen: kennzeichen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return ScreenShell(
      child: FutureBuilder<_ParkzeitDaten>(
        future: _daten,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: FortschrittsAnzeige());
          }
          final daten = snapshot.data!;
          final setting = aktivesPreissetting(
            daten.preissettings,
            DateTime.now(),
          );
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
                Text(
                  localizations.parkzoneWaehlen,
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final zone in daten.zonen)
                      ChoiceChip(
                        label: Text(zone.name),
                        selected: zone.id == _zone?.id,
                        onSelected: (_) => _waehleZone(zone),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                if (_zone == null) ...[
                  Text(
                    localizations.parkzeitZonenHinweis,
                    style: textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                ],
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final vielfaches
                        in ParkzeitAuswahlScreen.taktVielfache)
                      _ParkzeitKnopf(
                        beschriftung: _knopfText(
                          localizations,
                          parkdauerMinuten: taktMinuten * vielfaches,
                          taktMinuten: taktMinuten,
                          preisProTaktCent: preisProTaktCent,
                        ),
                        gewaehlt: _parkdauerMinuten == taktMinuten * vielfaches,
                        onPressed: _zone == null
                            ? null
                            : () => _waehleParkdauer(taktMinuten * vielfaches),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: _kennzeichen,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: localizations.kennzeichenHinweis,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                if (_fehlermeldung != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _fehlermeldung!,
                    style: textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _zone == null || _parkdauerMinuten == null
                      ? null
                      : () => _weiter(
                          localizations,
                          taktMinuten: taktMinuten,
                          preisProTaktCent: preisProTaktCent,
                        ),
                  child: Text(localizations.weiter),
                ),
                const SizedBox(height: 8),
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
}

/// Parkzeit-Knopf; hervorgehoben, solange die Parkdauer gewaehlt ist.
class _ParkzeitKnopf extends StatelessWidget {
  const _ParkzeitKnopf({
    required this.beschriftung,
    required this.gewaehlt,
    required this.onPressed,
  });

  final String beschriftung;
  final bool gewaehlt;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final label = Text(beschriftung);
    return gewaehlt
        ? FilledButton(onPressed: onPressed, child: label)
        : OutlinedButton(onPressed: onPressed, child: label);
  }
}
