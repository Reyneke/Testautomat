import 'package:flutter/foundation.dart';

import 'package:testautomat_proto/data/dto.dart';

/// Globaler Maschinenzustand (E-55).
///
abstract final class AppMachine {
  /// Aktive Maschine; `null`, solange sie noch nicht geladen wurde.
  static final ValueNotifier<Maschine?> maschineNotifier =
      ValueNotifier<Maschine?>(null);

  /// Setzt den Zustand zurueck (Tests, vgl. E-46).
  static void reset() => maschineNotifier.value = null;
}
