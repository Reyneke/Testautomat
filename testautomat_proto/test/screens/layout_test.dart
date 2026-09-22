// Gemeinsames Layout auf allen Bildschirmen und Verbot hartkodierter Maschinendaten.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/widgets/app_footer.dart';
import 'package:testautomat_proto/widgets/app_header.dart';
import 'package:testautomat_proto/widgets/language_selector.dart';
import 'package:testautomat_proto/widgets/theme_selector.dart';

import '../support/app_test_helpers.dart';

void main() {
  testWidgets('Kopf- und Fusszeile begleiten den ganzen Kaufablauf', (
    tester,
  ) async {
    await pumpeApp(tester);

    void pruefeRahmen() {
      expect(find.byType(AppHeader), findsOneWidget);
      expect(find.byType(AppFooter), findsOneWidget);
      expect(find.byType(ThemeModeSelector), findsOneWidget);
      expect(find.byType(LanguageSelector), findsOneWidget);
      // Debug-Angaben stammen aus der geladenen Maschine (E-55).
      expect(find.textContaining('4711'), findsOneWidget);
      expect(find.textContaining('Weiden i. d. OPf.'), findsOneWidget);
    }

    pruefeRahmen();

    await tester.tap(find.text('Verkauf starten'));
    await tester.pumpAndSettle();
    pruefeRahmen();

    await tester.tap(find.text('4 Stunden \u00b7 2,00 \u20ac'));
    await tester.pumpAndSettle();
    pruefeRahmen();

    await tester.tap(find.text('Karte'));
    await tester.pump(const Duration(milliseconds: 200));
    pruefeRahmen();

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    pruefeRahmen();

    await tester.tap(find.text('Weiter'));
    await tester.pumpAndSettle();
    pruefeRahmen();

    await beendeApp(tester);
  });

  test('Widget-Code enthaelt keine hartkodierten Maschinendaten', () {
    final verzeichnisse = <String>[
      'lib/screens',
      'lib/widgets',
      'lib/bootstrap',
    ];
    final treffer = <String>[];

    for (final verzeichnis in verzeichnisse) {
      for (final eintrag in Directory(verzeichnis).listSync(recursive: true)) {
        if (eintrag is! File || !eintrag.path.endsWith('.dart')) {
          continue;
        }
        final inhalt = eintrag.readAsStringSync();
        if (inhalt.contains("'4711'") || inhalt.contains('Weiden i. d. OPf.')) {
          treffer.add(eintrag.path);
        }
      }
    }

    expect(
      treffer,
      isEmpty,
      reason:
          'Maschinendaten gehoeren in die Seed-Daten (lib/data/seed_data.dart).',
    );
  });
}
