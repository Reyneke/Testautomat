import 'dart:async';

import 'package:flutter/foundation.dart';

/// Uhrzeit der App im 30-Sekunden-Takt (E-26).
///
/// Ein einziger Timer versorgt alle Anzeigen (Kopfzeile, Begruessung). Die
/// Nutzer zaehlen mit, damit ein Bildschirmwechsel den Takt nicht beendet;
/// beim letzten Nutzer wird der Timer abgebrochen (kein laufender Timer in
/// Tests, vgl. U-51).
///
/// Spaeter kommt die Pause im Hintergrund dazu (E-27, U-71).
abstract final class AppClock {
  /// Takt der Uhr (E-26).
  static const Duration takt = Duration(seconds: 30);

  /// Aktuelle Uhrzeit; aendert sich im [takt].
  static final ValueNotifier<DateTime> notifier = ValueNotifier<DateTime>(
    DateTime.now(),
  );

  static Timer? _timer;
  static int _nutzer = 0;

  /// Meldet einen Nutzer an und startet den Takt beim ersten Nutzer.
  static void start() {
    _nutzer += 1;
    _timer ??= Timer.periodic(takt, (_) => tick());
  }

  /// Meldet einen Nutzer ab; beim letzten Nutzer stoppt der Takt.
  static void stop() {
    if (_nutzer > 0) {
      _nutzer -= 1;
    }
    if (_nutzer == 0) {
      _timer?.cancel();
      _timer = null;
    }
  }

  /// Setzt die Uhrzeit auf den aktuellen Wert (auch fuer Tests).
  static void tick() => notifier.value = DateTime.now();

  /// Setzt Timer und Uhrzeit zurueck (Tests, vgl. E-46).
  static void reset() {
    _timer?.cancel();
    _timer = null;
    _nutzer = 0;
    notifier.value = DateTime.now();
  }
}
