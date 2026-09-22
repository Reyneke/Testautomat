// Debug-Bildschirm: Verkaeufe (Tabelle + Balken), Telemetrie, Bearbeiten.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/app_scope.dart';
import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/data/in_memory_repository.dart';
import 'package:testautomat_proto/l10n/app_locale.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/screens/debug_screen.dart';
import 'package:testautomat_proto/state/app_clock.dart';
import 'package:testautomat_proto/state/app_debug.dart';
import 'package:testautomat_proto/state/app_machine.dart';

/// Repository mit zwei Verkaeufen an bekannten UTC-Tagen.
InMemoryRepository _repositoryMitVerkaeufen() => InMemoryRepository(
  einschaltzeit: DateTime.utc(2026, 1, 1),
  verkaeufe: <Verkauf>[
    Verkauf(
      id: 1,
      maschineId: 1,
      timestamp: DateTime.utc(2026, 1, 5, 10),
      parkdauerMinuten: 240,
      betragCent: 200,
      zahlungsart: Zahlungsart.bar,
      belegnummer: 111,
    ),
    Verkauf(
      id: 2,
      maschineId: 1,
      timestamp: DateTime.utc(2026, 1, 6, 23, 30),
      parkdauerMinuten: 240,
      betragCent: 400,
      zahlungsart: Zahlungsart.karte,
      belegnummer: 222,
    ),
  ],
);

Future<void> _starteDebug(
  WidgetTester tester, {
  required InMemoryRepository repository,
  int telemetriePunkte = 96,
}) async {
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
        home: DebugScreen(
          von: DateTime.utc(2026, 1, 1),
          bis: DateTime.utc(2026, 1, 8),
          telemetriePunkte: telemetriePunkte,
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  setUp(() {
    AppLocale.setLocale(const Locale('de'));
    AppMachine.reset();
    AppClock.reset();
    AppDebug.reset();
  });

  Future<void> beende(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
  }

  Finder balken() => find.byWidgetPredicate(
    (widget) =>
        widget.key is ValueKey<String> &&
        (widget.key! as ValueKey<String>).value.startsWith('debug-balken-'),
  );

  testWidgets('zeigt Verkaeufe als Tabelle und Balken', (tester) async {
    await _starteDebug(tester, repository: _repositoryMitVerkaeufen());

    expect(
      find.text('Verkäufe je Tag (UTC-Tage, lokal angezeigt)'),
      findsOneWidget,
    );
    expect(find.text('2,00 \u20ac'), findsOneWidget);
    expect(find.text('4,00 \u20ac'), findsOneWidget);
    expect(balken(), findsNWidgets(2));

    await beende(tester);
  });

  testWidgets('zeigt einen Leerzustand ohne Verkaeufe', (tester) async {
    await _starteDebug(tester, repository: InMemoryRepository());

    expect(find.text('Keine Verkäufe im Zeitraum.'), findsOneWidget);
    expect(balken(), findsNothing);

    await beende(tester);
  });

  testWidgets('zeigt die Telemetrie nur lesend', (tester) async {
    await _starteDebug(
      tester,
      repository: InMemoryRepository(),
      telemetriePunkte: 3,
    );

    expect(find.text('Telemetrie (letzte 24 Stunden)'), findsOneWidget);
    expect(find.text('Stromverbrauch'), findsOneWidget);
    expect(find.textContaining(' dBm'), findsNWidgets(3));
    // Nur Preissettings und Verkaufszeiten tragen Bearbeitungsknoepfe:
    // 1 Preisregel + 7 Verkaufszeiten, keine Telemetrie.
    expect(find.text('Ändern'), findsNWidgets(8));

    await beende(tester);
  });

  testWidgets('aendert eine Preisregel ueber das Repository', (tester) async {
    final repository = _repositoryMitVerkaeufen();
    await _starteDebug(tester, repository: repository, telemetriePunkte: 2);

    expect(find.textContaining('240 min'), findsOneWidget);

    await tester.ensureVisible(find.text('Ändern').first);
    await tester.tap(find.text('Ändern').first);
    await tester.pumpAndSettle();

    final felder = find.byType(TextField);
    expect(felder, findsNWidgets(3));
    await tester.enterText(felder.at(0), '60');
    await tester.enterText(felder.at(1), '150');
    await tester.tap(find.text('Speichern'));
    await tester.pumpAndSettle();

    final settings = await repository.getPreissettings();
    expect(settings.single.taktMinuten, 60);
    expect(settings.single.preisProTaktCent, 150);
    expect(find.textContaining('60 min'), findsOneWidget);

    await beende(tester);
  });

  testWidgets('validiert und speichert Verkaufszeiten', (tester) async {
    final repository = _repositoryMitVerkaeufen();
    await _starteDebug(tester, repository: repository, telemetriePunkte: 2);

    await tester.ensureVisible(find.text('Ändern').at(1));
    await tester.tap(find.text('Ändern').at(1));
    await tester.pumpAndSettle();

    final felder = find.byType(TextField);
    expect(felder, findsNWidgets(3));

    await tester.enterText(felder.at(1), '8:00');
    await tester.tap(find.text('Speichern'));
    await tester.pumpAndSettle();
    expect(find.text('Ungültige Eingabe.'), findsOneWidget);

    await tester.enterText(felder.at(1), '08:00');
    await tester.enterText(felder.at(2), '18:00');
    await tester.tap(find.text('Speichern'));
    await tester.pumpAndSettle();

    final zeiten = await repository.getVerkaufszeiten();
    expect(zeiten.first.beginn, '08:00');
    expect(zeiten.first.ende, '18:00');

    await beende(tester);
  });
}
