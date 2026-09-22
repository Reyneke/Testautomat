import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart' as intl_daten;
import 'package:intl/intl.dart' as intl;

import 'package:testautomat_proto/l10n/app_locale.dart';

/// Lokalisierte Formatierung von Datum und Uhrzeit (E-18, U-70).
///
/// Die Muster stammen aus `intl` statt aus eigener Zeichenkettenrechnung:
/// `DateFormat.jm` liefert je nach Sprache die passende Stundenzaehlung
/// (Deutsch `08:05`, Englisch `8:05 AM`), `DateFormat.yMd` das landesuebliche
/// Datum (Deutsch `18.09.2026`, Englisch `9/18/2026`). `intl` bringt den
/// Namen `Locale` mit, deshalb der Import unter dem Praefix `intl`.
///
/// `intl` braucht seine Sprachdaten, bevor formatiert wird; [sicherstellen]
/// stellt sie fuer Deutsch und Englisch bereit und wird bei Bedarf automatisch
/// aufgerufen.
abstract class AppFormat {
  static bool _bereit = false;

  /// Stellt die Datums-Sprachdaten fuer Deutsch und Englisch bereit (einmalig).
  static void sicherstellen() {
    if (_bereit) {
      return;
    }
    // Die Initialisierung fuellt die Tabellen synchron; das Future ist sofort
    // erfuellt und wird deshalb nicht abgewartet.
    unawaited(intl_daten.initializeDateFormatting('de'));
    unawaited(intl_daten.initializeDateFormatting('en'));
    _bereit = true;
  }

  /// intl-Sprachkuerzel zur aktiven Sprache (`de` oder `en`).
  static String sprachkuerzel(Locale locale) =>
      AppLocale.istEnglisch(locale) ? 'en' : 'de';

  /// Uhrzeit, z. B. `08:05` (deutsch) bzw. `8:05 AM` (englisch).
  static String zeit(DateTime zeitpunkt, Locale locale) {
    sicherstellen();
    return intl.DateFormat.jm(sprachkuerzel(locale)).format(zeitpunkt);
  }

  /// Datum, z. B. `18.09.2026` (deutsch) bzw. `9/18/2026` (englisch).
  static String datum(DateTime zeitpunkt, Locale locale) {
    sicherstellen();
    return intl.DateFormat.yMd(sprachkuerzel(locale)).format(zeitpunkt);
  }
}
