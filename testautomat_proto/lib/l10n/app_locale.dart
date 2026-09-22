import 'package:flutter/material.dart';

/// Unterstuetzte Sprachen der App (E-06, E-08).
///
/// Die jeweils aktive Sprache liegt im `AppState` (`AppState.locale`), damit der
/// Zustand injizierbar bleibt (E-46); hier stehen nur die Konstanten.
abstract class AppLocale {
  /// Unterstuetzte Sprachen: Deutsch und Englisch.
  static const List<Locale> supportedLocales = [Locale('de'), Locale('en')];

  /// Standardsprache, falls keine gueltige Auswahl vorliegt.
  static const Locale fallbackLocale = Locale('de');

  /// Ist die Sprache unterstuetzt (E-08)?
  static bool unterstuetzt(Locale locale) => supportedLocales.any(
    (sprache) => sprache.languageCode == locale.languageCode,
  );

  /// Ist die Sprache Englisch?
  static bool istEnglisch(Locale locale) => locale.languageCode == 'en';

  /// Ordnet die Systemeinstellung des Geraets einer unterstuetzten Sprache zu
  /// (E-19).
  ///
  /// Beim ersten Start folgt die App der Systemsprache; alles, was nicht
  /// unterstuetzt wird, faellt auf [fallbackLocale] zurueck.
  static Locale vomSystem(Locale? system) {
    if (system != null && unterstuetzt(system)) {
      return Locale(system.languageCode);
    }
    return fallbackLocale;
  }
}
