import 'dart:async';

import 'package:flutter/material.dart';

import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/l10n/app_locale.dart';
import 'package:testautomat_proto/state/app_debug.dart';

/// Uhrzeit der App im 30-Sekunden-Takt (E-26, E-27).
///
/// Ein Timer versorgt alle Anzeigen (Kopfzeile, Begruessung). Die Nutzer zaehlen
/// mit, damit ein Bildschirmwechsel den Takt nicht beendet; beim letzten Nutzer
/// wird der Timer abgebrochen - so bleibt in Tests kein Timer zurueck (U-51).
/// Im Hintergrund pausiert der Takt und aktualisiert beim Zurueckkommen sofort
/// (E-27).
class AppClock {
  /// Takt der Uhr (E-26).
  static const Duration takt = Duration(seconds: 30);

  /// Aktuelle Uhrzeit; aendert sich im [takt].
  final ValueNotifier<DateTime> notifier = ValueNotifier<DateTime>(
    DateTime.now(),
  );

  Timer? _timer;
  int _nutzer = 0;
  bool _hintergrund = false;

  /// Laeuft der Takt gerade (nur fuer Tests)?
  @visibleForTesting
  bool get laeuft => _timer != null;

  /// Ist der Takt wegen des Hintergrunds pausiert (E-27)?
  @visibleForTesting
  bool get pausiert => _hintergrund;

  /// Meldet einen Nutzer an und startet den Takt beim ersten Nutzer.
  void start() {
    _nutzer += 1;
    _takten();
  }

  /// Meldet einen Nutzer ab; beim letzten Nutzer stoppt der Takt.
  void stop() {
    if (_nutzer > 0) {
      _nutzer -= 1;
    }
    if (_nutzer == 0) {
      _timer?.cancel();
      _timer = null;
    }
  }

  /// Die App ist im Hintergrund: der Takt pausiert (E-27).
  void pausieren() {
    _hintergrund = true;
    _timer?.cancel();
    _timer = null;
  }

  /// Die App ist wieder im Vordergrund: sofort aktualisieren und weiter (E-27).
  void fortsetzen() {
    if (!_hintergrund) {
      return;
    }
    _hintergrund = false;
    if (_nutzer > 0) {
      tick();
      _takten();
    }
  }

  /// Startet den Takt, sofern Nutzer anwesend und nicht im Hintergrund.
  void _takten() {
    if (_hintergrund || _nutzer == 0) {
      return;
    }
    _timer ??= Timer.periodic(takt, (_) => tick());
  }

  /// Setzt die Uhrzeit auf den aktuellen Wert (auch fuer Tests).
  void tick() => notifier.value = DateTime.now();

  /// Stoppt den Takt und setzt den Zaehler zurueck.
  void reset() {
    _timer?.cancel();
    _timer = null;
    _nutzer = 0;
    _hintergrund = false;
    notifier.value = DateTime.now();
  }

  /// Gibt Timer und Notifier frei.
  void dispose() {
    reset();
    notifier.dispose();
  }
}

/// Buendelt den globalen Zustand der App (E-06, E-22, E-46, E-55).
///
/// `main.dart` erzeugt genau eine Instanz und stellt sie ueber den AppScope
/// bereit; Tests erzeugen eigene Instanzen und bekommen damit isolierten Zustand
/// - die frueheren statischen Felder entfallen (E-46).
class AppState {
  AppState()
    : themeMode = ValueNotifier<ThemeMode>(ThemeMode.dark),
      locale = ValueNotifier<Locale>(AppLocale.fallbackLocale),
      maschine = ValueNotifier<Maschine?>(null),
      debugAngemeldet = ValueNotifier<bool>(false);

  /// Darstellungsmodus (Standard: Dunkel, E-07).
  final ValueNotifier<ThemeMode> themeMode;

  /// Aktuelle Sprache (E-06).
  final ValueNotifier<Locale> locale;

  /// Aktive Maschine (E-55); `null`, solange sie nicht geladen ist.
  final ValueNotifier<Maschine?> maschine;

  /// Ist der Debug-Bildschirm freigeschaltet (E-22)?
  final ValueNotifier<bool> debugAngemeldet;

  /// Uhrzeit der Kopfzeile (E-26).
  final AppClock clock = AppClock();

  /// Wechselt den Darstellungsmodus (E-07).
  void setzeThemeMode(ThemeMode neu) => themeMode.value = neu;

  /// Wechselt die Sprache, sofern sie unterstuetzt wird (E-08).
  void setLocale(Locale neu) {
    if (AppLocale.unterstuetzt(neu)) {
      locale.value = neu;
    }
  }

  /// Prueft die Debug-PIN und schaltet bei Erfolg frei (E-22).
  bool pruefeDebugPin(String eingabe) {
    final erfolg = eingabe.trim() == AppDebug.pin;
    if (erfolg) {
      debugAngemeldet.value = true;
    }
    return erfolg;
  }

  /// Sperrt den Debug-Zugang wieder (E-22).
  void debugAbmelden() => debugAngemeldet.value = false;

  /// Setzt alle Zustaende zurueck (Tests, vgl. E-46).
  void reset() {
    themeMode.value = ThemeMode.dark;
    locale.value = AppLocale.fallbackLocale;
    maschine.value = null;
    debugAngemeldet.value = false;
    clock.reset();
  }
}
