// Ruhige Fortschrittsanzeige bei "Bewegung reduzieren" (E-24, U-71).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/widgets/fortschritts_anzeige.dart';

Future<void> _pumpe(WidgetTester tester, Widget kind) => tester.pumpWidget(
  MaterialApp(
    home: Scaffold(body: Center(child: kind)),
  ),
);

void main() {
  testWidgets('ohne reduzierte Bewegung laufen die Anzeigen', (tester) async {
    await _pumpe(tester, const FortschrittsAnzeige());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await _pumpe(tester, const FortschrittsAnzeige(wert: 0.5));
    final balken = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(balken.value, 0.5);
  });

  testWidgets('bei reduzierter Bewegung steht die Anzeige still', (
    tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(reduceMotion: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

    await _pumpe(tester, const FortschrittsAnzeige());

    expect(
      find.byType(CircularProgressIndicator),
      findsNothing,
      reason: 'kein laufender Ring bei reduzierter Bewegung',
    );
    expect(find.byType(FortschrittsAnzeige), findsOneWidget);

    await _pumpe(tester, const FortschrittsAnzeige(wert: 0.5));

    expect(
      find.byType(LinearProgressIndicator),
      findsNothing,
      reason: 'auch der Balken animiert nicht, er wird ruhig gezeichnet',
    );
    expect(find.byType(ClipRRect), findsOneWidget);
    expect(
      tester.getSemantics(find.byType(FortschrittsAnzeige)).value,
      contains('50'),
    );
  });

  testWidgets('auch disableAnimations wird respektiert', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

    await _pumpe(tester, const FortschrittsAnzeige());

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
