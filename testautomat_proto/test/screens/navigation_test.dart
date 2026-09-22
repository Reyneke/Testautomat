// Durchstich durch die sechs Bildschirme (DoD Phase 2: alle Uebergaenge erreichbar).

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/data/in_memory_repository.dart';
import 'package:testautomat_proto/l10n/app_locale.dart';
import 'package:testautomat_proto/main.dart';
import 'package:testautomat_proto/routes.dart';
import 'package:testautomat_proto/state/app_clock.dart';
import 'package:testautomat_proto/state/app_machine.dart';
import 'package:testautomat_proto/theme/app_theme.dart';

void main() {
  setUp(() {
    AppTheme.themeModeNotifier.value = ThemeMode.dark;
    AppLocale.setLocale(const Locale('de'));
    AppMachine.reset();
    AppClock.reset();
  });

  Future<void> starteApp(WidgetTester tester) async {
    await tester.pumpWidget(TestAutomatApp(repository: InMemoryRepository()));
    await tester.pump();
    await tester.pump();
  }

  Future<void> beendeApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
  }

  testWidgets('Kaufablauf ist von Start bis Verabschiedung durchklickbar', (
    tester,
  ) async {
    await starteApp(tester);
    expect(find.text('Verkauf starten'), findsOneWidget);

    await tester.tap(find.text('Verkauf starten'));
    await tester.pumpAndSettle();
    expect(find.text('Parkzeit wählen'), findsOneWidget);

    await tester.tap(find.text('4 Stunden'));
    await tester.pumpAndSettle();
    expect(find.text('Zahlungsart wählen'), findsOneWidget);

    await tester.tap(find.text('Karte'));
    await tester.pumpAndSettle();
    expect(find.text('Parkinformation'), findsOneWidget);
    expect(find.text('4 Stunden'), findsOneWidget);

    await tester.tap(find.text('Weiter'));
    await tester.pumpAndSettle();
    expect(find.text('Auf Wiedersehen'), findsOneWidget);

    await tester.tap(find.text('Neuer Verkauf'));
    await tester.pumpAndSettle();
    expect(find.text('Verkauf starten'), findsOneWidget);

    await beendeApp(tester);
  });

  testWidgets('Zurueck fuehrt auf den vorherigen Bildschirm', (tester) async {
    await starteApp(tester);

    await tester.tap(find.text('Verkauf starten'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('4 Stunden'));
    await tester.pumpAndSettle();
    expect(find.text('Zahlungsart wählen'), findsOneWidget);

    await tester.tap(find.text('Zurück'));
    await tester.pumpAndSettle();
    expect(find.text('Parkzeit wählen'), findsOneWidget);

    await beendeApp(tester);
  });

  testWidgets('jede Parkzeit fuehrt ueber die Zahlungsauswahl weiter', (
    tester,
  ) async {
    await starteApp(tester);

    await tester.tap(find.text('Verkauf starten'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('8 Stunden'));
    await tester.pumpAndSettle();
    expect(find.text('Zahlungsart wählen'), findsOneWidget);
    expect(find.text('8 Stunden'), findsOneWidget);

    await tester.tap(find.text('Bar'));
    await tester.pumpAndSettle();
    expect(find.text('Parkinformation'), findsOneWidget);
    expect(find.text('8 Stunden'), findsOneWidget);

    await beendeApp(tester);
  });

  testWidgets('Aus-Bildschirm ist ueber seine Route erreichbar', (
    tester,
  ) async {
    await starteApp(tester);

    final navigator = Navigator.of(tester.element(find.byType(Scaffold)));
    unawaited(navigator.pushNamed(AppRoutes.aus));
    await tester.pumpAndSettle();

    expect(find.text('Der Verkauf ist derzeit nicht möglich.'), findsOneWidget);
    expect(find.text('Verkauf starten'), findsNothing);
    expect(find.text('Neu laden'), findsOneWidget);

    await beendeApp(tester);
  });
}
