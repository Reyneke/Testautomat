// Parkzeitauswahl: Vier-Stunden-Schritte, Preise und Rueckweg (E-15).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/data/in_memory_repository.dart';
import 'package:testautomat_proto/screens/parkzeit_auswahl_screen.dart';

import '../support/app_test_helpers.dart';

/// Label des Parkzeit-Knopfs, z. B. `4 Stunden \u00b7 2,00 \u20ac`.
const String _parkzeit4Stunden = '4 Stunden \u00b7 2,00 \u20ac';

void main() {
  Future<void> oeffneParkzeit(
    WidgetTester tester, {
    InMemoryRepository? repository,
  }) async {
    await pumpeApp(tester, repository: repository);
    await tester.tap(find.text('Verkauf starten'));
    await tester.pumpAndSettle();
  }

  testWidgets('bietet Vier-Stunden-Schritte mit Preis an', (tester) async {
    await oeffneParkzeit(tester);

    expect(find.text('Parkzeit wählen'), findsOneWidget);
    expect(find.text('4 Stunden \u00b7 2,00 \u20ac'), findsOneWidget);
    expect(find.text('8 Stunden \u00b7 4,00 \u20ac'), findsOneWidget);
    expect(find.text('12 Stunden \u00b7 6,00 \u20ac'), findsOneWidget);
    expect(find.text('24 Stunden \u00b7 12,00 \u20ac'), findsOneWidget);

    await beendeApp(tester);
  });

  testWidgets('faellt ohne Preisregel auf die Seed-Werte zurueck', (
    tester,
  ) async {
    await oeffneParkzeit(
      tester,
      repository: InMemoryRepository(preissettings: const <Preissetting>[]),
    );

    expect(find.text('4 Stunden \u00b7 2,00 \u20ac'), findsOneWidget);

    await beendeApp(tester);
  });

  testWidgets('Zurueck kehrt zum Startbildschirm', (tester) async {
    await oeffneParkzeit(tester);

    await tippeSichtbar(tester, find.text('Zurück'));

    expect(find.text('Verkauf starten'), findsOneWidget);

    await beendeApp(tester);
  });

  testWidgets('verlangt zuerst die Parkzone', (tester) async {
    await oeffneParkzeit(tester);

    expect(find.text('Bitte wählen Sie zuerst eine Parkzone.'), findsOneWidget);
    expect(
      tester
          .widget<OutlinedButton>(
            find.widgetWithText(OutlinedButton, _parkzeit4Stunden),
          )
          .onPressed,
      isNull,
      reason: 'ohne Zone darf keine Parkzeit waehlbar sein',
    );

    await tippeSichtbar(tester, find.text('Zone A'));

    expect(find.text('Bitte wählen Sie zuerst eine Parkzone.'), findsNothing);
    expect(
      tester
          .widget<OutlinedButton>(
            find.widgetWithText(OutlinedButton, _parkzeit4Stunden),
          )
          .onPressed,
      isNotNull,
    );

    await beendeApp(tester);
  });

  testWidgets('ein Zonenwechsel verwirft die gewaehlte Parkzeit', (
    tester,
  ) async {
    await oeffneParkzeit(tester);

    await tippeSichtbar(tester, find.text('Zone A'));
    await tippeSichtbar(tester, find.text(_parkzeit4Stunden));

    expect(
      find.widgetWithText(FilledButton, _parkzeit4Stunden),
      findsOneWidget,
      reason: 'die gewaehlte Parkzeit ist hervorgehoben',
    );

    await tippeSichtbar(tester, find.text('Zone B'));

    expect(
      find.widgetWithText(OutlinedButton, _parkzeit4Stunden),
      findsOneWidget,
      reason: 'der Zonenwechsel loescht die Parkzeit',
    );
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Weiter'))
          .onPressed,
      isNull,
      reason: 'ohne Parkzeit ist Weiter gesperrt',
    );

    await beendeApp(tester);
  });

  testWidgets('meldet ein ungueltiges Kennzeichen', (tester) async {
    await oeffneParkzeit(tester);

    await tippeSichtbar(tester, find.text('Zone A'));
    await tippeSichtbar(tester, find.text(_parkzeit4Stunden));
    await tester.enterText(find.byType(TextField), '123');
    await tippeSichtbar(tester, find.text('Weiter'));

    expect(
      find.text('Bitte geben Sie ein gültiges Kennzeichen ein.'),
      findsOneWidget,
    );

    await beendeApp(tester);
  });

  testWidgets('lehnt einen Doppelkauf auf dasselbe Kennzeichen ab', (
    tester,
  ) async {
    final jetzt = DateTime.utc(2026, 5, 1, 8);
    final repository = InMemoryRepository(
      verkaeufe: <Verkauf>[
        Verkauf(
          id: 1,
          maschineId: 1,
          timestamp: jetzt,
          parkdauerMinuten: 240,
          betragCent: 200,
          zahlungsart: Zahlungsart.bar,
          belegnummer: 1,
          kennzeichen: 'AB123',
        ),
      ],
    );

    await pumpeBildschirm(
      tester,
      bildschirm: ParkzeitAuswahlScreen(jetzt: jetzt),
      repository: repository,
    );

    await tippeSichtbar(tester, find.text('Zone A'));
    await tippeSichtbar(tester, find.text(_parkzeit4Stunden));
    await tester.enterText(find.byType(TextField), 'AB 123');
    await tippeSichtbar(tester, find.text('Weiter'));

    expect(
      find.textContaining(
        'Für dieses Kennzeichen läuft bereits ein Parkschein',
      ),
      findsOneWidget,
    );

    await beendeApp(tester);
  });
}
