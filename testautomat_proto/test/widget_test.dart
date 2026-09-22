// Widget-Tests fuer Theme- und Sprachumschaltung, Composition Root und Bootstrap.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/app_scope.dart';
import 'package:testautomat_proto/data/in_memory_repository.dart';

import 'support/app_test_helpers.dart';

void main() {
  testWidgets('Standard-Theme ist Dunkel', (tester) async {
    final zustand = await pumpeApp(tester);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);
    expect(zustand.themeMode.value, ThemeMode.dark);

    await beendeApp(tester);
  });

  testWidgets('Theme laesst sich auf Hell umschalten', (tester) async {
    final zustand = await pumpeApp(tester);

    await tester.tap(find.byIcon(Icons.light_mode));
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.light);
    expect(zustand.themeMode.value, ThemeMode.light);

    await beendeApp(tester);
  });

  testWidgets('Sprache laesst sich auf Englisch umschalten', (tester) async {
    final zustand = await pumpeApp(tester);

    expect(find.text('Verkauf starten'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Start sale'), findsOneWidget);
    expect(find.text('Verkauf starten'), findsNothing);
    expect(zustand.locale.value.languageCode, 'en');

    await beendeApp(tester);
  });

  testWidgets('AppScope stellt Zustand und Repository bereit', (tester) async {
    final repository = InMemoryRepository();
    final zustand = await pumpeApp(tester, repository: repository);

    final scope = AppScope.of(tester.element(find.byType(MaterialApp)));
    expect(scope.repository, same(repository));
    expect(scope.zustand, same(zustand));

    final maschine = await scope.repository.getMachine();
    expect(maschine.geraeteId, '4711');

    await beendeApp(tester);
  });

  testWidgets('Startbildschirm erscheint nach dem Laden der Maschine', (
    tester,
  ) async {
    final zustand = await pumpeApp(tester);

    expect(find.text('Verkauf starten'), findsOneWidget);
    expect(zustand.maschine.value?.geraeteId, '4711');
    expect(zustand.maschine.value?.standort, 'Weiden i. d. OPf.');

    await beendeApp(tester);
  });
}
