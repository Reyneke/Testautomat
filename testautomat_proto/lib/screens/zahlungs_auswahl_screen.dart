import 'dart:async';

import 'package:flutter/material.dart';

import 'package:testautomat_proto/app_scope.dart';
import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/data/seed_data.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/logic/verkaufszeit.dart';
import 'package:testautomat_proto/routes.dart';
import 'package:testautomat_proto/screens/kaufablauf.dart';
import 'package:testautomat_proto/widgets/fortschritts_anzeige.dart';
import 'package:testautomat_proto/widgets/screen_shell.dart';

/// Auswahl der Zahlungsart und simulierter Zahlungsablauf (E-51).
///
/// Phasen: Auswahl, Verarbeitung mit Fortschritt und Timeout, Fehler sowie der
/// Abschluss ueber das atomare `createSale` (E-16). Es gibt keinen echten
/// Zahlungsdienst; der Beleg wird nur angezeigt (kein PDF, kein Druck).
class ZahlungsAuswahlScreen extends StatefulWidget {
  const ZahlungsAuswahlScreen({
    super.key,
    this.fortschrittDauer = const Duration(seconds: 2),
    this.timeoutDauer = const Duration(seconds: 30),
  });

  /// Dauer der simulierten Zahlungsverarbeitung.
  final Duration fortschrittDauer;

  /// Nach dieser Zeit bricht die Verarbeitung mit einer Meldung ab.
  final Duration timeoutDauer;

  @override
  State<ZahlungsAuswahlScreen> createState() => _ZahlungsAuswahlScreenState();
}

enum _Phase { auswahl, verarbeitung, fehler }

class _ZahlungsAuswahlScreenState extends State<ZahlungsAuswahlScreen> {
  /// Takt der Fortschrittsanzeige.
  static const Duration _fortschrittTakt = Duration(milliseconds: 100);

  _Phase _phase = _Phase.auswahl;
  double _fortschritt = 0;
  String? _fehlermeldung;
  KaufAuswahl? _auswahl;
  Timer? _fortschrittsTimer;
  Timer? _timeoutTimer;

  @override
  void dispose() {
    _stoppeTimer();
    super.dispose();
  }

  void _stoppeTimer() {
    _fortschrittsTimer?.cancel();
    _timeoutTimer?.cancel();
    _fortschrittsTimer = null;
    _timeoutTimer = null;
  }

  void _waehle(Zahlungsart art, KaufAuswahl auswahl) {
    final schritte =
        widget.fortschrittDauer.inMilliseconds ~/
        _fortschrittTakt.inMilliseconds;
    setState(() {
      _auswahl = auswahl.mitZahlungsart(art);
      _phase = _Phase.verarbeitung;
      _fortschritt = 0;
      _fehlermeldung = null;
    });

    var gelaufen = 0;
    _fortschrittsTimer = Timer.periodic(_fortschrittTakt, (timer) {
      gelaufen += 1;
      if (!mounted) {
        return;
      }
      setState(() {
        _fortschritt = (gelaufen / (schritte <= 0 ? 1 : schritte)).clamp(0, 1);
      });
      if (gelaufen >= schritte) {
        timer.cancel();
        _fortschrittsTimer = null;
        unawaited(_verkaufe());
      }
    });

    _timeoutTimer = Timer(widget.timeoutDauer, () {
      if (!mounted || _phase != _Phase.verarbeitung) {
        return;
      }
      _stoppeTimer();
      setState(() {
        _phase = _Phase.fehler;
        _fehlermeldung = AppLocalizations.of(context)!.zahlungTimeout;
      });
    });
  }

  /// Bricht die Verarbeitung ab (E-51: Abbruch durch den Nutzer).
  void _abbrechen() {
    _stoppeTimer();
    setState(() {
      _phase = _Phase.auswahl;
      _fortschritt = 0;
      _fehlermeldung = null;
    });
  }

  Future<void> _verkaufe() async {
    final auswahl = _auswahl;
    if (auswahl == null) {
      return;
    }
    final scope = AppScope.of(context);
    final repository = scope.repository;
    final localizations = AppLocalizations.of(context)!;

    Verkauf? verkauf;
    String? fehlermeldung;
    try {
      final maschine =
          scope.zustand.maschine.value ?? await repository.getMachine();
      final jetzt = DateTime.now();
      final fenster = await repository.getVerkaufszeiten();
      if (!istInVerkaufszeit(fenster: fenster, jetztUtc: jetzt)) {
        fehlermeldung = localizations.ausserhalbVerkaufszeit;
      } else {
        verkauf = await repository.createSale(
          VerkaufDraft(
            maschineId: maschine.id,
            timestamp: jetzt,
            parkdauerMinuten: auswahl.parkdauerMinuten,
            betragCent: auswahl.betragCent,
            zahlungsart: auswahl.zahlungsart ?? Zahlungsart.bar,
          ),
        );
      }
    } on Object catch (fehler, spur) {
      debugPrint(fehler.toString());
      debugPrint(spur.toString());
      fehlermeldung = localizations.zahlungFehlgeschlagen;
    }

    if (!mounted) {
      return;
    }
    _stoppeTimer();

    if (verkauf != null) {
      await Navigator.of(
        context,
      ).pushReplacementNamed(AppRoutes.parkinfo, arguments: verkauf);
      return;
    }
    setState(() {
      _phase = _Phase.fehler;
      _fehlermeldung = fehlermeldung ?? localizations.zahlungFehlgeschlagen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final auswahl = KaufAuswahl.aus(
      ModalRoute.of(context)?.settings.arguments,
      standardParkdauerMinuten: SeedData.parktaktMinuten,
      standardBetragCent: SeedData.preisProTaktCent,
    );

    return ScreenShell(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: switch (_phase) {
            _Phase.auswahl => _auswahlInhalt(localizations, textTheme, auswahl),
            _Phase.verarbeitung => <Widget>[
              Text(
                localizations.zahlungLaeuft,
                style: textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 320,
                child: FortschrittsAnzeige(wert: _fortschritt),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: _abbrechen,
                child: Text(localizations.zahlungAbbrechen),
              ),
            ],
            _Phase.fehler => <Widget>[
              Text(
                _fehlermeldung ?? localizations.zahlungFehlgeschlagen,
                style: textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _abbrechen,
                child: Text(localizations.erneutVersuchen),
              ),
            ],
          },
        ),
      ),
    );
  }

  List<Widget> _auswahlInhalt(
    AppLocalizations localizations,
    TextTheme textTheme,
    KaufAuswahl auswahl,
  ) => <Widget>[
    Text(
      localizations.zahlungTitle,
      style: textTheme.displaySmall,
      textAlign: TextAlign.center,
    ),
    const SizedBox(height: 8),
    Text(
      '${localizations.formatParkdauer(auswahl.parkdauerMinuten)} \u00b7 '
      '${localizations.formatBetrag(auswahl.betragCent)}',
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
          onPressed: () => _waehle(Zahlungsart.bar, auswahl),
          child: Text(localizations.zahlungsartBar),
        ),
        FilledButton(
          onPressed: () => _waehle(Zahlungsart.karte, auswahl),
          child: Text(localizations.zahlungsartKarte),
        ),
      ],
    ),
    const SizedBox(height: 24),
    TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text(localizations.zurueck),
    ),
  ];
}
