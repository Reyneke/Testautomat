// Parkzeitauswahl: Vier-Stunden-Schritte, Preise und Rueckweg (E-15).

import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/data/in_memory_repository.dart';

import '../support/app_test_helpers.dart';

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

    await tester.tap(find.text('Zurück'));
    await tester.pumpAndSettle();

    expect(find.text('Verkauf starten'), findsOneWidget);

    await beendeApp(tester);
  });
}
