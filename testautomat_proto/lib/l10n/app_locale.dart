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
}
