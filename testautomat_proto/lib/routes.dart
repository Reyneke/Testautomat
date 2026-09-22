import 'package:flutter/material.dart';

import 'package:testautomat_proto/screens/aus_screen.dart';
import 'package:testautomat_proto/screens/debug_screen.dart';
import 'package:testautomat_proto/screens/parkinfo_screen.dart';
import 'package:testautomat_proto/screens/parkzeit_auswahl_screen.dart';
import 'package:testautomat_proto/screens/start_screen.dart';
import 'package:testautomat_proto/screens/verabschiedung_screen.dart';
import 'package:testautomat_proto/screens/zahlungs_auswahl_screen.dart';

/// Namen und Erzeugung der Bildschirm-Routen (E-13).
abstract final class AppRoutes {
  static const String aus = '/aus';
  static const String start = '/start';
  static const String parkzeit = '/parkzeit';
  static const String zahlung = '/zahlung';
  static const String parkinfo = '/parkinfo';
  static const String verabschiedung = '/verabschiedung';

  /// Verborgener Debug-Bildschirm (E-22).
  static const String debug = '/debug';

  /// Erzeugt die Route zu [settings].
  ///
  /// [onNeuLaden] bekommt nur der "Aus"-Bildschirm: er kann die Maschinendaten
  /// erneut laden (U-23).
  static Route<void> onGenerateRoute(
    RouteSettings settings, {
    VoidCallback? onNeuLaden,
  }) => MaterialPageRoute<void>(
    settings: settings,
    builder: (context) => switch (settings.name) {
      aus => AusScreen(onNeuLaden: onNeuLaden),
      parkzeit => const ParkzeitAuswahlScreen(),
      zahlung => const ZahlungsAuswahlScreen(),
      parkinfo => const ParkinformationScreen(),
      verabschiedung => const VerabschiedungScreen(),
      debug => const DebugScreen(),
      _ => const StartScreen(),
    },
  );
}
