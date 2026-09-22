// Durchstich durch die Bildschirme (DoD Phase 2/3: alle Uebergaenge erreichbar).

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/routes.dart';

import '../support/app_test_helpers.dart';

/// Label des Parkzeit-Knopfs, z. B. `4 Stunden \u00b7 2,00 \u20ac`.
const String parkzeit4Stunden = '4 Stunden \u00b7 2,00 \u20ac';
const String parkzeit8Stunden = '8 Stunden \u00b7 4,00 \u20ac';

void main() {
  testWidgets('Kaufablauf ist von Start bis Verabschiedung durchklickbar', (
    tester,
  ) async {
    await pumpeApp(tester);
    expect(find.text('Verkauf starten'), findsOneWidget);

    await tester.tap(find.text('Verkauf starten'));
    await tester.pumpAndSettle();
    expect(find.text('Parkzeit wählen'), findsOneWidget);

    await tester.tap(find.text(parkzeit4Stunden));
    await tester.pumpAndSettle();
    expect(find.text('Zahlungsart wählen'), findsOneWidget);
    expect(find.text(parkzeit4Stunden), findsOneWidget);

    await tester.tap(find.text('Karte'));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.text('Parkschein'), findsOneWidget);
    expect(find.textContaining('Belegnummer:'), findsOneWidget);

    await tester.tap(find.text('Weiter'));
    await tester.pumpAndSettle();
    expect(find.text('Auf Wiedersehen'), findsOneWidget);

    await tester.tap(find.text('Neuer Verkauf'));
    await tester.pumpAndSettle();
    expect(find.text('Verkauf starten'), findsOneWidget);

    await beendeApp(tester);
  });

  testWidgets('Zurueck fuehrt auf den vorherigen Bildschirm', (tester) async {
    await pumpeApp(tester);

    await tester.tap(find.text('Verkauf starten'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(parkzeit4Stunden));
    await tester.pumpAndSettle();
    expect(find.text('Zahlungsart wählen'), findsOneWidget);

    await tester.tap(find.text('Zurück'));
    await tester.pumpAndSettle();
    expect(find.text('Parkzeit wählen'), findsOneWidget);

    await beendeApp(tester);
  });

  testWidgets('jede Parkzeit fuehrt ueber die Zahlung zum Beleg', (
    tester,
  ) async {
    await pumpeApp(tester);

    await tester.tap(find.text('Verkauf starten'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(parkzeit8Stunden));
    await tester.pumpAndSettle();
    expect(find.text('Zahlungsart wählen'), findsOneWidget);
    expect(find.text(parkzeit8Stunden), findsOneWidget);

    await tester.tap(find.text('Bar'));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.text('Parkschein'), findsOneWidget);
    expect(find.textContaining('8 Stunden'), findsOneWidget);

    await beendeApp(tester);
  });

  testWidgets('Aus-Bildschirm ist ueber seine Route erreichbar', (
    tester,
  ) async {
    await pumpeApp(tester);

    final navigator = Navigator.of(tester.element(find.byType(Scaffold)));
    unawaited(navigator.pushNamed(AppRoutes.aus));
    await tester.pumpAndSettle();

    expect(find.text('Der Verkauf ist derzeit nicht möglich.'), findsOneWidget);
    expect(find.text('Verkauf starten'), findsNothing);
    expect(find.text('Neu laden'), findsOneWidget);

    await beendeApp(tester);
  });
}
