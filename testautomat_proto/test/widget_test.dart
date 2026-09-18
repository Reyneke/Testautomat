// Widget-Tests für Theme- und Sprachumschaltung.
//
// Siehe doc/plan/grundlagen/1_Frontendstruktur.md: Standard ist Dunkel, die
// Sprache muss jederzeit zwischen Deutsch und Englisch wechselbar sein.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/l10n/app_locale.dart';
import 'package:testautomat_proto/main.dart';
import 'package:testautomat_proto/theme/app_theme.dart';

void main() {
  setUp(() {
    // Globalen Zustand vor jedem Test zurücksetzen.
    AppTheme.themeModeNotifier.value = ThemeMode.dark;
    AppLocale.setLocale(const Locale('de'));
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const TestAutomatApp());
    await tester.pump();
  }

  Future<void> disposeApp(WidgetTester tester) async {
    // Bildschirm abräumen, damit der Uhr-Timer sauber beendet wird.
    await tester.pumpWidget(const SizedBox.shrink());
  }

  testWidgets('Standard-Theme ist Dunkel', (tester) async {
    await pumpApp(tester);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);
    expect(AppTheme.themeModeNotifier.value, ThemeMode.dark);

    await disposeApp(tester);
  });

  testWidgets('Theme lässt sich auf Hell umschalten', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.light_mode));
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.light);
    expect(AppTheme.themeModeNotifier.value, ThemeMode.light);

    await disposeApp(tester);
  });

  testWidgets('Sprache lässt sich auf Englisch umschalten', (tester) async {
    await pumpApp(tester);

    expect(find.text('Verkauf starten'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Start sale'), findsOneWidget);
    expect(find.text('Verkauf starten'), findsNothing);
    expect(AppLocale.notifier.value.languageCode, 'en');

    await disposeApp(tester);
  });
}
