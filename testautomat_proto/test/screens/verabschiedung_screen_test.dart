// Verabschiedungs-Bildschirm (0_Einfuehrung).

import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/screens/verabschiedung_screen.dart';

import '../support/app_test_helpers.dart';

void main() {
  testWidgets('bedankt sich und bietet einen neuen Verkauf an', (tester) async {
    await pumpeBildschirm(tester, bildschirm: const VerabschiedungScreen());

    expect(find.text('Auf Wiedersehen'), findsOneWidget);
    expect(find.text('Vielen Dank und eine gute Fahrt!'), findsOneWidget);
    expect(find.text('Neuer Verkauf'), findsOneWidget);

    await beendeApp(tester);
  });
}
