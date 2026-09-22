import 'package:flutter/material.dart';

/// Zentrale Theme-Definitionen der App.
///
/// Bündelt die hellen und dunklen [ThemeData] sowie die gemeinsame
/// [TextTheme]-Basis. Die Schriften (Poppins/Lato) liegen als Assets im
/// Repository und werden über den `fonts:`-Block der `pubspec.yaml` geladen -
/// kein Laufzeitabruf über das Netz (E-38, U-72). Der aktuelle [ThemeMode]
/// liegt im `AppState` (E-46).
/// Siehe `doc/plan/grundlagen/1_Frontendstruktur.md`.
abstract class AppTheme {
  /// Schriftfamilie der Überschriften (gebündeltes Asset, E-38).
  static const String ueberschriftFamilie = 'Poppins';

  /// Schriftfamilie des Fließtexts (gebündeltes Asset, E-38).
  static const String textFamilie = 'Lato';
  static final lightTheme = ThemeData(
    textTheme: baseTextTheme,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
  );

  static final darkTheme = ThemeData(
    textTheme: baseTextTheme,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
  );

  /// Baut einen Stil der Überschriftenschrift.
  static TextStyle _ueberschrift({
    required double groesse,
    required FontWeight gewicht,
    double? abstand,
  }) => TextStyle(
    fontFamily: ueberschriftFamilie,
    fontSize: groesse,
    fontWeight: gewicht,
    letterSpacing: abstand,
  );

  /// Baut einen Stil der Fließtextschrift.
  static TextStyle _text({
    required double groesse,
    required FontWeight gewicht,
  }) => TextStyle(
    fontFamily: textFamilie,
    fontSize: groesse,
    fontWeight: gewicht,
  );

  static final TextTheme baseTextTheme = TextTheme(
    // Display Styles - für Hero-Texte
    displayLarge: _ueberschrift(
      groesse: 57,
      gewicht: FontWeight.w400,
      abstand: -0.25,
    ),
    displayMedium: _ueberschrift(groesse: 45, gewicht: FontWeight.w400),
    displaySmall: _ueberschrift(groesse: 36, gewicht: FontWeight.w400),

    // Headline Styles - für Überschriften
    headlineLarge: _ueberschrift(groesse: 32, gewicht: FontWeight.w600),
    headlineMedium: _ueberschrift(groesse: 28, gewicht: FontWeight.w600),
    headlineSmall: _ueberschrift(groesse: 24, gewicht: FontWeight.w500),

    // Title Styles - für Komponenten-Titel
    titleLarge: _text(groesse: 22, gewicht: FontWeight.w600),
    titleMedium: _text(groesse: 18, gewicht: FontWeight.w500),
    titleSmall: _text(groesse: 16, gewicht: FontWeight.w500),

    // Body Styles - für Fließtext
    bodyLarge: _text(groesse: 16, gewicht: FontWeight.w400),
    bodyMedium: _text(groesse: 14, gewicht: FontWeight.w400),
    bodySmall: _text(groesse: 12, gewicht: FontWeight.w400),

    // Label Styles - für Beschriftungen
    labelLarge: _text(groesse: 14, gewicht: FontWeight.w500),
    labelMedium: _text(groesse: 12, gewicht: FontWeight.w500),
    labelSmall: _text(groesse: 11, gewicht: FontWeight.w500),
  );
}
