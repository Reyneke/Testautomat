import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/app_scope.dart';
import 'package:testautomat_proto/data/in_memory_repository.dart';
import 'package:testautomat_proto/data/parkautomat_repository.dart';
import 'package:testautomat_proto/l10n/app_locale.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/main.dart';
import 'package:testautomat_proto/state/app_state.dart';

/// Frischer, isolierter Zustand je Test (E-46).
///
/// Mit dem AppState braucht kein Test mehr globale Zustaende zurueckzusetzen.
AppState zustandFrisch() => AppState();

/// Pumpt die App mit injiziertem Zustand und Repository.
///
/// Standard ist das InMemory-Repository; der Maschinen-Ladevorgang (U-23) wird
/// abgeschlossen, sofern [ladevorgangAbschliessen] gesetzt ist. Zurueckgegeben
/// wird der verwendete [AppState], damit Tests ihn pruefen koennen.
Future<AppState> pumpeApp(
  WidgetTester tester, {
  AppState? zustand,
  ParkautomatRepository? repository,
  bool ladevorgangAbschliessen = true,
}) async {
  final state = zustand ?? AppState();
  await tester.pumpWidget(
    TestAutomatApp(
      zustand: state,
      repository: repository ?? InMemoryRepository(),
    ),
  );
  if (ladevorgangAbschliessen) {
    await tester.pump();
    await tester.pump();
  }
  return state;
}

/// Pumpt einen einzelnen Bildschirm mit Zustand, Repository und i18n.
///
/// [argumente] landen als Routen-Argument beim Bildschirm (z. B. der Beleg fuer
/// die Parkinformation).
Future<AppState> pumpeBildschirm(
  WidgetTester tester, {
  required Widget bildschirm,
  Object? argumente,
  AppState? zustand,
  ParkautomatRepository? repository,
}) async {
  final state = zustand ?? AppState();
  await tester.pumpWidget(
    AppScope(
      zustand: state,
      repository: repository ?? InMemoryRepository(),
      child: MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocale.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: '/test',
        onGenerateRoute: (settings) => MaterialPageRoute<void>(
          settings: RouteSettings(name: settings.name, arguments: argumente),
          builder: (context) => bildschirm,
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
  return state;
}

/// Raeumt den Bildschirm ab, damit der Uhr-Timer sauber endet (U-51).
Future<void> beendeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
}
