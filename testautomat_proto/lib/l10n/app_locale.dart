import 'package:flutter/material.dart';

/// Hält die aktuell gewählte Sprache der App.
///
/// Die Sprache kann jederzeit zur Laufzeit gewechselt werden, siehe
/// `doc/plan/grundlagen/1_Frontendstruktur.md`.
abstract class AppLocale {
  /// Unterstützte Sprachen: Deutsch und Englisch.
  static const List<Locale> supportedLocales = [Locale('de'), Locale('en')];

  /// Standardsprache, falls keine gültige Auswahl vorliegt.
  static const Locale fallbackLocale = Locale('de');

  /// Globaler Sprachzustand. Änderungen lösen sofort einen Neuaufbau aus.
  static final ValueNotifier<Locale> notifier = ValueNotifier(fallbackLocale);

  /// Wechselt die Sprache, sofern sie unterstützt wird.
  static void setLocale(Locale locale) {
    final isSupported = supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
    if (isSupported) {
      notifier.value = locale;
    }
  }
}
