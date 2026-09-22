import 'package:flutter/foundation.dart';

/// Zugang zum Debug-Bildschirm (E-22, F-15, F-30).
///
/// Der Bildschirm ist verborgen (Geste in der Fußzeile) und nur nach Eingabe
/// der PIN erreichbar. Im Produktivbuild bleiben Änderungen zusätzlich gesperrt
/// (schreibgeschützt).
abstract final class AppDebug {
  /// PIN für den Debug-Zugang.
  ///
  /// Bewusst einfach gehalten: der Prototyp hat keine echte
  /// Benutzerverwaltung; mit der REST-Anbindung (E-43) tritt eine
  /// Token-Authentifizierung an diese Stelle.
  static const String pin = '4711';

  /// So viele Taps auf die Fußzeilen-Debugangabe öffnen den Login.
  static const int tapsBisLogin = 5;

  /// Ist der Debug-Bildschirm freigeschaltet?
  static final ValueNotifier<bool> angemeldet = ValueNotifier<bool>(false);

  /// Prüft die PIN und schaltet bei Erfolg frei.
  static bool pruefePin(String eingabe) {
    final erfolg = eingabe.trim() == pin;
    if (erfolg) {
      angemeldet.value = true;
    }
    return erfolg;
  }

  /// Sperrt den Debug-Bildschirm wieder.
  static void abmelden() => angemeldet.value = false;

  /// Setzt den Zustand zurück (Tests, E-46).
  static void reset() => angemeldet.value = false;

  /// Dürfen Preissettings und Verkaufszeiten bearbeitet werden?
  ///
  /// Im Produktivbuild bleibt der Debug-Bildschirm schreibgeschützt (E-22).
  static bool bearbeitungErlaubt({required bool release}) => !release;

  /// Wie [bearbeitungErlaubt], aber für den Build-Modus dieser App.
  static bool get bearbeitungErlaubtImBuild =>
      bearbeitungErlaubt(release: kReleaseMode);
}
