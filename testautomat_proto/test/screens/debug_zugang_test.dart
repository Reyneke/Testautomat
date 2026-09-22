// Zugang zum Debug-Bildschirm: verborgene Geste, PIN, Sperre (E-22, F-15).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/data/in_memory_repository.dart';
import 'package:testautomat_proto/l10n/app_locale.dart';
import 'package:testautomat_proto/main.dart';
import 'package:testautomat_proto/state/app_clock.dart';
import 'package:testautomat_proto/state/app_debug.dart';
import 'package:testautomat_proto/state/app_machine.dart';
import 'package:testautomat_proto/theme/app_theme.dart';

void main() {
  setUp(() {
    AppTheme.themeModeNotifier.value = ThemeMode.dark;
    AppLocale.setLocale(const Locale('de'));
    AppMachine.reset();
    AppClock.reset();
    AppDebug.reset();
  });

  Future<void> starteApp(WidgetTester tester) async {
    await tester.pumpWidget(TestAutomatApp(repository: InMemoryRepository()));
    await tester.pump();
    await tester.pump();
  }

  Future<void> beendeApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
  }

  /// Tippt [anzahl] mal auf die verborgenen Debug-Angaben der Fusszeile.
  Future<void> tippeDebugBereich(WidgetTester tester, {int anzahl = 5}) async {
    final ziel = find.textContaining('Automatennummer:');
    for (var index = 0; index < anzahl; index++) {
      await tester.tap(ziel);
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  testWidgets('fuenf Taps oeffnen den PIN-Dialog', (tester) async {
    await starteApp(tester);

    await tippeDebugBereich(tester, anzahl: 4);
    await tester.pumpAndSettle();
    expect(find.text('Debug-Zugang'), findsNothing);

    await tippeDebugBereich(tester, anzahl: 1);
    await tester.pumpAndSettle();
    expect(find.text('Debug-Zugang'), findsOneWidget);

    await beendeApp(tester);
  });

  testWidgets('falsche PIN zeigt einen Fehler und sperrt', (tester) async {
    await starteApp(tester);
    await tippeDebugBereich(tester);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '0000');
    await tester.tap(find.text('Anmelden'));
    await tester.pumpAndSettle();

    expect(find.text('PIN ist falsch.'), findsOneWidget);
    expect(AppDebug.angemeldet.value, isFalse);
    expect(find.text('Debug'), findsNothing);

    await beendeApp(tester);
  });

  testWidgets('richtige PIN oeffnet den Debug-Bildschirm', (tester) async {
    await starteApp(tester);
    await tippeDebugBereich(tester);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), AppDebug.pin);
    await tester.tap(find.text('Anmelden'));
    await tester.pumpAndSettle();

    expect(AppDebug.angemeldet.value, isTrue);
    expect(find.text('Debug'), findsOneWidget);
    expect(find.text('Preissettings'), findsOneWidget);
    expect(find.text('Verkaufszeiten'), findsOneWidget);

    await tester.tap(find.text('Abmelden'));
    await tester.pumpAndSettle();

    expect(AppDebug.angemeldet.value, isFalse);
    expect(find.text('Verkauf starten'), findsOneWidget);

    await beendeApp(tester);
  });
}
