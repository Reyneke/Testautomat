// Aus-Bildschirm: Anzeige und Neuladen (0_Einfuehrung, E-23).

import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/screens/aus_screen.dart';

import '../support/app_test_helpers.dart';

void main() {
  testWidgets('zeigt den Hinweis ausserhalb der Verkaufszeit', (tester) async {
    await pumpeBildschirm(tester, bildschirm: const AusScreen());

    expect(find.text('Der Verkauf ist derzeit nicht möglich.'), findsOneWidget);
    expect(find.text('Neu laden'), findsNothing);

    await beendeApp(tester);
  });

  testWidgets('laesst sich neu laden', (tester) async {
    var neuGeladen = 0;
    await pumpeBildschirm(
      tester,
      bildschirm: AusScreen(onNeuLaden: () => neuGeladen += 1),
    );

    await tester.tap(find.text('Neu laden'));
    await tester.pump();

    expect(neuGeladen, 1);

    await beendeApp(tester);
  });
}
