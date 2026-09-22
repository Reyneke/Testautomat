import 'package:flutter/material.dart';

import 'package:testautomat_proto/l10n/app_format.dart';
import 'package:testautomat_proto/l10n/app_locale.dart';
import 'package:testautomat_proto/l10n/generated/app_localizations.dart';

/// App-Helfer auf den erzeugten Texten (E-17/U-70).
///
/// Bewusst als Erweiterung statt als eigene Klasse: die erzeugte
/// [AppLocalizations] bleibt die einzige Quelle der Texte, die Aufrufstellen
/// (`AppLocalizations.of(context)!.xyz`, `formatBetrag(...)`) bleiben
/// unveraendert. Formatierung von Datum und Uhrzeit kommt aus `intl`
/// ([AppFormat], E-18).
extension AppLocalizationsHelfer on AppLocalizations {
  /// Aktive Sprache als [Locale].
  Locale get sprache => Locale(localeName.split('_').first);

  /// Sprache ist Englisch?
  bool get istEnglisch => AppLocale.istEnglisch(sprache);

  /// Geldbetrag als Text, z. B. `2,00 €` bzw. `€2.00`.
  String formatBetrag(int cent) {
    final betrag = cent.abs();
    final euro = betrag ~/ 100;
    final rest = (betrag % 100).toString().padLeft(2, '0');
    final vorzeichen = cent < 0 ? '-' : '';
    return istEnglisch
        ? '$vorzeichen\u20ac$euro.$rest'
        : '$vorzeichen$euro,$rest \u20ac';
  }

  /// Parkdauer als Text, z. B. `4 Stunden` bzw. `4 hours`.
  String formatParkdauer(int minuten) {
    final stunden = minuten ~/ 60;
    final restMinuten = minuten % 60;
    final String stundenText;
    if (istEnglisch) {
      stundenText = stunden == 1 ? '1 hour' : '$stunden hours';
    } else {
      stundenText = stunden == 1 ? '1 Stunde' : '$stunden Stunden';
    }
    return restMinuten == 0 ? stundenText : '$stundenText $restMinuten min';
  }

  /// Uhrzeit im lokalen Muster, z. B. `08:05` bzw. `8:05 AM` (E-18).
  String formatTime(DateTime dateTime) => AppFormat.zeit(dateTime, sprache);

  /// Datum im lokalen Muster, z. B. `18.9.2026` bzw. `9/18/2026` (E-18).
  String formatDate(DateTime dateTime) => AppFormat.datum(dateTime, sprache);

  /// Uhrzeitangemessene Begrüßung für den übergebenen Zeitpunkt.
  String greetingFor(DateTime dateTime) {
    final hour = dateTime.hour;
    if (hour >= 5 && hour < 11) {
      return greetingMorning;
    }
    if (hour >= 11 && hour < 18) {
      return greetingAfternoon;
    }
    if (hour >= 18 && hour < 22) {
      return greetingEvening;
    }
    return greetingNight;
  }
}
