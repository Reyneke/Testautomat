// Widget-Tests fuer Theme- und Sprachumschaltung sowie die Composition Root.
//
// Siehe doc/plan/grundlagen/1_Frontendstruktur.md: Standard ist Dunkel, die
// Sprache muss jederzeit zwischen Deutsch und Englisch wechselbar sein.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/app_scope.dart';
import 'package:testautomat_proto/data/in_memory_repository.dart';
import 'package:testautomat_proto/data/parkautomat_repository.dart';
import 'package:testautomat_proto/l10n/app_locale.dart';
import 'package:testautomat_proto/main.dart';
import 'package:testautomat_proto/theme/app_theme.dart';

void main() {
  setUp(() {
    // Globalen Zustand vor jedem Test zuruecksetzen.
    AppTheme.themeModeNotifier.value = ThemeMode.dark;
    AppLocale.setLocale(const Locale('de'));
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    ParkautomatRepository? repository,
  }) async {
    await tester.pumpWidget(
      TestAutomatApp(repository: repository ?? InMemoryRepository()),
    );
    await tester.pump();
  }

  Future<void> disposeApp(WidgetTester tester) async {
    // Bildschirm abraeumen, damit der Uhr-Timer sauber beendet wird.
    await tester.pumpWidget(const SizedBox.shrink());
  }

  testWidgets('Standard-Theme ist Dunkel', (tester) async {
    await pumpApp(tester);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);
    expect(AppTheme.themeModeNotifier.value, ThemeMode.dark);

    await disposeApp(tester);
  });

  testWidgets('Theme laesst sich auf Hell umschalten', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.light_mode));
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.light);
    expect(AppTheme.themeModeNotifier.value, ThemeMode.light);

    await disposeApp(tester);
  });

  testWidgets('Sprache laesst sich auf Englisch umschalten', (tester) async {
    await pumpApp(tester);

    expect(find.text('Verkauf starten'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Start sale'), findsOneWidget);
    expect(find.text('Verkauf starten'), findsNothing);
    expect(AppLocale.notifier.value.languageCode, 'en');

    await disposeApp(tester);
  });

  testWidgets('AppScope stellt das Repository bereit', (tester) async {
    final repository = InMemoryRepository();
    await pumpApp(tester, repository: repository);

    final scope = AppScope.of(tester.element(find.byType(MaterialApp)));
    expect(scope.repository, same(repository));

    final maschine = await scope.repository.getMachine();
    expect(maschine.geraeteId, '4711');

    await disposeApp(tester);
  });
}
