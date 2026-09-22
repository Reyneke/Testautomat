// Zahlungsablauf: Auswahl, Fortschritt, Abbruch, Timeout und Beleg (E-51).

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/app_scope.dart';
import 'package:testautomat_proto/data/in_memory_repository.dart';
import 'package:testautomat_proto/l10n/app_locale.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/routes.dart';
import 'package:testautomat_proto/screens/parkinfo_screen.dart';
import 'package:testautomat_proto/screens/zahlungs_auswahl_screen.dart';
import 'package:testautomat_proto/state/app_clock.dart';
import 'package:testautomat_proto/state/app_machine.dart';

void main() {
  setUp(() {
    AppLocale.setLocale(const Locale('de'));
    AppMachine.reset();
    AppClock.reset();
  });

  Future<InMemoryRepository> starteZahlung(
    WidgetTester tester, {
    Duration fortschritt = const Duration(seconds: 2),
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final repository = InMemoryRepository(
      einschaltzeit: DateTime.utc(2026, 1, 1),
    );
    await tester.pumpWidget(
      AppScope(
        repository: repository,
        child: MaterialApp(
          locale: const Locale('de'),
          supportedLocales: AppLocale.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routes: <String, WidgetBuilder>{
            AppRoutes.parkinfo: (context) => const ParkinformationScreen(),
          },
          home: ZahlungsAuswahlScreen(
            fortschrittDauer: fortschritt,
            timeoutDauer: timeout,
          ),
        ),
      ),
    );
    return repository;
  }

  Future<void> beende(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
  }

  testWidgets('zeigt Parkdauer und Betrag zur Auswahl', (tester) async {
    await starteZahlung(tester);

    expect(find.text('Zahlungsart wählen'), findsOneWidget);
    expect(find.text('4 Stunden \u00b7 2,00 \u20ac'), findsOneWidget);
    expect(find.text('Bar'), findsOneWidget);
    expect(find.text('Karte'), findsOneWidget);

    await beende(tester);
  });

  testWidgets('zeigt den Fortschritt und laesst sich abbrechen', (
    tester,
  ) async {
    final repository = await starteZahlung(
      tester,
      fortschritt: const Duration(seconds: 10),
    );

    await tester.tap(find.text('Bar'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Zahlung wird verarbeitet \u2026'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    await tester.tap(find.text('Abbrechen'));
    await tester.pump();

    expect(find.text('Zahlungsart wählen'), findsOneWidget);
    final umsaetze = await repository.getTagesumsaetze(
      DateTime.utc(2020),
      DateTime.utc(2030),
    );
    expect(umsaetze, isEmpty);

    await beende(tester);
  });

  testWidgets('meldet eine Zeitueberschreitung', (tester) async {
    await starteZahlung(
      tester,
      fortschritt: const Duration(seconds: 10),
      timeout: const Duration(seconds: 2),
    );

    await tester.tap(find.text('Karte'));
    await tester.pump(const Duration(seconds: 3));

    expect(
      find.text('Zeit\u00fcberschreitung bei der Zahlung'),
      findsOneWidget,
    );

    await tester.tap(find.text('Erneut versuchen'));
    await tester.pump();
    expect(find.text('Zahlungsart wählen'), findsOneWidget);

    await beende(tester);
  });

  testWidgets('legt den Verkauf an und zeigt den Beleg', (tester) async {
    final repository = await starteZahlung(
      tester,
      fortschritt: const Duration(seconds: 1),
    );

    await tester.tap(find.text('Karte'));
    // Fortschritt und createSale ablaufen lassen (pumpAndSettle endet sonst
    // nach dem ersten Takt, weil dann kein Frame mehr offen ist).
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Parkschein'), findsOneWidget);
    expect(find.textContaining('Belegnummer:'), findsOneWidget);
    expect(find.textContaining('2,00 \u20ac'), findsWidgets);

    final umsaetze = await repository.getTagesumsaetze(
      DateTime.utc(2020),
      DateTime.utc(2030),
    );
    expect(umsaetze, hasLength(1));
    expect(umsaetze.single.umsatzCent, 200);

    await beende(tester);
  });
}
