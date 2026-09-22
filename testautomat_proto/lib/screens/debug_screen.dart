import 'package:flutter/material.dart';

import 'package:testautomat_proto/app_scope.dart';
import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/screens/debug_dialogs.dart';
import 'package:testautomat_proto/state/app_debug.dart';
import 'package:testautomat_proto/widgets/fortschritts_anzeige.dart';
import 'package:testautomat_proto/widgets/screen_shell.dart';

/// Debug-Bildschirm des Prototyps (E-22, E-12, E-10, E-04).
///
/// Zeigt Verkaeufe als Tabelle und Balken aus derselben Zeitreihe, die
/// Telemetrie nur lesend sowie Preissettings und Verkaufszeiten zum Bearbeiten.
/// Alle Zugriffe laufen ausschliesslich ueber das Repository ([AppScope]) - kein
/// Widget greift direkt auf die Datenbank zu.
class DebugScreen extends StatefulWidget {
  const DebugScreen({
    super.key,
    this.von,
    this.bis,
    this.telemetriePunkte = 96,
  });

  /// Beginn des Umsatz-Zeitraums (UTC); Standard: vor sechs Tagen.
  final DateTime? von;

  /// Ende des Umsatz-Zeitraums (UTC, exklusiv); Standard: morgen.
  final DateTime? bis;

  /// Angezeigte Telemetrie-Messpunkte (96 = 24 Stunden im 15-Minuten-Takt).
  final int telemetriePunkte;

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  List<Tagesumsatz>? _tagesumsaetze;
  List<Telemetrie>? _telemetrie;
  List<Preissetting>? _preissettings;
  List<Verkaufszeit>? _verkaufszeiten;
  String? _fehler;
  bool _gestartet = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_gestartet) {
      _gestartet = true;
      _lade();
    }
  }

  DateTime get _von =>
      widget.von ?? _heuteUtc().subtract(const Duration(days: 6));

  DateTime get _bis => widget.bis ?? _heuteUtc().add(const Duration(days: 1));

  DateTime _heuteUtc() {
    final jetzt = DateTime.now().toUtc();
    return DateTime.utc(jetzt.year, jetzt.month, jetzt.day);
  }

  Future<void> _lade() async {
    final localizations = AppLocalizations.of(context)!;
    final repository = AppScope.of(context).repository;
    try {
      final tagesumsaetze = await repository.getTagesumsaetze(_von, _bis);
      final alleMesswerte = await repository.getTelemetrie();
      final preissettings = await repository.getPreissettings();
      final verkaufszeiten = await repository.getVerkaufszeiten();
      final messwerte = alleMesswerte.length > widget.telemetriePunkte
          ? alleMesswerte.sublist(
              alleMesswerte.length - widget.telemetriePunkte,
            )
          : alleMesswerte;
      if (!mounted) {
        return;
      }
      setState(() {
        _tagesumsaetze = tagesumsaetze;
        _telemetrie = messwerte.reversed.toList();
        _preissettings = preissettings;
        _verkaufszeiten = verkaufszeiten;
        _fehler = null;
      });
    } on Object {
      if (!mounted) {
        return;
      }
      setState(() => _fehler = localizations.debugLadefehler);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    if (_tagesumsaetze == null && _fehler == null) {
      return const ScreenShell(child: Center(child: FortschrittsAnzeige()));
    }

    return ScreenShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  localizations.debugTitle,
                  style: textTheme.displaySmall,
                ),
              ),
              TextButton.icon(
                onPressed: _abmelden,
                icon: const Icon(Icons.lock_outline),
                label: Text(localizations.debugAbmelden),
              ),
            ],
          ),
          if (!AppDebug.bearbeitungErlaubtImBuild)
            Text(
              localizations.debugSchreibgeschuetzt,
              style: textTheme.bodySmall,
            ),
          if (_fehler != null) Text(_fehler!, style: textTheme.bodyLarge),
          const SizedBox(height: 16),
          _Abschnittstitel(text: localizations.debugVerkaeufe),
          ..._verkaufsInhalt(context, localizations, textTheme),
          const SizedBox(height: 24),
          _Abschnittstitel(text: localizations.debugTelemetrie),
          ..._telemetrieInhalt(localizations, textTheme),
          const SizedBox(height: 24),
          _Abschnittstitel(text: localizations.debugPreissettings),
          ..._preissettingsInhalt(localizations, textTheme),
          const SizedBox(height: 24),
          _Abschnittstitel(text: localizations.debugVerkaufszeiten),
          ..._verkaufszeitenInhalt(localizations, textTheme),
        ],
      ),
    );
  }

  void _abmelden() {
    AppScope.of(context).zustand.debugAbmelden();
    Navigator.of(context).pop();
  }

  List<Widget> _verkaufsInhalt(
    BuildContext context,
    AppLocalizations localizations,
    TextTheme textTheme,
  ) {
    final tage = _tagesumsaetze ?? const <Tagesumsatz>[];
    if (tage.isEmpty) {
      return <Widget>[
        Text(localizations.debugKeineVerkaeufe, style: textTheme.bodyMedium),
      ];
    }
    final hoechster = tage
        .map((tag) => tag.umsatzCent)
        .reduce(
          (aktuell, naechster) => naechster > aktuell ? naechster : aktuell,
        );

    return <Widget>[
      // Tabelle: UTC-Tag, lokal angezeigt (E-03).
      for (final tag in tage)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  localizations.formatDate(tag.tagUtc.toLocal()),
                  style: textTheme.bodyMedium,
                ),
              ),
              Text(
                localizations.formatBetrag(tag.umsatzCent),
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      const SizedBox(height: 12),
      // Balken aus genau derselben Zeitreihe (E-12).
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var index = 0; index < tage.length; index++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  key: ValueKey<String>('debug-balken-$index'),
                  height: _balkenhoehe(tage[index].umsatzCent, hoechster),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ];
  }

  double _balkenhoehe(int wert, int hoechster) =>
      hoechster == 0 ? 4 : 4 + (wert / hoechster) * 56;

  List<Widget> _telemetrieInhalt(
    AppLocalizations localizations,
    TextTheme textTheme,
  ) {
    final messwerte = _telemetrie ?? const <Telemetrie>[];
    if (messwerte.isEmpty) {
      return <Widget>[
        Text(localizations.debugKeineDaten, style: textTheme.bodyMedium),
      ];
    }
    return <Widget>[
      _Zeile(
        textTheme: textTheme,
        fett: true,
        werte: <String>[
          localizations.debugZeitpunkt,
          localizations.debugStromverbrauch,
          localizations.debugBatterie,
          localizations.debugSignal,
          localizations.debugPacketloss,
        ],
      ),
      for (final messwert in messwerte)
        _Zeile(
          textTheme: textTheme,
          werte: <String>[
            '${localizations.formatDate(messwert.timestamp.toLocal())} '
                '${localizations.formatTime(messwert.timestamp.toLocal())}',
            '${messwert.stromverbrauchWatt} W',
            '${messwert.batteriestandProzent} %',
            '${messwert.signalStaerkeDbm} dBm',
            '${messwert.packetlossProzent} %',
          ],
        ),
    ];
  }

  List<Widget> _preissettingsInhalt(
    AppLocalizations localizations,
    TextTheme textTheme,
  ) {
    final settings = _preissettings ?? const <Preissetting>[];
    if (settings.isEmpty) {
      return <Widget>[
        Text(localizations.debugKeineDaten, style: textTheme.bodyMedium),
      ];
    }
    return <Widget>[
      for (final setting in settings)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${setting.taktMinuten} min | '
                  '${localizations.formatBetrag(setting.preisProTaktCent)} | '
                  '${setting.waehrung}',
                  style: textTheme.bodyMedium,
                ),
              ),
              if (AppDebug.bearbeitungErlaubtImBuild)
                TextButton(
                  onPressed: () => _bearbeitePreissetting(setting),
                  child: Text(localizations.debugAendern),
                ),
            ],
          ),
        ),
    ];
  }

  List<Widget> _verkaufszeitenInhalt(
    AppLocalizations localizations,
    TextTheme textTheme,
  ) {
    final zeiten = _verkaufszeiten ?? const <Verkaufszeit>[];
    if (zeiten.isEmpty) {
      return <Widget>[
        Text(localizations.debugKeineDaten, style: textTheme.bodyMedium),
      ];
    }
    return <Widget>[
      for (final zeit in zeiten)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${localizations.debugWochentag} ${zeit.wochentag}: '
                  '${zeit.beginn}-${zeit.ende}',
                  style: textTheme.bodyMedium,
                ),
              ),
              if (AppDebug.bearbeitungErlaubtImBuild)
                TextButton(
                  onPressed: () => _bearbeiteVerkaufszeit(zeit),
                  child: Text(localizations.debugAendern),
                ),
            ],
          ),
        ),
    ];
  }

  Future<void> _bearbeitePreissetting(Preissetting setting) async {
    final localizations = AppLocalizations.of(context)!;
    final repository = AppScope.of(context).repository;
    final neu = await showDialog<Preissetting>(
      context: context,
      builder: (context) => PreissettingDialog(vorlage: setting),
    );
    if (neu == null) {
      return;
    }
    try {
      await repository.updatePreissetting(neu);
      await _lade();
    } on Object {
      if (!mounted) {
        return;
      }
      setState(() => _fehler = localizations.debugSpeicherfehler);
    }
  }

  Future<void> _bearbeiteVerkaufszeit(Verkaufszeit zeit) async {
    final localizations = AppLocalizations.of(context)!;
    final repository = AppScope.of(context).repository;
    final neu = await showDialog<Verkaufszeit>(
      context: context,
      builder: (context) => VerkaufszeitDialog(vorlage: zeit),
    );
    if (neu == null) {
      return;
    }
    try {
      await repository.updateVerkaufszeit(neu);
      await _lade();
    } on Object {
      if (!mounted) {
        return;
      }
      setState(() => _fehler = localizations.debugSpeicherfehler);
    }
  }
}

/// Abschnittsueberschrift im Debug-Bildschirm.
class _Abschnittstitel extends StatelessWidget {
  const _Abschnittstitel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: Theme.of(context).textTheme.titleLarge),
  );
}

/// Tabellenzeile mit gleich breiten Spalten.
class _Zeile extends StatelessWidget {
  const _Zeile({
    required this.textTheme,
    required this.werte,
    this.fett = false,
  });

  final TextTheme textTheme;
  final List<String> werte;
  final bool fett;

  @override
  Widget build(BuildContext context) {
    final stil = fett
        ? textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)
        : textTheme.bodySmall;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          for (final wert in werte) Expanded(child: Text(wert, style: stil)),
        ],
      ),
    );
  }
}
