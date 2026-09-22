// Beleg-Anzeige des Parkinformations-Bildschirms (E-51).

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
}
