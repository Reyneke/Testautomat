// Zugang zum Debug-Bildschirm: verborgene Geste, PIN, Sperre (E-22, F-15).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/state/app_debug.dart';

import '../support/app_test_helpers.dart';

void main() {
  /// Tippt [anzahl] mal auf die verborgenen Debug-Angaben der Fusszeile.
  Future<void> tippeDebugBereich(WidgetTester tester, {int anzahl = 5}) async {
    final ziel = find.textContaining('Automatennummer:');
    for (var index = 0; index < anzahl; index++) {
      await tester.tap(ziel);
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  testWidgets('fuenf Taps oeffnen den PIN-Dialog', (tester) async {
    await pumpeApp(tester);

    await tippeDebugBereich(tester, anzahl: 4);
    await tester.pumpAndSettle();
    expect(find.text('Debug-Zugang'), findsNothing);

    await tippeDebugBereich(tester, anzahl: 1);
    await tester.pumpAndSettle();
    expect(find.text('Debug-Zugang'), findsOneWidget);

    await beendeApp(tester);
  });

  testWidgets('falsche PIN zeigt einen Fehler und sperrt', (tester) async {
    final zustand = await pumpeApp(tester);
    await tippeDebugBereich(tester);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '0000');
    await tester.tap(find.text('Anmelden'));
    await tester.pumpAndSettle();

    expect(find.text('PIN ist falsch.'), findsOneWidget);
    expect(zustand.debugAngemeldet.value, isFalse);
    expect(find.text('Debug'), findsNothing);

    await beendeApp(tester);
  });

  testWidgets('richtige PIN oeffnet den Debug-Bildschirm', (tester) async {
    final zustand = await pumpeApp(tester);
    await tippeDebugBereich(tester);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), AppDebug.pin);
    await tester.tap(find.text('Anmelden'));
    await tester.pumpAndSettle();

    expect(zustand.debugAngemeldet.value, isTrue);
    expect(find.text('Debug'), findsOneWidget);
    expect(find.text('Preissettings'), findsOneWidget);
    expect(find.text('Verkaufszeiten'), findsOneWidget);

    await tester.tap(find.text('Abmelden'));
    await tester.pumpAndSettle();

    expect(zustand.debugAngemeldet.value, isFalse);
    expect(find.text('Verkauf starten'), findsOneWidget);

    await beendeApp(tester);
  });
}
