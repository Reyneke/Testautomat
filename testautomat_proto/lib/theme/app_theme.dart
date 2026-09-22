import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Zentrale Theme-Definitionen der App.
///
/// Bündelt die hellen und dunklen [ThemeData] sowie die gemeinsame
/// [TextTheme]-Basis. Der aktuelle [ThemeMode] liegt im `AppState` (E-46).
/// Siehe `doc/plan/grundlagen/1_Frontendstruktur.md`.
abstract class AppTheme {
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

  static final TextTheme baseTextTheme = TextTheme(
    // Display Styles - für Hero-Texte
    displayLarge: GoogleFonts.poppins(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 45,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 36,
      fontWeight: FontWeight.w400,
    ),

    // Headline Styles - für Überschriften
    headlineLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w500,
    ),

    // Title Styles - für Komponenten-Titel
    titleLarge: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.w600),
    titleMedium: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w500),
    titleSmall: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w500),

    // Body Styles - für Fließtext
    bodyLarge: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w400),

    // Label Styles - für Beschriftungen
    labelLarge: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w500),
    labelMedium: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w500),
  );
}
