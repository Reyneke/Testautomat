// Beleg-Anzeige des Parkinformations-Bildschirms (E-51).

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/screens/parkinfo_screen.dart';

import '../support/app_test_helpers.dart';

void main() {
  testWidgets('zeigt den Beleg zur uebergebenen Verkauf', (tester) async {
    final verkauf = Verkauf(
      id: 1,
      maschineId: 1,
      timestamp: DateTime.utc(2026, 1, 5, 10),
      parkdauerMinuten: 240,
      betragCent: 200,
      zahlungsart: Zahlungsart.karte,
      belegnummer: 4711,
    );

    await pumpeBildschirm(
      tester,
      bildschirm: const ParkinformationScreen(),
      argumente: verkauf,
    );

    expect(find.text('Parkschein'), findsOneWidget);
    expect(find.textContaining('Belegnummer: 4711'), findsOneWidget);
    expect(find.textContaining('4 Stunden'), findsOneWidget);
    expect(find.textContaining('2,00 \u20ac'), findsOneWidget);
    expect(find.textContaining('Karte'), findsOneWidget);
    expect(find.textContaining('Gültig bis:'), findsOneWidget);
    expect(find.text('Weiter'), findsOneWidget);

    await beendeApp(tester);
  });

  testWidgets('zeigt ohne Verkauf nur den Hinweis', (tester) async {
    await pumpeBildschirm(tester, bildschirm: const ParkinformationScreen());

    expect(find.text('Parkschein'), findsOneWidget);
    expect(find.textContaining('nach der Zahlung'), findsOneWidget);
    expect(find.textContaining('Belegnummer:'), findsNothing);

    await beendeApp(tester);
  });

  testWidgets(
    'laedt den Parkschein als PDF herunter und zeigt das Kennzeichen',
    (tester) async {
      final verkauf = Verkauf(
        id: 1,
        maschineId: 1,
        timestamp: DateTime.utc(2026, 1, 5, 10),
        parkdauerMinuten: 240,
        betragCent: 200,
        zahlungsart: Zahlungsart.paypal,
        belegnummer: 4711,
        kennzeichen: 'WENAB123',
      );

      Uint8List? erhalten;
      String? dateiname;
      await pumpeBildschirm(
        tester,
        bildschirm: ParkinformationScreen(
          parkscheinSpeichern: (bytes, name) async {
            erhalten = bytes;
            dateiname = name;
            return 'ablage/$name';
          },
        ),
        argumente: verkauf,
      );

      expect(find.textContaining('Kennzeichen: WENAB123'), findsOneWidget);
      expect(find.textContaining('PayPal'), findsOneWidget);

      await tester.tap(find.text('Als PDF herunterladen'));
      await tester.pumpAndSettle();

      expect(erhalten, isNotNull);
      expect(String.fromCharCodes(erhalten!.take(5)), '%PDF-');
      expect(dateiname, 'parkschein-4711.pdf');
      expect(find.textContaining('Parkschein gespeichert'), findsOneWidget);

      await beendeApp(tester);
    },
  );
}
