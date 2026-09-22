import 'package:flutter/widgets.dart';

/// Bewegung und Animationen der App (E-24, E-26).
///
/// Der Automat steht in der Oeffentlichkeit; wer am Geraet die Einstellung
/// "Bewegung reduzieren" gesetzt hat, bekommt keine laufenden Animationen.
abstract class AppMotion {
  /// Ist die Systemeinstellung "Bewegung reduzieren" aktiv?
  static bool get reduziert {
    final merkmale =
        WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
    return merkmale.reduceMotion || merkmale.disableAnimations;
  }

  /// Duerfen eigene Animationen laufen?
  ///
  /// [reduziert] laesst Tests den Wert vorgeben, ohne die Plattform zu stellen.
  static bool erlaubt({bool? reduziert}) => !(reduziert ?? AppMotion.reduziert);
}
