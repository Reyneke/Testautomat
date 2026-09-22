import 'package:flutter/foundation.dart';

/// Zugang zum Debug-Bildschirm (E-22, F-15, F-30).
///
abstract final class AppDebug {
  /// PIN fuer den Debug-Zugang.
  ///
  /// Bewusst einfach gehalten: der Prototyp hat keine echte Benutzerverwaltung;
  /// mit der REST-Anbindung (E-43) tritt eine Token-Authentifizierung an diese
  /// Stelle. Der Anmeldezustand liegt im `AppState`.
  static const String pin = '4711';

  /// So viele Taps auf die Fusszeilen-Debugangabe oeffnen den Login.
  static const int tapsBisLogin = 5;

  /// Duergen Preissettings und Verkaufszeiten bearbeitet werden?
  ///
  /// Im Produktivbuild bleibt der Debug-Bildschirm schreibgeschuetzt (E-22).
  static bool bearbeitungErlaubt({required bool release}) => !release;

  /// Wie [bearbeitungErlaubt], aber fuer den Build-Modus dieser App.
  static bool get bearbeitungErlaubtImBuild =>
      bearbeitungErlaubt(release: kReleaseMode);
}
