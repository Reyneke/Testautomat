// Startbildschirm: Begruessung, Startknopf und Navigation (0_Einfuehrung).

import 'package:flutter_test/flutter_test.dart';

import '../support/app_test_helpers.dart';

void main() {
  testWidgets('zeigt eine uhrzeitangemessene Begruessung und den Startknopf', (
    tester,
  ) async {
    await pumpeApp(tester);

    final begruessungen = <String>[
      'Guten Morgen',
      'Guten Tag',
      'Guten Abend',
      'Gute Nacht',
    ];
    final gefunden = begruessungen.where(
      (text) => find.text(text).evaluate().isNotEmpty,
    );

    expect(gefunden, hasLength(1));
    expect(find.text('Verkauf starten'), findsOneWidget);

    await beendeApp(tester);
  });

  testWidgets('startet den Verkauf', (tester) async {
    await pumpeApp(tester);

    await tester.tap(find.text('Verkauf starten'));
    await tester.pumpAndSettle();

    expect(find.text('Parkzeit wählen'), findsOneWidget);

    await beendeApp(tester);
  });
}
